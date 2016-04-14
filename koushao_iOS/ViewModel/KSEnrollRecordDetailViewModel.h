//
//  KSEnrollRecordDetailViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/5.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSActivityEnrollRecordItemInfo.h"

@interface KSEnrollRecordDetailViewModel : KSViewModel

@property(nonatomic, assign, readonly) BOOL isEnroll;

@property(nonatomic, strong, readonly) KSActivityEnrollRecordItemInfo *info;

@end
