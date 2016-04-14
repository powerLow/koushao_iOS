//
//  KSExpressSectionHeaderView.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/8.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSExpressSectionHeaderView.h"
#import "Masonry.h"
@implementation KSExpressSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.headerLabel = [UILabel new];
    [self.contentView addSubview:self.headerLabel];
    @weakify(self)
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
    }];
}
@end
