//
//  KSOpenInPCDailog.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/9.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSOpenInPCDailog.h"
#import "Masonry.h"
@interface KSOpenInPCDailog()

@property (nonatomic,copy) NSString* url;

@end

@implementation KSOpenInPCDailog

- (instancetype)initWithFrame:(CGRect)frame Url:(NSString*)url copyBlock:(VoidBlock)copyBlock shareBlock:(VoidBlock)shareBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.url = [url copy];
        [self setupViewWithcopyBlock:copyBlock shareBlock:shareBlock];
    }
    return self;
}

- (void)setupViewWithcopyBlock:(VoidBlock)copyBlock shareBlock:(VoidBlock)shareBlock; {
    UILabel *label = [UILabel new];
    label.text = @"签到链接";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = KS_NORMAL_FONT;
    [self addSubview:label];
    @weakify(self)
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.top.equalTo(self).offset(15);
    }];
    
    UILabel *link_label = [UILabel new];
    link_label.text  = self.url;
    link_label.font = KS_SMALL_FONT;
    link_label.textColor = KS_GrayColor3;
    [self addSubview:link_label];
    
    [link_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label);
        make.top.equalTo(label.mas_bottom).offset(20);
    }];
    
    UILabel *tip_label = [UILabel new];
    tip_label.text = @"请在电脑浏览器中打开";
    tip_label.textColor = [UIColor redColor];
    tip_label.font = KS_SMALL_FONT;
    [self addSubview:tip_label];
    
    [tip_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label);
        make.top.equalTo(link_label.mas_bottom).offset(5);
    }];
    
    //复制按钮
    UIButton *copy_btn = [UIButton new];
    [self addSubview:copy_btn];
    [copy_btn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    [copy_btn setTitle:@"复制" forState:UIControlStateNormal];
    //分享按钮
    UIButton *share_btn = [UIButton new];
    [self addSubview:share_btn];
    [share_btn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
    [share_btn setTitle:@"分享" forState:UIControlStateNormal];
    
    [copy_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-SCREEN_WIDTH * 0.05);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    [share_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(copy_btn);
        make.height.width.equalTo(copy_btn);
        make.right.equalTo(self).offset(-SCREEN_WIDTH * 0.05);
        make.left.equalTo(copy_btn.mas_right).offset(SCREEN_WIDTH * 0.1);
    }];
    
    
    [[copy_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        copyBlock();
    }];
    
    
    [[share_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        shareBlock();
    }];
    
}
@end
