//
//  KSActivitySignRecordViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSRefreshTableViewModel.h"
#import "KSSigninListModel.h"

//typedef enum : NSUInteger {
//    KSRequestSigninTypeYes,//已签到
//    KSRequestSigninTypeNO,//未签到
//} KSRequestSigninType;

@interface KSActivitySignRecordViewModel : KSRefreshTableViewModel

@property(nonatomic, strong, readonly) KSSigninListModel *listModel;
@property(nonatomic, strong, readonly) NSArray *sectionSource;

//切换已签到,未签到
@property(nonatomic, assign, readonly) KSSigninListApiType curRequestType;


@end
