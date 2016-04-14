//
//  UITextField+maxLength.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/9.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (maxLength)
- (void)setMaxTextLength:(int)length;
- (void)setMinNumberValue:(int)minNumberValue;
- (void)setMaxNumberValue:(int)maxNumberValue;
-(void)setDemcialDigit:(int)digit;


- (void)shake;
@end
