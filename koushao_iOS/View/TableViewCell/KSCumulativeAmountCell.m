//
//  KSCumulativeAmountCell.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/7.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSCumulativeAmountCell.h"
#import "KSCumulativeAmountItemViewModel.h"
#import "Masonry.h"
@implementation KSCumulativeAmountCell
- (void)bindViewModel:(KSCumulativeAmountItemViewModel *)viewModel {
    if (viewModel != nil) {
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        UILabel *name_label = [UILabel new];
        name_label.text = viewModel.itemModel.title;
        name_label.textColor = [UIColor blackColor];
        [self.contentView addSubview:name_label];
        
        NSDate* signTime = [NSDate dateWithTimeIntervalSince1970:[viewModel.itemModel.time unsignedIntegerValue]];
        NSDateFormatter *ft = [NSDateFormatter new];
        ft.dateFormat = @"yyyy-MM-dd";
        NSString *strsignTime = [ft stringFromDate:signTime];
        
        UILabel *time_label = [UILabel new];
        time_label.text = strsignTime;
        time_label.textColor = KS_GrayColor4;
        [self.contentView addSubview:time_label];
        
        UILabel *count_label = [UILabel new];
        count_label.text = [NSString stringWithFormat:@"%@",viewModel.itemModel.money];
        count_label.textColor = BASE_COLOR;
        [self.contentView addSubview:count_label];
        
        UILabel *unit_label = [UILabel new];
        unit_label.text = @"元";
        unit_label.textColor = [UIColor blackColor];
        [self.contentView addSubview:unit_label];
        
        @weakify(self)
        [name_label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(10);
        }];
        
        [time_label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.left.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        [count_label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.right.equalTo(unit_label.mas_left).offset(-2);
            make.centerY.equalTo(self.contentView);
        }];
        
        [unit_label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.right.equalTo(self.contentView).offset(-5);
            make.centerY.equalTo(self.contentView);
        }];
        
        viewModel.cellHeight = 70;
    }
}
@end
