//
//  KSWithDrawCell.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSWithDrawCell.h"
#import "KSWithdrawMoneyItemViewModel.h"
#import "Masonry.h"
@implementation KSWithDrawCell

- (void)bindViewModel:(KSWithdrawMoneyItemViewModel *)viewModel {
    if (viewModel != nil) {
        for (UIView *view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
//        self.contentView.backgroundColor = KS_GrayColor_BackColor;
        UILabel *account_label = [UILabel new];
        [self.contentView addSubview:account_label];
        account_label.text = [NSString stringWithFormat:@"收款账号-%@",viewModel.itemModel.receiver];
        account_label.textColor = [UIColor blackColor];
        account_label.font = KS_FONT_16;
        
        NSDate* signTime = [NSDate dateWithTimeIntervalSince1970:[viewModel.itemModel.time unsignedIntegerValue]];
        NSDateFormatter *ft = [NSDateFormatter new];
        ft.dateFormat = @"yyyy-MM-dd";
        NSString *strsignTime = [ft stringFromDate:signTime];
        
        UILabel *time_label = [UILabel new];
        time_label.text = strsignTime;
        time_label.textColor = KS_GrayColor4;
        time_label.font = KS_SMALL_FONT;
        [self.contentView addSubview:time_label];
        
        UILabel *count_label = [UILabel new];
        count_label.text = [NSString stringWithFormat:@"%@",viewModel.itemModel.money];
        count_label.textColor = BASE_COLOR;
        [self.contentView addSubview:count_label];
        
        UILabel *unit_label = [UILabel new];
        unit_label.text = @"元";
        unit_label.textColor = [UIColor blackColor];
        [self.contentView addSubview:unit_label];
        
        
        NSArray *titles = @[@"正在审核",@"提现成功",@"审核失败"];
        NSArray *colors = @[[UIColor redColor],BASE_COLOR,[UIColor orangeColor]];
        UILabel *states_label = [UILabel new];
        NSUInteger index = [viewModel.itemModel.status unsignedIntegerValue];
        states_label.text = titles[index];
        states_label.textColor = colors[index];
        states_label.font = KS_SMALL_FONT;
        [self.contentView addSubview:states_label];
        
        @weakify(self)
        [account_label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(15);
        }];
        
        [time_label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.left.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        [count_label mas_makeConstraints:^(MASConstraintMaker *make) {
//            @strongify(self)
            make.right.equalTo(unit_label.mas_left).offset(-2);
            make.top.equalTo(account_label);
        }];
        
        [unit_label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.right.equalTo(self.contentView).offset(-5);
            make.top.equalTo(account_label);
        }];
        
        [states_label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.right.equalTo(self.contentView).offset(-5);
            make.bottom.equalTo(time_label);
        }];
        viewModel.cellHeight = 75;
        
    }
}
@end
