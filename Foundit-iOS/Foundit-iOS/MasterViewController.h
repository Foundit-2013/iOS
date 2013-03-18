//
//  MasterViewController.h
//  Foundit
//
//  Created by Shaun Maharaj on 2013-03-06.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
