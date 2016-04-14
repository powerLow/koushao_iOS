//
//  KSFieldView.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSFieldView : UIView

- (void)drawRect:(CGRect)rect string:(NSArray*)string;

- (instancetype)initWithFrame:(CGRect)frame fieldNum:(NSNumber*)fieldNum;

@end
