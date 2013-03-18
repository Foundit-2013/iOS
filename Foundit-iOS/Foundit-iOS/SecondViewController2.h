//
//  SecondViewController2.h
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-16.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostingDetailViewController2;

@interface SecondViewController2 : UITableViewController {
    
    IBOutlet UITableView *myTableView;
    
}

- (IBAction)segmentSwitch:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *postingsFound;
@property (strong, nonatomic) IBOutlet UITableView *postingsLost;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segmentValueChanged:(id)sender;

@property (nonatomic, strong) NSArray* json;
@property (nonatomic, retain) NSMutableArray* images_downloaded;
@property (nonatomic, strong) NSDictionary* postings;
@property (nonatomic, strong) NSURL *postingsUrl;
@property (nonatomic) NSInteger* indexPathSend;

@property (strong, nonatomic) PostingDetailViewController2 *postingDetailViewController;
- (BOOL)connected ;

@end
