//
//  KSEnrollRecordItemViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSActivityEnrollRecordItem.h"

@interface KSEnrollRecordItemViewModel : KSViewModel

@property(nonatomic, assign) CGFloat cellHeight;

@property(nonatomic, strong, readonly) KSActivityEnrollRecordItem *item;

@property(nonatomic, assign, readonly) BOOL isEnroll;
@end
