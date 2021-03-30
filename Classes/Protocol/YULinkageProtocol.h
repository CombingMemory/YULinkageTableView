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

/// 提供可以用来响应的ScrollVIews 改为返回数据 来进行联动
- (nonnull NSArray<UIScrollView *> *)provideScrollViewsForLinkage;




@optional
/// 提供可以用来响应的ScrollVIew 已废弃-后续版本将会删除此代码
- (nonnull UIScrollView *)provideScrollViewForResponse DEPRECATED_MSG_ATTRIBUTE("请使用 -provideScrollViewsForLinkage方法返回一个由UIScrollView组成的数组用于响应联动");

@end

NS_ASSUME_NONNULL_END
