//
//  HomeViewController.h
//  ARPORTAL
//
//  Created by Suxin on 1/7/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@protocol HomeViewCtrlDegelate <NSObject>

@end

@class MightLikeViewController;
@class HomeMainViewController;
@class AddNewViewController;

@interface HomeViewController : UITabBarController<UITabBarControllerDelegate, HomeViewCtrlDegelate>
{
    CGFloat width;
    CGFloat height;
    
    //top bar
    UIImageView *accountIV;
    UIImageView *arPageIV;
    

}

@property (nonatomic, assign) id<ViewControllerDelegate> viewCtrlDelegate;

@property (nonatomic, strong) MightLikeViewController *mightLikeViewCtrl;
@property (nonatomic, strong) HomeMainViewController *homeMainViewCtrl;
@property (nonatomic, strong) AddNewViewController *addNewViewCtrl;

@end
