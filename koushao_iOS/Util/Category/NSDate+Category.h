//
//  NSDate+Category.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)
+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2;
- (NSString *)prettyDateWithReference:(NSDate *)reference;


@end
