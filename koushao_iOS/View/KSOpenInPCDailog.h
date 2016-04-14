//
//  KSOpenInPCDailog.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/9.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSOpenInPCDailog : UIView

- (instancetype)initWithFrame:(CGRect)frame Url:(NSString*)url copyBlock:(VoidBlock)copyBlock shareBlock:(VoidBlock)shareBlock;;

@end
