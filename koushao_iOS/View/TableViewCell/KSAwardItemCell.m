//
//  KSAwardItemCell.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/16.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSAwardItemCell.h"
#import "Masonry.h"
#import "KSAwardItemViewModel.h"
@implementation KSAwardItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) bindViewModel:(KSAwardItemViewModel*)viewModel{
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
        make.height.mas_equalTo(viewModel.cellHeight*0.8);
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
    imageView.image = [UIImage imageNamed:@"shiwu"];
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
    
    if (viewModel.isSend) {
        UILabel *title_label = [UILabel new];
        [contentView addSubview:title_label];
        title_label.font = KS_FONT_16;
        title_label.text = viewModel.itemModel.welfare_name;
    
        [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftView.mas_right).offset(15);
            make.top.equalTo(contentView).offset(15);
        }];
        
        //    NSMutableArray *labels = [NSMutableArray new];
        UIView *lastView = title_label;
        
        NSArray *texts = @[[NSString stringWithFormat:@"接收账号:  %@",viewModel.itemModel.receiver],
//                           [NSString stringWithFormat:@"发放时间:  %@",[KSUtil StringTimeFromNumber:viewModel.itemModel.time]],
                           [NSString stringWithFormat:@"发 放 人:  %@",viewModel.itemModel.admin],
                           ];
        for (int i = 0 ; i<texts.count; ++i) {
            UILabel *label = [UILabel new];
            label.textColor = KS_GrayColor4;
            label.font = KS_SMALL_FONT;
            label.text = texts[i];
            [contentView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftView.mas_right).offset(15);
                make.top.equalTo(lastView.mas_bottom).offset(7);
            }];
            
            //        [labels addObject:label];
            lastView = label;
        }
    }else{
        UILabel *title_label = [UILabel new];
        [self.contentView addSubview:title_label];
        title_label.font = KS_FONT_16;
        title_label.text = viewModel.itemModel.welfare_name;
        
        [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftView.mas_right).offset(15);
            make.top.equalTo(contentView).offset(15);
        }];
        
        //    NSMutableArray *labels = [NSMutableArray new];
        UIView *lastView = title_label;
        
        NSArray *texts = @[[NSString stringWithFormat:@"接收账号:  %@",viewModel.itemModel.receiver],
//                           [NSString stringWithFormat:@"抽奖时间:  %@",[KSUtil StringTimeFromNumber:viewModel.itemModel.time]],
                           ];
        for (int i = 0 ; i<texts.count; ++i) {
            UILabel *label = [UILabel new];
            label.textColor = KS_GrayColor4;
            label.font = KS_SMALL_FONT;
            label.text = texts[i];
            [contentView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftView.mas_right).offset(15);
                make.top.equalTo(lastView.mas_bottom).offset(10);
            }];
            
            //        [labels addObject:label];
            lastView = label;
        }
        
    }
    
    UIImageView *rightArrow = [UIImageView new];
    [contentView addSubview:rightArrow];
    rightArrow.image = [UIImage imageNamed:@"icon_arrow"];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView);
        make.right.equalTo(contentView).offset(-10);
    }];
    
    viewModel.cellHeight = viewModel.isSend ? 120 : 100;
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
