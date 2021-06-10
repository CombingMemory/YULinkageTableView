//
//  SortView.m
//  YULinkageTableView
//
//  Created by 捋忆 on 2021/6/10.
//

#import "SortView.h"

@interface SortViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *title_lb;

@end

@implementation SortViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _title_lb = [[UILabel alloc] init];
        [self.contentView addSubview:self.title_lb];
        [self.title_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        [self setSelected:NO animated:NO];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    self.title_lb.font = selected?[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]:[UIFont systemFontOfSize:14];
    self.title_lb.textColor = selected?[UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:1]:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    self.contentView.backgroundColor = selected?[UIColor whiteColor]:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
}

@end


//----------------------------------------------------------------------


@implementation SortView

- (instancetype)init{
    self = [super initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (self) {
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[SortViewCell class] forCellReuseIdentifier:@"SortViewCell"];
        self.rowHeight = 47;
    }
    return self;
}


// MARK: UITableView的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SortViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SortViewCell" forIndexPath:indexPath];
    cell.title_lb.text = [NSString stringWithFormat:@"第%ld页",indexPath.row];
    return cell;
}

@end
