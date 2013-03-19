//
//  PostingsViewController.m
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-12.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import "PostingsViewController.h"
#import "SystemConfiguration/SystemConfiguration.h"
#import "HUD.h"
#import <QuartzCore/QuartzCore.h>

@interface PostingsViewController ()

@end

@implementation PostingsViewController

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
    
    [HUD hideUIBlockingIndicator];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"/UIBackground.png"]];
    
    _isImageLoaded = NO;
    
    [_postName.layer setCornerRadius:0.0f];
    _postName.layer.shouldRasterize = YES;
    
    CGRect frameRect = _overLayTextfield.frame;
    frameRect.size.height = 95;
    _overLayTextfield.frame = frameRect;
    
    [_overLayTextfield.layer setCornerRadius:0.0f];
    _overLayTextfield.layer.shouldRasterize = YES;
    
    CGRect frameRect2 = _overLayCameraButton.frame;
    frameRect2.size.height = 90;
    _overLayCameraButton.frame = frameRect2;
    
    [_overLayCameraButton.layer setCornerRadius:0.0f];
    _overLayCameraButton.layer.shouldRasterize = YES;
    
    [_imageView.layer setCornerRadius:10.0f];
    _imageView.layer.shouldRasterize = YES;
    _imageView.layer.masksToBounds = YES;
    
	// Do any additional setup after loading the view.
    if ([_result isEqualToString:@"found"]) {
        _lostButton.hidden=TRUE;
        _foundButton.hidden=FALSE;
    }
    if ([_result isEqualToString:@"lost"]) {
        _foundButton.hidden=TRUE;
        _lostButton.hidden=FALSE;
    }
    self.postName.delegate = self;
    self.postDescription.delegate = self;
}

- (void) viewDidLayoutSubviews
{
    [self viewDidAppear:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (UIToolbar *)keyboardToolBar {
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard:)];
    [toolbar setItems:[NSArray arrayWithObjects: flexSpace, doneButton, nil] animated:NO];
    
    return toolbar;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!textField.inputAccessoryView) {
        textField.inputAccessoryView = [self keyboardToolBar];
    }
}

-(void)textViewShouldBeginEditing:(UITextField *)textView {
    [_scrollView setContentOffset:CGPointMake(0, 120 ) animated:YES];
    if (!textView.inputAccessoryView) {
        textView.inputAccessoryView = [self keyboardToolBar];
    }
}

-(void)textViewDidEndEditing:(UITextField *)textField {
    [_scrollView setContentOffset:CGPointMake(0, 0 ) animated:YES];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)hideKeyboard:(id)sender {
	[self.postName resignFirstResponder];
    [self.postDescription resignFirstResponder];
}

#pragma mark -
#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
}

- (void)keyboardWillHide:(NSNotification *)notification {
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

- (IBAction)BackgroundTap:(id)sender
{
    [_postName resignFirstResponder];
    [_postDescription resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_postName resignFirstResponder];
    [_postDescription resignFirstResponder];
    return NO;
}

- (IBAction)doneEditing:(id)sender {
    [_postDescription resignFirstResponder];
}

- (BOOL)textViewShouldReturn:(UITextView *)textView {
     [_postDescription resignFirstResponder];
    return NO;
}



- (void)uploadPost;
{
    [HUD showUIBlockingIndicatorWithText:@"Posting..."];
    
    #define DataDownloaderRunMode @"myapp.run_mode"
    UIImage *image = [[UIImage alloc] init];
    NSData *imageData = UIImageJPEGRepresentation(image, 90);
    
    NSString *urlString = @"http://foundit.andrewl.ca/postings/";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"POST"];
    
    // We need to add a header field named Content-Type with a value that tells that it's a form and also add a boundary.
    // I just picked a boundary by using one from a previous trace, you can just copy/paste from the traces.
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    // end of what we've added to the header
    
    // the body of the post
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"posting[name]\"\r\n\r\n%@", _postName.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];   
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"posting[description]\"\r\n\r\n%@", _postDescription.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

    if ([_result isEqualToString:@"found"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"posting[posting_type]\"\r\n\r\n%d", 2] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if ([_result isEqualToString:@"lost"]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"posting[posting_type]\"\r\n\r\n%d", 1] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (_isImageLoaded == YES) {
        NSLog(@"image not nil!!!");
        NSDate *date = [NSDate date];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"posting[photo]\"; filename=\"%@.jpg\"\r\n", date] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:UIImageJPEGRepresentation(self.image, 90)]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // and again the delimiting boundary
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // adding the body we've created to the request
    [request setHTTPBody:body];
    
    NSURLResponse* response;
    NSError* error;    
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
    NSLog(@"finish");

    [HUD hideUIBlockingIndicator];
    [self dismissModalViewControllerAnimated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post Successful" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

- (void)takePictureWithCamera {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imagePicker animated:YES];
        imagePicker.allowsEditing = NO;
    }
    else {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:imagePicker animated:YES];
        imagePicker.allowsEditing = NO;
    }
}

- (void)takePictureFromAlbum {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:imagePicker animated:YES];
    imagePicker.allowsEditing = NO;
}

- (IBAction)cancelButtonPost:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    _image = [info objectForKey: UIImagePickerControllerOriginalImage];
    [self dismissModalViewControllerAnimated:YES];
    // Do stuff to image.
    _imageView.hidden = NO;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.alpha = 1.0f;
    _imageView.image = self.image;
    _isImageLoaded = YES;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)lostButtonPressed:(id)sender {
    if ([self isConnectionAvailable] == TRUE){
        if ([self validateForms] == TRUE) {
            [HUD showUIBlockingIndicatorWithText:@"Posting..."];
            [self performSelectorInBackground:@selector(uploadPost) withObject:nil];
            //        [self uploadPost];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't connect. Please check your internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
}

- (IBAction)foundButtonPressed:(id)sender {
    if ([self isConnectionAvailable] == TRUE){
        if ([self validateForms] == TRUE) {
            [HUD showUIBlockingIndicatorWithText:@"Posting..."];
            [self performSelectorInBackground:@selector(uploadPost) withObject:nil];
            //        [self uploadPost];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't connect. Please check your internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
}

- (BOOL) validateForms
{
    if ([_postName.text length] < 3 || [_postName.text length] > 20 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Post name must be between 3 and 20 characters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        return FALSE;
    }
    if ([_postDescription.text length] < 10)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Post description must be at least 10 characters." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
        return FALSE;
    }
    else {
        return TRUE;
	}
}

-(IBAction)showActionSheet:(id)sender {
    if ([_result isEqualToString:@"lost"]) {
        [self takePictureFromAlbum];
    }
    else {
        UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Upload Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Choose Existing Photo", nil];
        popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [popupQuery showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
        case 0:
            [self takePictureWithCamera];
            break;
        case 1:
            [self takePictureFromAlbum];
            break;
        case 2:
//            self.label.text = @"Other Button 2 Clicked";
            break;
    }
}

@end
