//
//  HomeViewController.m
//  ARPORTAL
//
//  Created by Suxin on 1/7/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeViewController.h"


@implementation HomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void) initUI
{
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

@end
