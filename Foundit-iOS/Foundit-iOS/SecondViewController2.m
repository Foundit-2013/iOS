//
//  SecondViewController2.m
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-16.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import "SecondViewController2.h"
#import "PostingDetailViewController2.h"
#import "JSONModelLib.h"
#import "HUD.h"
#import "SystemConfiguration/SystemConfiguration.h"

@interface SecondViewController2 ()

@end

@implementation SecondViewController2

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL) isConnectionAvailable
{
	SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"google.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) )
    {
        return FALSE;
    } else {
		return TRUE;
	}
}

- (void)viewDidLoad
{
    self.tableView.dataSource = self;
    [super viewDidLoad];
    self.tableView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"/UIBackground.png"]];
    
    _postingsUrl = [NSURL URLWithString:@"http://foundit.andrewl.ca/postings_show_found.json"];
    
    _viewPreviouslyLoaded = YES;

    if (_viewPreviouslyLoaded != NO) {
        [HUD showUIBlockingIndicatorWithText:@"Loading..."];
    }
}

-(void)fetchJSONfromServer:(NSURL *)url {
    @try {
        NSData *jsonData=[NSData dataWithContentsOfURL:_postingsUrl];
        NSError *e = nil;
        self.json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&e];
        
        _images_downloaded = [[NSMutableArray alloc] init];
        for (int i=0; i< self.json.count; i++) {
            self.postings = [self.json objectAtIndex: i];
            
            UIImage *image;
            if (![[self.postings objectForKey:@"photo_url_thumb"] isEqualToString: @"/photos/thumb/missing.png"]) {
                NSString *myUrl = [self.postings objectForKey:@"photo_url_thumb"];
                NSString * strRR = [NSString stringWithFormat:@"http://foundit.andrewl.ca/%@", myUrl];
                NSURL *url = [NSURL URLWithString:strRR];
                image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
            }
            else {
                image = [UIImage imageNamed:@"/missing_image.png"];
            }
            [_images_downloaded addObject: image];
        }
    }
    @catch (NSException *ex){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't connect to Server :(" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
}

-(void)viewWillDisappear:(BOOL)animated
{
}

-(void)viewWillAppear:(BOOL)animated
{
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([self isConnectionAvailable] == TRUE){
        if (_viewPreviouslyLoaded != NO) {
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            
            [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
            
            self.refreshControl = refreshControl;
            
            [self fetchJSONfromServer:_postingsUrl];
            
            _viewPreviouslyLoaded = NO;
            
            [myTableView reloadData];
            [self.tableView reloadData];
        }
        else {}
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't connect. Please check your internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    [HUD hideUIBlockingIndicator];

}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    switch (index) {
        case 0:
            break;
        case 1:
            break;
    }
    return vc;
}

//RootViewController.m
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return [[[[json valueForKey:@"id"] objectAtIndex:section] valueForKey:@"name"] count];
    //    NSLog(@"JSON : %d", self.json.count);
    return self.json.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    //here you check for PreCreated cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    self.postings = [self.json objectAtIndex: indexPath.row];
    
    CGSize itemSize = CGSizeMake(60, 60);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    
    @try {
        [[self.images_downloaded objectAtIndex: indexPath.row] drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    }
    @catch (NSException *ex){
        cell.imageView.image = [UIImage imageNamed:@"/missing_image.png"];
    }

    UIGraphicsEndImageContext();
    
    //    cell.imageView.image = [self.images_downloaded objectAtIndex: indexPath.row];
    cell.textLabel.text = [self.postings objectForKey:@"name"];
    cell.detailTextLabel.text = [self.postings objectForKey:@"created_at_formatted"];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPathSend = indexPath.row;
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)segmentValueChanged:(id)sender {
    
    if ([self isConnectionAvailable] == TRUE){
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
        hud.labelText = @"Loading...";
        [self.view.window addSubview:hud];
        
        UISegmentedControl *seg = sender;
        if (seg.selectedSegmentIndex == 0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.tableView cache:NO];
            [UIView commitAnimations];
            
            _postingsUrl = [NSURL URLWithString:@"http://foundit.andrewl.ca/postings_show_found.json"];
//            [hud showWhileExecuting:@selector(fetchJSONfromServer:) onTarget:self withObject:_postingsUrl animated:YES];
//            [self performSelectorInBackground:@selector(fetchJSONfromServer:) withObject:_postingsUrl];
            [self fetchJSONfromServer:_postingsUrl];
            
            [myTableView reloadData];
            [self.tableView reloadData];
            [hud hide:YES];
        }
        else if (seg.selectedSegmentIndex == 1) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.tableView cache:NO];
            [UIView commitAnimations];
            
            _postingsUrl = [NSURL URLWithString:@"http://foundit.andrewl.ca/postings_show_lost.json"];
//            [hud showWhileExecuting:@selector(fetchJSONfromServer:) onTarget:self withObject:_postingsUrl animated:YES];
//            [self performSelectorInBackground:@selector(fetchJSONfromServer:) withObject:_postingsUrl];
            [self fetchJSONfromServer:_postingsUrl];
            
            [myTableView reloadData];
            [self.tableView reloadData];
            [hud hide:YES];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't connect. Please check your internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self isConnectionAvailable] == TRUE){
        return YES;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't connect. Please check your internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowPostingDetailsFound"]) {
        self.postings = [self.json objectAtIndex: _indexPathSend];
        NSArray *json = @[[self.postings objectForKey:@"name"],[self.postings objectForKey:@"posting_type"],[self.postings objectForKey:@"created_at_formatted"],[self.postings objectForKey:@"description"],[self.postings objectForKey:@"photo_url_large"]];
        PostingDetailViewController2 *vc = [segue destinationViewController];
        vc.json = json;
    }
    
}

- (void)refreshTable
{
    [HUD showUIBlockingIndicatorWithText:@"Loading..."];
    [self fetchJSONfromServer:_postingsUrl];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    [HUD hideUIBlockingIndicator];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enabled = [defaults boolForKey:@"enableDelete"];
    
    if (enabled) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If you're data source is an NSMutableArray, do this
        self.postings = [self.json objectAtIndex: indexPath.row];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        NSString * strRR = [NSString stringWithFormat:@"http://foundit.andrewl.ca/postings/%@", [self.postings objectForKey:@"id"]];
        
        [request setURL:[NSURL URLWithString:strRR]];
        [request setHTTPMethod:@"DELETE"];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        [self refreshTable];
    }
}

@end
