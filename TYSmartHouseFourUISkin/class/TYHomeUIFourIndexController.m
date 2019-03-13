//
//  ViewController.m
//  JKRFallsDemo
//
//  Created by Lucky on 16/3/22.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import "TYHomeUIFourIndexController.h"
#import "JKRFallsLayout.h"
#import "TYHomeDeviceItemCollectionViewCell.h"
#import "MJRefresh.h"
#import "MJRefreshComponent+RefreshError.h"


#import <TuyaSmartDeviceKit/TuyaSmartDeviceKit.h>
#import "TuyaSmartHomeUtil.h"


@interface TYHomeUIFourIndexController ()<UICollectionViewDataSource, JKRFallsLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TYHomeUIFourIndexController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCollectionView];
    [self setupRefresh];
}

#pragma mark - 创建collectionView
- (void)setupCollectionView
{
    JKRFallsLayout *fallsLayout = [[JKRFallsLayout alloc] init];
    fallsLayout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:fallsLayout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.dataSource = self;
    [_collectionView registerClass:[TYHomeDeviceItemCollectionViewCell class] forCellWithReuseIdentifier:@"TYHomeDeviceItemCollectionViewCell"];

    [self.view addSubview:_collectionView];

}

#pragma mark - 创建上下拉刷新
- (void)setupRefresh
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];

}

#pragma mark - 加载下拉数据
- (void)loadNewShops
{

}

- (void)stopAnimationWithError:(BOOL)hasError {
    if (hasError) {
        [self.collectionView.mj_header endRefreshingWithError];
    } else {
        [self.collectionView.mj_header endRefreshing];
    }
}

- (void)stopAnimation {
    [self.collectionView.mj_header endRefreshing];
}

#pragma mark - collection  delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    TuyaSmartHome * home =[TuyaSmartHomeUtil currentHome];
    return home.deviceList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TYHomeDeviceItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYHomeDeviceItemCollectionViewCell" forIndexPath:indexPath];

    return cell;
}

- (CGFloat)columnMarginInFallsLayout:(JKRFallsLayout *)fallsLayout
{
    return 5;
}

- (CGFloat)rowMarginInFallsLayout:(JKRFallsLayout *)fallsLayout
{
    return 5;
}

- (CGFloat)columnCountInFallsLayout:(JKRFallsLayout *)fallsLayout
{
    return 2;
}

- (UIEdgeInsets)edgeInsetsInFallsLayout:(JKRFallsLayout *)fallsLayout
{
    return UIEdgeInsetsMake(10, 5, 10, 5);
}



@end
