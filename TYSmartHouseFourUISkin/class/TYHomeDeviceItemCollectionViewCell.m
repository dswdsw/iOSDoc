//
//  TYHomeDeviceItemCollectionViewCell.m
//  TYSmartUserCenterThirdUISkin
//
//  Created by stephen on 2019/3/13.
//

#import "TYHomeDeviceItemCollectionViewCell.h"
#import "TYHomeDeviceItemCollectionViewCellView.h"


@interface TYHomeDeviceItemCollectionViewCell ()

@property (nonatomic , strong ) TYHomeDeviceItemCollectionViewCellView *deviceView;

@end

@implementation TYHomeDeviceItemCollectionViewCell

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];

    if (!self.deviceView) {
        self.deviceView = [TYHomeDeviceItemCollectionViewCellView new];
    }
    [self addSubview:self.deviceView];
}

@end
