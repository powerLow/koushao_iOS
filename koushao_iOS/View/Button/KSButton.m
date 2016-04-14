//
//  KSButton.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSButton.h"

@implementation KSButton

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
- (id)initWithColor:(UIColor*)color {
    self = [super init];
    if (self) {
        self.buttonColor = color;
        [self initialize];
    }
    return self;
}
- (UIColor *)titleColorForState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
        case UIControlStateHighlighted:
        case UIControlStateSelected:
        case UIControlStateApplication:
        case UIControlStateReserved:
            return HexRGB(0xffffff);
        case UIControlStateDisabled:
            //return HexRGB(0xCFCFCF);
            return HexRGB(0xffffff);
        default:
            break;
    }
    return nil;
}
-(void)setButtonColor:(UIColor *)buttonColor
{
    _buttonColor=buttonColor;
    [self setBackgroundImage:_buttonColor.color2Image forState:UIControlStateNormal];
    [self setBackgroundImage:_buttonColor.color2Image forState:UIControlStateReserved];
}
- (UIImage *)backgroundImageForState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            if(!_buttonColor)
                return BASE_COLOR.color2Image;
            else return _buttonColor.color2Image;
        case UIControlStateHighlighted:
        case UIControlStateSelected:
        case UIControlStateApplication:
        case UIControlStateReserved:
            if(!_buttonColor)
                return BASE_COLOR.color2Image;
            else return _buttonColor.color2Image;
        case UIControlStateDisabled:
            //return HexRGB(0x6D7E87).color2Image;
            return HexRGB(0xcccccc).color2Image;
        default:
            break;
    }
    return nil;
}

- (void)initialize {
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    
    [self setBackgroundImage:[self backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self setBackgroundImage:[self backgroundImageForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [self setBackgroundImage:[self backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    
    [self setTitleColor:[self titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self setTitleColor:[self titleColorForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [self setTitleColor:[self titleColorForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
}


@end
