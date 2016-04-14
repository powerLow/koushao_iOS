//
//  KSActivityUserSignViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSActivity.h"
#import "KSQRCodeResultModel.h"

@interface KSActivityUserSignViewModel : KSViewModel

@property(nonatomic, strong, readonly) KSActivity *activity;
@property(nonatomic, strong, readonly) KSQRCodeResultModel *model;
@end
