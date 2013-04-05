//
//  FirstViewController.h
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-06.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController {
    bool foundWasClicked;
    bool lostWasClicked;
    
    UIImageView *coverImageView;
    UITextField* username;
}
@property (strong, nonatomic) IBOutlet UIImageView *cloudsImage;
@property (nonatomic, retain) UIImageView *coverImageView;

@end
