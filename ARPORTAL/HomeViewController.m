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


@implementation HomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    

    
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
    
    CGRect viewSize = fromView.frame;
    BOOL scrollRight = controllerIndex > tabBarController.selectedIndex;
    
    [fromView.superview addSubview:toView];
    toView.frame = CGRectMake((scrollRight?width:-width), viewSize.origin.y, width, viewSize.size.height);
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromView.frame = CGRectMake((scrollRight?-width:width), viewSize.origin.y, width, viewSize.size.height);
        toView.frame = CGRectMake(0, viewSize.origin.y, width, viewSize.size.height);
    } completion:^(BOOL finished) {
        if (finished){
            tabBarController.selectedIndex = controllerIndex;
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
    return accountIV.frame.origin.y+accountIV.frame.size.height+11;
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

@end
