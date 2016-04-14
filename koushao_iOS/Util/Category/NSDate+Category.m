//
//  NSDate+Category.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

+ (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

- (NSString *)prettyDateWithReference:(NSDate *)reference {
    NSString *suffix = @"后";
    
    float different = [reference timeIntervalSinceDate:self];
    if (different < 0) {
        different = -different;
        suffix = @"前";
    }
    
    // days = different / (24 * 60 * 60), take the floor value
    float dayDifferent = floor(different / 86400);
    
    int days   = (int)dayDifferent;
    int weeks  = (int)ceil(dayDifferent / 7);
    int months = (int)ceil(dayDifferent / 30);
    int years  = (int)ceil(dayDifferent / 365);
    
    // It belongs to today
    if (dayDifferent <= 0) {
        // lower than 60 seconds
        if (different < 60) {
            return @"刚刚";
        }
        
        // lower than 120 seconds => one minute and lower than 60 seconds
//        if (different < 120) {
//            return [NSString stringWithFormat:@"1 分钟%@", suffix];
//        }
        
        // lower than 60 minutes
        if (different < 60 * 60) {
            return [NSString stringWithFormat:@"%d 分钟%@", (int)floor(different / 60), suffix];
        }
        
        // lower than 60 * 2 minutes => one hour and lower than 60 minutes
//        if (different < 7200) {
//            return [NSString stringWithFormat:@"1 小时%@", suffix];
//        }
        
        // lower than one day
        if (different < 86400) {
            return [NSString stringWithFormat:@"%d 小时%@", (int)floor(different / 3600), suffix];
        }
    }
    // lower than one week
    else if (days < 7) {
        return [NSString stringWithFormat:@"%d 天%@", days,suffix];
    }
    // lager than one week but lower than a month
    else if (weeks < 4) {
        return [NSString stringWithFormat:@"%d 星期%@", weeks,suffix];
    }
    // lager than a month and lower than a year
    else if (months < 12) {
        return [NSString stringWithFormat:@"%d 月%@", months,suffix];
    }
    // lager than a year
    else {  
        return [NSString stringWithFormat:@"%d 年%@", years,suffix];
    }  
    
    return self.description;  
}


@end
