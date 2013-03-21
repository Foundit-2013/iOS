//
//  PostingDetailViewController2.m
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-17.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import "PostingDetailViewController2.h"
#import "LargeImageViewController.h"
#import "HUD.h"
#import <QuartzCore/QuartzCore.h>

@interface PostingDetailViewController2 ()

@end

@implementation PostingDetailViewController2

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"UIBackground.png"]];
    
//    self.tableView.backgroundColor=[UIColor clearColor];
//    UIImage *backgroundImage = [UIImage imageNamed:@"UIBackground.png.png"];
//    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:backgroundImage];
//    self.tableView.backgroundView=backgroundImageView;
    
    @try {
    [HUD showUIBlockingIndicatorWithText:@"Loading..."];
    
    UIImage *image;
    _myUrl = _json[4];
    
    if (![_myUrl isEqualToString: @"/photos/large/missing.png"]) {
        NSString * strRR = [NSString stringWithFormat:@"http://foundit.andrewl.ca/%@", _myUrl];
        NSURL *url = [NSURL URLWithString:strRR];
        image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    }
    else{
        image = [UIImage imageNamed:@"/missing_image_large.png"];
    }
    
    [HUD hideUIBlockingIndicator];
    
    _detailNameLabel.text = _json[0];
    
    NSString *postingType = @"Found";
    if ([_json[1] isEqualToString:@"1"]) {
        postingType = @"Lost";
    }
    _detailPostingTypeLabel.text = [NSString stringWithFormat:@"Posting Type: %@ Item", postingType];
    _detailCreatedAtLabel.text = [NSString stringWithFormat:@"Date Posted: %@", _json[2]];
    _detailDescriptionTextView.text = _json[3];
    _detailImageView.image = image;
    
//    [_detailImageView.layer setBorderColor: [[UIColor blackColor] CGColor]];
//    [_detailImageView.layer setBorderWidth: 2.0];
    
    CGRect frame;
    frame = _detailDescriptionTextView.frame;
    frame.size.height = [_detailDescriptionTextView contentSize].height;
    _detailDescriptionTextView.frame = frame;
    }
    @catch (NSException *ex){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't connect to Server :(" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 3) {
        return _detailDescriptionTextView.frame.size.height + 30.0;
    }
    // "Else"
    return 45;
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

-(void) viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if (![_myUrl isEqualToString: @"/photos/large/missing.png"]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowLargeImageView"]) {
        LargeImageViewController *vc = [segue destinationViewController];
        NSString * strRR = [NSString stringWithFormat:@"http://foundit.andrewl.ca/%@", _json[4]];
        vc.imageOriginal = strRR;
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

@end
