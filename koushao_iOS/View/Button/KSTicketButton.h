//
//  KSTicketButton.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSTicketButton : UIButton
typedef NS_ENUM(NSInteger, KSTicketButtonStyle) {
    KSTicketButtonStyleAdd,
    KSTicketButtonStyleGreen,
    KSTicketButtonStyleRed,
};
@property(nonatomic,assign) KSTicketButtonStyle buttonStyle;
@property(nonatomic,copy)NSString* titleText;
@property(nonatomic,copy)NSString* subtitleText;
@property(nonatomic,copy)NSString* bottomLeftText;
@property(nonatomic,copy) void (^deleteButtonPressed)();
-(void)hideDeleButton;
-(void)setTicketIconImage:(UIImage*)image;
@end
