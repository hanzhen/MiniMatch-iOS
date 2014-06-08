//
//  LMGameViewController.h
//  LoveMatch
//
//  Created by Bi Chen Ka Kit on 31/5/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMGameViewController : UIViewController

@property (nonatomic, assign) NSInteger type;
@property (assign, nonatomic) BOOL isInitialLoaded;

- (void)reloadPhotoMatch;

@end
