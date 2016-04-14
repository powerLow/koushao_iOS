//
//  KSClientApi.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSClientApi.h"

//model
#import "KSApiResult.h"
#import "KSActivity.h"
#import "KSMyInfo.h"
#import "KSMyMoneyInfo.h"
#import "KSActivityVisitsInfo.h"
#import "KSActivityEnrollInfo.h"
#import "KSActivityEnrollRecordItem.h"
#import "KSActivityEnrollRecordItemInfo.h"
#import "KSSignResultModel.h"
#import "KSCreateActivityApi.h"
#import "KSUpdateActivityApi.h"
#import "KSActivityCreatApiResult.h"
#import "KSSigninDetailModel.h"
#import "KSSigninListApi.h"
#import "KSSigninListModel.h"
#import "KSQRCodeResultModel.h"
#import "KSWelfareVerifyResultModel.h"
#import "KSGetImageUploadTokenApi.h"
#import "KSGetImageUploadTokenResult.h"
#import "KSWelfareVerifyLogsResultModel.h"
#import "KSGetNetPicApi.h"
#import "InternalPictureModel.h"
#import "KSAwardItemModel.h"
#import "KSAwardDetailModel.h"
#import "KSAwardConfirmResultModel.h"
#import "KSAddSubAccountResultModel.h"
#import "KSActivityAdminListModel.h"
#import "KSSetEnlistInfoApi.h"
#import "KSSetModuleInfoApi.h"
#import "KSQuestionReplyResultModel.h"
#import "KSQuestionDeleteResultModel.h"
#import "KSQuestionListModel.h"
#import "KSDeleteWelfare.h"
#import "KSSetWelfareInfoApi.h"
#import "KSRequestSmsCode.h"
#import "KSWelfareAnalyseModel.h"
#import "KSMapPoisResultModel.h"
#import "KSFeedbackApi.h"
#import "KSSetUserProfile.h"
#import "KSDrawCashApi.h"
#import "KSMoneyRecordListModel.h"
#import "KSLoginSubAccount.h"
#import "RegisterDeviceApi.h"
#import "KSStopActivityResultModel.h"
#import "KSActivityBaseInfoModel.h"
#import "KSWelfareStopModel.h"
#import "KSWelfareStatusModel.h"
static NSString * const KSInstantDomain = @"KoushaoInstant";

#define errorTips @{@"tips":@"网络请求失败"}


@implementation KSClientApi

//短信登陆
+ (RACSignal *)loginWithPhone:(NSString*)mobilePhone SmsCode:(NSString*)smscode {
    NSLog(@"手机号登陆ing");
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        KSLoginSmsApi *loginApi = [[KSLoginSmsApi alloc] initWithMobile:mobilePhone smscode:smscode];
        [loginApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            //            NSLog(@"KSLoginSmsApi 请求成功 \n responseJSONObject =%@ \n",request.responseJSONObject);
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"loginWithPhone = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSUser *user = [KSUser sharedInstance];
                [user mj_setKeyValues:result.dict];
                [KSUser cacheUser:user];
                user.isLogin = YES;
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            NSLog(@"KSLoginSmsApi 请求失败 \n responseString = %@",request.responseString);
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
//子账号登陆
+ (RACSignal *)loginWithSubAccount:(NSString*)username password:(NSString*)password {
    NSLog(@"子账号登陆ing");
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        KSLoginSubAccount *loginApi = [[KSLoginSubAccount alloc] initWithUserName:username password:password];
        [loginApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"loginWithSubAccount = %@",request.responseJSONObject);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSUser *user = [KSUser sharedInstance];
                [user mj_setKeyValues:result.dict];
                [KSUser cacheUser:user];
                user.isLogin = YES;
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
    
}

+ (RACSignal *)registerDevice:(NSString*)username
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        RegisterDeviceApi *registerDeviceApi = [[RegisterDeviceApi alloc] initWithUsername:username];
        [registerDeviceApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"registerDevice = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            NSLog(@"registerDeviceApi 请求失败 \n responseString = %@",request.responseString);
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
/**
 *  请求验证码的方法
 *
 *  @param mobilePhone 手机号码
 *
 *  @return 信号
 */
+ (RACSignal *)requestSMSCode:(NSString*)mobilePhone withType:(NSInteger)type{
    NSLog(@"请求验证码ing");
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSRequestSmsCode *smsCodeApi = [[KSRequestSmsCode alloc] initWithMobile:mobilePhone withType:type];
        [smsCodeApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"requestSMSCode = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:@1];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            NSLog(@"KSLoginSmsApi 请求失败 \n responseString = %@",request.responseString);
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

//登出
+ (RACSignal *)logout{
    NSLog(@"登出ing");
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSLogoutApi *logoutApi = [[KSLogoutApi alloc] initWithMobilePhone:[KSUser currentUser].mobilePhone];
        [KSUser cacheUser:nil];
        [SSKeychain deleteAccessToken];
        [logoutApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"logout = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                //                KSUser *user = [KSUser currentUser];
                //                user.isLogin = NO;
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            NSLog(@"KSLogoutApi 请求失败 \n responseString = %@",request.responseString);
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}


#pragma - Acitivity
//获取活动列表
+ (RACSignal *)getActivityListWithLimit:(NSNumber*)limit time:(NSNumber*)time type:(KSRequestRefreshType)type {
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        //        [NSNumber numberWithUnsignedInteger:now];
        KSActivityListApi *getActivityListApi = [[KSActivityListApi alloc] initWithLimit:limit createtime:time type:type];
        [getActivityListApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            NSLog(@"getActivityListWithLimit = %@",request.responseString);
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSActivityList *items = [KSActivityList mj_objectWithKeyValues:request.responseJSONObject];
                for (NSDictionary* dict in items.activityList) {
                    KSActivity *item = [KSActivity mj_objectWithKeyValues:dict];
                    [subscriber sendNext:item];
                }
                [subscriber sendCompleted];
            }else{
                //传递错误
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            NSLog(@"KSActivityListApi 请求失败 \n responseString = %@",request.responseString);
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

//创建活动
+ (RACSignal*)creatActivity
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSCreateActivityApi *createActivityApi = [[KSCreateActivityApi alloc] init];
        [createActivityApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"creatActivity = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSActivityCreatApiResult *kSActivityCreatApiResult = [KSActivityCreatApiResult mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:kSActivityCreatApiResult];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
+ (RACSignal*)stopActivity {
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSStopActivityApi *api = [[KSStopActivityApi alloc] init];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"stopActivity = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSStopActivityResultModel *model = [KSStopActivityResultModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
+ (RACSignal*)getActivityBaseInfo {
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSActivityBaseApi *api = [[KSActivityBaseApi alloc] init];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getActivityBaseInfo = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSActivityBaseInfoModel *model = [KSActivityBaseInfoModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
//获取网络图库
+ (RACSignal*)getNetPic:(NSInteger)type
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSGetNetPicApi *getNetPicApi = [[KSGetNetPicApi alloc] init];
        getNetPicApi.type=type;
        [getNetPicApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getNetPic = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                NSArray *internalPictures = [InternalPictureModel mj_objectArrayWithKeyValuesArray:result.dict];
                [subscriber sendNext:internalPictures];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
    
}
//获取活动上传的token
+ (RACSignal*)getImageUploadToken
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSGetImageUploadTokenApi *getImageUploadTokenApi = [[KSGetImageUploadTokenApi alloc] init];
        [getImageUploadTokenApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getImageUploadToken = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSGetImageUploadTokenResult *kSGetImageUploadTokenResult = [KSGetImageUploadTokenResult mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:kSGetImageUploadTokenResult];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}



/**
 *  修改用户个人信息
 *
 *  @return
 */
+ (RACSignal*)setUserProfile:(NSString*)nickname andGender:(NSInteger)gender
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSSetUserProfile *setUserProfile = [[KSSetUserProfile alloc] initWithNickname:nickname andGender:gender];
        [setUserProfile startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

/**
 *  提现
 *
 *  @return
 */
+ (RACSignal*)drawCash:(NSString*)account andName:(NSString*)name andMoney:(float)money andCode:(NSString*)code andPic:(NSString*)pic
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSDrawCashApi *drawCash = [[KSDrawCashApi alloc] init];
        drawCash.name=name;
        drawCash.money=money;
        drawCash.code=code;
        drawCash.pic_1=pic;
        drawCash.account=account;
        
        [drawCash startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

//更新活动信息
+ (RACSignal*)upDateActivity:(NSMutableDictionary*)params
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSUpdateActivityApi *updateActivityApi = [[KSUpdateActivityApi alloc] init];
        updateActivityApi.params=params;
        [updateActivityApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"upDateActivity = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
    
}


/**
 *  更新活动福利信息
 *
 *  @return
 */
+ (RACSignal*)setActivityWelfareInfo
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSSetWelfareInfoApi *setWelfareInfoApi = [[KSSetWelfareInfoApi alloc] init];
        [setWelfareInfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
    
}


/**
 *  删除活动福利信息
 *
 *  @return
 */
+ (RACSignal*)deleteActivityWelfareInfo
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSDeleteWelfare *deleteWelfare = [[KSDeleteWelfare alloc] init];
        [deleteWelfare startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
    
}
/**
 * 发布活动
 *
 *  @return
 */
+ (RACSignal*)startActivity
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSStartActivityApi *startActivity = [[KSStartActivityApi alloc] init];
        [startActivity startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSActivity *activity = [KSActivity mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:activity];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
//设置活动模板信息
+ (RACSignal*)setActivityTemplete
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSSetActivityTempleteApi *setActivityTempleteApi = [[KSSetActivityTempleteApi alloc] init];
        [setActivityTempleteApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

//设置活动票务信息
+ (RACSignal*)setActivityEnlistInfo
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSSetEnlistInfoApi *setEnlistInfoApi = [[KSSetEnlistInfoApi alloc] init];
        [setEnlistInfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

//设置活动模块信息
+ (RACSignal*)setActivityModuleInfo
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSSetModuleInfoApi *setModuleInfoApi = [[KSSetModuleInfoApi alloc] init];
        [setModuleInfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

#pragma mark - Analyse
//获取活动统计的信息
+ (RACSignal*)getMyinfo {
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSMyinfoApi *myinfoApi = [[KSMyinfoApi alloc] init];
        [myinfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getMyinfo = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSMyInfo *myinfo = [KSMyInfo mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:myinfo];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
//获取金额统计信息
+ (RACSignal*)getMyMoneyinfo {
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSMyMoneyInfoApi *myinfoApi = [[KSMyMoneyInfoApi alloc] init];
        [myinfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getMyMoneyinfo = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSMyMoneyInfo *myinfo = [KSMyMoneyInfo mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:myinfo];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
            
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
//获取浏览详情
+ (RACSignal*)getVisitsInfoApi{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSVisitsInfoApi *myinfoApi = [[KSVisitsInfoApi alloc] init];
        [myinfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getVisitsInfoApi = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSActivityVisitsInfo *info = [KSActivityVisitsInfo mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:info];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
//获取报名详情
+ (RACSignal*)getEnrollInfoApi{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSEnrollInfoApi *myinfoApi = [[KSEnrollInfoApi alloc] init];
        [myinfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getEnrollInfoApi result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSActivityEnrollInfo *info = [KSActivityEnrollInfo mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:info];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
//获取报名详情-报名列表
+ (RACSignal*)getEnrollRecordApiWithTid:(NSNumber*)tid
                                  limit:(NSNumber*)limit
                                   type:(KSRequestRefreshType)type{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSEnrollRecordApi *myinfoApi = [[KSEnrollRecordApi alloc] initWithTid:tid refresh_type:type limit:limit];
        [myinfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getEnrollRecordApi result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                NSArray *items = [KSActivityEnrollRecordItem mj_objectArrayWithKeyValuesArray:result.dict];
                for (KSActivityEnrollRecordItem* item in items) {
                    [subscriber sendNext:item];
                }
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
//报名详情-报名列表-报名详情/购票详情
+ (RACSignal*)getEnrollRecordDetailWithTicketId:(NSString*)ticket_id{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSEnrollRecordDetailApi *myinfoApi = [[KSEnrollRecordDetailApi alloc] initWithTicketId:ticket_id];
        [myinfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getEnrollRecordDetailWithTicketId result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSActivityEnrollRecordItemInfo *item = [KSActivityEnrollRecordItemInfo mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:item];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
+ (RACSignal*)FeedbackCommit:(NSString*)content
                 withContact:(NSString*)contact
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSFeedbackApi *feedbackApi = [[KSFeedbackApi alloc] init];
        feedbackApi.content=content;
        feedbackApi.contact=contact;
        [feedbackApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
    
}

+ (RACSignal*)getMoneyRecordWithId:(NSNumber*)mid
                      refresh_type:(KSRequestRefreshType)refresh_type
                       record_type:(KSMoneyRecordApiType)record_type
                             limit:(NSNumber*)limit{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSMoneyRecordApi *api = [[KSMoneyRecordApi alloc] initWithId:mid record_type:record_type refresh_type:refresh_type limit:limit];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getMoneyRecordWithId result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSMoneyRecordListModel *item = [KSMoneyRecordListModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:item];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
#pragma mark - 签到API
//主办方签到
+ (RACSignal*)signinWithType:(KSSigninType)type SmsCode:(NSString*)code{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSSigninApi *api = [[KSSigninApi alloc] initWithSignType:type Code:code];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"signinApiWith result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSSignResultModel *model = [KSSignResultModel mj_objectWithKeyValues:result.dict];
                model.success = YES;
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }else if([result.errorno integerValue] == KSInstantErrorTicketHasBeenUse){
                KSSignResultModel *model = [KSSignResultModel mj_objectWithKeyValues:result.dict];
                model.success = NO;
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
#pragma mark - 二维码
+ (RACSignal*)getcheckinQRCode{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSQRCodeApi *myinfoApi = [[KSQRCodeApi alloc] init];
        
        [myinfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getcheckinQRCode result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSQRCodeResultModel *item = [KSQRCodeResultModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:item];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
#pragma mark - 签到
+ (RACSignal*)getSigninListWithTid:(NSNumber*)tid
                              type:(KSSigninListApiType)type
                      refresh_tyep:(KSRequestRefreshType)refresh_type
                             limit:(NSNumber *)limit {
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSSigninListApi *myinfoApi = [[KSSigninListApi alloc] initWithTid:tid type:type refresh_tyep:refresh_type limit:limit];
        [myinfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getSigninList result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSSigninListModel *items = [KSSigninListModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:items];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
+ (RACSignal*)getSigninDetailWithTicketId:(NSString*)ticket_id {
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        KSSigninDetailApi *myinfoApi = [[KSSigninDetailApi alloc] initWithTicketId:ticket_id];
        [myinfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getSigninDetailWithTicketId result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSSigninDetailModel *item = [KSSigninDetailModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:item];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

#pragma mark - 福利
+ (RACSignal*)requestWelafreVerifyWithType:(KSWelfareVerifyType)type Code:(NSString*)code {
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSWelfareVerifyApi *myinfoApi = [[KSWelfareVerifyApi alloc] initWithType:type Code:code];
        [myinfoApi startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"requestWelafreVerifyWithType result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                
                KSWelfareVerifyResultModel *model = [KSWelfareVerifyResultModel mj_objectWithKeyValues:result.dict];
                model.success = YES;
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }else if([result.errorno integerValue] == KSInstantErrorWelfareCodeHasBeenUse){
                KSWelfareVerifyResultModel *model = [KSWelfareVerifyResultModel mj_objectWithKeyValues:result.dict];
                model.success = NO;
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

+ (RACSignal*)getWelfareLogsListWid:(NSNumber*)wid
                       refresh_type:(KSRequestRefreshType)refresh_type
                        record_type:(KSWelfareVerifyLogsRecordType)record_type
                              limit:(NSNumber*)limit
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSWelfareVerifyLogsApi *api = [[KSWelfareVerifyLogsApi alloc] initWithWid:wid refresh_type:refresh_type record_type:record_type limit:limit];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getWelfareLogsList result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSWelfareVerifyLogsResultModel *item = [KSWelfareVerifyLogsResultModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:item];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

+ (RACSignal*)getWelfareLogsDetailWithWid:(NSNumber*)wid{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSWelfareVerifyLogsDetailApi *api = [[KSWelfareVerifyLogsDetailApi alloc] initWithWid:wid];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getWelfareLogsDetailWithWid result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSWelfareVerifyLogsDetailModel *item = [KSWelfareVerifyLogsDetailModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:item];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
+ (RACSignal*)getAwardListWithWid:(NSNumber*)wid
                     refresh_type:(KSRequestRefreshType)refresh_type
                            limit:(NSNumber*)limit
                             type:(KSAwardListApiType)type{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSAwardListApi *api = [[KSAwardListApi alloc] initWithWid:wid refresh_type:refresh_type limit:limit type:type];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getAwardList result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                NSArray *items = [KSAwardItemModel mj_objectArrayWithKeyValuesArray:result.dict];
                for (KSAwardItemModel* item in items) {
                    [subscriber sendNext:item];
                }
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

+ (RACSignal*)getAwardDetailWid:(NSNumber*)wid{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSAwardDetailApi *api = [[KSAwardDetailApi alloc] initWithWid:wid];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getAwardDetailWid result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSAwardDetailModel *item = [KSAwardDetailModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:item];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
+ (RACSignal*)confirmAwardWithWid:(NSNumber*)wid
                               nu:(NSString*)nu
                          company:(NSString*)company{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSAwardConfirmApi *api = [[KSAwardConfirmApi alloc] initWithWid:wid nu:nu company:company];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"confirmAwardWithWid result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSAwardConfirmResultModel *item = [KSAwardConfirmResultModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:item];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
+ (RACSignal*)getWelfareAnalyse{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSWelfareAnalyseApi *api = [[KSWelfareAnalyseApi alloc] init];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getWelfareAnalyse result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSWelfareAnalyseModel *item = [KSWelfareAnalyseModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:item];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

+ (RACSignal*)stopWelfare{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSWelfareStopApi *api = [[KSWelfareStopApi alloc] init];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"stopWelfare result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSWelfareStopModel *model = [KSWelfareStopModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
+ (RACSignal*)getWelfareStatus{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSWelfareStatusApi *api = [[KSWelfareStatusApi alloc] init];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"getWelfareStatus result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSWelfareStatusModel *item = [KSWelfareStatusModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:item];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

#pragma mark - 管理员(子账号)
+ (RACSignal*)addSubAccount:(NSString*)account
                   Password:(NSString*)password
                     signin:(BOOL)signin
                   question:(BOOL)question
                    welfare:(BOOL)welfare
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSSubaccountPostApi *api = [[KSSubaccountPostApi alloc] initWithAccount:account Password:password signin:signin question:question welfare:welfare];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"addSubAccount result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSAddSubAccountResultModel *model = [KSAddSubAccountResultModel mj_objectWithKeyValues:request.responseJSONObject];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

+ (RACSignal*)ModifySubAccount:(NSString*)account
                      Password:(NSString*)password
                        signin:(BOOL)signin
                      question:(BOOL)question
                       welfare:(BOOL)welfare
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSSubaccountPutApi *api = [[KSSubaccountPutApi alloc] initWithAccount:account Password:password signin:signin question:question welfare:welfare];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"ModifySubAccount result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

+ (RACSignal*)DelSubAccount:(NSString*)account
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSSubaccountDeleteApi *api = [[KSSubaccountDeleteApi alloc] initWithAccount:account];
        
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"DelSubAccount result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                [subscriber sendNext:account];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:@{@"tips":result.msg}];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

+ (RACSignal*)getSubAccountList
{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSSubaccountGetApi *api = [[KSSubaccountGetApi alloc] init];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            if ([result.errorno integerValue] == KSInstantSuccess) {
                NSLog(@"getSubAccountList result = %@",request.responseString);
                KSActivityAdminListModel *items = [KSActivityAdminListModel mj_objectWithKeyValues:result.dict];
                for (KSActivityAdminItemModel *item in items.list) {
                    [subscriber sendNext:item];
                }
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:nil];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
#pragma mark - 咨询回复

+ (RACSignal*)GetQuestionListWithId:(NSNumber*)qid
                               type:(KSRequestRefreshType)type
                          replytype:(KSQuestionListApiReplyType)replytype
                              limit:(NSNumber*)limit{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSQuestionListApi *api = [[KSQuestionListApi alloc] initWithId:qid type:type replytype:replytype limit:limit];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"GetQuestionListWithId result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSQuestionListModel *items = [KSQuestionListModel mj_objectWithKeyValues:result.dict];
                for (KSQuestionListItemModel *item in items.list) {
                    [subscriber sendNext:item];
                }
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:nil];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

+ (RACSignal*)PostReplyWithId:(NSNumber*)qid answer:(NSString*)answer{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSQuestionReplyPostApi *api = [[KSQuestionReplyPostApi alloc] initWithId:qid answer:answer];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"PostReplyWithId result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSQuestionReplyResultModel *model = [KSQuestionReplyResultModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:nil];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}

+ (RACSignal*)DeleteReplyWithType:(KSQuestionReplyDeleteApiType)type Id:(NSNumber*)qid{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSQuestionReplyDeleteApi *api = [[KSQuestionReplyDeleteApi alloc] initWithType:type Id:qid];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"DeleteReplyWithId result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSQuestionDeleteResultModel *model = [KSQuestionDeleteResultModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:nil];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
#pragma mark - 地图
+ (RACSignal*)MapPoisWithQuery:(NSString*)query
                     longitude:(NSString*)longitude
                      latitude:(NSString*)latitude{
    NSError *accessError = [NSError errorWithDomain:KSInstantDomain
                                               code:KSInstantErrorOperationCouldnotbeCompleted
                                           userInfo:errorTips];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        KSMapPoisApi *api = [[KSMapPoisApi alloc] initWithQuery:query longitude:longitude latitude:latitude];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            KSApiResult *result = [KSApiResult mj_objectWithKeyValues:request.responseJSONObject];
            NSLog(@"MapPoisWithQuery result = %@",request.responseString);
            if ([result.errorno integerValue] == KSInstantSuccess) {
                KSMapPoisResultModel *model = [KSMapPoisResultModel mj_objectWithKeyValues:result.dict];
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }else{
                NSError *Error = [NSError errorWithDomain:KSInstantDomain
                                                     code:[result.errorno integerValue]
                                                 userInfo:nil];
                [subscriber sendError:Error];
            }
        } failure:^(YTKBaseRequest *request) {
            [subscriber sendError:accessError];
        }];
        return nil;
    }];
}
@end
