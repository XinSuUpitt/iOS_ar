//
//  MightLikeViewController.m
//  ARPORTAL
//
//  Created by Suxin on 1/7/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MightLikeViewController.h"
#import "Manager.h"

@implementation MightLikeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self inittableImgListArray];
    
    [self initCollectionView];
}

- (void)initCollectionView
{
    CGFloat topbarHeight = [self.delegate getTopBarHeight];
    NSLog(@"top bar height %f", topbarHeight);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topbarHeight, width, height - topbarHeight) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"mightLikeCollectionViewCell"];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)inittableImgListArray
{
    likeImgArray = [[NSArray alloc] initWithObjects:@"art.scnassets/user_1.jpg", @"art.scnassets/user_2.jpg", @"art.scnassets/user_3.jpg", @"art.scnassets/user_4.jpg", @"art.scnassets/user_5.jpg", @"art.scnassets/user_6.jpg", @"art.scnassets/user_7.jpg", @"art.scnassets/user_8.jpg", @"art.scnassets/user_9.jpg", @"art.scnassets/user_10.jpg", @"art.scnassets/user_11.jpg", @"art.scnassets/user_12.jpg", @"art.scnassets/user_13.jpg", @"art.scnassets/user_14.jpg",nil];
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
        newSize.width = (width - 1) * 0.38;
    } else {
        newSize.width = (width - 1) * 0.62;
    }
    return newSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"mightLikeCollectionViewCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.clipsToBounds = YES;
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *name = [likeImgArray objectAtIndex:[indexPath row]];
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:name]];
    
    cell.backgroundView = bgView;
    
    
    [cell addSubview:bgView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imageString = [likeImgArray objectAtIndex:[indexPath row]];
    [self.delegate getimageString:imageString];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 14;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

@end
