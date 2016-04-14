//
//  KSWelfareVerifyLogsApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBaseApiRequest.h"
// 0全部,1非验证发放,2验证发放,3实物寄送
typedef enum : NSUInteger {
    KSWelfareVerifyLogsRecordTypeAll,
    KSWelfareVerifyLogsRecordTypeQuan1,
    KSWelfareVerifyLogsRecordTypeQuan2,
    KSWelfareVerifyLogsRecordTypeShiwu,
    KSWelfareVerifyLogsRecordTypeAllQuan,
} KSWelfareVerifyLogsRecordType;

@interface KSWelfareVerifyLogsApi : KSBaseApiRequest
- (instancetype)initWithWid:(NSNumber*)wid
               refresh_type:(KSRequestRefreshType)type
                 record_type:(KSWelfareVerifyLogsRecordType)record_type
                      limit:(NSNumber*)limit;

@end
