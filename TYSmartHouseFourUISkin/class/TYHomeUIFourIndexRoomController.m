//
//  
//
//
//  Created by Lucky on 16/3/22.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import "TYHomeUIFourIndexRoomController.h"
#import "JKRFallsLayout.h"
#import "TYHomeDeviceItemCollectionViewCell.h"
#import "MJRefresh.h"
#import "MJRefreshComponent+RefreshError.h"

@interface TYHomeUIFourIndexRoomController ()<UICollectionViewDataSource, JKRFallsLayoutDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation TYHomeUIFourIndexRoomController

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
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:fallsLayout];
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    collectionView.dataSource = self;
//    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JKRShopCell class]) bundle:nil] forCellWithReuseIdentifier:ID];

    [collectionView registerClass:[TYHomeDeviceItemCollectionViewCell class] forCellWithReuseIdentifier:@"TYHomeDeviceItemCollectionViewCell"];

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

- (void)stopAnimation {
    [self.collectionView.mj_header endRefreshing];
}


- (void)stopAnimationWithError:(BOOL)hasError {
    if (hasError) {
        [self.collectionView.mj_header endRefreshingWithError];
    } else {
        [self.collectionView.mj_header endRefreshing];
    }
}


#pragma collection delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return 0;
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
    return 4;
}

- (UIEdgeInsets)edgeInsetsInFallsLayout:(JKRFallsLayout *)fallsLayout
{
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

@end
