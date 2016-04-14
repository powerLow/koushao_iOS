//
//  CTBottomPoper.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/24.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CTBottomPoper : UIView
@property(nonatomic,assign)CGFloat poperHeight;
@property(nonatomic,assign)BOOL applyBlurEffect;
@property(nonatomic,assign)UIBlurEffectStyle blureffectTheme;
-(void)pop;
-(void)dismiss;
-(id)initWithPoperHeight:(CGFloat)poperHeight;
@end
