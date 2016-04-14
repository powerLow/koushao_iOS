//
//  KSActivity.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/14.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    KSActivityStatusReady,
    KSActivityStatusStart,
    KSActivityStatusEnd,
} KSActivityStatus;
/*
attr =     {
    module =         {
        cover = 0;
        question = 1;
        signin = 1;
        welfare = 1;
    };
    qrcode = "http://image.koushaoapp.com/FlRr2KvJ-kCTbwqacwYX3s_aq_Kb";
    template =         {
        cover = 4;
        detail = 3;
        question = 1;
        signin = 1;
        welfare = 2;
    };
    ticket =         {
        form =             (
        );
        limit = 100;
        type = 0;
    };
};
 */

@interface KSActivityAttrModuleModel : NSObject

@property (nonatomic,strong,readonly) NSNumber* cover;
@property (nonatomic,strong,readonly) NSNumber* question;
@property (nonatomic,strong,readonly) NSNumber* signin;
@property (nonatomic,strong,readonly) NSNumber* welfare;

@end

@interface KSActivityAttrTicketModel : NSObject

@property (nonatomic,strong,readonly) NSNumber* limit;
@property (nonatomic,strong,readonly) NSNumber* type;
@property (nonatomic,strong,readonly) NSArray* form;
@property (nonatomic,strong,readonly) NSNumber* verify;

@end

@interface KSActivityAttrModel : NSObject

@property (nonatomic,copy,readonly) NSString* qrcode;
@property (nonatomic,strong,readonly) KSActivityAttrModuleModel *module;
@property (nonatomic,strong,readonly) KSActivityAttrTicketModel *ticket;
@end

@interface KSActivity : NSObject <KSPersistenceProtocol>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSNumber *category;
@property (nonatomic, copy, readonly) NSString *poster;
@property (nonatomic, copy, readonly) NSString *cover_pic;
@property (nonatomic, copy, readonly) NSString *color;
@property (nonatomic, copy, readonly) NSString *detail;

@property (nonatomic, copy, readonly) NSString *location;
@property (nonatomic, strong, readonly) NSNumber *longitude;
@property (nonatomic, strong, readonly) NSNumber *latitude;

@property (nonatomic, strong, readonly) NSNumber *startTime;
@property (nonatomic, strong, readwrite) NSNumber *endTime;
@property (nonatomic, assign, readonly) BOOL isday;

@property (nonatomic, strong, readonly) NSNumber *create_time;
@property (nonatomic, strong, readonly) NSNumber *modified_time;

@property (nonatomic, copy, readwrite) NSString *hashCode;
@property (nonatomic, copy, readonly) NSString *sig;

@property (nonatomic, assign, readwrite) KSActivityStatus status;

@property (nonatomic, strong, readonly) KSActivityAttrModel *attr;

@property (nonatomic, strong, readwrite) NSNumber *visits; //浏览人数
@property (nonatomic, strong, readonly) NSNumber *totalmoney; //收款总金额
@property (nonatomic, strong, readwrite) NSNumber *enroll; //报名人数
@property (nonatomic, strong, readonly) NSNumber *welfare_type;//当前福利的类别

@property (nonatomic, strong, readwrite) UIImage *thumbnail;//缩略图
@property (nonatomic, copy, readwrite) NSString *shortUrl;//分享的短网址

+ (void)ks_saveActivitys:(NSArray*)activitys;
+ (NSArray*)ks_fetchActivitys;
+ (void)ks_deleteActivitys;
@end

@interface KSActivityList : NSObject

@property (strong, nonatomic) NSMutableArray *activityList;

@end
