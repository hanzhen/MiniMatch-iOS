//
//  LMGameOverViewController.m
//  LoveMatch
//
//  Created by Bi Chen Ka Kit on 1/6/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import "LMGameOverViewController.h"
#import "UIFont+LMFont.h"
#import <QuartzCore/QuartzCore.h>

@interface LMGameOverViewController ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *gameOverLabel;



@end

@implementation LMGameOverViewController

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
    [self.gameOverLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.gameOverLabel setText:@"Congratulation!"];
    [self.contentView.layer setCornerRadius:20.0f];
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
