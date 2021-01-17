//
//  YULinkageTableView.m
//  YU
//
//  Created by 捋忆 on 2018/4/23.
//  Copyright © 2018年 捋忆. All rights reserved.
//

#import "YULinkageTableView.h"
#import "YULinkageView.h"

@interface YULinkageTableView()<UITableViewDelegate,UITableViewDataSource,YULinkageViewDelegate>

@property (nonatomic, strong) UIView *segmented;

@property (nonatomic, assign) float segmented_height;

@property (nonatomic, strong) YULinkageView *linkage_view;

@property (nonatomic, assign) BOOL isCanScroll;

@property (nonatomic, assign) float previou_offset_y;

@property (nonatomic, assign) YULinkageTouchMove touch_move;

@end

@implementation YULinkageTableView

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame style:UITableViewStyleGrouped];
}


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    //    self = [super initWithFrame:frame style:UITableViewStylePlain];
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init{
    self.isCanScroll = YES;
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsVerticalScrollIndicator = NO;
    // 注册cell
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"YULinkageTableViewCell"];
    [self registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YULinkageTableViewHeaderView"];
    
    
    self.linkage_view = [[YULinkageView alloc] init];
    self.linkage_view.translatesAutoresizingMaskIntoConstraints = NO;
    self.linkage_view.yu_delegate = self;
    __weak __typeof(&*self)weakSelf = self;
    self.linkage_view.currentIndexChanged = ^(int index) {
        weakSelf.touch_move = YULinkageTouchMoveNone;
        /// block转发
        if (weakSelf.currentIndexChanged) {
            weakSelf.currentIndexChanged(index);
        }
    };
}

#pragma mark tableView的代理
/// segmented的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.segmented_height;
}
/// header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YULinkageTableViewHeaderView"];
    if (self.segmented) {
        self.segmented.frame = CGRectMake(0, 0, self.frame.size.width, self.segmented_height);
        [header.contentView addSubview:self.segmented];
    }
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
/// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cell_height = self.bounds.size.height - self.segmented_height;
    if (@available(iOS 11.0, *)) {
        cell_height -= self.safeAreaInsets.top;
    }
    return cell_height;
}

/// cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
/// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YULinkageTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 添加视图
    [cell.contentView addSubview:self.linkage_view];
    // 删除旧约束
    [self.linkage_view.superview removeConstraints:self.linkage_view.superview.constraints];
    // 添加约束
    NSLayoutConstraint *left_constraint = [NSLayoutConstraint constraintWithItem:self.linkage_view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.linkage_view.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *right_constraint = [NSLayoutConstraint constraintWithItem:self.linkage_view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.linkage_view.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *top_constraint = [NSLayoutConstraint constraintWithItem:self.linkage_view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.linkage_view.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom_constraint = [NSLayoutConstraint constraintWithItem:self.linkage_view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.linkage_view.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.linkage_view.superview addConstraints:@[left_constraint,right_constraint,top_constraint,bottom_constraint]];
    return cell;
}
#pragma mark LinkageView的代理
/// 其中一个滑动到顶部了 通知所有的子试图不可以滑动
- (void)restoreRootViewScroll{
    self.isCanScroll = YES;
    [self.linkage_view subViewsNotScrollable];
}
/// 同步自视图的滑动状态
- (void)returnTouchMove:(YULinkageTouchMove)touch_move{
    self.touch_move = touch_move;
}

#pragma mark scrollView的代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.previou_offset_y = scrollView.contentOffset.y;
    if ([_outer_delegate respondsToSelector:_cmd]) {
        [_outer_delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 同时也是headerView的高度
    CGFloat cell_y = [self rectForSection:0].origin.y;
    if (@available(iOS 11.0, *)) {
        cell_y -= self.safeAreaInsets.top;
    }
    CGFloat offset_y = scrollView.contentOffset.y;
    if (!self.isCanScroll) {
        scrollView.contentOffset = CGPointMake(0, cell_y);
        return;
    }
    if (offset_y >= cell_y) {
        self.isCanScroll = NO;
        self.touch_move = YULinkageTouchMoveNone;
        scrollView.contentOffset = CGPointMake(0, cell_y);
        [self.linkage_view restoreSubViewsScroll];
        return;
    }
    switch (self.touch_move) {
        case YULinkageTouchMoveFinish:break;
        case YULinkageTouchMoveNone:
        case YULinkageTouchMoveUp:{
            float differ = offset_y - self.previou_offset_y;
            if (differ > 0) {
                self.touch_move = YULinkageTouchMoveUp;
                self.previou_offset_y = offset_y;
                
            }else{
                self.touch_move = YULinkageTouchMoveDown;
                scrollView.contentOffset = CGPointMake(0, self.previou_offset_y);
            }
            // 同步子视图的滑动状态
            self.touch_move = [self.linkage_view touchMove:self.touch_move];
            break;
        }
        case YULinkageTouchMoveDown:{
            scrollView.contentOffset = CGPointMake(0, self.previou_offset_y);
            break;
        }
    }
    if ([_outer_delegate respondsToSelector:_cmd]) {
        [_outer_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if ([_outer_delegate respondsToSelector:_cmd]) {
        [_outer_delegate scrollViewDidZoom:scrollView];
    }
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if ([_outer_delegate respondsToSelector:_cmd]) {
        [_outer_delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([_outer_delegate respondsToSelector:_cmd]) {
        [_outer_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([_outer_delegate respondsToSelector:_cmd]) {
        [_outer_delegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([_outer_delegate respondsToSelector:_cmd]) {
        [_outer_delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if ([_outer_delegate respondsToSelector:_cmd]) {
        [_outer_delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if ([_outer_delegate respondsToSelector:_cmd]) {
        return [_outer_delegate viewForZoomingInScrollView:scrollView];
    } else {
        return nil;
    }
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view{
    if ([_outer_delegate respondsToSelector:_cmd]) {
        [_outer_delegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    if ([_outer_delegate respondsToSelector:_cmd]) {
        [_outer_delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if ([_outer_delegate respondsToSelector:_cmd]) {
        return [_outer_delegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if ([_outer_delegate respondsToSelector:_cmd]) {
        [_outer_delegate scrollViewDidScrollToTop:scrollView];
    }
}

#pragma mark 实现方法
- (void)setCurrentIndex:(int)currentIndex{
    self.linkage_view.currentIndex = currentIndex;
}

- (int)currentIndex{
    return self.linkage_view.currentIndex;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate{
    [super setDelegate:self];
}

- (id<UITableViewDelegate>)delegate{
    return [super delegate];
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource{
    [super setDataSource:self];
}

- (id<UITableViewDataSource>)dataSource{
    return [super dataSource];
}

/// 添加scrollView
- (BOOL)addScrollView:(nonnull UIScrollView *)scrollView{
    return [self.linkage_view addScrollView:scrollView];
}
/// 插入scrollView
- (BOOL)insertScrollView:(nonnull UIScrollView *)scrollView atIndex:(NSInteger)index{
    return [self.linkage_view insertScrollView:scrollView atIndex:index];
}
/// 根据VC添加scrollView
- (BOOL)addScrollViewWithVC:(nonnull UIViewController<YULinkageTableViewDelegate> *)vc{
    return [self.linkage_view addScrollViewWithVC:vc];
}
/// 根据VC插入scrollView
- (BOOL)insertScrollViewWithVC:(nonnull UIViewController<YULinkageTableViewDelegate> *)vc atIndex:(NSInteger)index{
    return [self.linkage_view insertScrollViewWithVC:vc atIndex:index];
}
/// 删除scrollView
- (BOOL)removeSubviewAtIndex:(NSInteger)index{
    return [self.linkage_view removeSubviewAtIndex:index];
}
/// 添加Segmented
- (void)setSegmented:(UIView *)segmented {
    if (_segmented == segmented) return;
    // 移除旧的观察者 移除旧的视图
    [_segmented removeObserver:self forKeyPath:@"frame" context:nil];
    [_segmented removeFromSuperview];
    _segmented = nil;
    // 赋值
    _segmented = segmented;
    self.segmented_height = segmented.frame.size.height;
    // 添加KVO
    [self.segmented addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    // 刷新UI
    [self reloadData];
}
/// KVO 观察 segmented frame 的改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.segmented) {
        NSValue *new_value = change[@"new"];
        CGRect new_frame = [new_value CGRectValue];
        NSValue *old_value = change[@"old"];
        CGRect olb_frame = [old_value CGRectValue];
        if (CGSizeEqualToSize(new_frame.size, olb_frame.size)) return;
        self.segmented_height = new_frame.size.height;
        [self reloadData];
        
    }
}
/// 是否与其他手势识别器同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    UIScrollView *aScrollView = (UIScrollView *)otherGestureRecognizer.view;
    return [self.linkage_view canLinkageWithSrollView:aScrollView];
    
}

- (void)dealloc{
    [self.segmented removeObserver:self forKeyPath:@"frame"];
}

@end
