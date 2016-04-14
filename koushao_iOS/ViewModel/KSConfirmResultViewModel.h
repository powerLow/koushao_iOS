//
//  KSConfirmResultViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/17.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSAwardDetailModel.h"

@interface KSConfirmResultViewModel : KSViewModel

@property(nonatomic, strong, readonly) KSAwardDetailModel *model;


@property(nonatomic, strong, readonly) RACCommand *didClickLoopUpBtn;


@end
