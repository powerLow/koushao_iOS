//
//  KSMyMoneyInfoTableViewCell.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/22.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMyMoneyInfoTableViewCell.h"
#import "KSMyMoneyInfoViewModel.h"
#import "Masonry.h"

@interface KSMyMoneyInfoTableViewCell ()
//@property (strong, nonatomic)  UILabel *titleLabel;
//@property (strong, nonatomic)  UILabel *countLabel;
//@property (strong, nonatomic)  UILabel *unitLabel;

@end

@implementation KSMyMoneyInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(KSMyMoneyInfoViewModel *)viewModel {
//    self.titleLabel.text = viewModel.labelTitle;
//    self.countLabel.textAlignment = NSTextAlignmentRight;
//    self.countLabel.textColor = BASE_COLOR;
//    self.countLabel.text = [NSString stringWithFormat:@"%@",viewModel.count];
//    self.unitLabel.text = viewModel.unit;
    
    for (UIView* view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    UILabel *title_label = [UILabel new];
    title_label.text = viewModel.labelTitle;
    [self.contentView addSubview:title_label];
    
    UILabel *count_label = [UILabel new];
    count_label.textAlignment = NSTextAlignmentRight;
    count_label.textColor = BASE_COLOR;
    count_label.text = [NSString stringWithFormat:@"%.2f",[viewModel.count floatValue]];
    [self.contentView addSubview:count_label];
    
    UILabel *unit_label = [UILabel new];
    unit_label.text = viewModel.unit;
    [self.contentView addSubview:unit_label];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.image = [UIImage imageNamed:@"ic_arrow"];
    [self.contentView addSubview:arrow];
    
    [arrow setHidden:!viewModel.has_arrow];
    
    @weakify(self)
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    
    [count_label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(unit_label.mas_left).offset(-2);
    }];
    
    [unit_label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(arrow.mas_left).offset(-8);
    }];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-5);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(10);
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
