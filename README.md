# YULinkageTableView

#### 特性
- 使用方便、代码0入侵
- 使用时添加需要联动的scrollView即可
- 不需要设置scrollView任何代理，设置任何属性或继承自某父类，不用重写方法
- 支持添加VC中的view，与vc.view中的scrollView进行联动
- 支持插入、删除单个 联动page页
- segmented高度自定义，直接传入原本已自定义好的segmented
- 支持adjustedContentInset
- 支持iOS 11以下的版本
- 支持单个page页中多个scrollView的联动

#### 使用
` pod 'YULinkageTableView' `

https://github.com/CombingMemory/YULinkageTableView

#### 效果展示
![RPReplay_Final1624278837.gif](https://upload-images.jianshu.io/upload_images/991899-b6cdeb1ee28b46ce.gif?imageMogr2/auto-orient/strip)

![RPReplay_Final1624278882.gif](https://upload-images.jianshu.io/upload_images/991899-298200bd7ddaf7fc.gif?imageMogr2/auto-orient/strip)

#### API

```
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

```

#### 版本

**v 1.4.2**
- 添加scrollView视图时候，默认修改为内容未满也可以垂直滑动

**v 1.4.1**
- 修复拖动segmented拉动headerView的时候，联动的子视图未滑动的时候出现联动错误
- 修复了当用户第一次touch未离开屏幕的时候，第二个touch触发的时候、特殊情况下出现联动错误的问题

**v 1.4.0**
- 支持了可拖动segmented将headerView下拉下来，不用等到子scrollView滑动到顶部的时候才能对header进行滑动
- 修复了部分情况下代码移动子视图造成联动错误的问题

**v 1.3.5**
- 修复动态修改ignoreHeaderHeight属性是，联动视图高度不正确的问题

**v 1.3.4**
- 添加属性ignoreHeaderHeight,被忽略的头部视图高度

**v 1.3.3**
- 修复了联动视图中嵌套子UIScrollView导致联动失败的问题

**v 1.3.2**
- 修复了设置默认page页面失败的问题

**v 1.3.1**
- 修复了self.view中多个scrollView联动时，其中一个滑动到顶部，联动另一个也滑动到顶部的问题

**v 1.3.0**
- addScrollViewWithVC: 支持联动 self.view中的多个 scrollView

**v 1.2.0**
- 修复了插入新视图，约束错误的问题
- 适配了子视图的contentInset.top属性

**v 1.1.0**
- 修复了部分联动错误
- 适配了adjustedContentInset
- 适配了ios 11 以下的设备
- 修复了ios 10 didScrollView回调顺序不确定的问题
