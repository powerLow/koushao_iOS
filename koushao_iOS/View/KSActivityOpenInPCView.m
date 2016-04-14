//
//  KSActivityOpenInPCView.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/9.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityOpenInPCView.h"
#import "KSOpenInPCDailog.h"
#import "UIView+Extension.h"
@interface KSActivityOpenInPCView ()

@property (nonatomic, strong) KSOpenInPCDailog *inputView;
/** 蒙板 */
@property (nonatomic, weak) UIButton *cover;
@end

@implementation KSActivityOpenInPCView

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        /** 蒙板 */
        [self setupCover];
    }
    return self;
}
/** 蒙板 */
- (void)setupCover
{
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cover];
    self.cover = cover;
    [self.cover setBackgroundColor:[UIColor blackColor]];
//    self.cover.alpha = 0.5;
    self.cover.frame = self.bounds;
    [self.cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Private
- (void)coverClick {
    [self removeViewFromSuperView];
}

- (void)removeViewFromSuperView
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.inputView.y += 30;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.inputView.y = -_inputView.height;
            self.cover.alpha = 0.01;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

- (void)showWithUrl:(NSString*)url copyBlock:(VoidBlock)copyBlock shareBlock:(VoidBlock)shareBlock
{
    [self showInView:[UIApplication sharedApplication].keyWindow url:url copyBlock:copyBlock shareBlock:shareBlock];
}

- (void)showInView:(UIView *)view url:(NSString*)url copyBlock:(VoidBlock)copyBlock shareBlock:(VoidBlock)shareBlock
{
    [view addSubview:self];
    
    KSOpenInPCDailog *inputView = [[KSOpenInPCDailog alloc] initWithFrame:CGRectMake(self.width * 0.10, -self.width * 0.4, self.width * 0.8, self.width * 0.5) Url:url copyBlock:copyBlock shareBlock:shareBlock];
    [self addSubview:inputView];
    self.inputView = inputView;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = _inputView.bounds;
    [_inputView insertSubview:effectView atIndex:0];
    
    _inputView.layer.cornerRadius = 5;
    _inputView.layer.borderWidth = 0;
    _inputView.layer.borderColor = [[UIColor grayColor] CGColor];
    _inputView.layer.masksToBounds = YES;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.inputView.y = (self.height - self.inputView.height - _keyboardHeight) * 0.5 + 30;
        self.inputView.centerY = self.centerY;
//        self.cover.alpha = 0.01;
        self.cover.alpha = 0.5;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.inputView.y -= 30;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.inputView.y += 10;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.inputView.y -= 5;
                }completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}
@end
