//
//  KSActivitySignCodeViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewModel.h"

@interface KSActivitySignCodeViewModel : KSViewModel

@property(nonatomic, strong, readonly) RACCommand *didSubmitCommand;
@property(nonatomic, strong, readonly) RACCommand *didClickViewRecordCommand;

@end
