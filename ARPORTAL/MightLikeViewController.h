//
//  MightLikeViewController.h
//  ARPORTAL
//
//  Created by Suxin on 1/7/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface MightLikeViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat width;
    CGFloat height;
    
    NSArray *likeImgArray;
    
    UICollectionView *collectionView;
}

@property (nonatomic, assign) id<HomeViewCtrlDegelate> delegate;
@end
