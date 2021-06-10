//
//  MixVC.m
//  YULinkageTableView
//
//  Created by 捋忆 on 2021/6/10.
//

#import "MixVC.h"
#import "CollectionVC.h"
#import "TableViewVC.h"
#import "TableViewTwoVC.h"

#import <Masonry/Masonry.h>

@interface MixVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UISegmentedControl *segmented;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *content_view;

@property (nonatomic, strong) CollectionVC *collection_vc;

@property (nonatomic, strong) TableViewVC *table_vc;

@property (nonatomic, strong) TableViewTwoVC *table_two_vc;

@end

@implementation MixVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.segmented = [[UISegmentedControl alloc] initWithItems:@[@"模块",@"列表",@"双列"]];
    [self.segmented addTarget:self action:@selector(valueChangedAction:) forControlEvents:UIControlEventValueChanged];
    self.segmented.selectedSegmentIndex = 0;
    [self.view addSubview:self.segmented];
    [self.segmented mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmented.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    self.content_view = [[UIView alloc] init];
    [self.scrollView addSubview:self.content_view];
    [self.content_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.height.mas_equalTo(self.scrollView);
    }];
    
    [self.content_view addSubview:self.collection_vc.view];
    [self.collection_vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
    }];
    
    [self.content_view addSubview:self.table_vc.view];
    [self.table_vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
        make.left.mas_equalTo(self.collection_vc.view.mas_right);
    }];
    
    [self.content_view addSubview:self.table_two_vc.view];
    [self.table_two_vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
        make.left.mas_equalTo(self.table_vc.view.mas_right);
        
        make.right.mas_equalTo(0);
    }];
    
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat offsetX = targetContentOffset->x;
    offsetX += scrollView.frame.size.width / 2;
    int currentIndex = offsetX / scrollView.frame.size.width;
    [self.segmented setSelectedSegmentIndex:currentIndex];
}

- (void)valueChangedAction:(UISegmentedControl *)segmented{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * segmented.selectedSegmentIndex, 0) animated:YES];
}




// MARK: YULinkageTableViewDelegate
- (NSArray<UIScrollView *> *)provideScrollViewsForLinkage{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:[self.collection_vc provideScrollViewsForLinkage]];
    [array addObjectsFromArray:[self.table_vc provideScrollViewsForLinkage]];
    [array addObjectsFromArray:[self.table_two_vc provideScrollViewsForLinkage]];
    return array;
}


// MARK: lazy
- (CollectionVC *)collection_vc{
    if (!_collection_vc) {
        _collection_vc = [[CollectionVC alloc] init];
        [self addChildViewController:_collection_vc];
    }
    return _collection_vc;
}

- (TableViewVC *)table_vc{
    if (!_table_vc) {
        _table_vc = [[TableViewVC alloc] init];
        [self addChildViewController:_table_vc];
    }
    return _table_vc;
}

- (TableViewTwoVC *)table_two_vc{
    if (!_table_two_vc) {
        _table_two_vc = [[TableViewTwoVC alloc] init];
    }
    return _table_two_vc;
}

@end
