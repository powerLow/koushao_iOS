//
//  KSNavigationProtocol.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KSViewModelProtocol;


@protocol KSNavigationProtocol <NSObject>


- (void)pushViewModel:(id <KSViewModelProtocol>)viewModel animated:(BOOL)animated;


- (void)popViewModelAnimated:(BOOL)animated;


- (void)popToRootViewModelAnimated:(BOOL)animated;


- (void)presentViewModel:(id <KSViewModelProtocol>)viewModel animated:(BOOL)animated completion:(VoidBlock)completion;


- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion;


- (void)resetRootViewModel:(id <KSViewModelProtocol>)viewModel;

@end
