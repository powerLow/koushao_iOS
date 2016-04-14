//
//  KSMyInfo.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/21.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DB_ID_KSMYINFO @"db_myinfo"

@interface KSMyInfo : NSObject <KSPersistenceProtocol>



@property (nonatomic, strong, readonly) NSNumber *count;        //举办活动数目
@property (nonatomic, strong, readonly) NSNumber *visits;       //访问人数
@property (nonatomic, strong, readonly) NSNumber *interested;   //感兴趣人数
@property (nonatomic, strong, readonly) NSNumber *enroll;       //报名人数


-(instancetype)initWithCount:(NSNumber*)count visits:(NSNumber*)visits interested:(NSNumber*)interested
                      enroll:(NSNumber*)enroll;
@end
