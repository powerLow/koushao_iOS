//
//  KSConfirmGfitViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/17.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSAwardDetailModel.h"
#import "KSAwardConfirmResultModel.h"


@interface KSConfirmGfitViewModel : KSViewModel

@property(nonatomic, strong, readonly) RACCommand *didClickConfirmBtn;
@property(nonatomic, strong, readonly) KSAwardDetailModel *model;
@property(nonatomic, strong, readonly) KSAwardConfirmResultModel *result;

@end
