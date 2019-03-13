//
//  ViewController.h
//  JKRFallsDemo
//
//  Created by Lucky on 16/3/22.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTabPagingContainerItemProtocol.h"

@interface TYHomeUIFourIndexController : UIViewController <TYTabPagingContainerItemProtocol>

@property (nonatomic, assign) CGFloat maxHeight; // view最大高度
@property (nonatomic, strong) void(^reloadBlock)(void);

@property (nonatomic, strong) void(^scrollBlock)(TYHomeUIFourIndexController *vc, CGFloat offsetY);

- (void)stopAnimation;

- (void)stopAnimationWithError:(BOOL)hasError;


@end

