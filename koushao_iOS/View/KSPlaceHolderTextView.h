//
//  KSPlaceHolderTextView.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSPlaceHolderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)setFrameOfPlaceHolderLabel:(CGRect)frame;

-(void)textChanged:(NSNotification*)notification;

@end
