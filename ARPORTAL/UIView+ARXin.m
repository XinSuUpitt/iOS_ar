//
//  UIView+ARXin.m
//  ARPORTAL
//
//  Created by Suxin on 1/7/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+ARXin.h"

@implementation UIView (ARXin)

- (void)addBottomBorderWithColor:(UIColor*) color andWidth:(CGFloat) borderWidth
{
    CALayer *border = [CALayer layer];
    border.backgroundColor = color.CGColor;
    border.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, borderWidth);
    [self.layer addSublayer:border];
}

@end
