//
//  KSEnrollRecordViewCell.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSEnrollRecordViewCell.h"
#import "Masonry.h"
#import "KSEnrollRecordItemViewModel.h"
@implementation KSEnrollRecordViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) bindViewModel:(KSEnrollRecordItemViewModel*)viewModel{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    //NSLog(@"bindViewModel = %@",viewModel);
    UILabel *nickname = [UILabel new];
    nickname.text  = viewModel.item.nickname;
    [self.contentView addSubview:nickname];
    
    
    @weakify(self)
    [nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    
    NSDate* signTime = [NSDate dateWithTimeIntervalSince1970:[viewModel.item.time unsignedIntegerValue]];
    NSDateFormatter *ft = [NSDateFormatter new];
    ft.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *strsignTime = [ft stringFromDate:signTime];
    UILabel *timeLabel = [UILabel new];
    
    if ([viewModel isEnroll]) {
        timeLabel.text = [NSString stringWithFormat:@"报名时间: %@",strsignTime];
    }else{
        timeLabel.text = [NSString stringWithFormat:@"购票时间: %@",strsignTime];
    }
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = HexRGB(0x969696);
    timeLabel.font = KS_SMALL_FONT;
    [self.contentView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickname);
        make.top.equalTo(nickname.mas_bottom).offset(5);
    }];
    
//    UILabel *signLabel = [UILabel new];
//    if ([viewModel isEnroll]) {
//        signLabel.text = [NSString stringWithFormat:@"签到状态: %@",
//                          [viewModel.item.signin isEqualToNumber:@0] ? @"未签到": @"已签到" ];
//    }else{
//        signLabel.text = [NSString stringWithFormat:@"使用状态: %@",
//                          [viewModel.item.signin isEqualToNumber:@0] ? @"未使用": @"已使用" ];
//    }
//    
//    
//    signLabel.textAlignment = NSTextAlignmentLeft;
//    signLabel.textColor = HexRGB(0x969696);
//    signLabel.font = [UIFont fontWithName:@"Arial" size:14];
//    
//    [self.contentView addSubview:signLabel];
//    
//    [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(nickname);
//        make.top.equalTo(timeLabel.mas_bottom).offset(5);
//    }];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
