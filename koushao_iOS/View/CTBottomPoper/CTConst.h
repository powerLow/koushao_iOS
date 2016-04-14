//
//  CTConst.h
//  koushao_iOS
//
//  Created by 陈奇 on 15/12/24.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_IOS_7 ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)?YES:NO
#define CT_SCREEN_HEIGHT ((IS_IOS_7)?([UIScreen mainScreen].bounds.size.height):([UIScreen mainScreen].bounds.size.height - 20))
#define CT_SCREEN_WIDTH (int)[UIScreen mainScreen].bounds.size.width
@interface CTConst : NSObject

@end
