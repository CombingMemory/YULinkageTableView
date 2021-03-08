# YULinkageTableView

#### 特性
- 使用方便、代码0入侵
- 使用时添加需要联动的ScrollView即可
- 不用接入ScrollView任何代理，设置任何属性或继承自某父类
- 支持添加VC中的view，与vc中的ScrollView进行联动
- 支持插入、删除单个 联动page页
- segmented高度自定义，直接传入原本已自定义好的segmented
- 支持adjustedContentInset
- 支持iOS 11以下的版本

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
**v 1.1.0**
- 修复了部分联动错误
- 适配了adjustedContentInset
- 适配了ios 11 以下的设备
- 修复了ios 10 didScrollView回调顺序不确定的问题


#### 后续功能

- addScrollViewWithVC 时候将会支持VC中多个ScrollView的联动效果（例如一个VC中两列TableView效果）。目前仅支持VC中的单个ScrollView的联动效果。
