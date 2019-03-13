//
//
//
//
//  Created by Lucky on 16/3/22.
//  Copyright © 2016年 Lucky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTabPagingContainerItemProtocol.h"

@interface TYHomeUIFourIndexRoomController : UIViewController <TYTabPagingContainerItemProtocol>


- (void)stopAnimation;

- (void)stopAnimationWithError:(BOOL)hasError;

@end

