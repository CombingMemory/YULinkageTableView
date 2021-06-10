//
//  CollectionVC.m
//  YULinkageTableView
//
//  Created by 捋忆 on 2021/6/10.
//

#import "CollectionVC.h"
#import "CollectionViewCell.h"


@interface CollectionVC ()<UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *array;

@end

@implementation CollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    @{@"title":@"",
//      @"photo":@"",
//      @"read_count":@"",
//      @"avatar":@"",
//      @"date":@"",
//      @"name":@""
//    },
//
    
    self.array = @[
        @{@"title":@"B 端设计指南（六）：数据图表怎么设计？",
          @"photo":@"photo",
          @"read_count":@"50",
          @"avatar":@"avatar",
          @"date":@"2021-06-10",
          @"name":@"狂怒"
        },
        @{@"title":@"见微知著！有哪些适应环境且特别巧妙的设计细节？",
          @"photo":@"photo1",
          @"read_count":@"47",
          @"avatar":@"avatar1",
          @"date":@"2021-05-10",
          @"name":@"陈字母"
        },
        @{@"title":@"APP把简单直观地体验作为设计的目标",
          @"photo":@"photo",
          @"read_count":@"35",
          @"avatar":@"avatar2",
          @"date":@"2021-04-10",
          @"name":@"龙爪槐守望者"
        },
        @{@"title":@"5000+超干货！帮你完整梳理弹幕的起源……",
          @"photo":@"photo3",
          @"read_count":@"27",
          @"avatar":@"avatar3",
          @"date":@"2021-03-10",
          @"name":@"JellyDesign"
        },
        @{@"title":@"轻松三步搞定数据统计分析：统计+分析+可视化",
          @"photo":@"photo2",
          @"read_count":@"99",
          @"avatar":@"avatar2",
          @"date":@"2021-04-10",
          @"name":@"龙爪槐守望者"
        },
        @{@"title":@"这份 iOS 15 推送通知设计指南，值得设计……",
          @"photo":@"photo4",
          @"read_count":@"117",
          @"avatar":@"avatar3",
          @"date":@"2021-03-10",
          @"name":@"JellyDesign"
        },
    ];
    
    
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

// MARK: collectionView代理
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 7;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic = self.array[indexPath.item];
    [cell.avatar_btn setImage:[UIImage imageNamed:dic[@"avatar"]] forState:UIControlStateNormal];
    cell.date_lb.text = dic[@"date"];
    cell.photo_iv.image = [UIImage imageNamed:dic[@"photo"]];
    cell.name_lb.text = dic[@"name"];
    cell.title_lb.text = dic[@"title"];
    [cell.read_btn setTitle:dic[@"read_count"] forState:UIControlStateNormal];
    return cell;
}

// MARK: YULinkageTableViewDelegate
- (NSArray<UIScrollView *> *)provideScrollViewsForLinkage{
    return @[self.collectionView];
}

// MARK: lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(173, 275);
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    }
    return _collectionView;
}

@end
