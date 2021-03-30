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

@property (nonatomic, strong) NSMutableArray<NSMutableArray<YULinkageItemObserver *> *> *items;
/// 约束
@property (nonatomic, strong) MASConstraint *right_constraint;
/// 执行动画中   注释：002
@property (nonatomic, assign) BOOL isOffsetAnimation;

@end

@implementation YULinkageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.directionalLockEnabled = YES;
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
    [self setCurrentIndex:currentIndex animated:NO];
}
/// 设置下标
- (void)setCurrentIndex:(int)currentIndex animated:(BOOL)animated{
    currentIndex = (int)[self checkIndexOutOfBounds:currentIndex];
    if (_currentIndex == currentIndex) return;
    _currentIndex = currentIndex;
    // 注释：002
    self.isOffsetAnimation = animated;
    [self setContentOffset:CGPointMake(self.frame.size.width * currentIndex, 0) animated:animated];
    // 注释：002
    if (animated) {
        [NSRunLoop cancelPreviousPerformRequestsWithTarget:self selector:@selector(offsetAnimationAction) object:nil];
        [self performSelector:@selector(offsetAnimationAction) withObject:nil afterDelay:0.3 inModes:@[NSRunLoopCommonModes]];
    }
}
/// offset动画执行  注释：002
- (void)offsetAnimationAction{
    self.isOffsetAnimation = NO;
}

- (NSInteger)checkIndexOutOfBounds:(NSInteger)index{
    // 防止越界
    if (index < 0) {
        return 0;
    }
    if (index > self.contentView.subviews.count - 1) {
        return (NSInteger)self.contentView.subviews.count - 1;
    }
    return index;
}

/// 返回是否可以联动
- (BOOL)canLinkageWithSrollView:(nonnull UIScrollView *)aScrollView {
    if (0 == self.items.count) return NO;
    NSMutableArray *item = self.items[self.currentIndex];
    for (YULinkageItemObserver *observer in item) {
        if (aScrollView == observer.scrollView) {
            return YES;
        }
    }
    return NO;
}
/// 添加scrollView
- (BOOL)addScrollView:(nonnull UIScrollView *)scrollView{
    return [self insertScrollView:scrollView atIndex:self.contentView.subviews.count];
}
/// 插入scrollView
- (BOOL)insertScrollView:(nonnull UIScrollView *)scrollView atIndex:(NSInteger)index{
    // 防止越界
    index = index < 0?0:index;
    index = index > self.contentView.subviews.count?self.contentView.subviews.count:index;
    // 添加observer
    BOOL result = [self addObserverWithScrollViews:@[scrollView] index:index];
    // 如果结果失败
    if (!result) return NO;
    /// 添加item视图
    [self insertLinkageItemView:scrollView atIndex:index];
    return YES;
}
/// 根据VC添加scrollView
- (BOOL)addScrollViewWithVC:(nonnull UIViewController<YULinkageTableViewDelegate> *)vc{
    return [self insertScrollViewWithVC:vc atIndex:self.contentView.subviews.count];
}
/// 根据VC插入scrollView
- (BOOL)insertScrollViewWithVC:(nonnull UIViewController<YULinkageTableViewDelegate> *)vc atIndex:(NSInteger)index{
    // 防止越界
    index = index < 0?0:index;
    index = index > self.contentView.subviews.count?self.contentView.subviews.count:index;
    // 获取 scrollViews
    NSArray *scrollViews = nil;
    if ([vc respondsToSelector:@selector(provideScrollViewsForLinkage)]) {
        scrollViews = [vc provideScrollViewsForLinkage];
    }else if ([vc respondsToSelector:@selector(provideScrollViewForResponse)]){
        UIScrollView *scrollView = [vc provideScrollViewForResponse];
        if (!scrollView) return NO;
        scrollViews = @[scrollView];
    }else{
        return NO;
    }
    // 添加observer
    BOOL result = [self addObserverWithScrollViews:scrollViews index:index];
    // 如果结果失败
    if (!result) return NO;
    // 添加item视图 添加vc的view
    [self insertLinkageItemView:vc.view atIndex:index];
    return YES;
}

/// 添加观察者
- (BOOL)addObserverWithScrollViews:(NSArray<UIScrollView *> *)scrollViews index:(NSInteger)index{
    NSMutableArray<YULinkageItemObserver *> *item = [NSMutableArray array];
    for (UIScrollView *scrollView in scrollViews) {
        // 检查是否是 UIScrollView 列表里面必须全部都是 UIScrollView 才能添加成功
        if (![scrollView isKindOfClass:[UIScrollView class]]) return NO;
        // 创建观察者
        YULinkageItemObserver *observer = [[YULinkageItemObserver alloc] init];
        // 添加绑定
        observer.scrollView = scrollView;
        // 添加代理
        observer.yu_delegate = self.yu_delegate;
        // 观察者添加到指定的数组
        [item addObject:observer];
        // 观察UIScrollView的contentOffset属性
        [scrollView addObserver:observer forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    [self.items insertObject:item atIndex:index];
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

/// 移除观察者
- (void)removeObserverAtIndex:(NSInteger)index{
    [self removeObserverAtItem:self.items[index]];
    [self.items removeObjectAtIndex:index];
}

- (void)removeObserverAtItem:(NSArray<YULinkageItemObserver *> *)item{
    for (YULinkageItemObserver *observer in item) {
        // 拿到scrollView
        UIScrollView *scrollView = observer.scrollView;
        // 移除观察者
        [scrollView removeObserver:observer forKeyPath:@"contentOffset"];
    }
}

/// 删除scrollView
- (BOOL)removeSubviewAtIndex:(NSInteger)index{
    // 防止越界
    index = [self checkIndexOutOfBounds:index];
    NSUInteger count = self.contentView.subviews.count;
    // 检查是否还有数据
    if (0 == count) return NO;
    // 移除观察者
    [self removeObserverAtIndex:index];
    // 获得view
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
    // 移除视图
    [subview removeFromSuperview];
    // 重新调整约束
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
    UIView *last_subview = self.contentView.subviews.lastObject;
    if (last_subview) {
        [self.right_constraint uninstall];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.right_constraint = make.right.equalTo(last_subview.mas_right);
        }];
    }
}
/// 恢复子视图的滑动
- (BOOL)restoreSubViewsScroll {
    /// 遍历所有的observer
    [self.items enumerateObjectsUsingBlock:^(NSMutableArray<YULinkageItemObserver *> * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        [item enumerateObjectsUsingBlock:^(YULinkageItemObserver * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj restoreScroll];
        }];
    }];
    if (self.items.count) {
        return YES;
    }else{
        return NO;
    }
}

/// 所以的子视图都不可以滑动了
- (void)subViewsNotScrollable{
    [self.items setValue:@NO forKeyPath:@"isCanScroll"];
}

/// 子视图与root视图的状态同步
- (YULinkageTouchMove)syncTouchMove:(YULinkageTouchMove)touch_move scrollView:(UIScrollView *)aScrollView{
    if (!self.items.count) return YULinkageTouchMoveFinish;
    if (!aScrollView) return YULinkageTouchMoveFinish;
    YULinkageItemObserver *observer = nil;
    NSMutableArray<YULinkageItemObserver *> *item = self.items[self.currentIndex];
    for (YULinkageItemObserver *obj in item) {
        if (obj.scrollView == aScrollView) {
            observer = obj;
        }
    }
    return [observer syncTouchMove:touch_move];
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offsetX = scrollView.contentOffset.x;
    if ([_yu_delegate respondsToSelector:@selector(didScrollForOffsetX:)]) {
        [_yu_delegate didScrollForOffsetX:offsetX];
    }
    // 注释：002
    if (self.isOffsetAnimation) return;
    // 滑动时计算 index
    offsetX += scrollView.frame.size.width / 2;
    int currentIndex = (int)offsetX / scrollView.frame.size.width;
    currentIndex = (int)[self checkIndexOutOfBounds:currentIndex];
    if (_currentIndex == currentIndex) return;
    _currentIndex = currentIndex;
    if (self.currentIndexChanged) {
        self.currentIndexChanged(self.currentIndex);
    }
}

#pragma mark 懒加载
- (NSMutableArray<NSMutableArray<YULinkageItemObserver *> *> *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)dealloc{
    // 移除所有的观察者
    for (NSMutableArray<YULinkageItemObserver *> *item in self.items) {
        [self removeObserverAtItem:item];
    }
}

@end
