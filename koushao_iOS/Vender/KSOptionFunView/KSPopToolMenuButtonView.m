//
//  KSPopToolMenuButtonView.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSPopToolMenuButtonView.h"

@interface KSPopToolMenuButtonView ()

@property (nonatomic, assign) CGRect initFrame;

@property (nonatomic, strong) UIButton *showButton;

@end

@implementation KSPopToolMenuButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        
        self.initFrame = frame;
        self.frame = CGRectMake(frame.origin.x + frame.size.width, frame.origin.y, 0, frame.size.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
        
    }
    
    return self;
}

- (void)funcSelect:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(OptionFunButtonView:didSelectIndex:)]) {
        [self.delegate OptionFunButtonView:self didSelectIndex:button.tag];
    }
}

- (void)reloadData
{
    for (UIButton *button in self.subviews) {
        [button removeFromSuperview];
    }
    
    [self setupButtons];
    
}

- (void)show
{
    [self reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = self.initFrame;
        
    }];
}

- (void)hiden
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect tempF = self.initFrame;
        
        tempF.origin.x = CGRectGetMaxX(self.frame);
        tempF.size.width = 0;
        
        self.frame = tempF;
        
    }];
}

- (void)setupButtons
{
    NSInteger buttonNumbers = [self.dataSource numberOfTabs];
    
    CGFloat buttonWidth = self.initFrame.size.width / (buttonNumbers * 2);
    CGFloat imageWidth = self.initFrame.size.height / 2;
    for (NSInteger index = 0; index < buttonNumbers; index ++) {
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(buttonWidth * (index * 2) + buttonWidth / 2, imageWidth / 2, imageWidth , imageWidth);
        imageView.image = [self.dataSource KSPopToolMenuButtonView:self imageForTabIndex:index];
        [self addSubview:imageView];
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = index;
        button.frame = CGRectMake(buttonWidth * (index * 2 + 1), 0, buttonWidth, self.initFrame.size.height);
        [button.titleLabel setFont:_titleFont];
        [button addTarget:self action:@selector(funcSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *buttonTitle = [self.dataSource KSPopToolMenuButtonView:self titlesForTabIndex:index];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        
        [self addSubview:button];
        
        UIView *separatorV = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth * (index * 2 +2) + 5 , 4, 0.5, self.initFrame.size.height - 8)];
        separatorV.backgroundColor = [UIColor whiteColor];
        [self addSubview:separatorV];
        
    }
    
}



@end
