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
/// 上次滑动的位置
@property (nonatomic, assign) float previou_offset_y;
/// 上次滑动位置的值已赋值
@property (nonatomic, assign) BOOL isAssigned;
/// 当前滑动的类型
@property (nonatomic, assign) YULinkageTouchMove touch_move;

@end

@implementation YULinkageItemObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (self.scrollView != object) return;
    NSValue *new_value = change[@"new"];
    CGFloat new_y = [new_value CGPointValue].y;
    NSValue *old_value = change[@"old"];
    CGFloat old_y = [old_value CGPointValue].y;
    if (new_y == old_y) return;
    // 判断是否到达了顶部
    if (self.isCanScroll) {
        if (new_y <= -self.scrollView.contentInset.top) {
            // 检查是否通知成功
            BOOL result = NO;
            // 通知外层
            if ([_yu_delegate respondsToSelector:@selector(restoreRootViewScrollForLinkageScrollView:)]) {
                result = [_yu_delegate restoreRootViewScrollForLinkageScrollView:self.scrollView];
            }
            if (result) {
                // 变为不可滑动状态
                self.isCanScroll = NO;
            }
            [self notScrollable];
        }
        return;
    }
    // 不可滑动后 根据touch_move来判断该有的状态
    [self touchMoveForNewY:new_y oldY:old_y];
}

/// 根据touch_move来判断是否可以滑动
- (void)touchMoveForNewY:(float)new_y oldY:(float)old_y{
    switch (self.touch_move) {
        case YULinkageTouchMoveFinish:{
            [self notScrollable];
            break;
        }
        case YULinkageTouchMoveNone:{
            [self moveNoneForNewY:new_y oldY:old_y];
            break;
        }
        case YULinkageTouchMoveUp:{
            [self moveUpForNewY:new_y oldY:old_y];
            break;
        }
        case YULinkageTouchMoveDown:{
            [self moveDownForNewY:new_y oldY:old_y];
            break;
        }
    }
}

/// 默认状态下执行的方法 moveNone
- (void)moveNoneForNewY:(float)new_y oldY:(float)old_y{
    YULinkageTouchMove touch_move = [self getTouchMoveForNewY:new_y oldY:old_y];
    self.touch_move = [self syncTouchMove:touch_move offsetY:old_y];
    // 同步touch_move // 注释:001
    [self syncRootViewTouchMove];
    [self touchMoveForNewY:new_y oldY:old_y];
}

/// 向上滑动执行的方法 moveUp
- (void)moveUpForNewY:(float)new_y oldY:(float)old_y{
    if ([self syncRootViewTouchMove]) {// 判断是否同步成功了
        if (!self.isAssigned) {
            self.isAssigned = YES;
            self.previou_offset_y = old_y;
        }
        [self.scrollView setContentOffset:CGPointMake(0, self.previou_offset_y)];
    }else{
        self.isAssigned = NO;
    }
}

/// 向下滑动执行的方法 moveDown
- (void)moveDownForNewY:(float)new_y oldY:(float)old_y{
    self.isAssigned = YES;
    self.previou_offset_y = new_y;
    if (new_y <= -self.scrollView.contentInset.top) {
        self.touch_move = YULinkageTouchMoveFinish;
        [self syncRootViewTouchMove];
        [self touchMoveForNewY:new_y oldY:old_y];
        return;
    }
    self.touch_move = [self getTouchMoveForNewY:new_y oldY:old_y];
    if (self.touch_move == YULinkageTouchMoveUp) {// 判断是否同步成功了
        if ([self syncRootViewTouchMove]) {
            [self.scrollView setContentOffset:CGPointMake(0, old_y)];
        }
    }
}

/// 同步外部根视图的的TouchMove状态
- (BOOL)syncRootViewTouchMove{
    if ([self.yu_delegate respondsToSelector:@selector(returnTouchMove:linkageScrollView:)]) {
        return [self.yu_delegate returnTouchMove:self.touch_move linkageScrollView:self.scrollView];
    }
    return NO;
}

/// 判断touchMove的状态
- (YULinkageTouchMove)getTouchMoveForNewY:(float)new_y oldY:(float)old_y{
    float differ = new_y - old_y;
    if (differ > 0) {
        return YULinkageTouchMoveUp;
    }else{
        return YULinkageTouchMoveDown;
    }
}

/// 恢复滑动 --- 总视图通知过来的
- (void)restoreScroll{
    self.isCanScroll = YES;
    self.touch_move = YULinkageTouchMoveNone;
    self.scrollView.showsVerticalScrollIndicator = YES;
}

///  自己滑动到了顶部 自己不可滑动了
- (void)notScrollable{
    [self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top)];
    self.isAssigned = NO;
    self.previou_offset_y = -self.scrollView.contentInset.top;
    self.scrollView.showsVerticalScrollIndicator = NO;
}

- (YULinkageTouchMove)syncTouchMove:(YULinkageTouchMove)touch_move{
    return [self syncTouchMove:touch_move offsetY:self.scrollView.contentOffset.y];
}

- (YULinkageTouchMove)syncTouchMove:(YULinkageTouchMove)touch_move offsetY:(CGFloat)offsetY{
    if (offsetY > -self.scrollView.contentInset.top && !self.isCanScroll) {
        self.touch_move = touch_move;
    }else{
        self.touch_move = YULinkageTouchMoveFinish;
    }
    return self.touch_move;
}

@end
