//
//  KSViewModel.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSViewModelProtocol.h"

@interface KSViewModel : NSObject <KSViewModelProtocol>

@property(nonatomic, assign) BOOL isNoMoreData;
@property(nonatomic, strong) RACCommand *requestRemoteDataCommand;

- (BOOL (^)(NSError *))requestRemoteDataErrorsFilter;

@end
