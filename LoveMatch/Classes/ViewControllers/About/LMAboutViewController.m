//
//  LMAboutViewController.m
//  LoveMatch
//
//  Created by Bi Chen Ka Kit on 2/6/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import "LMAboutViewController.h"
#import "UIFont+LMFont.h"
#import "UIColor+LMColor.h"
#import <QuartzCore/QuartzCore.h>

@interface LMAboutViewController ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) IBOutlet UIImageView *aboutImageView;

@end

@implementation LMAboutViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.aboutLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.contentView.layer setCornerRadius:20.0f];
    [self.aboutImageView.layer setCornerRadius:50.f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
