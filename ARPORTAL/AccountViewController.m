//
//  AccountViewController.m
//  ARPORTAL
//
//  Created by Suxin on 1/7/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountViewController.h"
#import "Manager.h"
#import "ViewController.h"

@implementation AccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self initImgListArray];
    
    [self initTopBar];
    
    [self initCover];
    
    [self initAccountSettingsEditings];
    
    [self initCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)initTopBar
{
    CGFloat originY = 20 + ([Manager isPhoneX]?24:0);
    CGFloat iconSize = 28;
    
    tapBGView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, originY+iconSize+10)];
    [tapBGView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tapBGView];
    
    arPageIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, originY, iconSize, iconSize)];
    [arPageIV setImage:[UIImage imageNamed:@"camera"]];
    arPageIV.image = [arPageIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [arPageIV setTintColor:UIColorFromRGB(0x102037)];
    [self.view addSubview:arPageIV];
    UITapGestureRecognizer *arPageIVTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arPageIVTapGRTap)];
    [arPageIV setUserInteractionEnabled:YES];
    [arPageIV addGestureRecognizer:arPageIVTapGR];
    
    homeIV = [[UIImageView alloc] initWithFrame:CGRectMake(width - iconSize - 10, originY, iconSize, iconSize)];
    [homeIV setImage:[UIImage imageNamed:@"home"]];
    homeIV.image = [homeIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [homeIV setTintColor:UIColorFromRGB(0x102037)];
    [self.view addSubview:homeIV];
    UITapGestureRecognizer *homePageIVTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(homePageIVTapGRTap)];
    [homeIV setUserInteractionEnabled:YES];
    [homeIV addGestureRecognizer:homePageIVTapGR];
    
    
    CALayer *border = [CALayer layer];
    border.backgroundColor = [UIColor colorWithRed:16.f/255.f green:32.f/255.f blue:55.f/255.f alpha:0.2].CGColor;
    border.frame = CGRectMake(0, homeIV.frame.origin.y+homeIV.frame.size.height+10, width, 1);
    [self.view.layer addSublayer:border];
    
}

- (void)initCover
{
    coverImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, tapBGView.frame.origin.y+tapBGView.frame.size.height+1, width, width/2)];
    [coverImgView setImage:[UIImage imageNamed:@"art.scnassets/user_18.jpg"]];
    [self.view addSubview:coverImgView];
}

- (void)initAccountSettingsEditings
{
    CGFloat radius = 35;
    CGFloat centerY = coverImgView.frame.origin.y+coverImgView.frame.size.height;
    CGFloat centerX = radius + 20;
    placeholderBgView = [[UIImageView alloc] initWithFrame:CGRectMake(centerX - radius, centerY - radius, 2*radius, 2*radius)];
    placeholderBgView.layer.cornerRadius = radius;
    placeholderBgView.layer.borderWidth = 0.5;
    placeholderBgView.layer.borderColor = UIColorFromRGB(0x102037).CGColor;
    placeholderBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:placeholderBgView];
    
    UIImageView *cameraPHView = [[UIImageView alloc] initWithFrame:CGRectMake(placeholderBgView.center.x+11, placeholderBgView.center.y+11, 24, 24)];
    [cameraPHView setImage:[UIImage imageNamed:@"edit"]];
    [cameraPHView setTintColor:UIColorFromRGB(0x102037)];
    [self.view addSubview:cameraPHView];
    
    nameLab = [[UILabel alloc] initWithFrame:CGRectMake(centerX - radius, placeholderBgView.frame.origin.y+placeholderBgView.frame.size.height + 10, width, 17)];
    nameLab.text = @"Xin Su";
    nameLab.font = [UIFont boldSystemFontOfSize:15];
    nameLab.textColor =UIColorFromRGB(0x102037);
    nameLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:nameLab];
    
    signatureLab = [[UILabel alloc] initWithFrame:CGRectMake(centerX - radius, nameLab.frame.origin.y+nameLab.frame.size.height, width, 17)];
    signatureLab.text = @"Let's go warriors!";
    signatureLab.font = [UIFont systemFontOfSize:14];
    signatureLab.textColor =UIColorFromRGB(0x102037);
    signatureLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:signatureLab];
    
    followersNumLab = [[UILabel alloc] initWithFrame:CGRectMake(width/3, centerY+10, width*2/9, 20)];
    int followerNum = 45;
    followersNumLab.text = [NSString stringWithFormat:@"%d", followerNum];
    followersNumLab.font = [UIFont boldSystemFontOfSize:13];
    followersNumLab.textColor = UIColorFromRGB(0x102037);
    followersNumLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:followersNumLab];
    
    followingNumLab = [[UILabel alloc] initWithFrame:CGRectMake(width*5/9, centerY+10, width*2/9, 20)];
    int followingNum = 45;
    followingNumLab.text = [NSString stringWithFormat:@"%d", followingNum];
    followingNumLab.font = [UIFont boldSystemFontOfSize:13];
    followingNumLab.textColor = UIColorFromRGB(0x102037);
    followingNumLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:followingNumLab];
    
    UILabel *followerTxt = [[UILabel alloc] initWithFrame:CGRectMake(width/3, followersNumLab.frame.origin.y+followersNumLab.frame.size.height, width*2/9, 20)];
    followerTxt.text = @"followers";
    followerTxt.font = [UIFont systemFontOfSize:11];
    followerTxt.textColor = UIColorFromRGB(0x102037);
    followerTxt.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:followerTxt];
    
    UILabel *followingTxt = [[UILabel alloc] initWithFrame:CGRectMake(width*5/9, followersNumLab.frame.origin.y+followersNumLab.frame.size.height, width*2/9, 20)];
    followingTxt.text = @"followings";
    followingTxt.font = [UIFont systemFontOfSize:11];
    followingTxt.textColor = UIColorFromRGB(0x102037);
    followingTxt.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:followingTxt];
    
    settingImgView = [[UIImageView alloc] initWithFrame:CGRectMake(width*8/9-13, centerY+15, 26, 26)];
    [settingImgView setImage:[UIImage imageNamed:@"cog"]];
    [settingImgView setTintColor:UIColorFromRGB(0x102037)];
    [self.view addSubview:settingImgView];
    
}

- (void)initCollectionView
{
    CGFloat originY = signatureLab.frame.origin.y + signatureLab.frame.size.height + 10;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, originY, width, height - originY) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"accountCollectionViewCell"];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:collectionView];
}

- (void)initImgListArray
{
    imgListArray = [[NSArray alloc] initWithObjects:@"art.scnassets/user_15.jpg", @"art.scnassets/user_16.jpg", @"art.scnassets/user_17.jpg", @"art.scnassets/user_18.jpg", @"art.scnassets/user_19.jpg", @"art.scnassets/user_20.jpg", @"art.scnassets/user_21.jpg", @"art.scnassets/user_22.jpg", @"art.scnassets/user_23.jpg", @"art.scnassets/user_24.jpg", @"art.scnassets/user_25.jpg", @"art.scnassets/user_26.jpg",nil];
}

#pragma mark - collectionviewdelegate methods
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize newSize = CGSizeZero;
    newSize.height = 140;
    if (indexPath.item %4 == 0 || indexPath.item % 4 == 3) {
        newSize.width = (width - 1) * 0.50;
    } else {
        newSize.width = (width - 1) * 0.50;
    }
    return newSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"accountCollectionViewCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.clipsToBounds = YES;
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *name = [imgListArray objectAtIndex:[indexPath row]];
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    
    cell.backgroundView = bgView;
    
    
    [cell addSubview:bgView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageString = [imgListArray objectAtIndex:[indexPath row]];
    [self.viewCtrlDelegate showPaneramaFromAccount:imageString];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

#pragma mark - tap gesture method
- (void)arPageIVTapGRTap
{
    [self.viewCtrlDelegate backToARPageFromAccount];
}

- (void)homePageIVTapGRTap
{
    [self.viewCtrlDelegate gotoHomePageFromAccount];
}

@end
