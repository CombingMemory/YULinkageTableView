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

@end

@implementation SingleTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (nonnull UIScrollView *)provideScrollViewForResponse {
    return self.tableView;
}

- (TableView *)tableView{
    if (!_tableView) {
        _tableView = [[TableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
//        _tableView = [[TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    }
    return _tableView;
}

@end
