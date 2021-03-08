//
//  ViewController.m
//  YULinkageTableView
//
//  Created by 捋忆 on 2021/1/6.
//

#import "ViewController.h"
#import "YULinkageTableView.h"
#import "TableView.h"
#import <Masonry.h>

#import "SingleTableVC.h"

@interface ViewController ()

@property (nonatomic, strong) YULinkageTableView *linkage_tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.linkage_tableView = [[YULinkageTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.linkage_tableView];
    [self.linkage_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    [view addSubview:label];
    label.text = @"Header位置";
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:57];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor yellowColor];
    self.linkage_tableView.tableHeaderView = view;
    
    
    if (@available(iOS 11.0, *)) {
        
    }else{
        self.linkage_tableView.adjustedTop = 64;
    }
    
    
    
    
    // 这里放置 segmented
    UIView *segmented = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    segmented.backgroundColor = [UIColor blueColor];
    [self.linkage_tableView setSegmented:segmented];
    
    
    
    TableView *one1 = [[TableView alloc] init];
    one1.tag = 1;
    one1.backgroundColor = [UIColor yellowColor];
    [self.linkage_tableView addScrollView:one1];
    
    TableView *one = [[TableView alloc] init];
    one.tag = 2;
    one.backgroundColor = [UIColor redColor];
    [self.linkage_tableView addScrollView:one];
    
    TableView *one2 = [[TableView alloc] init];
    one2.tag = 3;
    one2.backgroundColor = [UIColor blueColor];
    [self.linkage_tableView addScrollView:one2];

    TableView *one3 = [[TableView alloc] init];
    one3.tag = 4;
    one3.backgroundColor = [UIColor purpleColor];
    [self.linkage_tableView addScrollView:one3];

    TableView *one4 = [[TableView alloc] init];
    one4.tag = 5;
    one4.backgroundColor = [UIColor cyanColor];
    [self.linkage_tableView addScrollView:one4];

    TableView *one5 = [[TableView alloc] init];
    one5.tag = 6;
    one5.backgroundColor = [UIColor orangeColor];
    [self.linkage_tableView addScrollView:one5];
    
    SingleTableVC *s_vc = [[SingleTableVC alloc] init];
    [self addChildViewController:s_vc];
    [self.linkage_tableView insertScrollViewWithVC:s_vc atIndex:0];
    UIBarButtonItem *delete_item = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteScrollView)];
    self.navigationItem.rightBarButtonItem = delete_item;
    
    self.linkage_tableView.currentIndexChanged = ^(int index) {
        NSLog(@"%d",index);
    };
    
    self.linkage_tableView.didScroll = ^(float offsetX, float offsetY) {
//        NSLog(@"x:%f---y:%f",offsetX,offsetY);
    };
    
}

- (void)deleteScrollView{
//    [self.linkage_tableView removeSubviewAtIndex:1];
    [self.linkage_tableView setCurrentIndex:6 animated:YES];
    [self.linkage_tableView setCurrentIndex:0 animated:YES];
    [self.linkage_tableView setCurrentIndex:3 animated:YES];
}


@end
