//
//  CollectionViewCell.m
//  YULinkageTableView
//
//  Created by 捋忆 on 2021/6/10.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 8;
        self.contentView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
        self.contentView.layer.shadowOffset = CGSizeMake(0, 3);
        self.contentView.layer.shadowOpacity = 1;
        self.contentView.layer.shadowRadius = 6;
        
        
        _photo_iv = [[UIImageView alloc] init];
        self.photo_iv.contentMode = UIViewContentModeScaleAspectFill;
        self.photo_iv.layer.cornerRadius = 8;
        self.photo_iv.layer.masksToBounds = YES;
        [self.contentView addSubview:self.photo_iv];
        [self.photo_iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(self.photo_iv.mas_width);
        }];
        
        _title_lb = [[UILabel alloc] init];
        self.title_lb.numberOfLines = 2;
        self.title_lb.textColor = [UIColor blackColor];
        self.title_lb.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.title_lb];
        [self.title_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-6);
            make.top.mas_equalTo(self.photo_iv.mas_bottom).offset(4);
        }];
        
        _date_lb = [[UILabel alloc] init];
        self.date_lb.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        self.date_lb.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.date_lb];
        [self.date_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(self.title_lb.mas_bottom).offset(4);
        }];
        
        
        _avatar_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.avatar_btn.imageView.layer.cornerRadius = 14;
        self.avatar_btn.imageView.layer.masksToBounds = YES;
        self.avatar_btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.avatar_btn];
        [self.avatar_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(self.date_lb.mas_bottom).offset(4);
            make.width.height.mas_equalTo(28);
        }];
        
        _name_lb = [[UILabel alloc] init];
        self.name_lb.font = [UIFont systemFontOfSize:11];
        self.name_lb.textColor = [UIColor colorWithRed:80/255 green:80/255 blue:80/255 alpha:1];
        [self.contentView addSubview:self.name_lb];
        [self.name_lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatar_btn.mas_right).offset(3);
            make.centerY.mas_equalTo(self.avatar_btn);
        }];
        
        _read_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.read_btn setImage:[UIImage imageNamed:@"read"] forState:UIControlStateNormal];
        [self.read_btn setTitleColor:[UIColor colorWithRed:110/255 green:110/255 blue:110/255 alpha:1] forState:UIControlStateNormal];
        self.read_btn.titleLabel.font = [UIFont systemFontOfSize:11];
        self.read_btn.userInteractionEnabled = NO;
        [self.contentView addSubview:self.read_btn];
        [self.read_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-7);
            make.centerY.mas_equalTo(self.avatar_btn);
        }];
    }
    return self;
}

@end
