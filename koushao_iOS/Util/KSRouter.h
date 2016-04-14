//
//  KSRouter.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSViewProtocol.h"
@protocol KSViewProtocol;
@protocol KSViewModelProtocol;

@interface KSRouter : NSObject


+ (instancetype)sharedInstance;


- (id<KSViewProtocol>)viewControllerForViewModel:(id<KSViewModelProtocol>)viewModel;

@end
