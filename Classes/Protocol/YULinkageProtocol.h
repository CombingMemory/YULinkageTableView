//
//  YULinkageProtocol.h
//  YU
//
//  Created by 捋忆 on 2021/1/6.
//  Copyright © 2021 费猫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, YULinkageTouchMove){
    YULinkageTouchMoveNone,
    YULinkageTouchMoveUp,
    YULinkageTouchMoveDown,
    YULinkageTouchMoveFinish
};

@protocol YULinkageTableViewDelegate <NSObject>
@required
/// 提供可以用来响应的ScrollVIew
- (nonnull UIScrollView *)provideScrollViewForResponse;

@end

NS_ASSUME_NONNULL_END
