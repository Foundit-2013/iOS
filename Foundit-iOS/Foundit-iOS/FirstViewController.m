//
//  FirstViewController.m
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-06.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import "FirstViewController.h"
#import "PostingsViewController.h"
#import "HUD.h"
#import <QuartzCore/QuartzCore.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

//    NSUUID  *uuid = [NSUUID UUID];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    BOOL isFirst = [defaults boolForKey:@"firstRun"];
//    if(isFirst == NO)
//    {
//        [defaults setBool:YES forKey:@"firstRun"];
//        NSLog(@"UUID: %@", [uuid UUIDString]);
//        
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Welcome to Foundit"
//                              message:@"Please Enter a Username"
//                              delegate:self
//                              cancelButtonTitle: nil
//                              otherButtonTitles:@"Continue", nil ];
//        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//        username = [alert textFieldAtIndex:0];
//        
//        [alert show];
//    }
//    
//    NSString *valueToSave = [uuid UUIDString];
//    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"userIDValueString"];
//    
//    
//    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"userIDValueString"];
//    NSLog(@"UUID: %@", savedValue);

    
    UIImage *defaultImage = [UIImage imageNamed:@"/Default.png"];
    _coverImageView = [[UIImageView alloc] initWithImage:defaultImage];
    [self.view addSubview:_coverImageView];
    
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [self.coverImageView setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                     }];
    
    CGRect cloudsImageFrameInitial = self.cloudsImage.frame;
    cloudsImageFrameInitial.origin.y = self.view.bounds.size.height;
    self.cloudsImage.frame = cloudsImageFrameInitial;
    
    CGRect cloudsImageFrameTransition = self.cloudsImage.frame;
    cloudsImageFrameTransition.origin.y = 251;
    
    [UIView animateWithDuration:1.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.cloudsImage.frame = cloudsImageFrameTransition;
                     }
                     completion:^(BOOL finished) {
                     }];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"UIBackground.png"]];
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
//    if([title isEqualToString:@"Continue"])
//    {
//        NSString *userFieldString = username.text;
//        [[NSUserDefaults standardUserDefaults] setObject:userFieldString forKey:@"founditUsername"];
//    }
//    else {
//    }
//    
//}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PostingNewView"] || [[segue identifier] isEqualToString:@"PostingNewView2"]) {
        NSString * result;
        if (foundWasClicked){
            result = @"found";
            PostingsViewController *vc = [segue destinationViewController];
            vc.result = result;
        }
        if (lostWasClicked){
            result = @"lost";
            PostingsViewController *vc = [segue destinationViewController];
            vc.result = result;
        }
    }
}

- (IBAction)foundButtonAction:(id)sender {
    foundWasClicked = YES;
    lostWasClicked = NO;
}

- (IBAction)lostButtonAction:(id)sender {
    lostWasClicked = YES;
    foundWasClicked = NO;
}
@end
