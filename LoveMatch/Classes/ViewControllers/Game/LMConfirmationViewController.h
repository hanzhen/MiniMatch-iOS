//
//  LMConfirmationViewController.h
//  LoveMatch
//
//  Created by Bi Chen Ka Kit on 1/6/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import "LMBaseViewController.h"


@protocol LMConfirmationViewController <NSObject>

- (void)LMConfirmationViewControllerDidDismissWithTag:(NSInteger)tag;

@end

@interface LMConfirmationViewController : LMBaseViewController

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSInteger tag;

@end
