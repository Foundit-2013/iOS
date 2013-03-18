//
//  LargeImageViewController.m
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-14.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import "LargeImageViewController.h"

@interface LargeImageViewController ()

@end

@implementation LargeImageViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
	// Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:_imageOriginal];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    _imageLarge.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ImageLargeDoneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}
@end
