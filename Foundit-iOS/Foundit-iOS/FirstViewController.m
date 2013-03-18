//
//  FirstViewController.m
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-06.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import "FirstViewController.h"
#import "PostingsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    [UIView animateWithDuration:3
//                          delay:0
//                        options:UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                         blackView.layer.opacity = 100;
//                     }
//                     completion:^(BOOL finished) {
//                         // This line prevents the flash
//                         blackView.layer.opacity = 0;
//                         [blackView removeFromSuperview];
//                     }];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"/UIBackground.png"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
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
            // do something else here, like tell the user why you didn't move them
        }
    }
}

- (IBAction)foundButtonAction:(id)sender {
    foundWasClicked = YES;
}

- (IBAction)lostButtonAction:(id)sender {
    lostWasClicked = YES;
}
@end
