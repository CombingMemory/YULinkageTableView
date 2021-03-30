//
//  SingleTableVC.m
//  YULinkageTableView
//
//  Created by 捋忆 on 2021/1/7.
//

#import "SingleTableVC.h"
#import "TableView.h"
#import <Masonry.h>

@interface SingleTableVC ()

@property (nonatomic, strong) TableView *tableView;

@property (nonatomic, strong) TableView *tableView2;

@end

@implementation SingleTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView2];
    [self.tableView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(120);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableView2.mas_right);
        make.top.right.bottom.mas_equalTo(0);
    }];
    
}

- (NSArray<UIScrollView *> *)provideScrollViewsForLinkage{
    return @[self.tableView,self.tableView2];
}

- (TableView *)tableView{
    if (!_tableView) {
        _tableView = [[TableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    }
    return _tableView;
}

- (TableView *)tableView2{
    if (!_tableView2) {
        _tableView2 = [[TableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView2.backgroundColor = [UIColor grayColor];
        _tableView2.contentInset = UIEdgeInsetsMake(70, 0, 0, 0);
    }
    return _tableView2;
}

@end
