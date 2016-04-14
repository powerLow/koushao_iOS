//
//  KSActivityShareViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"

@class KSActivityShareViewController;

@interface KSActivityShareViewModel : KSViewModel

@property(nonatomic, strong, readonly) RACCommand *didClickWeixinBtnCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickFriendBtnCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickWeiboBtnCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickQQBtnCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickQzoneBtnCommand;

@property(nonatomic, strong, readonly) RACCommand *didClickCopyLinkBtnCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickSendContactBtnCommand;

@property(nonatomic, weak) KSActivityShareViewController *vc;

@end
