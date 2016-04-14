//
//  CTBottomPoper.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/24.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "CTBottomPoper.h"
#import "CTConst.h"
#import "CTPoperBgCover.h"

#define DEFAULT_POPER_HEIGHT 150
#define DEFAULT_BACKGROUND_COLOR [UIColor whiteColor]
@interface CTBottomPoper()
@property(nonatomic,strong)UIBlurEffect* blurEffect;
@property(nonatomic,strong)UIVisualEffectView* effectView;
@end
@implementation CTBottomPoper
-(id)init
{
    if(self=[super init])
    {
        _blurEffect= [UIBlurEffect effectWithStyle:_blureffectTheme];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:_blurEffect];
        _effectView.frame = [UIScreen mainScreen].bounds;
        [self addSubview:_effectView];
        
        _poperHeight=DEFAULT_POPER_HEIGHT;
        self.frame=CGRectMake(0, CT_SCREEN_HEIGHT, CT_SCREEN_WIDTH, _poperHeight);
        self.backgroundColor=DEFAULT_BACKGROUND_COLOR;
    }
    return self;
}
-(void)setPoperHeight:(CGFloat)poperHeight
{
    _poperHeight=poperHeight;
    self.frame=CGRectMake(0, CT_SCREEN_HEIGHT, CT_SCREEN_WIDTH, _poperHeight);
}

-(void)setBlureffectTheme:(UIBlurEffectStyle)blureffectTheme
{
    _blureffectTheme=blureffectTheme;
    _blurEffect= [UIBlurEffect effectWithStyle:_blureffectTheme];
    [_effectView setEffect:_blurEffect];
}

-(id)initWithPoperHeight:(CGFloat)poperHeight
{
    if(self=[super init])
    {
        _blurEffect= [UIBlurEffect effectWithStyle:_blureffectTheme];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:_blurEffect];
        _effectView.frame = [UIScreen mainScreen].bounds;
        [self addSubview:_effectView];
        
        _poperHeight=poperHeight;
        self.frame=CGRectMake(0, CT_SCREEN_HEIGHT, CT_SCREEN_WIDTH, _poperHeight);
        self.backgroundColor=DEFAULT_BACKGROUND_COLOR;
    }
    return self;
}

-(void)setApplyBlurEffect:(BOOL)applyBlurEffect
{
    if(applyBlurEffect)
    {
        _effectView.hidden=NO;
        self.backgroundColor=[UIColor clearColor];
    }
    else
    {
        _effectView.hidden=YES;
        self.backgroundColor=DEFAULT_BACKGROUND_COLOR;
    }
}

-(void)pop
{
    UIWindow* window=[[UIApplication sharedApplication].delegate window];
    [window addSubview:[CTPoperBgCover share]];
    [window addSubview:self];
    [[CTPoperBgCover share].CTPoperArray addObject:self];
    
    __weak CTBottomPoper* safeSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        safeSelf.frame = CGRectMake(0, CT_SCREEN_HEIGHT -  safeSelf.frame.size.height, safeSelf.frame.size.width, safeSelf.frame.size.height);
        [CTPoperBgCover share].frame=CGRectMake(0,0,CT_SCREEN_WIDTH,CT_SCREEN_HEIGHT-safeSelf.frame.size.height);
        [CTPoperBgCover share].alpha = 0.3;
    }];
}
-(void)dismiss
{
    __weak CTBottomPoper* safeSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        safeSelf.frame = CGRectMake(0, CT_SCREEN_HEIGHT, safeSelf.frame.size.width, safeSelf.frame.size.height);
        [CTPoperBgCover share].frame=[UIScreen mainScreen].bounds;
        [CTPoperBgCover share].alpha = 0;
        
    } completion:^(BOOL finished) {
        [safeSelf removeFromSuperview];
        [[CTPoperBgCover share] removeFromSuperview];
        [[CTPoperBgCover share].CTPoperArray removeObject:safeSelf];
    }];
}
@end
