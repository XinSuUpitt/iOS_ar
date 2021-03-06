//
//  ViewController.h
//  ARPORTAL
//
//  Created by Suxin on 12/30/17.
//  Copyright © 2017 Suxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@class HomeViewController;
@class AccountViewController;

@protocol ViewControllerDelegate <NSObject>
- (void)backToARPageFromHome;
- (void)gotoAccountPageFromHome;
- (void)backToARPageFromAccount;
- (void)gotoHomePageFromAccount;
- (void)showPaneramaWith:(NSString*)string;
- (void)showPaneramaFromAccount:(NSString*)string;
- (void)showARPageUnderView;
- (void)pauseARPageUnderView;
- (AccountViewController*)getAccountCtrl;
- (HomeViewController*)getHomeCtrl;
@end

@interface ViewController : UIViewController<UIScrollViewDelegate, ViewControllerDelegate, UIGestureRecognizerDelegate> {
    CGFloat width;
    CGFloat height;
    CGFloat centerX;
    
    BOOL showARScene;
    BOOL showVideo;
    
    //top bar
    UIImageView *homeIV;
    UIImageView *addIV;
    UIImageView *accountIV;
    UIImageView *exitIV;
    UIImageView *refreshIV;
    
    NSArray *imgNameArray;
    NSString *panameraViewImgString;
    
    UIView *hotImgsView;
    UIScrollView *horizontalScrollView;
    
    SCNNode *sphereNode;
    SCNPlane *plane;
    SCNNode *planeNode;
    ARPlaneAnchor *planeAnchor;
}

@property (nonatomic, strong) HomeViewController *homeCtrl;
@property (nonatomic, strong) AccountViewController *accountCtrl;

@end
