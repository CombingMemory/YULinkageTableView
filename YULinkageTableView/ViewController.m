//
//  ViewController.m
//  YULinkageTableView
//
//  Created by 捋忆 on 2021/1/6.
//

#import "ViewController.h"
#import "YULinkageTableView.h"
#import <Masonry.h>

#import "CollectionVC.h"
#import "TableViewVC.h"
#import "TableViewTwoVC.h"
#import "MixVC.h"


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

    UIImage *header_image = [UIImage imageNamed:@"header"];
    UIImageView *header_iv = [[UIImageView alloc] initWithImage:header_image];
    float height = self.view.frame.size.width / header_image.size.width * header_image.size.height;
    header_iv.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
    self.linkage_tableView.tableHeaderView = header_iv;
    
    
    if (@available(iOS 11.0, *)) {
        
    }else{
        self.linkage_tableView.adjustedTop = 64;
    }
    
    self.linkage_tableView.ignoreHeaderHeight = 0;
    
    
    UISegmentedControl *segmented_control = [[UISegmentedControl alloc] initWithItems:@[@"双列",@"混合",@"模块",@"列表"]];
    segmented_control.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    [self.linkage_tableView setSegmented:segmented_control];
    segmented_control.selectedSegmentIndex = 1;
    [segmented_control addTarget:self action:@selector(valueChangedAction:) forControlEvents:UIControlEventValueChanged];
    
    
    CollectionVC *collection_vc = [[CollectionVC alloc] init];
    [self addChildViewController:collection_vc];
    [self.linkage_tableView addScrollViewWithVC:collection_vc];
    
    TableViewVC *table_vc = [[TableViewVC alloc] init];
    [self addChildViewController:table_vc];
    [self.linkage_tableView addScrollViewWithVC:table_vc];
    
    TableViewTwoVC *two_vc = [[TableViewTwoVC alloc] init];
    [self addChildViewController:two_vc];
    [self.linkage_tableView insertScrollViewWithVC:two_vc atIndex:0];
    
    MixVC *mix_vc = [[MixVC alloc] init];
    [self addChildViewController:mix_vc];
    [self.linkage_tableView insertScrollViewWithVC:mix_vc atIndex:1];
    
    
    self.linkage_tableView.currentIndex = 1;
    
    self.linkage_tableView.currentIndexChanged = ^(int index) {
        segmented_control.selectedSegmentIndex = index;
    };
}

- (void)valueChangedAction:(UISegmentedControl *)segmented{
    [self.linkage_tableView setCurrentIndex:(int)segmented.selectedSegmentIndex animated:YES];
}

@end
