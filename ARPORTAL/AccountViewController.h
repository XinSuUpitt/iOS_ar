//
//  AccountViewController.h
//  ARPORTAL
//
//  Created by Suxin on 1/7/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AccountViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ViewControllerDelegate, UIGestureRecognizerDelegate>
{
    CGFloat width;
    CGFloat height;
    CGFloat centerX;
    
    NSArray *imgListArray;
    
    //top bar
    UIImageView *tapBGView;
    UIImageView *homeIV;
    UIImageView *arPageIV;
    
    //cover
    UIImageView *coverImgView;
    
    //account settings and editings
    UIImageView *placeholderBgView;
    UIImageView *accountImgView;
    
    UILabel *nameLab;
    UILabel *signatureLab;
    UILabel *followersNumLab;
    UILabel *followingNumLab;
    UIImageView *settingImgView;
    
    
    //collectionView
    UICollectionView *collectionView;
}

@property (nonatomic, assign) id<ViewControllerDelegate> viewCtrlDelegate;
@end
