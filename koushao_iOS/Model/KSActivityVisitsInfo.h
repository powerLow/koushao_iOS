//
//  KSActivityVisitsInfo.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/2.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DB_ID_VISITSINFO @"db_visitsInfo"

@interface KSActivityVisitsInfo : NSObject<KSPersistenceProtocol>


@property (nonatomic, strong, readonly) NSNumber *interested;       //感兴趣人数
@property (nonatomic, strong, readonly) NSNumber *visits;           //浏览人数
@property (nonatomic, strong, readonly) NSArray *city;              //城市分布
@property (nonatomic, strong, readonly) NSDictionary *app;          //访问方式分布
@property (nonatomic, strong, readonly) NSDictionary *page;         //浏览的页面及其停留时间

@end
