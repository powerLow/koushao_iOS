//
// Created by 廖哲琦 on 15/11/29.
// Copyright (c) 2015 kuaicuhmen. All rights reserved.
//

#import "KSWelfareStatisticsCell.h"
#import "KSWelfareStatisticsItemViewModel.h"
#import "Masonry.h"

@implementation KSWelfareStatisticsCell {

}

- (void)bindViewModel:(KSWelfareStatisticsItemViewModel *)viewModel {
    if (viewModel != nil) {
        
        self.contentView.backgroundColor = viewModel.bkcolr;
        
        UILabel *title_label = [UILabel new];
        title_label.font = viewModel.font;
        title_label.text = viewModel.text;
        [self.contentView addSubview:title_label];

        UILabel *count_label = [UILabel new];
        count_label.font = viewModel.font;
        count_label.text = [NSString stringWithFormat:@"%@", viewModel.count];
        count_label.textColor = BASE_COLOR;
        [self.contentView addSubview:count_label];

        UILabel *unit_label = [UILabel new];
        unit_label.font = viewModel.font;
        unit_label.text = @"份";
        [self.contentView addSubview:unit_label];
        
        
        @weakify(self)
        [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10 + [viewModel.left_offset unsignedIntegerValue]);
        }];

        [count_label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(unit_label.mas_left).offset(-5);
        }];

        [unit_label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.right.equalTo(self.contentView).mas_offset(-10);
            make.centerY.equalTo(self.contentView);
        }];
        if (viewModel.line) {
            UIView *sp = [UIView new];
            [self.contentView addSubview:sp];
            sp.backgroundColor = KS_GrayColor0;
            [sp mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self)
                make.left.right.equalTo(self.contentView);
                make.height.equalTo(@1);
                make.bottom.equalTo(self.contentView);
            }];
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

@end