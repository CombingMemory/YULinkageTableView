//
//  TableViewTwoCell.h
//  YULinkageTableView
//
//  Created by 捋忆 on 2021/6/10.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewTwoCell : UITableViewCell

@property (nonatomic, strong, readonly) UIImageView *photo_iv;

@property (nonatomic, strong, readonly) UILabel *title_lb;

@property (nonatomic, strong, readonly) UILabel *date_lb;

@property (nonatomic, strong, readonly) UILabel *name_lb;

@property (nonatomic, strong, readonly) UILabel *tip_lb;

@end

NS_ASSUME_NONNULL_END
