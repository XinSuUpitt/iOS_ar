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

@interface ViewController : UIViewController<UIScrollViewDelegate> {
    CGFloat width;
    CGFloat height;
    
    NSArray *imgNameArray;
    NSString *panameraViewImgString;
    
    UIView *hotImgsView;
    UIScrollView *horizontalScrollView;
    
    SCNNode *sphereNode;
}

@end