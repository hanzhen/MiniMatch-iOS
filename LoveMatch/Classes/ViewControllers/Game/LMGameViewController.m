//
//  LMGameViewController.m
//  LoveMatch
//
//  Created by Bi Chen Ka Kit on 31/5/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import "LMGameViewController.h"
#import <POP/POP.h>
#import "KKUtilities.h"
#import "UIColor+LMColor.h"
#import "UIFont+LMFont.h"
#import <AudioToolbox/AudioServices.h>
#import "LMGameOverViewController.h"
#import "LMConfirmationViewController.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "LMCreateMatchViewController.h"


@interface LMGameViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *gameButtons;
@property (strong, nonatomic) IBOutlet UIButton *retryButton;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UILabel *movesLabel;
@property (strong, nonatomic) NSMutableArray *buttonGraphics;
@property (assign, nonatomic) NSInteger moves;

@end

@implementation LMGameViewController

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
    
    self.isInitialLoaded = YES;
    
    NSArray *graphicNames = @[@"graphic_cloud",@"graphic_mail",@"graphic_paint",@"graphic_star",@"graphic_drink",@"graphic_message",@"graphic_phone",@"graphic_taxi",@"graphic_game",@"graphic_movie",@"graphic_pool",@"graphic_thunder",@"graphic_heels",@"graphic_music",@"graphic_sing"];

    self.gameButtons = [self.gameButtons sortedArrayUsingComparator:^NSComparisonResult(id objA, id objB){
        return(
               ([objA tag] < [objB tag]) ? NSOrderedAscending  :
               ([objA tag] > [objB tag]) ? NSOrderedDescending :
               NSOrderedSame);
    }];
    
    
    self.buttonGraphics = [NSMutableArray array];
    for (NSString *string in graphicNames) {
        [self.buttonGraphics addObject:string];
        [self.buttonGraphics addObject:string];
    }
    
    [self.buttonGraphics shuffle];
    
    for (NSInteger i = 0 ; i < self.gameButtons.count; i++) {
        UIButton *button = [self.gameButtons objectAtIndex:i];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        button.tag = i;
        [button.layer setCornerRadius:25.f];
        [button setClipsToBounds:YES];
        if (self.type == 1) {
            [button setImage:[UIImage imageNamed:@"graphic_love"]forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"graphic_love"]forState:UIControlStateNormal|UIControlStateHighlighted];
        }else{
            [button setImage:[UIImage imageNamed:@"graphic_photo"]forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"graphic_photo"]forState:UIControlStateNormal|UIControlStateHighlighted];
        }
        [button setImage:[UIImage imageNamed:[self.buttonGraphics objectAtIndex:i]] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:[self.buttonGraphics objectAtIndex:i]]forState:UIControlStateSelected|UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:[self.buttonGraphics objectAtIndex:i]]forState:UIControlStateSelected|UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:[self.buttonGraphics objectAtIndex:i]] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(gameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.retryButton.titleLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.retryButton.layer setCornerRadius:20.f];
    [self.menuButton.titleLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.menuButton.layer setCornerRadius:20.f];
    [self.editButton.titleLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.editButton.layer setCornerRadius:20.f];
    [self.movesLabel.layer setCornerRadius:20.f];
    [self.movesLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.movesLabel setText:[NSString stringWithFormat:@"Moves: %ld",(long)self.moves]];
    
    if (self.type == 2) {
        [self.menuButton setFrame:CGRectMake(20, 10, 80, 40)];
        [self.editButton setFrame:CGRectMake(120, 10, 80, 40)];
        [self.retryButton setFrame:CGRectMake(220, 10, 80, 40)];
    }else{
        [self.editButton setHidden:YES];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.type == 2 && self.isInitialLoaded) {
        
        self.isInitialLoaded = NO;
        [self reloadPhotoMatch];
    }
}

- (void)reloadPhotoMatch
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"match.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"match.plist"] ];
    }
    NSMutableDictionary *matchDictionary;
    if ([fileManager fileExistsAtPath: path])
    {
        matchDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        matchDictionary = [[NSMutableDictionary alloc] init];
        [matchDictionary setObject:[NSMutableArray array] forKey:@"match_photos"];
        [matchDictionary writeToFile: path atomically:YES];
    }
    NSMutableArray *matchPhotos = [matchDictionary objectForKey:@"match_photos"];
    if (matchPhotos.count != 15) {
        LMCreateMatchViewController *viewController = [[LMCreateMatchViewController alloc]initWithNibName:@"LMCreateMatchViewController" bundle:nil];
        viewController.transitioningDelegate = self;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:viewController animated:YES completion:^{
        }];
    }else{
        self.buttonGraphics = [NSMutableArray array];
        for (NSString *string in matchPhotos) {
            [self.buttonGraphics addObject:string];
            [self.buttonGraphics addObject:string];
        }
        [self.buttonGraphics shuffle];
        for (NSInteger i = 0 ; i < self.gameButtons.count; i++) {
            
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",[self.buttonGraphics objectAtIndex:i]]];
            NSData * data = [NSData dataWithContentsOfFile:path];
            UIImage *result = [UIImage imageWithData:data];
            NSLog(@"%@",path);
            UIButton *button = [self.gameButtons objectAtIndex:i];
            [button setImage:result forState:UIControlStateSelected];
            [button setImage:result forState:UIControlStateSelected|UIControlStateHighlighted];
            [button setImage:result forState:UIControlStateSelected|UIControlStateDisabled];
            [button setImage:result forState:UIControlStateDisabled];
            
        }
    }
}

- (IBAction)gameButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self showButtonFlipAnimationWithTag:button.tag];
    [self playButtonFlipSound];
    
    //check 1st / 2nd
    NSMutableArray *selectedButtons = [NSMutableArray array];
    for (UIButton *button in self.gameButtons) {
        if (button.selected && button.enabled) {
            [selectedButtons addObject:button];
        }
    }
    
    if (selectedButtons.count == 0) {
        
        [button setSelected:!button.selected];
        
    }else if (selectedButtons.count == 1) {
        
        UIButton *firstButton = [selectedButtons objectAtIndex:0];;
        UIButton *secondButton = [self.gameButtons objectAtIndex:button.tag];
        
        if (firstButton == secondButton) {
            [button setSelected:!button.selected];
            return;
        }
        
        self.moves++;
        [self.movesLabel setText:[NSString stringWithFormat:@"Moves: %ld",(long)self.moves]];
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        positionAnimation.velocity = @100;
        positionAnimation.springBounciness = 10;
        [self.movesLabel.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
        
        
        
        if ([[self.buttonGraphics objectAtIndex:firstButton.tag]isEqualToString:[self.buttonGraphics objectAtIndex:button.tag]]) {
            [firstButton setSelected:YES];
            [secondButton setSelected:YES];
            [firstButton setEnabled:NO];
            [secondButton setEnabled:NO];
            
            [self showButtonSpringAnimationWithTag:firstButton.tag];
            [self showButtonSpringAnimationWithTag:secondButton.tag];
        }else{
            [button setSelected:!button.selected];
            [self closeButtonWithTag:firstButton.tag delay:1.0];
            [self closeButtonWithTag:secondButton.tag delay:1.0];
            
            [self showButtonShakeAnimationWithTag:firstButton.tag];
            [self showButtonShakeAnimationWithTag:secondButton.tag];
        }
        
    }else if (selectedButtons.count > 1) {
        for (UIButton *button in selectedButtons) {
            [self showButtonFlipAnimationWithTag:button.tag];
            [button setSelected:NO];
        }
        [button setSelected:!button.selected];
    }
    
    BOOL gameFinish = YES;
    for (UIButton *button in self.gameButtons) {
        if (button.enabled == YES) {
            gameFinish = NO;
            break;
        }
    }
    if (gameFinish) {
        LMGameOverViewController *viewController = [[LMGameOverViewController alloc]initWithNibName:@"LMGameOverViewController" bundle:nil];
        viewController.transitioningDelegate = self;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:viewController
                                                animated:YES
                                              completion:NULL];
    }
    
    
}

- (void)closeButtonWithTag:(NSInteger)tag delay:(float)second
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, second * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIButton *button = [self.gameButtons objectAtIndex:tag];
        if (button.selected) {
            [self showButtonFlipAnimationWithTag:tag];
            [button setSelected:NO];
        }
    });
}

- (void)showButtonFlipAnimationWithTag:(NSInteger)tag
{
    UIButton *button = [self.gameButtons objectAtIndex:tag];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.375;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.type = @"oglFlip";
    [button.layer addAnimation:animation forKey:nil];
}

- (void)playButtonFlipSound
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"button-flip" ofType:@"mp3"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    SystemSoundID audioEffect;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AudioServicesDisposeSystemSoundID(audioEffect);
    });
}

- (void)showButtonShakeAnimationWithTag:(NSInteger)tag
{
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, .375f * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIButton *button = [self.gameButtons objectAtIndex:tag];
        POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
        positionAnimation.velocity = @100;
        positionAnimation.springBounciness = 10;
        [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            button.userInteractionEnabled = YES;
        }];
        [button.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    });
}

- (void)showButtonSpringAnimationWithTag:(NSInteger)tag
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, .375f * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIButton *button = [self.gameButtons objectAtIndex:tag];
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
        scaleAnimation.springBounciness = 5.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    });
}

- (IBAction)retryButtonPressed:(id)sender {
    
    UIButton *button = sender;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    [scaleAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        LMConfirmationViewController *viewController = [[LMConfirmationViewController alloc]initWithNibName:@"LMConfirmationViewController" bundle:nil];
        viewController.delegate = self;
        viewController.tag = 2;
        viewController.transitioningDelegate = self;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:viewController
                           animated:YES
                         completion:NULL];
    }];
    
}

- (IBAction)menuButtonPressed:(id)sender {
    
    UIButton *button = sender;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    [scaleAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        LMConfirmationViewController *viewController = [[LMConfirmationViewController alloc]initWithNibName:@"LMConfirmationViewController" bundle:nil];
        viewController.delegate = self;
        viewController.tag = 1;
        viewController.transitioningDelegate = self;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:viewController
                           animated:YES
                         completion:NULL];
    }];
    
}

- (IBAction)editButtonPressed:(id)sender {
    
    UIButton *button = sender;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    [scaleAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        LMCreateMatchViewController *viewController = [[LMCreateMatchViewController alloc]initWithNibName:@"LMCreateMatchViewController" bundle:nil];
        viewController.transitioningDelegate = self;
        viewController.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:viewController
                           animated:YES
                         completion:NULL];
    }];
}


- (void)resetGameButtons
{
    self.moves = 0;
    [self.movesLabel setText:[NSString stringWithFormat:@"Moves: %ld",(long)self.moves]];
    [self.buttonGraphics shuffle];
    
    for (NSInteger i = 0 ; i < self.gameButtons.count; i++) {
        UIButton *button = [self.gameButtons objectAtIndex:i];
        [self showButtonFlipAnimationWithTag:button.tag];
        [button setSelected:NO];
        [button setEnabled:YES];
        [button setImage:[UIImage imageNamed:[self.buttonGraphics objectAtIndex:i]] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:[self.buttonGraphics objectAtIndex:i]]forState:UIControlStateSelected|UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:[self.buttonGraphics objectAtIndex:i]]forState:UIControlStateSelected|UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:[self.buttonGraphics objectAtIndex:i]] forState:UIControlStateDisabled];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)LMConfirmationViewControllerDidDismissWithTag:(NSInteger)tag
{
    if (tag == 1) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, .1f * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self dismissViewControllerAnimated:YES completion:^{}];
        });
    }if (tag == 2) {
        [self resetGameButtons];
        if (self.type == 2) {
            [self reloadPhotoMatch];
        }
    }
}

@end
