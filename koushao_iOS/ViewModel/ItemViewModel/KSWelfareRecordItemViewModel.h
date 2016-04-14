//
//  KSWelfareRecordItemViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSActivityWelfareRecordViewModel.h"

@interface KSWelfareRecordItemViewModel : KSViewModel

@property(nonatomic, assign) CGFloat cellHeight;
@property(nonatomic, strong, readonly) KSWelfareVerifyLogsItemModel *itemModel;
@property(nonatomic, assign) BOOL showTime;

@end
