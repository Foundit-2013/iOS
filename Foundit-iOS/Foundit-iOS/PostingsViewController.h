//
//  PostingsViewController.h
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-12.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostingsViewController : UIViewController <UIActionSheetDelegate> {
    
}

- (IBAction)lostButtonPressed:(id)sender;
- (IBAction)foundButtonPressed:(id)sender;
- (IBAction)BackgroundTap:(id)sender;
@property (nonatomic, strong) NSString *result;
@property (strong, nonatomic) IBOutlet UIButton *lostButton;
@property (strong, nonatomic) IBOutlet UIButton *foundButton;
@property (strong, nonatomic) IBOutlet UITextField *postName;
@property (strong, nonatomic) IBOutlet UITextView *postDescription;
@property (strong, nonatomic) IBOutlet UIButton *postUploadPhotoButton;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIView *keyboardToolbar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic) BOOL* isImageLoaded;

//- (IBAction)uploadPost:(id)sender;
- (IBAction)takePictureWithCamera:(UIButton*)sender;
- (IBAction)cancelButtonPost:(id)sender;

-(IBAction)showActionSheet:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *overLayTextfield;
@property (strong, nonatomic) IBOutlet UITextField *overLayCameraButton;




@end
