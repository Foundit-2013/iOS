//
//  PostingDetailViewController2.h
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-17.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostingDetailViewController2 : UITableViewController

//@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailPostingTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailCreatedAtLabel;
@property (strong, nonatomic) IBOutlet UITextView *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) IBOutlet UITextView *detailDescriptionTextView;
@property (strong, nonatomic) NSString *myUrl;

@property (nonatomic, strong) NSArray *json;


@end
