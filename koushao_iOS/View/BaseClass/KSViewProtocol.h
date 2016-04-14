//
//  KSViewProtocol.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol KSViewModelProtocol;

@protocol KSViewProtocol <NSObject>


@required

// Initialization method. This is the preferred way to create a new view.
//
// viewModel - corresponding view model
//
// Returns a new view.
- (instancetype)initWithViewModel:(id<KSViewModelProtocol>)viewModel;

// The `viewModel` parameter in `-initWithViewModel:` method.
@property (nonatomic, strong, readonly) id<KSViewModelProtocol> viewModel;

@optional

// Binds the corresponding view model to the view.
- (void)bindViewModel;

@end
