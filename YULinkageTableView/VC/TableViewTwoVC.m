//
//  TableViewTwoVC.m
//  YULinkageTableView
//
//  Created by 捋忆 on 2021/6/10.
//

#import "TableViewTwoVC.h"

#import "TableViewTwoCell.h"
#import "SortView.h"

@interface TableViewTwoVC ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) SortView *sort_view;

@end

@implementation TableViewTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.array = @[
        @{@"title":@"社交体验实战案例！亿万人在用的QQ群是如何做好设计的？",
          @"tip":@"  iOS 15         ",
          @"photo":@"photo",
          @"date":@"2021-06-10",
          @"name":@"狂怒"
        },
        
        @{@"title":@"刚接触交互岗位，应该怎么做才不会手忙脚乱？",
          @"tip":@"  设计         ",
          @"photo":@"photo3",
          @"date":@"2021-06-10",
          @"name":@"没事看开点"
        },
        
        @{@"title":@"社交体验实战案例！亿万人在用的QQ群是如何做好设计的？",
          @"tip":@"  复杂UI         ",
          @"photo":@"photo2",
          @"date":@"2021-06-10",
          @"name":@"牛呀牛呀"
        },
        
        @{@"title":@"社交体验实战案例！亿万人在用的QQ群是如何做好设计的？",
          @"tip":@"  联动         ",
          @"photo":@"photo1",
          @"date":@"2021-06-10",
          @"name":@"海基会"
        },
        
    ];
    
    [self.view addSubview:self.sort_view];
    [self.sort_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(90);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.sort_view.mas_right);
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
    TableViewTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewTwoCell" forIndexPath:indexPath];
    NSDictionary *dic = self.array[indexPath.item];
    cell.photo_iv.image = [UIImage imageNamed:dic[@"photo"]];
    cell.date_lb.text = dic[@"date"];
    cell.name_lb.text = dic[@"name"];
    cell.title_lb.text = dic[@"title"];
    cell.tip_lb.text = dic[@"tip"];
    return cell;
}

// MARK: YULinkageTableViewDelegate
- (NSArray<UIScrollView *> *)provideScrollViewsForLinkage{
    return @[self.sort_view,self.tableView];
}

// MARK: lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        [_tableView registerClass:[TableViewTwoCell class] forCellReuseIdentifier:@"TableViewTwoCell"];
        _tableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        _tableView.rowHeight = 121;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (SortView *)sort_view{
    if (!_sort_view) {
        _sort_view = [[SortView alloc] init];
    }
    return _sort_view;
}

@end
