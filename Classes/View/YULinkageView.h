//
//  YULinkageView.h
//  YU
//
//  Created by 捋忆 on 2018/4/18.
//  Copyright © 2018年 捋忆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YULinkageTableView.h"
#import "YULinkageProtocol.h"

@protocol YULinkageViewDelegate <NSObject>

@required
- (void)restoreRootViewScroll;

- (void)returnTouchMove:(YULinkageTouchMove)touch_move;

- (void)didScrollForOffsetX:(float)offsetX;

@end



@interface YULinkageView : UIScrollView

/// 当前的index
@property (nonatomic, assign) int currentIndex;
/// currentIndex 发生了改变
@property (nonatomic, copy) void (^ _Nullable currentIndexChanged)(int index);
/// 代理
@property (nonatomic, weak, nullable) id <YULinkageViewDelegate> yu_delegate;



/// 设置index
- (void)setCurrentIndex:(int)currentIndex animated:(BOOL)animated;
/// 返回是否可以联动
- (BOOL)canLinkageWithSrollView:(nonnull UIScrollView *)aScrollView;
/// 添加scrollView
- (BOOL)addScrollView:(nonnull UIScrollView *)scrollView;
/// 插入scrollView
- (BOOL)insertScrollView:(nonnull UIScrollView *)scrollView atIndex:(NSInteger)index;
/// 根据VC添加scrollView
- (BOOL)addScrollViewWithVC:(nonnull UIViewController<YULinkageTableViewDelegate> *)vc;
/// 根据VC插入scrollView
- (BOOL)insertScrollViewWithVC:(nonnull UIViewController<YULinkageTableViewDelegate> *)vc atIndex:(NSInteger)index;
/// 删除scrollView
- (BOOL)removeSubviewAtIndex:(NSInteger)index;
/// 恢复所有子视图的滑动
- (BOOL)restoreSubViewsScroll;
/// 所以子视图暂停滑动
- (void)subViewsNotScrollable;
/// root视图与子视图同步滑动状态
- (YULinkageTouchMove)syncTouchMove:(YULinkageTouchMove)touch_move;

@end
