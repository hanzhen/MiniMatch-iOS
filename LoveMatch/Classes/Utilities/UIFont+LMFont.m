//
//  UIFont+LMFont.m
//  LoveMatch
//
//  Created by Bi Chen Ka Kit on 31/5/14.
//  Copyright (c) 2014年 biworks. All rights reserved.
//

#import "UIFont+LMFont.h"

@implementation UIFont (LMFont)

+ (UIFont *)themeFont:(ThemeFontType)fontType size:(float)size
{
    NSString *fontTypeString = @"";
    switch (fontType) {
        case BOLD:
        {
            fontTypeString = @"Kirvy-Bold";
            break;
        }
        case REGULAR:
        {
            fontTypeString = @"Kirvy-Regular";
            break;
        }
        case THIN:
        {
            fontTypeString = @"Kirvy-Thin";
            break;
        }
        case LIGHT:
        {
            fontTypeString = @"Kirvy-Light";
            break;
        }
        default:
            break;
    }
    UIFont *font = [UIFont fontWithName:fontTypeString size:size];
    return font;
}

@end
