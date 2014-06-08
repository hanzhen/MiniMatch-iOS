//
//  LMCreateMatchViewController.m
//  LoveMatch
//
//  Created by Bi Chen Ka Kit on 2/6/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import "LMCreateMatchViewController.h"
#import <POP/POP.h>
#import <QuartzCore/QuartzCore.h>
#import "UIFont+LMFont.h"
#import "PresentingAnimator.h"
#import "DismissingAnimator.h"
#import "LMGameViewController.h"
#import "LMConfirmationViewController.h"


@interface LMCreateMatchViewController () <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *photoButtons;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) NSMutableArray *photos;

- (IBAction)photoButtonPressed:(id)sender;

@end

@implementation LMCreateMatchViewController

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
    [self.doneButton.titleLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.doneButton.layer setCornerRadius:20.f];
    [self.menuButton.titleLabel setFont:[UIFont themeFont:LIGHT size:20]];
    [self.menuButton.layer setCornerRadius:20.f];
    [self.descLabel.layer setCornerRadius:20.f];
    [self.descLabel setFont:[UIFont themeFont:LIGHT size:20]];
    self.photos = [NSMutableArray array];
    self.photoButtons = [self.photoButtons sortedArrayUsingComparator:^NSComparisonResult(id objA, id objB){
        return(
               ([objA tag] < [objB tag]) ? NSOrderedAscending  :
               ([objA tag] > [objB tag]) ? NSOrderedDescending :
               NSOrderedSame);
    }];
    for (UIButton *button in self.photoButtons) {
        [button.layer setCornerRadius:25.f];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *matchDictionary;
    if ([fileManager fileExistsAtPath: [self matchPhotoPath]])
    {
        matchDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:[self matchPhotoPath]];
    }else{
        // If the file doesn’t exist, create an empty dictionary
        matchDictionary = [[NSMutableDictionary alloc] init];
        [matchDictionary setObject:[NSMutableArray array] forKey:@"match_photos"];
        [matchDictionary writeToFile:[self matchPhotoPath] atomically:YES];
    }
    
    NSMutableArray *matchPhotos = [matchDictionary objectForKey:@"match_photos"];
    if (matchPhotos.count == 15) {
        for (NSInteger i = 0; i < 15; i++) {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",[matchPhotos objectAtIndex:i]]];
            NSData * data = [NSData dataWithContentsOfFile:path];
            UIImage *result = [UIImage imageWithData:data];
            [self.photos addObject:result];
        }
        [self resetPhotoButtonsImages];
    }else{
        NSMutableDictionary *matchDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: [self matchPhotoPath]];
        NSMutableArray *matchPhotos = [matchDictionary objectForKey:@"match_photos"];
        for (NSString *photoName in matchPhotos) {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",photoName]];
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
        [matchDictionary setObject:[NSMutableArray array] forKey:@"match_photos"];
        [matchDictionary writeToFile:[self matchPhotoPath] atomically:YES];
    }
    
}

- (NSString *)matchPhotoPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"match.plist"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addButtonPressed:(id)sender
{
    if (self.photos.count != 15) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"Take a Photo",@"Pick from Album",nil];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Take a Photo"]) {
        [self takeNewPhoto];
    }else if([title isEqualToString:@"Pick from Album"]){
        [self selectFromAlbum];
    }else if ([title isEqualToString:@"Delete Photo"]){
        [self.photos removeObjectAtIndex:actionSheet.tag];
        NSMutableDictionary *matchDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: [self matchPhotoPath]];
        NSMutableArray *matchPhotos = [matchDictionary objectForKey:@"match_photos"];
        NSString *photoName = [matchPhotos objectAtIndex:actionSheet.tag];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",photoName]];
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        [matchPhotos removeObjectAtIndex:actionSheet.tag];
        [matchDictionary setObject:matchPhotos forKey:@"match_photos"];
        [matchDictionary writeToFile:[self matchPhotoPath] atomically:YES];
        [self resetPhotoButtonsImages];
    }
}

- (void)resetPhotoButtonsImages
{
    for (NSInteger i = 0; i < 15; i++) {
        UIButton *button = [self.photoButtons objectAtIndex:i];
        if (i < self.photos.count) {
            UIImage *image = [self.photos objectAtIndex:i];
            [button setImage:image forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:@"graphic_photo"] forState:UIControlStateNormal];
        }
    }
}

- (void)takeNewPhoto{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)selectFromAlbum{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGRect rect = CGRectMake(0,0,100,100);
    UIGraphicsBeginImageContext( rect.size );
    // use the local image variable to draw in context
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.photos addObject:picture1];
    [self resetPhotoButtonsImages];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    
    NSMutableDictionary *matchDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: [self matchPhotoPath]];
    NSMutableArray *matchPhotos = [matchDictionary objectForKey:@"match_photos"];
    [matchPhotos addObject:[NSString stringWithFormat:@"%@.jpg",stringFromDate]];
    [matchDictionary setObject:matchPhotos forKey:@"match_photos"];
    [matchDictionary writeToFile:[self matchPhotoPath] atomically:YES];

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.jpg",stringFromDate]];
        NSData *data = UIImageJPEGRepresentation(picture1, 0.5);
        [data writeToFile:path atomically:YES];
    });
    [picker dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(id)sender {
    
    if (self.photos.count == 15) {
        
        LMGameViewController *viewController = (LMGameViewController *)self.presentingViewController;
        viewController.isInitialLoaded = YES;
        [viewController reloadPhotoMatch];
        
        UIButton *button = sender;
        POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
        scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
        scaleAnimation.springBounciness = 18.0f;
        [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
        [scaleAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (IBAction)menuButtonPressed:(id)sender {
    UIButton *button = sender;
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    [button.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
    [scaleAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        
        if (self.photos.count != 15) {
            LMConfirmationViewController *viewController = [[LMConfirmationViewController alloc]initWithNibName:@"LMConfirmationViewController" bundle:nil];
            viewController.delegate = self;
            viewController.tag = 1;
            viewController.transitioningDelegate = self;
            viewController.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:viewController
                               animated:YES
                             completion:NULL];
        }else{
             [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)photoButtonPressed:(id)sender {
    UIButton *button = sender;
    if (button.tag < self.photos.count) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"Delete Photo",nil];
        actionSheet.tag = button.tag;
        [actionSheet showInView:self.view];
    }
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
    NSMutableDictionary *matchDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: [self matchPhotoPath]];
    NSMutableArray *matchPhotos = [matchDictionary objectForKey:@"match_photos"];
    for (NSString *photoName in matchPhotos) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@",photoName]];
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
    [matchDictionary setObject:[NSMutableArray array] forKey:@"match_photos"];
    [matchDictionary writeToFile:[self matchPhotoPath] atomically:YES];
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
