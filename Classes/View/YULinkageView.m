//
//  YULinkageView.m
//  YU
//
//  Created by 捋忆 on 2018/4/18.
//  Copyright © 2018年 捋忆. All rights reserved.
//

#import "YULinkageView.h"
#import "YULinkageItemObserver.h"
#import <Masonry/Masonry.h>

@interface YULinkageView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray<UIScrollView *> *scrollerViews;

@property (nonatomic, strong) NSMutableArray<YULinkageItemObserver *> *observers;

@property (nonatomic, strong) MASConstraint *right_constraint;

@end

@implementation YULinkageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.delegate = self;
        self.contentView = [[UIView alloc] init];
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
            make.height.equalTo(self);
        }];
    }
    return self;
}

/// 设置下标
- (void)setCurrentIndex:(int)currentIndex{
    if (_currentIndex == currentIndex) return;
    [self setContentOffset:CGPointMake(self.frame.size.width * currentIndex, 0) animated:YES];
}
/// 返回是否可以联动
- (BOOL)canLinkageWithSrollView:(nonnull UIScrollView *)aScrollView{
    if (self.scrollerViews.count) {
        UIScrollView *subScrollView = self.scrollerViews[self.currentIndex];
        if (subScrollView == aScrollView) {
            return YES;
        }
    }
    return NO;
}
/// 添加scrollView
- (BOOL)addScrollView:(nonnull UIScrollView *)scrollView{
    return [self insertScrollView:scrollView atIndex:self.scrollerViews.count];
}
/// 插入scrollView
- (BOOL)insertScrollView:(nonnull UIScrollView *)scrollView atIndex:(NSInteger)index{
    if (index > self.contentView.subviews.count) return NO;
    if (![scrollView isKindOfClass:[UIScrollView class]]) return NO;
    // 添加滚动视图到指定数组
    [self.scrollerViews insertObject:scrollView atIndex:index];
    // 创建观察者
    YULinkageItemObserver *observer = [[YULinkageItemObserver alloc] init];
    // 添加代理
    observer.yu_delegate = self.yu_delegate;
    // 观察者添加到指定的数组
    [self.observers insertObject:observer atIndex:index];
    // 观察contentOffset
    [scrollView addObserver:observer forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    /// 添加item视图
    [self insertLinkageItemView:scrollView atIndex:index];
    return YES;
}
/// 根据VC添加scrollView
- (BOOL)addScrollViewWithVC:(nonnull UIViewController<YULinkageTableViewDelegate> *)vc{
    return [self insertScrollViewWithVC:vc atIndex:self.scrollerViews.count];
}
/// 根据VC插入scrollView
- (BOOL)insertScrollViewWithVC:(nonnull UIViewController<YULinkageTableViewDelegate> *)vc atIndex:(NSInteger)index{
    if (index > self.contentView.subviews.count) return NO;
    if (![vc respondsToSelector:@selector(provideScrollViewForResponse)]) return NO;
    UIScrollView *scrollView = [vc provideScrollViewForResponse];
    if (![scrollView isKindOfClass:[UIScrollView class]]) return NO;
    // 添加滚动视图到指定数组
    [self.scrollerViews insertObject:scrollView atIndex:index];
    // 创建观察者
    YULinkageItemObserver *observer = [[YULinkageItemObserver alloc] init];
    // 添加代理
    observer.yu_delegate = self.yu_delegate;
    // 观察者添加到指定的数组
    [self.observers insertObject:observer atIndex:index];
    // 观察contentOffset
    [scrollView addObserver:observer forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    /// 添加item视图 添加vc的view
    [self insertLinkageItemView:vc.view atIndex:index];
    return YES;
}

- (void)insertLinkageItemView:(UIView *)view atIndex:(NSInteger)index{
    NSUInteger count = self.contentView.subviews.count;
    // 添加视图到contetnView
    [self.contentView insertSubview:view atIndex:index];
    // 获取上一个和下一个的视图
    UIView *previou_view = nil;
    UIView *next_view = nil;
    if (index > 0) {
        previou_view = self.contentView.subviews[index - 1];
    }
    if (index < count) {
        next_view = self.contentView.subviews[index + 1];
    }
    // 添加约束
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self);
        make.top.mas_offset(0);
        if (previou_view) {
            make.left.mas_equalTo(previou_view.mas_right);
        }else{
            make.left.mas_equalTo(0);
        }
    }];
    if (next_view) {// 更改后面视图的约束
        [next_view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(self);
            make.left.mas_equalTo(view.mas_right);
        }];
    }else{// 代表插入到了最后一个
        // 重设可滑动的宽度
        [self resetContentSize];
    }
}

/// 删除scrollView
- (BOOL)removeSubviewAtIndex:(NSInteger)index{
    if (index >= self.contentView.subviews.count) return NO;
    NSUInteger count = self.contentView.subviews.count;
    UIScrollView *scrollView = self.scrollerViews[index];
    YULinkageItemObserver *observer = self.observers[index];
    UIView *subview = self.contentView.subviews[index];
    // 获取上一个和下一个的视图
    UIScrollView *previou_sbuview = nil;
    UIScrollView *next_subview = nil;
    if (index > 0) {
        previou_sbuview = self.contentView.subviews[index - 1];
    }
    if (index < count - 1) {
        next_subview = self.contentView.subviews[index + 1];
    }
    // 移除观察者
    [scrollView removeObserver:observer forKeyPath:@"contentOffset"];
    // 从数组中删除观察者
    [self.observers removeObject:observer];
    // 删除保存的scrollView
    [self.scrollerViews removeObject:scrollView];
    // 移除视图
    [subview removeFromSuperview];
    if (!next_subview) {// 代表最后一个被删除了
        [self resetContentSize];
    }else if (!previou_sbuview) {// 代表第一个被删除了
        [next_subview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(self);
        }];
    }else{
        [next_subview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(previou_sbuview.mas_right);
            make.size.mas_equalTo(self);
        }];
    }
    return YES;
}
/// 重设可滑动的宽度
- (void)resetContentSize{
    UIScrollView *last_subview = self.scrollerViews.lastObject;
    if (last_subview) {
        [self.right_constraint uninstall];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.right_constraint = make.right.equalTo(last_subview.mas_right);
        }];
    }
}
/// 恢复子视图的滑动
- (void)restoreSubViewsScroll{
    for (YULinkageItemObserver *observer in self.observers) {
        [observer restoreScroll];
    }
}

/// 所以的子视图都不可以滑动了
- (void)subViewsNotScrollable{
    [self.observers setValue:@NO forKeyPath:@"isCanScroll"];
}

/// 子视图与root视图的状态同步
- (YULinkageTouchMove)touchMove:(YULinkageTouchMove)touch_move{
    if (!self.observers.count) return YULinkageTouchMoveFinish;
    YULinkageItemObserver *observer = self.observers[self.currentIndex];
    return [observer touchMove:touch_move];
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentIndex = (int)scrollView.contentOffset.x / scrollView.frame.size.width;
    if (currentIndex == self.currentIndex || currentIndex < 0) return;
    _currentIndex = currentIndex;
    if (self.currentIndexChanged) {
        self.currentIndexChanged(self.currentIndex);
    }
}

#pragma mark 懒加载
- (NSMutableArray<UIScrollView *> *)scrollerViews{
    if (!_scrollerViews) {
        _scrollerViews = [NSMutableArray array];
    }
    return _scrollerViews;
}

- (NSMutableArray<YULinkageItemObserver *> *)observers{
    if (!_observers) {
        _observers = [NSMutableArray array];
    }
    return _observers;
}

- (void)dealloc{
    // 移除所有的观察者
    for (int i = 0; i < self.observers.count; i++) {
        UIScrollView *scrollView = self.scrollerViews[i];
        YULinkageItemObserver *observer = self.observers[i];
        [scrollView removeObserver:observer forKeyPath:@"contentOffset"];
    }
}

@end
