//
//  HomeViewController.h
//  ARPORTAL
//
//  Created by Suxin on 1/7/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

typedef enum{
    MenuTabType_Unknown = -1,
    MenuTabType_MightLike,
    MenuTabType_HomeMain,
    MenuTabType_AddNew,
} MenuTabType;

typedef enum{
    SwipeOrScrollType_Default = -1,
    SwipeOrScrollType_Swipe = 0,
    SwipeOrScrollType_Scroll = 1,
} SwipeOrScrollType;

typedef enum{
    ControllerNumType_MightLike = 0,
    ControllerNumType_HomeMain,
    ControllerNumType_AddNew,
} ControllerNumType;

@protocol HomeViewCtrlDegelate <NSObject>
-(CGFloat)getTopBarHeight;
- (void)getimageString:(NSString *)string;
- (void)setSwipeType:(SwipeOrScrollType)type;
@end

@class MightLikeViewController;
@class HomeMainViewController;
@class AddNewViewController;

@interface HomeViewController : UITabBarController<UITabBarControllerDelegate, HomeViewCtrlDegelate, UIGestureRecognizerDelegate>
{
    CGFloat width;
    CGFloat height;
    
    BOOL isEdgeSwipeGesture;
    int swipeOrScroll;
    CGFloat margin_Right;
    CGFloat margin_Left;
    CGFloat centerX;
    ControllerNumType controllerNumType;
    
    //top bar
    UIImageView *accountIV;
    UIImageView *arPageIV;
    

}

@property (nonatomic, assign) id<ViewControllerDelegate> viewCtrlDelegate;

@property (nonatomic, strong) MightLikeViewController *mightLikeViewCtrl;
@property (nonatomic, strong) HomeMainViewController *homeMainViewCtrl;
@property (nonatomic, strong) AddNewViewController *addNewViewCtrl;

@property (nonatomic, assign) UIViewController *currentTabVC;

@end
