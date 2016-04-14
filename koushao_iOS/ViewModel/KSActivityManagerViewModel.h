//
//  KSActivityManagerViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/25.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSActivity.h"
#import "KSActivityBaseInfoModel.h"
//@class KSActivity;
@interface KSActivityManagerViewModel : KSViewModel

@property(nonatomic, strong) KSActivity *activity;

@property(nonatomic, strong, readonly) RACCommand *didClickShareBtnCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickAskBtnCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickWelfareBtnCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickSignBtnCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickAdminBtnCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickLookBtnCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickStopBtnCommand;

@property(nonatomic, strong, readonly) RACCommand *didClickBrowseDetailCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickEnrollDetailCommand;

@property (nonatomic,strong, readonly) KSActivityBaseInfoModel *baseinfo;
@end
