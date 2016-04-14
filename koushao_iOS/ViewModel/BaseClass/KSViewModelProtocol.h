//
//  KSViewModelProtocol.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, KSTitleViewType) {
    KSTitleViewTypeDefault,
    KSTitleViewTypeDoubleTitle,
    KSTitleViewTypeLoadingTitle
};


@protocol KSViewModelServices;

@protocol KSViewModelProtocol <NSObject>


@required

- (instancetype)initWithServices:(id <KSViewModelServices>)services params:(id)params;

// The `services` parameter in `-initWithServices:params:` method.
@property(nonatomic, strong, readonly) id <KSViewModelServices> services;

// The `params` parameter in `-initWithServices:params:` method.
@property(nonatomic, strong, readonly) id params;

@optional

@property(nonatomic, assign) KSTitleViewType titleViewType;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;

// The callback block.
@property(nonatomic, copy) VoidBlock_id callback;

// A RACSubject object, which representing all errors occurred in view model.
@property(nonatomic, strong, readonly) RACSubject *errors;


@property(nonatomic, assign) BOOL shouldFetchLocalDataOnViewModelInitialize;
@property(nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

@property(nonatomic, strong, readonly) RACSubject *willDisappearSignal;

// An additional method, in which you can initialize data, RACCommand etc.
//
// This method will be execute after the execution of `-initWithServices:params:` method. But
// the premise is that you need to inherit `MRCViewModel`.
- (void)initialize;

@end
