//
//  PostingsFoundViewController.m
//  Foundit-iOS
//
//  Created by Shaun Maharaj on 2013-03-07.
//  Copyright (c) 2013 Shaun Maharaj. All rights reserved.
//

#import "PostingsFoundViewController.h"

@interface PostingsFoundViewController ()

@end

@implementation PostingsFoundViewController

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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"UIBackground.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonFoundIt:(id)sender {
    
}
@end
