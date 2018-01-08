//
//  Manager.m
//  ARPORTAL
//
//  Created by Suxin on 1/6/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Manager.h"


@implementation Manager

+ (BOOL) isPhoneX
{
    CGSize size = [UIScreen mainScreen].currentMode.size;
    return MAX(size.height, size.width) / MIN(size.height, size.width) > 2.1;
}

#pragma mark - shadow
- (void)setShadowOfView:(UIView*)view withOffsetX:(CGFloat)x withOffsetY:(CGFloat)y withBlur:(CGFloat)blur withOpacity:(CGFloat)opacity
{
    [view.layer setShadowOffset:CGSizeMake(x, y)];
    [view.layer setShadowColor:UIColorFromRGB(0x102037).CGColor];
    [view.layer setShadowOpacity:opacity];
    [view.layer setShadowRadius:blur];
    [view.layer setShouldRasterize:YES];
}


@end
