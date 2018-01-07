//
//  HomeViewController.h
//  ARPORTAL
//
//  Created by Suxin on 1/7/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface HomeViewController : UITabBarController<UITabBarControllerDelegate>
{
    CGFloat width;
    CGFloat height;
    
    //top bar
    UIImageView *accountIV;
    UIImageView *arPageIV;
}

@property (nonatomic, assign) id<ViewControllerDelegate> viewCtrlDelegate;

@end
