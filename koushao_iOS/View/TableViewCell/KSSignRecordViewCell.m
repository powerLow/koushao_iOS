//
//  KSSignRecordViewCell.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/10.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSSignRecordViewCell.h"
#import "KSSignRecordListItemViewModel.h"
#import "Masonry.h"

@implementation KSSignRecordViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(KSSignRecordListItemViewModel *)viewModel {
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
    imageView.image = [UIImage imageNamed:@"icon_signin"];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftView);
        make.centerY.equalTo(leftView).offset(-10);
        make.width.equalTo(leftView).multipliedBy(0.4);
        make.height.equalTo(imageView.mas_width).multipliedBy(83.0 / 100.0);
    }];

    //图片底下的时间
    NSDate *time = nil;
    if (viewModel.isSignin) {
        time = [NSDate dateWithTimeIntervalSince1970:[viewModel.itemModel.signin_time unsignedIntegerValue]];
    } else {
        time = [NSDate dateWithTimeIntervalSince1970:[viewModel.itemModel.signup_time unsignedIntegerValue]];
    }

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


    UIView *lastView = nil;
    NSArray *texts = nil;
    NSArray *fonts = nil;
    NSArray *colors = nil;
    if (viewModel.isSignin) {
        texts = @[
                viewModel.itemModel.nickname,
                [NSString stringWithFormat:@"报名账号:  %@", viewModel.itemModel.mobilePhone],
                [NSString stringWithFormat:@"签 到 人:  %@", viewModel.itemModel.signin_admin],
        ];
        fonts = @[KS_FONT_16, KS_SMALL_FONT, KS_SMALL_FONT];
        colors = @[[UIColor blackColor], KS_GrayColor4, KS_GrayColor4];
    } else {
        texts = @[
                viewModel.itemModel.nickname,
                [NSString stringWithFormat:@"报名账号:  %@", viewModel.itemModel.mobilePhone],
        ];
        fonts = @[KS_FONT_16, KS_SMALL_FONT];
        colors = @[[UIColor blackColor], KS_GrayColor4];
    }


    for (int i = 0; i < texts.count; ++i) {
        UILabel *label = [UILabel new];
        label.textColor = colors[i];
        label.font = fonts[i];
        label.text = texts[i];
        [self.contentView addSubview:label];
        if (lastView == nil) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftView.mas_right).offset(15);
                make.top.equalTo(imageView).offset(-5);
            }];
        } else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftView.mas_right).offset(15);
                make.top.equalTo(lastView.mas_bottom).offset(10);
            }];
        }
        lastView = label;
    }

    //箭头
    UIImageView *rightArrow = [UIImageView new];
    [contentView addSubview:rightArrow];
    rightArrow.image = [UIImage imageNamed:@"icon_arrow"];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView);
        make.right.equalTo(contentView).offset(-10);
    }];

    viewModel.cellHeight = viewModel.showTime ? 120 : 100;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
