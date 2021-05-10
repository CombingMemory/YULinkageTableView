//
//  YULinkageTableView.m
//  YU
//
//  Created by 捋忆 on 2018/4/23.
//  Copyright © 2018年 捋忆. All rights reserved.
//

#import "YULinkageTableView.h"
#import "YULinkageView.h"
#import <Masonry/Masonry.h>

@interface YULinkageTableView()<UITableViewDelegate,UITableViewDataSource,YULinkageViewDelegate>

@property (nonatomic, strong) UIView *segmented;

@property (nonatomic, assign) float segmented_height;

@property (nonatomic, strong) YULinkageView *linkage_view;

@property (nonatomic, assign) BOOL isCanScroll;

@property (nonatomic, assign) float previou_offset_y;

@property (nonatomic, assign) YULinkageTouchMove touch_move;
/// 相应的子视图
@property (nonatomic, weak) UIScrollView *response_view;

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
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init{
    self.isCanScroll = YES;
    [super setDelegate:self];
    [super setDataSource:self];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsVerticalScrollIndicator = NO;
    // 注册cell
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"YULinkageTableViewCell"];
    [self registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"YULinkageTableViewHeaderView"];
    
    
    self.linkage_view = [[YULinkageView alloc] init];
    self.linkage_view.yu_delegate = self;
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

/// cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cell_height = self.bounds.size.height - self.segmented_height;
    if (@available(iOS 11.0, *)) {
        cell_height -= self.adjustedContentInset.top;
    }else{
        cell_height -= self.adjustedTop;
    }
    // 减去忽略头部高度
    cell_height -= self.ignoreHeaderHeight;
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
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    // 添加视图
    [cell.contentView addSubview:self.linkage_view];
    // 添加约束
    [self.linkage_view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    return cell;
}
#pragma mark LinkageView的代理
/// 其中一个滑动到顶部了 根视图恢复滑动  同时通知所有的子试图不可以滑动
- (BOOL)restoreRootViewScrollForLinkageScrollView:(UIScrollView *)linkageScrollView{
    if (linkageScrollView == self.response_view) {
        self.isCanScroll = YES;
        [self.linkage_view subViewsNotScrollable];
        return YES;
    }else{
        return NO;
    }
}
/// 同步自视图的滑动状态 这里是子ScrollView的回调
- (BOOL)returnTouchMove:(YULinkageTouchMove)touch_move linkageScrollView:(UIScrollView *)linkageScrollView{
    if (linkageScrollView == self.response_view){
        self.touch_move = touch_move;
        return YES;
    }else{
        return NO;
    }
}

#pragma YULinkageView offsetX滑动返回
/// YULinkageView offsetX滑动返回
- (void)didScrollForOffsetX:(float)offsetX{
    if (self.didScroll) {
        self.didScroll(offsetX, self.contentOffset.y);
    }
}

/// 本视图 YULinkageTableView offsetY 滑动返回代理
- (void)didScrollForOffsetY:(float)offsetY{
    if (self.didScroll) {
        self.didScroll(self.linkage_view.contentOffset.x, offsetY);
    }
}

#pragma mark scrollView的代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset_y = scrollView.contentOffset.y;
    // 同时也是headerView的高度
    CGFloat cell_y = [self rectForSection:0].origin.y;
    // 适配调整后的高度
    if (@available(iOS 11.0, *)) {
        cell_y -= self.adjustedContentInset.top;
    }else{
        cell_y -= self.adjustedTop;
    }
    // 减去忽略头部高度
    cell_y -= self.ignoreHeaderHeight;
    
    // 这里只拖动了 header
    if (!self.response_view && !self.isCanScroll) {
        self.isCanScroll = YES;
        [self.linkage_view subViewsNotScrollable];
    }

    // 判断是否不可滑动
    if (!self.isCanScroll) {
        scrollView.contentOffset = CGPointMake(0, cell_y);
        [self didScrollForOffsetY:scrollView.contentOffset.y];
        return;
    }
    // 判断header是否已经滑动完毕。更改为不可滑动状态
    if (offset_y >= cell_y) {
        BOOL resust = [self.linkage_view restoreSubViewsScroll];
        self.isCanScroll = !resust;
        self.touch_move = YULinkageTouchMoveFinish;
        scrollView.contentOffset = CGPointMake(0, cell_y);
        [self didScrollForOffsetY:scrollView.contentOffset.y];
        return;
    }
    // 这里只拖动了 header 那么什么也不执行
    if (!self.response_view) return;
    switch (self.touch_move) {
        case YULinkageTouchMoveFinish:break;
        case YULinkageTouchMoveNone:
        case YULinkageTouchMoveUp:{
            float differ = offset_y - self.previou_offset_y;
            YULinkageTouchMove touch_move = YULinkageTouchMoveDown;
            if (differ < 0) {
                touch_move = YULinkageTouchMoveDown;
                scrollView.contentOffset = CGPointMake(0, self.previou_offset_y);
            }else{
                touch_move = YULinkageTouchMoveUp;
                self.previou_offset_y = offset_y;
            }
            if (self.touch_move != touch_move) {// 不用多次同步
                // 同步子视图的滑动状态
                self.touch_move = [self.linkage_view syncTouchMove:touch_move scrollView:self.response_view];
            }
            break;
        }
        case YULinkageTouchMoveDown:{
            scrollView.contentOffset = CGPointMake(0, self.previou_offset_y);
            break;
        }
    }
    [self didScrollForOffsetY:scrollView.contentOffset.y];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 防止代码改变offset从而触发了联动
    self.response_view = nil;
}

//MARK: 实现方法 方法转发
- (void)setCurrentIndexChanged:(void (^)(int))currentIndexChanged{
    self.linkage_view.currentIndexChanged = currentIndexChanged;
}

- (void (^)(int))currentIndexChanged{
    return self.linkage_view.currentIndexChanged;
}

- (void)setCurrentIndex:(int)currentIndex{
    self.linkage_view.currentIndex = currentIndex;
}

- (int)currentIndex{
    return self.linkage_view.currentIndex;
}

- (void)setCurrentIndex:(int)currentIndex animated:(BOOL)animated{
    [self.linkage_view setCurrentIndex:currentIndex animated:animated];
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

- (void)setIgnoreHeaderHeight:(float)ignoreHeaderHeight{
    if (_ignoreHeaderHeight == ignoreHeaderHeight) return;
    _ignoreHeaderHeight = ignoreHeaderHeight;
    if (!CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
        [self reloadData];
    }
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
#pragma mark 添加Segmented
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
        if (new_frame.size.height == olb_frame.size.height) return;
        self.segmented_height = new_frame.size.height;
        [self reloadData];
    }
}

/// 手势开始触摸时
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    self.response_view = nil;
    self.previou_offset_y = self.contentOffset.y;
    self.touch_move = YULinkageTouchMoveNone;
    return YES;
}

/// 是否与其他手势识别器同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    UIScrollView *aScrollView = (UIScrollView *)otherGestureRecognizer.view;
    if (![aScrollView isKindOfClass:[UIScrollView class]]) return NO;
    if ([aScrollView.class.description isEqualToString:@"UITableViewWrapperView"]) return NO;
    BOOL isCanLinkage = NO;
    isCanLinkage = [self.linkage_view canLinkageWithSrollView:aScrollView];
    if (isCanLinkage) {
        self.response_view = aScrollView;
    }
    return isCanLinkage;
}

- (void)dealloc{
    [self.segmented removeObserver:self forKeyPath:@"frame"];
}

@end
