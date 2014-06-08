//
//  LMConfirmationViewController.m
//  LoveMatch
//
//  Created by Bi Chen Ka Kit on 1/6/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import "LMConfirmationViewController.h"
#import "UIFont+LMFont.h"
#import "UIColor+LMColor.h"
#import <QuartzCore/QuartzCore.h>

@interface LMConfirmationViewController ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *confirmationLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmationButton;


@end

@implementation LMConfirmationViewController

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
    [self.confirmationLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.confirmationButton.titleLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.confirmationLabel setText:@"Are you sure?"];
    [self.contentView.layer setCornerRadius:20.0f];
    [self.confirmationButton.layer setCornerRadius:25.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmationButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(LMConfirmationViewControllerDidDismissWithTag:)]) {
            [self.delegate LMConfirmationViewControllerDidDismissWithTag:self.tag];
        }
    }];
}


- (IBAction)dismissButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
