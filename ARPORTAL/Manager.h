//
//  Manager.h
//  ARPORTAL
//
//  Created by Suxin on 1/6/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
    blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
    alpha:1.0]

@interface Manager : NSObject
+ (BOOL) isPhoneX;
@end
