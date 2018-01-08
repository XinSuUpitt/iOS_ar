//
//  HomeMainViewController.h
//  ARPORTAL
//
//  Created by Suxin on 1/7/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "Manager.h"

@interface HomeMainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    Manager *sharedManager;
    
    CGFloat width;
    CGFloat height;
    
    NSArray *imgNameArray;
    NSString *panameraViewImgString;
    NSArray *imgListNameArray;
    
    UIView *hotImgsView;
    UIScrollView *horizontalScrollView;
    
    UITableView *tableView;
    UIRefreshControl *tableRefreshControl;
    CGFloat cellHeight;
    CGFloat limitCellNameLabWidth;
}

@property (nonatomic, assign) id<HomeViewCtrlDegelate> delegate;

@end
