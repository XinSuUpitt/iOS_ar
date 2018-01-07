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
    
    [self initTopBar];
}

- (void)initTopBar
{
    CGFloat originY = 20 + ([Manager isPhoneX]?24:0);
    CGFloat iconSize = 28;
    
    accountIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, originY, iconSize, iconSize)];
    [accountIV setImage:[UIImage imageNamed:@"user"]];
    accountIV.image = [accountIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [accountIV setTintColor:UIColorFromRGB(0x102037)];
    [self.view addSubview:accountIV];
    
    arPageIV = [[UIImageView alloc] initWithFrame:CGRectMake(width - iconSize - 10, originY, iconSize, iconSize)];
    [arPageIV setImage:[UIImage imageNamed:@"picture-frame"]];
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

#pragma mark - tap gesture method
- (void)arPageIVTapGRTap
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewCtrl = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    viewCtrl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:viewCtrl animated:YES completion:nil];
}

@end
