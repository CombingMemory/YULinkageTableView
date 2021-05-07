//
//  YULinkageTableView.h
//  YU
//
//  Created by 捋忆 on 2018/4/23.
//  Copyright © 2018年 捋忆. All rights reserved.
//

/*
 
 总注释:
 
    001:内部的ScrollView先触发了，测试了iPhone5 根ScrollView和子ScrollView联动时先后回调的顺序不一样，很随机。测试的iPhone XS触发顺序很确定，永远是外部ScrollView先回调，故加了这一层处理
 
    002:修改currentIndex的时候。因为动画的原因，index会回调中间改变的过程。比如从0更改为6。会出现0、1、2、3、4、5、6的回调。而我们要的效果则是没有任何回调
 
 
 */



/// https://github.com/CombingMemory/YULinkageTableView


#import <UIKit/UIKit.h>
#import "YULinkageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface YULinkageTableView : UITableView

/// 当前的index
@property (nonatomic, assign) int currentIndex;
/// index发生了改变
@property (nonatomic, copy, nullable) void (^currentIndexChanged)(int index);
/// 视图滚动
@property (nonatomic, copy, nullable) void (^didScroll)(float offsetX,float offsetY);
/// 设置index
- (void)setCurrentIndex:(int)currentIndex animated:(BOOL)animated;

/// scrollView的自动调整高度。VC的属性automaticallyAdjustsScrollViewInsets为YES的情况下使用
@property (nonatomic, assign) float adjustedTop API_DEPRECATED("VC的属性automaticallyAdjustsScrollViewInsets为YES的情况下使用",ios(7.0,11.0));

/// 忽略的头部高度 默认:0
@property (nonatomic, assign) float ignoreHeaderHeight;

/// 设置segmented
- (void)setSegmented:(nonnull UIView *)segmented;



/// 添加scrollView
- (BOOL)addScrollView:(nonnull UIScrollView *)scrollView;
/// 插入scrollView
- (BOOL)insertScrollView:(nonnull UIScrollView *)scrollView atIndex:(NSInteger)index;



//  YULinkageTableViewDelegate 代理中的 provideScrollViewForResponse 方法会早于 viewDidLoad执行。因此所返回的 scrollView 需采用懒加载的方式创建。
//  另vc需要自行添加为指定的控制器的子控制器 addChildViewController

/// 根据VC添加scrollView
- (BOOL)addScrollViewWithVC:(nonnull UIViewController<YULinkageTableViewDelegate> *)vc;
/// 根据VC插入scrollView
- (BOOL)insertScrollViewWithVC:(nonnull UIViewController<YULinkageTableViewDelegate> *)vc atIndex:(NSInteger)index;




/// 删除subView
- (BOOL)removeSubviewAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
