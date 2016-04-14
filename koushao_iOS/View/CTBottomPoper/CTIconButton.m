//
//  CTIconButton.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/25.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "CTIconButton.h"
#define DEFAULT_ICON_SIZE CGSizeMake(40, 40)
#define DEFAULT_LABEL_COLOR [UIColor grayColor]
#define DEFAUlT_ICON_MARGIN_TOP 16.0f
#define DEFAUlT_LABEL_MARGIN_TOP 4.0f
#define DEFAUlT_LABEL_TEXTSIZE 10.0f

@interface CTIconButton()
@property(nonatomic,strong)UIImageView* buttonIcon;
@property(nonatomic,strong)UILabel* buttonLabel;
@end
@implementation CTIconButton
-(id)initWithButtonModel:(CTIconButtonModel *)buttonModel
{
    if(self=[super init])
    {
        _buttonIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:buttonModel.buttonIcon]];
        _buttonIcon.contentMode=UIViewContentModeScaleAspectFit;
        _buttonIcon.translatesAutoresizingMaskIntoConstraints=NO;
        [self addSubview:_buttonIcon];
        [self activeIconLayoutConstraint];
        
        _buttonLabel=[[UILabel alloc]init];
        _buttonLabel.translatesAutoresizingMaskIntoConstraints=NO;
        _buttonLabel.textColor=DEFAULT_LABEL_COLOR;
        _buttonLabel.font=[UIFont systemFontOfSize:DEFAUlT_LABEL_TEXTSIZE];
        _buttonLabel.textAlignment=NSTextAlignmentCenter;
        _buttonLabel.text=buttonModel.buttonText;

        [self addSubview:_buttonLabel];
        [self activeLabelLayoutConstraint];
    }
    return self;
}
-(void)activeIconLayoutConstraint
{
    NSLayoutConstraint* centerXConstraint = [NSLayoutConstraint constraintWithItem:_buttonIcon attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:_buttonIcon attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
    
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:_buttonIcon attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:DEFAULT_ICON_SIZE.height];
    
    NSLayoutConstraint* widthConstraint = [NSLayoutConstraint constraintWithItem:_buttonIcon attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:DEFAULT_ICON_SIZE.width];
    
    widthConstraint.active = YES;
    centerXConstraint.active = YES;
    topConstraint.active = YES;
    heightConstraint.active = YES;
}

-(void)activeLabelLayoutConstraint
{
    NSLayoutConstraint* centerXConstraint = [NSLayoutConstraint constraintWithItem:_buttonLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:_buttonLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_buttonIcon attribute:NSLayoutAttributeBottom multiplier:1.0f constant:DEFAUlT_LABEL_MARGIN_TOP];
    
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:_buttonLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:DEFAUlT_LABEL_TEXTSIZE];
    
    NSLayoutConstraint* widthConstraint = [NSLayoutConstraint constraintWithItem:_buttonLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    
    widthConstraint.active = YES;
    centerXConstraint.active = YES;
    topConstraint.active = YES;
    heightConstraint.active = YES;
}
@end
