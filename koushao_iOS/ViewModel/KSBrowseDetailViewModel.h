//
//  KSBrowseDetailViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/2.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"
#import "KSActivity.h"
#import "KSActivityVisitsInfo.h"
@interface KSBrowseDetailViewModel : KSViewModel

@property (nonatomic, strong) KSActivity *activity;
@property (nonatomic, strong, readonly) KSActivityVisitsInfo *visitsInfo;
@end
