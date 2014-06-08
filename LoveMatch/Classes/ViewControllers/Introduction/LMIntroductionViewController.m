//
//  LMIntroductionViewController.m
//  LoveMatch
//
//  Created by Bi Chen Ka Kit on 31/5/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import "LMIntroductionViewController.h"
#import <POP/POP.h>
#import "UIColor+LMColor.h"
#import "UIFont+LMFont.h"
#import "LMMenuViewController.h"

@interface LMIntroductionViewController ()

@property (strong, nonatomic) UILabel *logoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *heartImageView;

@end

@implementation LMIntroductionViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self runAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)runAnimation
{
    [self.heartImageView setCenter:self.view.center];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [self.heartImageView.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, .375f * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:1.0f animations:^{
            [self.heartImageView setFrame:CGRectMake(self.heartImageView.frame.origin.x, 80, self.heartImageView.frame.size.width, self.heartImageView.frame.size.height)];
        } completion:^(BOOL finished) {
            LMMenuViewController *viewController = [[LMMenuViewController alloc]initWithNibName:@"LMMenuViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:NO];
        }];
    });
}

@end
