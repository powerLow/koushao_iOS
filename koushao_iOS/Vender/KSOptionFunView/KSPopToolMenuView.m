//
//  KSPopToolMenuView.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSPopToolMenuView.h"
#import "KSPopToolMenuButtonView.h"

#define kFunButtonWidth 22
#define kFunButtonHeight 30

@interface KSPopToolMenuView ()<KSPopToolMenuButtonViewDataSource, KSPopToolMenuButtonViewDelegate>

@property (nonatomic, strong) KSPopToolMenuButtonView *buttonView;

@property (nonatomic, strong) UIButton *showButton;

@end

@implementation KSPopToolMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.buttonView = [[KSPopToolMenuButtonView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - kFunButtonWidth, frame.size.height)];
        
        self.buttonView.delegate = self;
        self.buttonView.dataSource = self;
        self.isButtonShow = NO;
        [self addSubview:_buttonView];
        
        UIButton *showButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - kFunButtonWidth, 0, kFunButtonWidth, kFunButtonHeight)];
        [showButton setImage:[UIImage imageNamed:@"icon_question_more"] forState:UIControlStateNormal];
        [showButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [showButton addTarget:self action:@selector(showButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showButton];
        self.showButton = showButton;
        
    }
    
    return self;
}

- (void)setButtonFont:(UIFont *)buttonFont
{
    _buttonFont = buttonFont;
    
    self.buttonView.titleFont = buttonFont;
    
}

- (void)showButtonClick
{
    if (_isButtonShow) {
        [self hidenButtons];
    } else {
        [self showButtons];
    }
    self.isButtonShow = !_isButtonShow;
}

- (NSInteger)numberOfTabs
{
    return _funTitles.count;
}

- (NSString *)KSPopToolMenuButtonView:(KSPopToolMenuButtonView *)OptionFunButtonView titlesForTabIndex:(NSInteger)index
{
    return [_funTitles objectAtIndex:index];
}
- (UIImage *)KSPopToolMenuButtonView:(KSPopToolMenuButtonView *)OptionFunButtonView imageForTabIndex:(NSInteger)index
{
    return [_funImages objectAtIndex:index];
}

- (void)OptionFunButtonView:(KSPopToolMenuButtonView *)OptionFunButtonView didSelectIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(KSPopToolMenuView:didSelectButtonAtIndex:)]) {
        [self.delegate KSPopToolMenuView:self didSelectButtonAtIndex:index];
    }
    
    [self showButtonClick];
    
}

- (void)showButtons
{
    [self.buttonView show];
    
}

- (void)hidenButtons
{
    [self.buttonView hiden];
}

@end
