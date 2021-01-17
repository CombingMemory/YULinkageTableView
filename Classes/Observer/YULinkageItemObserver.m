//
//  YULinkageItemObserver.m
//  YU
//
//  Created by 捋忆 on 2020/11/16.
//  Copyright © 2020 捋忆. All rights reserved.
//

#import "YULinkageItemObserver.h"

@interface YULinkageItemObserver ()

/// 自己视图是否可以滑动
@property (nonatomic, assign) BOOL isCanScroll;
/// scrollView
@property (nonatomic, weak) UIScrollView *scrollView;
/// 上次滑动的位置
@property (nonatomic, assign) float previou_offset_y;
/// 当前滑动的类型
@property (nonatomic, assign) YULinkageTouchMove touch_move;

@end

@implementation YULinkageItemObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    self.scrollView = (UIScrollView *)object;
    NSValue *new_value = change[@"new"];
    CGFloat new_y = [new_value CGPointValue].y;
    NSValue *old_value = change[@"old"];
    CGFloat old_y = [old_value CGPointValue].y;
    if (new_y == old_y) return;
    // 判断是否到达了顶部
    if (new_y < 0 && self.isCanScroll) {
        [self notScrollable];
        return;
    }
    // 如果有可以滑动不做任何操作
    if (self.isCanScroll) return;
    switch (self.touch_move) {
        case YULinkageTouchMoveFinish:
        case YULinkageTouchMoveNone:{
            [self.scrollView setContentOffset:CGPointZero];
            break;
        }
        case YULinkageTouchMoveUp:{
            if (self.previou_offset_y <= 0) {                self.previou_offset_y = old_y;
            }
            [self.scrollView setContentOffset:CGPointMake(0, self.previou_offset_y)];
            break;
        }
        case YULinkageTouchMoveDown:{
            if (new_y <= 0) {
                self.touch_move = YULinkageTouchMoveFinish;
                [self.scrollView setContentOffset:CGPointZero];
                if ([self.yu_delegate respondsToSelector:@selector(returnTouchMove:)]) {
                    [self.yu_delegate returnTouchMove:self.touch_move];
                }
                self.previou_offset_y = 0;
                return;
            }
            float differ = new_y - old_y;
            if (differ > 0) {
                self.touch_move = YULinkageTouchMoveUp;
                [self.scrollView setContentOffset:CGPointMake(0, old_y)];
                if ([self.yu_delegate respondsToSelector:@selector(returnTouchMove:)]) {
                    [self.yu_delegate returnTouchMove:self.touch_move];
                }
            }
            self.previou_offset_y = new_y;
            break;
        }
    }
}

/// 恢复滑动
- (void)restoreScroll{
    self.isCanScroll = YES;
    self.previou_offset_y = 0;
    self.touch_move = YULinkageTouchMoveNone;
    self.scrollView.showsVerticalScrollIndicator = YES;
}

///  自己滑动到了顶部 自己不可滑动了
- (void)notScrollable{
    self.isCanScroll = NO;
    [self.scrollView setContentOffset:CGPointZero];
    self.previou_offset_y = 0;
    self.scrollView.showsVerticalScrollIndicator = NO;
    if ([_yu_delegate respondsToSelector:@selector(restoreRootViewScroll)]) {
        [_yu_delegate restoreRootViewScroll];
    }
}

- (YULinkageTouchMove)touchMove:(YULinkageTouchMove)touch_move{
    if (self.scrollView.contentOffset.y && !self.isCanScroll) {
        self.touch_move = touch_move;
        return touch_move;
    }else{
        return YULinkageTouchMoveFinish;
    }
}

@end
