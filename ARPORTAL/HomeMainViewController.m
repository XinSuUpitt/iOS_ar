//
//  HomeMainViewController.m
//  ARPORTAL
//
//  Created by Suxin on 1/7/18.
//  Copyright © 2018 Suxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeMainViewController.h"
#import "Manager.h"

@implementation HomeMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sharedManager = [Manager new];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    width = [UIScreen mainScreen].bounds.size.width;
    height = [UIScreen mainScreen].bounds.size.height;
    
    [self initHotView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)initHotView
{
    [self initBlurView];
    
    [self initHorizontalScrollView];
    
    [self initTable];
}

- (void)initBlurView
{
    CGFloat topbarHeight = [self.delegate getTopBarHeight];
    hotImgsView = [[UIView alloc] initWithFrame:CGRectMake(0, topbarHeight, width, 130)];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = hotImgsView.bounds;
    [hotImgsView addSubview:blurEffectView];
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    vibrancyView.frame = hotImgsView.bounds;
    [blurEffectView.contentView addSubview:vibrancyView];
    [self.view addSubview:hotImgsView];
    
    UILabel *hotTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    hotTitleLabel.text = @"Hot Landscapes";
    hotTitleLabel.textColor = UIColorFromRGB(0x102037);
    hotTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    hotTitleLabel.textAlignment = NSTextAlignmentLeft;
    [hotImgsView addSubview:hotTitleLabel];
}

- (void)initHorizontalScrollView
{
    horizontalScrollView = [[UIScrollView alloc] init];
    horizontalScrollView.delegate = self;
    int scrollWidth = 100;
    horizontalScrollView.frame = CGRectMake(hotImgsView.frame.origin.x, hotImgsView.frame.origin.y+30, width, scrollWidth-10);
    [self initImgArray];
    
    int xOffSet = 0;
    for (int i = 0; i < [imgNameArray count]; i++) {
        UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake(xOffSet + 10, 0, 80, 80)];
        [imageView setImage:[UIImage imageNamed:[imgNameArray objectAtIndex:i]] forState:UIControlStateNormal];
        imageView.tag = i;
        [imageView addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [horizontalScrollView addSubview:imageView];
        
        xOffSet += 100;
    }
    
    [self.view addSubview:horizontalScrollView];
    horizontalScrollView.contentSize = CGSizeMake(scrollWidth + xOffSet, scrollWidth);
}

- (void)initTable
{
    [self inittableImgListArray];
    cellHeight = 200.f;
    limitCellNameLabWidth = 250.f;
    CGFloat initTableY = hotImgsView.frame.origin.y + hotImgsView.frame.size.height;
    UITableViewStyle tableStyle = UITableViewStylePlain;
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, initTableY, width, height - initTableY) style:tableStyle];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    tableRefreshControl = [[UIRefreshControl alloc] init];
    [tableRefreshControl setTintColor:[UIColor colorWithRed:16.f/255.f green:32.f/255.f blue:55.f/255.f alpha:0.5]];
    [tableRefreshControl addTarget:self action:@selector(tableViewRefresh) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:tableRefreshControl];
}

- (void)initImgArray
{
    imgNameArray = [[NSArray alloc] initWithObjects:@"art.scnassets/01.jpg",@"art.scnassets/02.jpg",@"art.scnassets/03.jpg",@"art.scnassets/04.jpg",@"art.scnassets/05.jpg",@"art.scnassets/06.jpg",@"art.scnassets/07.jpg",@"art.scnassets/08.jpg",@"art.scnassets/09.jpg",@"art.scnassets/10.jpg",@"art.scnassets/11.jpg",@"art.scnassets/12.jpg",@"art.scnassets/13.jpg",@"art.scnassets/14.jpg",@"art.scnassets/15.jpg",@"art.scnassets/16.jpg",@"art.scnassets/17.jpg",@"art.scnassets/18.jpg", nil];
}

- (void)inittableImgListArray
{
    imgListNameArray = [[NSArray alloc] initWithObjects:@"art.scnassets/user_1.jpg", @"art.scnassets/user_2.jpg", @"art.scnassets/user_3.jpg", @"art.scnassets/user_4.jpg", @"art.scnassets/user_5.jpg", @"art.scnassets/user_6.jpg", @"art.scnassets/user_7.jpg", @"art.scnassets/user_8.jpg", @"art.scnassets/user_9.jpg", @"art.scnassets/user_10.jpg", @"art.scnassets/user_11.jpg", @"art.scnassets/user_12.jpg", @"art.scnassets/user_13.jpg", @"art.scnassets/user_14.jpg", @"art.scnassets/user_15.jpg", @"art.scnassets/user_16.jpg",nil];
}

#pragma mark - refresh methods
- (void)tableViewRefresh
{
    
}

#pragma mark - table view methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [imgListNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    UILabel *nameLab = nil;
    UIImageView *accountBGView;
    UIImageView *cellImgView;
    UIImageView *shadowImgView;
    UIImageView *blurImgView;
    
    NSString *name = [imgListNameArray objectAtIndex:[indexPath row]];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imgTableCell"];
    
    cell.clipsToBounds = YES;
    
    cellImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, width-20, cellHeight-20)];
    cellImgView.layer.cornerRadius = 12;
    cellImgView.clipsToBounds = YES;
    [cellImgView setImage:[UIImage imageNamed:name]];
    [cell insertSubview:cellImgView atIndex:0];
    
    blurImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellImgView.frame.size.width, 50)];
    blurImgView.backgroundColor = [UIColor clearColor];
    [self addblurEffectToView:blurImgView withStyle:UIBlurEffectStyleProminent];
    [cellImgView addSubview:blurImgView];
    
    CGFloat radius = 17;
    UIColor *randomColor = [UIColor colorWithRed:arc4random_uniform(255)/255.f green:arc4random_uniform(255)/255.f blue:arc4random_uniform(255)/255.f alpha:1];
    accountBGView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 2*radius, 2*radius)];
    accountBGView.layer.cornerRadius = radius;
    accountBGView.layer.borderWidth = radius;
    accountBGView.layer.borderColor = randomColor.CGColor;
    [blurImgView addSubview:accountBGView];
    
    nameLab = [[UILabel alloc] initWithFrame:CGRectMake(accountBGView.frame.origin.x+accountBGView.frame.size.width+10, accountBGView.frame.origin.y, limitCellNameLabWidth, accountBGView.frame.size.height)];
    nameLab.textColor = randomColor;
    nameLab.text = name;
    nameLab.font = [UIFont boldSystemFontOfSize:16];
    [blurImgView addSubview:nameLab];
    
    shadowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 1, width-22, cellHeight - 22)];
    shadowImgView.backgroundColor = [UIColor whiteColor];
    [shadowImgView.layer setCornerRadius:12];
    [sharedManager setShadowOfView:shadowImgView withOffsetX:0 withOffsetY:7 withBlur:12 withOpacity:0.3];
    [cell insertSubview:shadowImgView atIndex:0];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    CGRect cellFrame = [cell frame];
    cellFrame.size.height = cellHeight;
    cellFrame.size.width = width;
    [cell setFrame:cellFrame];


    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

#pragma mark - click method
- (void)touchDown:(id)sender
{
    UIButton* button = (UIButton*)sender;
    panameraViewImgString = [imgNameArray objectAtIndex:button.tag];
}

#pragma mark - blureffect method

- (void)addblurEffectToView: (UIView*)view withStyle:(NSInteger)style
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = view.bounds;
    blurEffectView.userInteractionEnabled = NO;
    [blurEffectView setAlpha:1];
    [view insertSubview:blurEffectView atIndex:0];
}

@end
