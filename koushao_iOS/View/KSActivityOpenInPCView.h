//
//  KSActivityOpenInPCView.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/9.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSActivityOpenInPCView : UIView

/** 弹出 */
- (void)showWithUrl:(NSString*)url copyBlock:(VoidBlock)copyBlock shareBlock:(VoidBlock)shareBlock;
- (void)showInView:(UIView *)view url:(NSString*)url copyBlock:(VoidBlock)copyBlock shareBlock:(VoidBlock)shareBlock;

- (void)removeViewFromSuperView;

@end
