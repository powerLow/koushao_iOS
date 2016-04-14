//
//  KSCodeView.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSInputViewDelegate <NSObject>

@optional
/** 输入完成 */
- (void)finish:(NSString *)code;

@end

@interface KSCodeView : UIView

@property (nonatomic, weak) UITextField *responsder;

@property (nonatomic, weak) id<KSInputViewDelegate> delegate;

- (void)clear;
@end
