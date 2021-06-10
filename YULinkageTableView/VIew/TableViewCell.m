//
//  TableViewCell.m
//  YULinkageTableView
//
//  Created by 捋忆 on 2021/6/10.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *bg_view = [[UIView alloc] init];
        bg_view.layer.cornerRadius = 8;
        bg_view.layer.masksToBounds = YES;
        bg_view.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bg_view];
        [bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
        }];
        
        UIView *gray_view = [[UIView alloc] init];
        gray_view.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:247/255.0 alpha:1];
        [bg_view addSubview:gray_view];
        [gray_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.top.mas_equalTo(13);
        }];
        
        _title_lb = [[UILabel alloc] init];
        self.title_lb.numberOfLines = 2;
        self.title_lb.font = [UIFont systemFontOfSize:16];
        self.title_lb.textColor = [UIColor colorWithRed:20/255 green:20/255 blue:20/255 alpha:1];
        [gray_view addSubview:self.title_lb];
        [self.title_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(12);
        }];
        
        UIButton *q_a_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        q_a_btn.backgroundColor = [UIColor colorWithRed:255/255.0 green:215/255.0 blue:108/255.0 alpha:1];
        q_a_btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [q_a_btn setTitle:@"查看答案" forState:UIControlStateNormal];
        [q_a_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        q_a_btn.layer.cornerRadius = 12;
        q_a_btn.layer.masksToBounds = YES;
        [gray_view addSubview:q_a_btn];
        [q_a_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(68);
            make.height.mas_equalTo(24);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(self.title_lb.mas_bottom).offset(6);
            
            make.bottom.mas_equalTo(-6);
        }];
        
        _read_lb = [[UILabel alloc] init];
        self.read_lb.font = [UIFont systemFontOfSize:12];
        self.read_lb.textColor = [UIColor colorWithRed:161/255 green:166/255 blue:173/255 alpha:1];
        [gray_view addSubview:self.read_lb];
        [self.read_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.centerY.mas_equalTo(q_a_btn);
        }];
        
        UILabel *read_text_lb = [[UILabel alloc] init];
        read_text_lb.textColor = self.read_lb.textColor;
        read_text_lb.font = self.read_lb.font;
        [gray_view addSubview:read_text_lb];
        [read_text_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.read_lb);
            make.left.mas_equalTo(self.read_lb.mas_right);
        }];
        
        _avatar_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.avatar_btn.imageView.layer.cornerRadius = 15;
        self.avatar_btn.imageView.layer.masksToBounds = YES;
        self.avatar_btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [bg_view addSubview:self.avatar_btn];
        [self.avatar_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.top.mas_equalTo(gray_view.mas_bottom).offset(8);
            make.width.height.mas_equalTo(30);
        }];
        
        _name_lb = [[UILabel alloc] init];
        self.name_lb.font = [UIFont systemFontOfSize:11];
        self.name_lb.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1];
        [bg_view addSubview:self.name_lb];
        [self.name_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatar_btn.mas_right).offset(3);
            make.centerY.mas_equalTo(self.avatar_btn);
        }];
        
        _date_lb = [[UILabel alloc] init];
        self.date_lb.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        self.date_lb.font = [UIFont systemFontOfSize:11];
        [bg_view addSubview:self.date_lb];
        [self.date_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-13);
            make.centerY.mas_equalTo(self.avatar_btn);
        }];
    }
    return self;
}

@end
