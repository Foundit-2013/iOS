//
//  LargeImageViewController.h
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-14.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LargeImageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageLarge;
@property (nonatomic, strong) NSString *imageOriginal;
- (IBAction)ImageLargeDoneButton:(id)sender;

@end
