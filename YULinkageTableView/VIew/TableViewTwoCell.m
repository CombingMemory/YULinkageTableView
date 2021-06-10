//
//  TableViewTwoCell.m
//  YULinkageTableView
//
//  Created by 捋忆 on 2021/6/10.
//

#import "TableViewTwoCell.h"

@implementation TableViewTwoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        _photo_iv = [[UIImageView alloc] init];
        self.photo_iv.contentMode = UIViewContentModeScaleAspectFill;
        self.photo_iv.layer.cornerRadius = 8;
        self.photo_iv.layer.masksToBounds = YES;
        [self.contentView addSubview:self.photo_iv];
        [self.photo_iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(94);
            make.centerY.mas_equalTo(0);
        }];
        
        _title_lb = [[UILabel alloc] init];
        self.title_lb.numberOfLines = 2;
        self.title_lb.font = [UIFont systemFontOfSize:16];
        self.title_lb.textColor = [UIColor colorWithRed:20/255 green:20/255 blue:20/255 alpha:1];
        [self.contentView addSubview:self.title_lb];
        [self.title_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.photo_iv.mas_right).offset(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.photo_iv);
        }];
        
        _date_lb = [[UILabel alloc] init];
        self.date_lb.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        self.date_lb.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.date_lb];
        [self.date_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.title_lb);
            make.top.mas_equalTo(self.title_lb.mas_bottom).offset(8);
        }];
        
        
        
        _tip_lb = [[UILabel alloc] init];
        self.tip_lb.font = [UIFont systemFontOfSize:12];
        self.tip_lb.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        self.tip_lb.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
        self.tip_lb.textAlignment = NSTextAlignmentCenter;
        self.tip_lb.layer.cornerRadius = 10;
        self.tip_lb.layer.masksToBounds = YES;
        [self.contentView addSubview:self.tip_lb];
        [self.tip_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(self.photo_iv);
            make.height.mas_equalTo(20);
        }];
        

        
        _name_lb = [[UILabel alloc] init];
        self.name_lb.font = [UIFont systemFontOfSize:11];
        self.name_lb.textColor = [UIColor colorWithRed:80/255 green:80/255 blue:80/255 alpha:1];
        [self.contentView addSubview:self.name_lb];
        [self.name_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.title_lb);
            make.centerY.mas_equalTo(self.tip_lb);
        }];
    }
    return self;
}

@end
