//
//  KSClientApi.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

//api
#import "KSBaseApiRequest.h"
#import "KSLoginSmsApi.h"
#import "KSLogoutApi.h"
#import "KSActivityListApi.h"
#import "KSMyinfoApi.h"
#import "KSMyMoneyInfoApi.h"
#import "KSVisitsInfoApi.h"
#import "KSEnrollInfoApi.h"
#import "KSEnrollRecordApi.h"
#import "KSEnrollRecordDetailApi.h"
#import "KSSigninApi.h"
#import "KSQRCodeApi.h"
#import "KSSigninListApi.h"
#import "KSSigninDetailApi.h"
#import "KSWelfareVerifyApi.h"
#import "KSWelfareVerifyLogsApi.h"
#import "KSWelfareStatusApi.h"
#import "KSWelfareStopApi.h"
#import "KSAwardListApi.h"
#import "KSAwardDetailApi.h"
#import "KSAwardConfirmApi.h"
#import "KSSubaccountPostApi.h"
#import "KSSubaccountGetApi.h"
#import "KSSubaccountPutApi.h"
#import "KSSubaccountDeleteApi.h"
#import "KSSetActivityTempleteApi.h"
#import "KSQuestionListApi.h"
#import "KSQuestionReplyDeleteApi.h"
#import "KSQuestionReplyPostApi.h"
#import "KSWelfareVerifyLogsDetailApi.h"
#import "KSStartActivityApi.h"
#import "KSWelfareAnalyseApi.h"
#import "KSMapPoisApi.h"
#import "KSMoneyRecordApi.h"
#import "KSStopActivityApi.h"
#import "KSActivityBaseApi.h"
typedef NS_ENUM(NSInteger, KSInstantError) {
    KSInstantErrorOperationCouldnotbeCompleted = -1,
    KSInstantSuccess = 0,
    KSInstantErrorAccessDenied = 1,
    KSInstantErrorInvalidResponse = 2,
    KSInstantErrorUsernameIsMissing = 200,
    KSInstantErrorPasswordIsMissing = 201,
    KSInstantErrorSubAccountHasBeenTaken = 219,
    KSInstantErrorUsernameTooLong = 220,
    KSInstantErrorPasswordTooLong = 221,
    KSInstantErrorTokenHasExpired = 253,
    KSInstantErrorTokenHasNotFound = 254,
    KSInstantErrorTicketNotFound = 321,
    KSInstantErrorTicketHasBeenUse = 323,
    KSInstantErrorWelfareCodeNotFound = 330,
    KSInstantErrorWelfareCodeHasBeenUse = 331,
};

@interface KSClientApi : NSObject

+ (RACSignal *)loginWithPhone:(NSString*)mobilePhone SmsCode:(NSString*)smscode;
+ (RACSignal *)logout;
+ (RACSignal *)loginWithSubAccount:(NSString*)username password:(NSString*)password;
+ (RACSignal *)registerDevice:(NSString*)username;
/**
 *  获取短信验证码
 *
 *  @param mobilePhone 手机号码
 *
 *  @return 信号
 */
+ (RACSignal *)requestSMSCode:(NSString*)mobilePhone withType:(NSInteger)type;

/**
 *  获取活动列表
 *
 *  @param limit 获取条数
 *  @param time  请求的时间
 *  @param type  大于时间还是小于提供的时间
 *
 *  @return KSActivity数组
 */
+ (RACSignal *)getActivityListWithLimit:(NSNumber*)limit time:(NSNumber*)time type:(KSRequestRefreshType)type;

/**
 *  获取活动统计
 *
 *  @return 活动统计[举办活动次数,访问人数,感兴趣人数, 报名人数]
 */
+ (RACSignal*)getMyinfo;
/**
 *  获取金额统计
 *
 *  @return 活动金额统计
 */
+ (RACSignal*)getMyMoneyinfo;

/**
 *  获取浏览详情
 *
 *  @return 获取浏览详情
 */
+ (RACSignal*)getVisitsInfoApi;
#pragma mark - 签到
/**
 *  获取报名详情
 *
 *  @return 获取报名详情
 */
+ (RACSignal*)getEnrollInfoApi;
/**
 *  获取报名详情-报名记录
 *
 *  @return 报名记录
 */
+ (RACSignal*)getEnrollRecordApiWithTid:(NSNumber*)tid
                                   limit:(NSNumber*)limit
                                    type:(KSRequestRefreshType)type;
/**
 *  获取报名详情-报名记录-报名详情/购票详情
 *
 *  @return 
 */
+ (RACSignal*)getEnrollRecordDetailWithTicketId:(NSString*)ticket_id;
+ (RACSignal*)signinWithType:(KSSigninType)type SmsCode:(NSString*)code;
/**
 *  获取签到二维码
 *
 *  @return
 */
+ (RACSignal*)getcheckinQRCode;
/**
 *  获取签到列表
 *
 *  @return
 */
+ (RACSignal*)getSigninListWithTid:(NSNumber*)tid
                               type:(KSSigninListApiType)type
                       refresh_tyep:(KSRequestRefreshType)refresh_type
                              limit:(NSNumber *)limit;
/**
 *  获取签到详情
 *
 *  @return
 */
+ (RACSignal*)getSigninDetailWithTicketId:(NSString*)ticket_id;
#pragma mark - 活动
/**
 *  创建活动
 *
 *  @return
 */
+ (RACSignal*)creatActivity;

/**
 *  停止活动
 *
 *  @return
 */
+ (RACSignal*)stopActivity;
/**
 *  获取基本的信息(浏览次数,报名人数)
 *
 *  @return
 */
+ (RACSignal*)getActivityBaseInfo;
/**
 *  更新活动参数
 *
 *  @return
 */
+ (RACSignal*)upDateActivity:(NSMutableDictionary*)params;

/**
 *  获取上传图片的token
 *
 *  @return
 */
+ (RACSignal*)getImageUploadToken;
/**
 *  更新活动模板信息
 *
 *  @return
 */

+ (RACSignal*)setActivityTemplete;

/**
 *  更新活动模块信息
 *
 *  @return
 */

+ (RACSignal*)setActivityModuleInfo;

/**
 *  更新活动票务信息
 *
 *  @return
 */
+ (RACSignal*)setActivityEnlistInfo;

/**
 *  更新活动福利信息
 *
 *  @return
 */
+ (RACSignal*)setActivityWelfareInfo;

/**
 *  删除福利信息
 *
 *  @return
 */
+ (RACSignal*)deleteActivityWelfareInfo;

/**
 * 发布活动
 *
 *  @return
 */
+ (RACSignal*)startActivity;
#pragma mark - 福利
/**
 *  验证福利的码（短信/二维码）
 *
 *  @return
 */
+ (RACSignal*)requestWelafreVerifyWithType:(KSWelfareVerifyType)type Code:(NSString*)code;
/**
 *  获取福利验证记录的列表
 *
 *  @return
 */
+ (RACSignal*)getWelfareLogsListWid:(NSNumber*)wid
                       refresh_type:(KSRequestRefreshType)type
                        record_type:(KSWelfareVerifyLogsRecordType)record_type
                              limit:(NSNumber*)limit;

/**
 *  获取福利发放记录的详细信息
 *
 *  @param wid 要查看福利的ID
 *
 *  @return
 */
+ (RACSignal*)getWelfareLogsDetailWithWid:(NSNumber*)wid;

/**
 *  获取实物记录的列表
 *
 *  @return
 */
+ (RACSignal*)getAwardListWithWid:(NSNumber*)wid
                     refresh_type:(KSRequestRefreshType)refresh_type
                            limit:(NSNumber*)limit
                             type:(KSAwardListApiType)type;
/**
 *  获取实物记录的详情
 *
 *  @return
 */
+ (RACSignal*)getAwardDetailWid:(NSNumber*)wid;
/**
 *  确认发放实物列表
 *
 *  @return
 */
+ (RACSignal*)confirmAwardWithWid:(NSNumber*)wid
                               nu:(NSString*)nu
                          company:(NSString*)company;
/**
 *  获取福利的统计
 *
 *  @return
 */
+ (RACSignal*)getWelfareAnalyse;
/**
 *  停止福利
 *
 *  @return 
 */
+ (RACSignal*)stopWelfare;
/**
 *  获取福利状态
 *
 *  @return 
 */
+ (RACSignal*)getWelfareStatus;
#pragma mark - 子账号/管理员
/**
 *  添加管理员
 *
 *  @param account  账号
 *  @param password 密码
 *  @param signin   签到权限
 *  @param question 咨询权限
 *  @param welfare  福利权限
 *
 *  @return
 */
+ (RACSignal*)addSubAccount:(NSString*)account
                   Password:(NSString*)password
                     signin:(BOOL)signin
                   question:(BOOL)question
                    welfare:(BOOL)welfare;

+ (RACSignal*)ModifySubAccount:(NSString*)account
                   Password:(NSString*)password
                     signin:(BOOL)signin
                   question:(BOOL)question
                    welfare:(BOOL)welfare;

+ (RACSignal*)DelSubAccount:(NSString*)account;

+ (RACSignal*)getSubAccountList;

#pragma mark - 咨询回复

+ (RACSignal*)GetQuestionListWithId:(NSNumber*)qid
                                  type:(KSRequestRefreshType)type
                             replytype:(KSQuestionListApiReplyType)replytype
                                 limit:(NSNumber*)limit;

+ (RACSignal*)PostReplyWithId:(NSNumber*)qid answer:(NSString*)answer;

+ (RACSignal*)DeleteReplyWithType:(KSQuestionReplyDeleteApiType)type Id:(NSNumber*)qid;

#pragma mark - 图库
/**
 *  获取网络图库
 *
 *  @return
 */
+ (RACSignal*)getNetPic:(NSInteger)type;
#pragma mark - 地图
+ (RACSignal*)MapPoisWithQuery:(NSString*)query
                     longitude:(NSString*)longitude
                      latitude:(NSString*)latitude;

#pragma mark - 个人信息部分
/**
 *  反馈提交
 *
 *  @param content 反馈内容
 *  @param contact 联系方式（邮箱）
 *
 *  @return
 */
+ (RACSignal*)FeedbackCommit:(NSString*)content
                     withContact:(NSString*)contact;

/**
 *  修改用户个人信息
 *
 *  @return 
 */
+ (RACSignal*)setUserProfile:(NSString*)nickname andGender:(NSInteger)gender;

/**
 *  提现
 *
 *  @param account 支付宝帐户
 *  @param name    提现人姓名
 *  @param money   提现金额
 *  @param code    验证码
 *  @param pic     手持身份证照片
 *
 *  @return 信号
 */
+ (RACSignal*)drawCash:(NSString*)account andName:(NSString*)name andMoney:(float)money andCode:(NSString*)code andPic:(NSString*)pic;

/**
 *  获取金额的历史记录列表(获取记录，取现记录)
 *
 *  @param mid          id
 *  @param refresh_type 刷新类型,上拉下拉
 *  @param record_type  查询类型,获取金额记录，取现金额记录
 *  @param limit        分页，每页几个
 *
 *  @return
 */
+ (RACSignal*)getMoneyRecordWithId:(NSNumber*)mid
                      refresh_type:(KSRequestRefreshType)refresh_type
                       record_type:(KSMoneyRecordApiType)record_type
                             limit:(NSNumber*)limit;
@end
