//
//  LMImagePickerViewController.m
//  LoveMatch
//
//  Created by bichenkk on 3/6/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import "LMImagePickerViewController.h"

@interface LMImagePickerViewController ()

@end

@implementation LMImagePickerViewController

static LMImagePickerViewController *_instance = nil;

+(LMImagePickerViewController*)Instance
{
    if (!_instance) {
        _instance = [[LMImagePickerViewController alloc]init];
    }
    return _instance;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIDeviceOrientationIsPortrait(toInterfaceOrientation);
}

@end
