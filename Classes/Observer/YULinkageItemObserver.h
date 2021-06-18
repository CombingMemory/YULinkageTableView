//
//  YULinkageItemObserver.h
//  YU
//
//  Created by 捋忆 on 2020/11/16.
//  Copyright © 2020 捋忆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YULinkageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YULinkageItemObserver : NSObject

@property (nonatomic, weak) id <YULinkageViewDelegate>yu_delegate;
/// scrollView
@property (nonatomic, strong) UIScrollView *scrollView;
/// 恢复滑动
- (void)restoreScroll;
/// root视图与子视图同步滑动状态
- (YULinkageTouchMove)syncTouchMove:(YULinkageTouchMove)touch_move;

@end

NS_ASSUME_NONNULL_END
