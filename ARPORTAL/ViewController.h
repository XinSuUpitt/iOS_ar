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
#import "HomeViewController.h"
#import "AccountViewController.h"

@class HomeViewController;
@class AccountViewController;

@interface ViewController : UIViewController<UIScrollViewDelegate> {
    CGFloat width;
    CGFloat height;
    
    //top bar
    UIImageView *homeIV;
    UIImageView *addIV;
    UIImageView *accountIV;
    
    NSArray *imgNameArray;
    NSString *panameraViewImgString;
    
    UIView *hotImgsView;
    UIScrollView *horizontalScrollView;
    
    SCNNode *sphereNode;
}

@property (nonatomic, strong) HomeViewController *homeCtrl;
@property (nonatomic, strong) AccountViewController *accountCtrl;

@end
