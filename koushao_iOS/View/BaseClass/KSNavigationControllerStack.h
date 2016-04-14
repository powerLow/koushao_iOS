//
//  KSNavigationControllerStack.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KSViewModelServices;

@interface KSNavigationControllerStack : NSObject


- (instancetype)initWithServices:(id<KSViewModelServices>)services;


- (void)pushNavigationController:(UINavigationController *)navigationController;

- (UINavigationController *)popNavigationController;

- (UINavigationController *)topNavigationController;

@end
