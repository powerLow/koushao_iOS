//
//  KSWelfareAnalyseModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/27.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
{
    "result": {
        "total_statistics": {
            "nodraw": 3,
            "total": 6,
            "detail": {
                "hasget": 2,
                "noget": 1
            },
            "hasdraw": 3
        },
        "detail_statistics": [
        {
            "name": "一等奖",
            "detail": {
                "hasget": 1,
                "noget": 1
            },
            "nodraw": 0,
            "hasdraw": 2,
            "total": 2,
            "type": 1
        },
                        ]
    },
    "error": {
        "errorno": 0,
        "msg": "成功"
    }
}
*/
@interface KSWelfareStatisticsDetail : NSObject

@property (nonatomic,strong,readonly) NSNumber *hasget;
@property (nonatomic,strong,readonly) NSNumber *noget;
@end

@interface KSWelfareTotalStatistics : NSObject
@property (nonatomic,strong,readonly) NSNumber *nodraw;
@property (nonatomic,strong,readonly) NSNumber *total;
@property (nonatomic,strong,readonly) NSNumber *hasdraw;
@property (nonatomic,strong,readonly) KSWelfareStatisticsDetail *detail;
@end

@interface KSWelfareAnalyseModel : NSObject
@property(nonatomic,strong,readonly) KSWelfareTotalStatistics *total_statistics;
@property (nonatomic,strong,readonly) NSArray *detail_statistics;
@end



@interface KSWelfareDetailStatistics : NSObject
@property (nonatomic,strong,readonly) NSNumber *nodraw;
@property (nonatomic,strong,readonly) NSNumber *total;
@property (nonatomic,strong,readonly) NSNumber *hasdraw;
@property (nonatomic,strong,readonly) NSNumber *type;
@property (nonatomic,copy,readonly) NSString *name;
@property (nonatomic,strong,readonly) KSWelfareStatisticsDetail *detail;
@end
