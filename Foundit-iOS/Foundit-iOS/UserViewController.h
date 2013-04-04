//
//  UserViewController.h
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-16.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostingDetailViewController2;

@interface UserViewController : UITableViewController {
    
    IBOutlet UITableView *myTableView;
    NSIndexPath *lastIndexPath;
    
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
@property (nonatomic) BOOL* viewPreviouslyLoaded;

@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (nonatomic, retain) NSMutableArray* filteredTableImages;

@property (strong, nonatomic) PostingDetailViewController2 *postingDetailViewController;
- (BOOL)connected ;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) bool isFiltered;
@property (nonatomic, assign) bool deleteYes;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchEnable;
- (IBAction)searchEnable:(id)sender;

@end
