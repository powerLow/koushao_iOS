//
//  InsetsUILabel.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsUILabel : UILabel
@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;
@end
