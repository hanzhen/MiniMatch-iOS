//
//  UIFont+LMFont.h
//  LoveMatch
//
//  Created by Bi Chen Ka Kit on 31/5/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    BOLD,
    THIN,
    REGULAR,
    LIGHT,
}ThemeFontType;

@interface UIFont (LMFont)

+ (UIFont *)themeFont:(ThemeFontType)fontType size:(float)size;

@end
