//
//  KSWelfareRecordItemCell.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/25.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWelfareRecordItemCell.h"
#import "Masonry.h"

@implementation KSWelfareRecordItemCell

- (void)bindViewModel:(KSWelfareRecordItemViewModel *)viewModel {
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    self.contentView.backgroundColor = KS_GrayColor_BackColor;
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];

    [self.contentView addSubview:contentView];
    @weakify(self);
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@90);
    }];
    UIView *leftView = [UIView new];
    [self.contentView addSubview:leftView];
    leftView.backgroundColor = BASE_COLOR;

    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.top.bottom.equalTo(contentView);
        make.width.equalTo(leftView.mas_height);
    }];

    UIImageView *imageView = [UIImageView new];
    [leftView addSubview:imageView];
    if (viewModel.itemModel.welfare_type == KSWelfareTypeWuPin) {
        imageView.image = [UIImage imageNamed:@"shiwu"];
    } else {
        imageView.image = [UIImage imageNamed:@"jiangquan"];
    }
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.centerY.equalTo(leftView).offset(-10);
        make.width.equalTo(leftView).multipliedBy(0.4);
        make.height.equalTo(imageView.mas_width).multipliedBy(83.0 / 100.0);
    }];

    NSDate *time = [NSDate dateWithTimeIntervalSince1970:[viewModel.itemModel.time unsignedIntegerValue]];
    NSDateFormatter *ft = [NSDateFormatter new];
//    ft.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    ft.dateFormat = @"HH:mm";
    NSString *strTime = [ft stringFromDate:time];

    UILabel *timeLabel = [UILabel new];
    timeLabel.text = strTime;
    timeLabel.font = KS_SMALL_FONT;
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [leftView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.top.equalTo(imageView.mas_bottom).offset(5);
    }];

    UILabel *nameLabel = [UILabel new];
    nameLabel.text = viewModel.itemModel.welfare_title;
    nameLabel.font = KS_FONT_16;
    nameLabel.textColor = [UIColor blackColor];
    [contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).offset(15);
        make.centerY.equalTo(leftView).offset(-15);
    }];

    UILabel *mobileLabel = [UILabel new];;
    mobileLabel.text = [NSString stringWithFormat:@"接收账号: %@", viewModel.itemModel.receiver];
    mobileLabel.font = KS_SMALL_FONT;
    mobileLabel.textColor = KS_GrayColor4;
    [contentView addSubview:mobileLabel];
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.centerY.equalTo(leftView).offset(15);
    }];


    //只有实物奖品才有详情(箭头标识)
    if (viewModel.itemModel.welfare_type == KSWelfareTypeWuPin) {
        UIImageView *rightArrow = [UIImageView new];
        [contentView addSubview:rightArrow];
        rightArrow.image = [UIImage imageNamed:@"icon_arrow"];
        [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftView);
            make.right.equalTo(contentView).offset(-10);
        }];

    }

    viewModel.cellHeight = viewModel.showTime ? 120 : 100;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
