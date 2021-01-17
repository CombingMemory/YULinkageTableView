//
//  YULinkageTableView.h
//  YU
//
//  Created by 捋忆 on 2018/4/23.
//  Copyright © 2018年 捋忆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YULinkageProtocol.h"

@interface YULinkageTableView : UITableView

@property (nonatomic, weak, nullable) id <UIScrollViewDelegate> outer_delegate;
/// 当前的index
@property (nonatomic, assign) int currentIndex;
/// index发生了改变
@property (nonatomic, copy) void (^ _Nullable currentIndexChanged)(int index);
/// 设置segmented
- (void)setSegmented:(nonnull UIView *)segmented;
/// 添加scrollView
- (BOOL)addScrollView:(nonnull UIScrollView *)scrollView;
/// 插入scrollView
- (BOOL)insertScrollView:(nonnull UIScrollView *)scrollView atIndex:(NSInteger)index;



//  YULinkageTableViewDelegate 代理中的 provideScrollViewForResponse 方法会早于 viewDidLoad执行。因此所返回的 ScrollView 需采用懒加载的方式创建。
// 另vc需要自行添加为指定的控制器的子控制器 addChildViewController

/// 根据VC添加scrollView
- (BOOL)addScrollViewWithVC:(nonnull UIViewController<YULinkageTableViewDelegate> *)vc;
/// 根据VC插入scrollView
- (BOOL)insertScrollViewWithVC:(nonnull UIViewController<YULinkageTableViewDelegate> *)vc atIndex:(NSInteger)index;
/// 删除subView
- (BOOL)removeSubviewAtIndex:(NSInteger)index;

@end
