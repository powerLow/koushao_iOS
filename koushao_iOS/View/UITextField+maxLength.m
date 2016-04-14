//
//  UITextField+maxLength.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/9.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "UITextField+maxLength.h"
#define NUMBERS @"0123456789"
#define DECIMAL @"0123456789."

@implementation UITextField (maxLength)
static NSString *kLimitTextLengthKey = @"kLimitTextLengthKey";
static NSString *kLimitMaxNumberValueKey = @"kLimitMaxNumberValueKey";
static NSString *kLimitMinNumberValueKey = @"kLimitMinNumberValueKey";
static NSString *kLimitDemcialDigitKey = @"kLimitDemcialDigitKey";
- (void)setMaxTextLength:(int)length
{
    objc_setAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey), [NSNumber numberWithInt:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addTarget:self action:@selector(textFieldTextLimit:) forControlEvents:UIControlEventEditingChanged];
}
- (void)setMaxNumberValue:(int)maxNumberValue
{
    objc_setAssociatedObject(self, (__bridge const void *)(kLimitMaxNumberValueKey), [NSNumber numberWithInt:maxNumberValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addTarget:self action:@selector(textFieldTextLimit:) forControlEvents:UIControlEventEditingChanged];
}
- (void)setMinNumberValue:(int)minNumberValue
{
    objc_setAssociatedObject(self, (__bridge const void *)(kLimitMinNumberValueKey), [NSNumber numberWithInt:minNumberValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addTarget:self action:@selector(textFieldTextLimit:) forControlEvents:UIControlEventEditingChanged];
}
-(void)setDemcialDigit:(int)digit
{
    objc_setAssociatedObject(self, (__bridge const void *)(kLimitDemcialDigitKey), [NSNumber numberWithInt:digit], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addTarget:self action:@selector(textFieldTextLimit:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldTextLimit:(id)sender
{
    NSNumber *lengthNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey));
    int length = [lengthNumber intValue];
    bool isChinese;
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    if ([current.primaryLanguage isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    if(sender == self) {
        NSString *str = [[self text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
        if (isChinese) {
            UITextRange *selectedRange = [self markedTextRange];
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                if ( str.length>=length) {
                    NSString *strNew = [NSString stringWithString:str];
                    [self setText:[strNew substringToIndex:length]];
                }
            }
            else
            {
                
            }
        }else{
            if ([str length]>=length) {
                NSString *strNew = [NSString stringWithString:str];
                [self setText:[strNew substringToIndex:length]];
            }
        }
        if(self.keyboardType==UIKeyboardTypeNumberPad||self.keyboardType==UIKeyboardTypeDecimalPad)
        {
            NSNumber *maxNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitMaxNumberValueKey));
            NSNumber *minNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitMinNumberValueKey));
            NSNumber *demcialDigitNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitDemcialDigitKey));
            
            
            NSCharacterSet*cs;
            cs = [[NSCharacterSet characterSetWithCharactersInString:self.keyboardType==UIKeyboardTypeNumberPad?NUMBERS:DECIMAL] invertedSet];
            NSString*filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL basicTest = [str isEqualToString:filtered];
            if(!basicTest) {
                [self setText:filtered];
            }
            
            if(str.length!=0)
            {
                float currentValue=[str floatValue];
                if(maxNumber)
                {
                    if(currentValue>[maxNumber floatValue])
                    {
                        [self setText:[NSString stringWithFormat:@"%i",[maxNumber intValue]]];
                    }
                }
                if(minNumber)
                {
                    if(currentValue<[minNumber floatValue])
                    {
                        [self setText:[NSString stringWithFormat:@"%i",[minNumber intValue]]];
                    }
                }
                if(demcialDigitNumber)
                {
                    NSInteger flag=0;
                    
                    for (int i = (int)(str.length-1); i>=0; i--) {
                        
                        if ([str characterAtIndex:i] == '.') {
                            if (flag > [demcialDigitNumber integerValue]) {
                                NSString * newString = [str substringWithRange:NSMakeRange(0, [str length] - 1)];
                                [self setText:newString];
                                break;
                            }
                        }
                        flag++;
                    }
                }
                
            }
        }
    }
}

- (void)shake
{
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.5f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x-5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x+5, self.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)],
                      nil];
    [keyAn setValues:array];
    
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn setKeyTimes:times];
    [self.layer addAnimation:keyAn forKey:@"TextAnim"];
}
@end
