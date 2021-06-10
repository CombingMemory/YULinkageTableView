//
//  TableViewVC.m
//  YULinkageTableView
//
//  Created by 捋忆 on 2021/6/10.
//

#import "TableViewVC.h"

#import "TableViewCell.h"

@interface TableViewVC ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@end

@implementation TableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.array = @[
        @{@"title":@"社交体验实战案例！亿万人在用的QQ群是如何做好设计的？",
          @"read_count":@"117",
          @"avatar":@"avatar",
          @"date":@"2021-06-10",
          @"name":@"狂怒"
        },
        
        @{@"title":@"刚接触交互岗位，应该怎么做才不会手忙脚乱？",
          @"read_count":@"117",
          @"avatar":@"avatar3",
          @"date":@"2021-06-10",
          @"name":@"没事看开点"
        },
        
        @{@"title":@"社交体验实战案例！亿万人在用的QQ群是如何做好设计的？",
          @"read_count":@"117",
          @"avatar":@"avatar2",
          @"date":@"2021-06-10",
          @"name":@"牛呀牛呀"
        },
        
        @{@"title":@"社交体验实战案例！亿万人在用的QQ群是如何做好设计的？",
          @"read_count":@"117",
          @"avatar":@"avatar1",
          @"date":@"2021-06-10",
          @"name":@"海基会"
        },
        
    ];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

// MARK: TableView的代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    NSDictionary *dic = self.array[indexPath.item];
    [cell.avatar_btn setImage:[UIImage imageNamed:dic[@"avatar"]] forState:UIControlStateNormal];
    cell.date_lb.text = dic[@"date"];
    cell.name_lb.text = dic[@"name"];
    cell.title_lb.text = dic[@"title"];
    cell.read_lb.text = dic[@"read_count"];
    return cell;
}

// MARK: YULinkageTableViewDelegate
- (NSArray<UIScrollView *> *)provideScrollViewsForLinkage{
    return @[self.tableView];
}

// MARK: lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        [_tableView registerClass:[TableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
        _tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        _tableView.rowHeight = 153;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
