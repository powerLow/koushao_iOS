//
//  KSMyDataTableViewCell.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/15.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMyDataTableViewCell.h"
#import "KSMyDataViewModel.h"
@interface KSMyDataTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *unitLabel;
@end
@implementation KSMyDataTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma -KSReactiveView

- (void)bindViewModel:(KSMyDataViewModel *)viewModel {
    self.titleLabel.text = viewModel.labelTitle;
    self.countLabel.textAlignment = NSTextAlignmentRight;
    self.countLabel.textColor = BASE_COLOR;
    self.countLabel.text = [NSString stringWithFormat:@"%@",viewModel.count];
    self.unitLabel.text = viewModel.unit;
}
@end
