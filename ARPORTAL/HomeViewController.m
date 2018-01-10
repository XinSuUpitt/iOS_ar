//
//  HomeViewController.m
//  ARPORTAL
//
//  Created by Suxin on 1/7/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeViewController.h"
#import "Manager.h"
#import "ViewController.h"
#import "MightLikeViewController.h"
#import "HomeMainViewController.h"
#import "AddNewViewController.h"
#import "AccountViewController.h"


@implementation HomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    margin_Left = 30;
    margin_Right = 30;
    swipeOrScroll = SwipeOrScrollType_Default;
    
    [self initUI];
}

- (void)initUI
{
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initChildControllers];
    
    [self initTabBar];
    
    [self initTopBar];
    
    //init gesture
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    UIScreenEdgePanGestureRecognizer *rightEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightEdgeGesture:)];
    rightEdgeGesture.edges = UIRectEdgeRight;
    rightEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:rightEdgeGesture];
    
    centerX = self.view.bounds.size.width/2;
    
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    leftEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:leftEdgeGesture];
    
    [self setControllerNumType:ControllerNumType_HomeMain];
    
}

- (void)initTopBar
{
    CGFloat originY = 20 + ([Manager isPhoneX]?24:0);
    CGFloat iconSize = 28;
    
    UIImageView *tapBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, originY+iconSize+10)];
    [tapBGView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tapBGView];
    
    accountIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, originY, iconSize, iconSize)];
    [accountIV setImage:[UIImage imageNamed:@"account-100"]];
    accountIV.image = [accountIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [accountIV setTintColor:UIColorFromRGB(0x102037)];
    [self.view addSubview:accountIV];
    UITapGestureRecognizer *accountPageGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(accountPageGRTap)];
    [accountIV setUserInteractionEnabled:YES];
    [accountIV addGestureRecognizer:accountPageGR];
    
    arPageIV = [[UIImageView alloc] initWithFrame:CGRectMake(width - iconSize - 10, originY, iconSize, iconSize)];
    [arPageIV setImage:[UIImage imageNamed:@"camera"]];
    arPageIV.image = [arPageIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [arPageIV setTintColor:UIColorFromRGB(0x102037)];
    [self.view addSubview:arPageIV];
    UITapGestureRecognizer *arPageIVTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arPageIVTapGRTap)];
    [arPageIV setUserInteractionEnabled:YES];
    [arPageIV addGestureRecognizer:arPageIVTapGR];
    
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor colorWithRed:16.f/255.f green:32.f/255.f blue:55.f/255.f alpha:0.2].CGColor;
    border.frame = CGRectMake(0, accountIV.frame.origin.y+accountIV.frame.size.height+10, width, 1);
    [self.view.layer addSublayer:border];
    
}

- (void)initChildControllers
{
    self.view.backgroundColor = [UIColor clearColor];
    
    self.mightLikeViewCtrl = [[MightLikeViewController alloc] initWithNibName:@"MightLikeViewController" bundle:nil];
    self.mightLikeViewCtrl.delegate = self;
    
    self.homeMainViewCtrl = [[HomeMainViewController alloc] initWithNibName:@"HomeMainViewController" bundle:nil];
    self.homeMainViewCtrl.delegate = self;
    
    self.addNewViewCtrl = [[AddNewViewController alloc] initWithNibName:@"AddNewViewController" bundle:nil];
    self.addNewViewCtrl.delegate = self;
}

- (void)initTabBar
{
    self.delegate = self;
    
    self.viewControllers = @[self.mightLikeViewCtrl, self.homeMainViewCtrl, self.addNewViewCtrl];
    [self.tabBar setTintColor:UIColorFromRGB(0xDB434F)];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    
    self.mightLikeViewCtrl.tabBarItem.image = [UIImage imageNamed:@"heart-7"];
    self.homeMainViewCtrl.tabBarItem.image = [UIImage imageNamed:@"home-7"];
    self.addNewViewCtrl.tabBarItem.image = [UIImage imageNamed:@"camera-7"];
    
    self.selectedIndex = MenuTabType_HomeMain;
    
}

#pragma mark - type getter and setter
- (void)setControllerNumType:(ControllerNumType)type
{
    controllerNumType = type;
}

- (ControllerNumType)getControllerNumType
{
    return controllerNumType;
}

- (MenuTabType)getMenuCurrTabType {
    return (MenuTabType) self.selectedIndex;
}

- (void)setSwipeType:(SwipeOrScrollType)type
{
    swipeOrScroll = type;
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSUInteger controllerIndex = [self.viewControllers indexOfObject:viewController];
    
    UIView *fromView = tabBarController.selectedViewController.view;
    UIView *toView = [tabBarController.viewControllers[controllerIndex] view];
    
    if (controllerIndex == tabBarController.selectedIndex) {
        return NO;
    }
    
    if (controllerIndex == 2) {
        [self setControllerNumType:ControllerNumType_AddNew];
    } else if (controllerIndex == 1) {
        [self setControllerNumType:ControllerNumType_HomeMain];
    } else {
        [self setControllerNumType:ControllerNumType_MightLike];
    }
    
    CGRect viewSize = fromView.frame;
    BOOL scrollRight = controllerIndex > tabBarController.selectedIndex;
    
    [fromView.superview addSubview:toView];
    toView.frame = CGRectMake((scrollRight?width:-width), viewSize.origin.y, width, viewSize.size.height);
    [self.tabBar setUserInteractionEnabled:NO];
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromView.frame = CGRectMake((scrollRight?-width:width), viewSize.origin.y, width, viewSize.size.height);
        toView.frame = CGRectMake(0, viewSize.origin.y, width, viewSize.size.height);
    } completion:^(BOOL finished) {
        if (finished){
            tabBarController.selectedIndex = controllerIndex;
            [self.tabBar setUserInteractionEnabled:YES];
            swipeOrScroll = SwipeOrScrollType_Default;
            [fromView removeFromSuperview];
        }
    }];
    return NO;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (viewController == self.currentTabVC){
        return;
    }
    self.currentTabVC = viewController;
}

#pragma mark - homeViewCtrl delegate methods
-(CGFloat)getTopBarHeight
{
    return ([Manager isPhoneX]?24:0) + 59;
}

- (void)getimageString:(NSString *)string
{
    [self.viewCtrlDelegate showPaneramaWith:string];
}


#pragma mark - tap gesture method
- (void)arPageIVTapGRTap
{
    [self.viewCtrlDelegate backToARPageFromHome];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ViewController *viewCtrl = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//    viewCtrl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:viewCtrl animated:YES completion:nil];
}

- (void)accountPageGRTap
{
    [self.viewCtrlDelegate gotoAccountPageFromHome];
}

#pragma mark - swipe gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//handle right edge swipe gesture to go back to arpage
- (void)handleRightEdgeGesture: (UIScreenEdgePanGestureRecognizer *)gesture
{
    CGFloat distance = 100;
    UIView *fromView;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [self.viewCtrlDelegate showARPageUnderView];
    fromView = self.view;
    if (UIGestureRecognizerStateBegan == gesture.state || UIGestureRecognizerStateChanged == gesture.state) {
        CGPoint transition = [gesture translationInView:gesture.view];
        fromView.center = CGPointMake(centerX + transition.x, fromView.center.y);
    } else {
        if (centerX - fromView.center.x > distance) {
            [UIView animateWithDuration:.3 animations:^{
                fromView.center = CGPointMake(centerX-screenWidth, fromView.center.y);
            } completion:^(BOOL finished) {
                [fromView removeFromSuperview];
            }];
        } else {
            isEdgeSwipeGesture = NO;
            [self.viewCtrlDelegate pauseARPageUnderView];
            [UIView animateWithDuration:.3 animations:^{
                fromView.center = CGPointMake(centerX, fromView.center.y);
            } completion:^(BOOL finished) {
                nil;
            }];
        }
    }
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture
{
    CGFloat distance = 100;
    UIView *fromView;
    UIView *toView;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    fromView = self.view;
    AccountViewController *accountCtrl = [self.viewCtrlDelegate getAccountCtrl];
    toView = accountCtrl.view;
    [fromView.superview addSubview:toView];
    accountCtrl.view.frame = CGRectMake(-screenWidth, 0, width, height);
    
    if (UIGestureRecognizerStateBegan == gesture.state || UIGestureRecognizerStateChanged == gesture.state) {
        CGPoint transition = [gesture translationInView:gesture.view];
        fromView.center = CGPointMake(centerX + transition.x, fromView.center.y);
        toView.center = CGPointMake(centerX + transition.x - width, fromView.center.y);
    } else {
        CGPoint transition = [gesture translationInView:gesture.view];
        if (fromView.center.x - centerX> distance) {
            toView.center = CGPointMake(centerX + transition.x - width, fromView.center.y);
            [UIView animateWithDuration:.3 animations:^{
                fromView.center = CGPointMake(centerX+screenWidth, fromView.center.y);
                toView.center = CGPointMake(centerX, fromView.center.y);
            } completion:^(BOOL finished) {
                [fromView removeFromSuperview];
            }];
        } else {
            isEdgeSwipeGesture = NO;
            toView.center = CGPointMake(centerX + transition.x - width, fromView.center.y);
            [UIView animateWithDuration:.3 animations:^{
                fromView.center = CGPointMake(centerX, fromView.center.y);
                toView.center = CGPointMake(centerX-screenWidth, fromView.center.y);
            } completion:^(BOOL finished) {
                [toView removeFromSuperview];
            }];
        }
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (swipeOrScroll == SwipeOrScrollType_Default) {
        if (fabs([gesture velocityInView:gesture.view].y) > fabs([gesture velocityInView:gesture.view].x)) {
            swipeOrScroll = SwipeOrScrollType_Scroll;
        } else {
            swipeOrScroll = SwipeOrScrollType_Swipe;
        }
    }
    
    CGPoint transition = [gesture translationInView:gesture.view];
    UIView *fromView;
    UIView *toView;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat distance = 60;
    if (UIGestureRecognizerStateBegan == gesture.state && ([gesture locationInView:gesture.view].x > screenWidth - distance || [gesture locationInView:gesture.view].x < distance)) {
        isEdgeSwipeGesture = YES;
    }
    
    if (UIGestureRecognizerStateEnded == gesture.state && transition.x > 0) {
        isEdgeSwipeGesture = NO;
    }
    
    if (isEdgeSwipeGesture) {
        return;
    } else {
        switch ([self getControllerNumType]) {
            case ControllerNumType_MightLike:
                {
                    if (toView == nil) {
                        fromView = self.mightLikeViewCtrl.view;
                        toView = self.homeMainViewCtrl.view;
                        [fromView.superview addSubview:toView];
                        toView.frame = CGRectMake(screenWidth, 0, width, height);
                    }
                    fromView = self.mightLikeViewCtrl.view;
                    toView = self.homeMainViewCtrl.view;
                    if (UIGestureRecognizerStateBegan == gesture.state || UIGestureRecognizerStateChanged == gesture.state) {
                        if (swipeOrScroll == SwipeOrScrollType_Swipe) {
                            if (transition.x < 0) {
                                fromView.center = CGPointMake(centerX + transition.x, fromView.center.y);
                                toView.center = CGPointMake(centerX + transition.x + screenWidth, fromView.center.y);
                            } else {
                                fromView.center = CGPointMake(centerX, fromView.center.y);
                                toView.center = CGPointMake(centerX + screenWidth, fromView.center.y);
                            }
                        } else {
                            return;
                        }
                    } else {
                        swipeOrScroll = SwipeOrScrollType_Default;
                        if (centerX - fromView.center.x > distance) {
                            toView.center = CGPointMake(fromView.center.x + screenWidth, fromView.center.y);
                            [UIView animateWithDuration:.3 animations:^{
                                fromView.center = CGPointMake(-centerX, fromView.center.y);
                                toView.center = CGPointMake(centerX, fromView.center.y);
                            } completion:^(BOOL finished) {
                                [fromView removeFromSuperview];
                            }];
                            [self setControllerNumType:ControllerNumType_HomeMain];
                            self.homeMainViewCtrl.tabBarController.selectedIndex = 1;
                        } else {
                            toView.center = CGPointMake(fromView.center.x + screenWidth, fromView.center.y);
                            [UIView animateWithDuration:.3 animations:^{
                                fromView.center = CGPointMake(centerX, fromView.center.y);
                                toView.center = CGPointMake(screenWidth+centerX, fromView.center.y);
                            } completion:^(BOOL finished) {
                                [toView removeFromSuperview];
                            }];
                        }
                    }
                    break;
                }
            case ControllerNumType_HomeMain: {
                UIView *leftToView;
                UIView *rightToView;
                fromView = self.homeMainViewCtrl.view;
                leftToView = self.mightLikeViewCtrl.view;
                rightToView = self.addNewViewCtrl.view;
                [fromView.superview addSubview:leftToView];
                [fromView.superview addSubview:rightToView];
                leftToView.frame = CGRectMake(-screenWidth, 0, width, height);
                rightToView.frame = CGRectMake(screenWidth, 0, width, height);
                if (UIGestureRecognizerStateBegan == gesture.state || UIGestureRecognizerStateChanged == gesture.state) {
                    if (swipeOrScroll == SwipeOrScrollType_Swipe) {
                        fromView.center = CGPointMake(centerX + transition.x, fromView.center.y);
                        leftToView.center = CGPointMake(centerX + transition.x - screenWidth, fromView.center.y);
                        rightToView.center = CGPointMake(centerX + transition.x + screenWidth, fromView.center.y);
                    } else {
                        return;
                    }
                } else {
                    swipeOrScroll = SwipeOrScrollType_Default;
                    if (fromView.center.x - centerX > distance) {
                        leftToView.center = CGPointMake(fromView.center.x-screenWidth, fromView.center.y);
                        rightToView.center = CGPointMake(fromView.center.x+screenWidth, fromView.center.y);
                        [UIView animateWithDuration:.3 animations:^{
                            leftToView.center = CGPointMake(centerX, fromView.center.y);
                            fromView.center = CGPointMake(centerX+screenWidth, fromView.center.y);
                            rightToView.center = CGPointMake(centerX+screenWidth*2, fromView.center.y);
                        } completion:^(BOOL finished) {
                            [fromView removeFromSuperview];
                            [rightToView removeFromSuperview];
                        }];
                        [self setControllerNumType:ControllerNumType_MightLike];
                        self.mightLikeViewCtrl.tabBarController.selectedIndex = 0;
                    } else if (centerX - fromView.center.x < distance && fromView.center.x - centerX < distance) {
                        leftToView.center  =CGPointMake(fromView.center.x-screenWidth, fromView.center.y);
                        rightToView.center = CGPointMake(fromView.center.x+screenWidth, fromView.center.y);
                        [UIView animateWithDuration:.3 animations:^{
                            leftToView.center = CGPointMake(centerX-screenWidth, fromView.center.y);
                            fromView.center = CGPointMake(centerX, fromView.center.y);
                            rightToView.center = CGPointMake(centerX+screenWidth, fromView.center.y);
                        } completion:^(BOOL finished) {
                            [leftToView removeFromSuperview];
                            [rightToView removeFromSuperview];
                        }];
                    } else {
                        leftToView.center = CGPointMake(fromView.center.x-screenWidth, fromView.center.y);
                        rightToView.center = CGPointMake(fromView.center.x+screenWidth, fromView.center.y);
                        [UIView animateWithDuration:.3 animations:^{
                            leftToView.center = CGPointMake(centerX-screenWidth*2, fromView.center.y);
                            fromView.center = CGPointMake(centerX-screenWidth, fromView.center.y);
                            rightToView.center = CGPointMake(centerX, fromView.center.y);
                        } completion:^(BOOL finished) {
                            [leftToView removeFromSuperview];
                            [fromView removeFromSuperview];
                        }];
                        [self setControllerNumType:ControllerNumType_AddNew];
                        self.addNewViewCtrl.tabBarController.selectedIndex = 2;
                    }
                }
                break;
            }
            case ControllerNumType_AddNew: {
                if (toView == nil) {
                    fromView = self.addNewViewCtrl.view;
                    toView = self.homeMainViewCtrl.view;
                    [fromView.superview addSubview:toView];
                    toView.frame = CGRectMake(-screenWidth, 0, width, height);
                }
                fromView = self.addNewViewCtrl.view;
                toView = self.homeMainViewCtrl.view;
                toView.frame = CGRectMake(-screenWidth, 0, width, height);
                
                if (UIGestureRecognizerStateBegan == gesture.state || UIGestureRecognizerStateChanged == gesture.state) {
                    if (swipeOrScroll == SwipeOrScrollType_Swipe) {
                        if (transition.x > 0) {
                            fromView.center = CGPointMake(centerX + transition.x, fromView.center.y);
                            toView.center = CGPointMake(centerX + transition.x - screenWidth, fromView.center.y);
                        } else {
                            fromView.center = CGPointMake(centerX, fromView.center.y);
                            toView.center = CGPointMake(centerX  - screenWidth, fromView.center.y);
                        }
                    } else {
                        return;
                    }
                } else {
                    swipeOrScroll = SwipeOrScrollType_Default;
                    if (fromView.center.x - centerX > distance) {
                        toView.center = CGPointMake(fromView.center.x-screenWidth, fromView.center.y);
                        [UIView animateWithDuration:.3 animations:^{
                            fromView.center = CGPointMake(centerX + screenWidth, fromView.center.y);
                            toView.center = CGPointMake(centerX, fromView.center.y);
                        } completion:^(BOOL finished) {
                            [fromView removeFromSuperview];
                        }];
                        [self setControllerNumType:ControllerNumType_HomeMain];
                        self.homeMainViewCtrl.tabBarController.selectedIndex = 1;
                    } else {
                        toView.center = CGPointMake(fromView.center.x-screenWidth, fromView.center.y);
                        [UIView animateWithDuration:.3 animations:^{
                            fromView.center = CGPointMake(centerX, fromView.center.y);
                            toView.center = CGPointMake(centerX-screenWidth, fromView.center.y);
                        } completion:^(BOOL finished) {
                            [toView removeFromSuperview];
                        }];
                    }
                    toView = nil;
                }
                break;
            }
            default:
                break;
        }
    }
    
}

@end
