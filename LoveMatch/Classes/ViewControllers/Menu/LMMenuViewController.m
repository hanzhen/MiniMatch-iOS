//
//  LMMenuViewController.m
//  LoveMatch
//
//  Created by Bi Chen Ka Kit on 31/5/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import "LMMenuViewController.h"
#import "LMGameViewController.h"
#import "UIColor+LMColor.h"
#import "UIFont+LMFont.h"
#import <QuartzCore/QuartzCore.h>
#import <POP/POP.h>
#import "FBShimmeringView.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "LMAboutViewController.h"
#import "LMCreateMatchViewController.h"


@interface LMMenuViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) IBOutlet UIButton *normalGameButton;
@property (strong, nonatomic) IBOutlet UIButton *customizedGameButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;
@property (strong, nonatomic) IBOutlet UILabel *logoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *heartLogoImageView;
@property (strong, nonatomic) IBOutlet UILabel *sloganLabel;


@property (assign, nonatomic) BOOL isInitialLoaded;

@end

@implementation LMMenuViewController

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
    [self.normalGameButton.titleLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.normalGameButton.layer setCornerRadius:25.f];
    [self.customizedGameButton.titleLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.customizedGameButton.layer setCornerRadius:25.f];
    [self.aboutButton.titleLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.aboutButton.layer setCornerRadius:25.f];
    [self.logoLabel setFont:[UIFont themeFont:BOLD size:30]];
    [self.sloganLabel setFont:[UIFont themeFont:BOLD size:15]];
    
    [self.logoLabel setAlpha:0.f];
    [self.normalGameButton setAlpha:0.f];
    [self.customizedGameButton setAlpha:0.f];
    [self.aboutButton setAlpha:0.f];
    
    NSTimer *logoSpringAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                       target:self
                                                     selector:@selector(showSpringAnimation:)
                                                     userInfo:nil
                                                      repeats:YES];
    [logoSpringAnimationTimer  fire];
}

-(void)showSpringAnimation:(NSTimer *) theTimer
{
    [self showLogoSpringAnimation];
    [self showIconMatchButtonSpringAnimation];
    [self showPhotoMatchButtonSpringAnimation];
    [self showAboutButtonSpringAnimation];
}

- (void)showLogoSpringAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [self.heartLogoImageView.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)showIconMatchButtonSpringAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [self.normalGameButton.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)showPhotoMatchButtonSpringAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [self.customizedGameButton.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)showAboutButtonSpringAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [self.aboutButton.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.isInitialLoaded) {
        self.isInitialLoaded = YES;
        [UIView animateWithDuration:1.0f animations:^{
            [self.logoLabel setAlpha:1.f];
            [self.normalGameButton setAlpha:1.f];
            [self.customizedGameButton setAlpha:1.f];
            [self.aboutButton setAlpha:1.f];
        } completion:^(BOOL finished) {
            FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.logoLabel.frame];
            [self.view addSubview:shimmeringView];
            shimmeringView.contentView = self.logoLabel;
            // Start shimmering.
            shimmeringView.shimmering = YES;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)normalMatchButtonPressed:(id)sender {
    
    UIButton *button = sender;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, .375f * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        LMGameViewController *viewController = [[LMGameViewController alloc]initWithNibName:@"LMGameViewController" bundle:nil];
        viewController.type = 1;
        viewController.transitioningDelegate = self;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        [self.navigationController presentViewController:viewController animated:YES completion:^{
        }];
        
    });
}

- (IBAction)createMatchButtonPressed:(id)sender {
    
    UIButton *button = sender;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    [scaleAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        LMGameViewController *viewController = [[LMGameViewController alloc]initWithNibName:@"LMGameViewController" bundle:nil];
        viewController.type = 2;
        viewController.transitioningDelegate = self;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        [self.navigationController presentViewController:viewController animated:YES completion:^{
        }];
    }];
}

- (IBAction)myMatchButtonPressed:(id)sender {
    
    UIButton *button = sender;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    
}

- (IBAction)aboutButtonPressed:(id)sender {
    
    UIButton *button = sender;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, .375f * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        LMAboutViewController *viewController = [[LMAboutViewController alloc]initWithNibName:@"LMAboutViewController" bundle:nil];
        viewController.transitioningDelegate = self;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        [self.navigationController presentViewController:viewController animated:YES completion:^{
        }];
        
    });
    
}

static void dispatch_async_repeated_internal(dispatch_time_t firstPopTime, double intervalInSeconds, dispatch_queue_t queue, void(^work)(BOOL *stop))
{
    __block BOOL shouldStop = NO;
    dispatch_time_t nextPopTime = dispatch_time(firstPopTime, (int64_t)(intervalInSeconds * NSEC_PER_SEC));
    dispatch_after(nextPopTime, queue, ^{
        work(&shouldStop);
        if(!shouldStop)
        {
            dispatch_async_repeated_internal(nextPopTime, intervalInSeconds, queue, work);
        }
    });
}

void dispatch_async_repeated(double intervalInSeconds, dispatch_queue_t queue, void(^work)(BOOL *stop))
{
    dispatch_time_t firstPopTime = dispatch_time(DISPATCH_TIME_NOW, intervalInSeconds * NSEC_PER_SEC);
    dispatch_async_repeated_internal(firstPopTime, intervalInSeconds, queue, work);
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [PresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [DismissingAnimator new];
}

@end
