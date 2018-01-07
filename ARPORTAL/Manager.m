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

@end
