//
//  CustomMapViewViewController.h
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-26.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CustomMapViewViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
//    IBOutlet UIView *mapViewOnScreen;
    MKMapView *mapView;
    CLLocationManager *locationManager;
}
- (IBAction)cancelButtonLoc:(id)sender;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) MKPointAnnotation *centerAnnotation;
- (IBAction)setLoc:(id)sender;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
