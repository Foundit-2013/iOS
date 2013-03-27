//
//  CustomMapViewViewController.m
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-26.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import "CustomMapViewViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import "AppDelegate.h"

@interface CustomMapViewViewController ()
- (void)coordinateChanged_:(NSNotification *)notification;
@end

@implementation CustomMapViewViewController {
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    NSLog(@"%@", [self deviceLocation]);
    
    _mapView.showsUserLocation = YES;
    _centerAnnotation = [[MKPointAnnotation alloc] init];
    _centerAnnotation.title = @"Location Pin";
    _centerAnnotation.subtitle = @"Move me to the location";
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    UITapGestureRecognizer *longPressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [_mapView addGestureRecognizer:longPressGesture];
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    MKCoordinateSpan span;

    span.latitudeDelta = 0.2;

    span.longitudeDelta = 0.2;

    MKCoordinateRegion region;

    region.span = span;

    region.center = newLocation.coordinate;

    [_mapView setRegion:region animated:YES];
    _mapView.showsUserLocation = YES;
    
    _centerAnnotation.coordinate = newLocation.coordinate;
    [_mapView addAnnotation:_centerAnnotation];
    
    
    locationLatitudeGlobal = newLocation.coordinate.latitude;
    locationLongitudeGlobal = newLocation.coordinate.longitude;

//    viewController.latitude.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
//
//    viewController.latitude.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];

}


- (NSString *)deviceLocation {
    NSString *theLocation = [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    return theLocation;
}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    _mapView.centerCoordinate = userLocation.location.coordinate;
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonLoc:(id)sender {
    CLLocationCoordinate2D annotationCoord;
    
//    annotationCoord.latitude = _mapView.userLocation.location.coordinate.latitude;
//    annotationCoord.longitude = _mapView.userLocation.location.coordinate.longitude;
    
    annotationCoord.latitude = locationLatitudeGlobal;
    annotationCoord.longitude = locationLongitudeGlobal;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (annotationCoord, 900, 900);
    [_mapView setRegion:region animated:YES];
    
    _centerAnnotation.coordinate = annotationCoord;
    [_mapView addAnnotation:_centerAnnotation];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    _centerAnnotation.coordinate = mapView.centerCoordinate;
    _centerAnnotation.subtitle = [NSString stringWithFormat:@"%f, %f", _centerAnnotation.coordinate.latitude, _centerAnnotation.coordinate.longitude];
}


//#pragma mark -
//#pragma mark DDAnnotationCoordinateDidChangeNotification
//
//// NOTE: DDAnnotationCoordinateDidChangeNotification won't fire in iOS 4, use -mapView:annotationView:didChangeDragState:fromOldState: instead.
//- (void)coordinateChanged_:(NSNotification *)notification {
//	
//	DDAnnotation *annotation = notification.object;
//	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
//}
//
//#pragma mark -
//#pragma mark MKMapViewDelegate
//
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
//	
//	if (oldState == MKAnnotationViewDragStateDragging) {
//		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
//		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
//	}
//}
//
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
//	
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        return nil;
//	}
//	
//	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
//	MKAnnotationView *draggablePinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
//	
//	if (draggablePinView) {
//		draggablePinView.annotation = annotation;
//	} else {
//		// Use class method to create DDAnnotationView (on iOS 3) or built-in draggble MKPinAnnotationView (on iOS 4).
//		draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:self.mapView];
//        
//		if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
//			// draggablePinView is DDAnnotationView on iOS 3.
//		} else {
//			// draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
//		}
//	}
//	
//	return draggablePinView;
//}
- (IBAction)setLoc:(id)sender {
    if (_centerAnnotation.coordinate.latitude > 0.0 || _centerAnnotation.coordinate.longitude > 0.0) {
        locationLatitudeGlobal = _centerAnnotation.coordinate.latitude;
        locationLongitudeGlobal = _centerAnnotation.coordinate.longitude;
    }
    else {
        locationLatitudeGlobal = _mapView.userLocation.location.coordinate.latitude;
        locationLongitudeGlobal = _mapView.userLocation.location.coordinate.longitude;
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    NSLog(@"Long touch!!");
    CGPoint point = [sender locationInView:_mapView];
    CLLocationCoordinate2D locCoord = [_mapView convertPoint:point toCoordinateFromView:self.mapView];
    _centerAnnotation.coordinate = locCoord;
    [_mapView addAnnotation:_centerAnnotation];
}
@end
