//
//  KSRouter.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/13.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSRouter.h"
#import "KSViewProtocol.h"

static KSRouter *_sharedInstance = nil;

@interface KSRouter ()

@property(nonatomic, copy) NSDictionary *viewModelViewMappings; // viewModel到view的映射

@end


@implementation KSRouter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[super allocWithZone:NULL] init];
    });
    return _sharedInstance;
}

- (id <KSViewProtocol>)viewControllerForViewModel:(id <KSViewModelProtocol>)viewModel {
    NSString *viewController = [self.viewModelViewMappings valueForKey:NSStringFromClass(((NSObject *) viewModel).class)];

    NSParameterAssert([NSClassFromString(viewController) conformsToProtocol:@protocol(KSViewProtocol)]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);

    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}

- (NSDictionary *)viewModelViewMappings {
    return @{
            @"KSLoginViewModel" : @"KSLoginViewController",
            @"KSHomepageViewModel" : @"KSHomepageViewController",
            @"KSStartpageViewModel" : @"KSStartpageViewController",
            @"KSLoginSubViewModel" : @"KSLoginSubViewController",
            @"KSProfileViewModel" : @"KSProfileViewController",
            @"KSActivityListViewModel" : @"KSActivityListViewController",
            @"KSMyDataViewModel" : @"KSMyDataViewController",
            @"KSMyMoneyInfoViewModel" : @"KSMyMoneyInfoViewController",
            @"KSActivityManagerViewModel" : @"KSActivityManagerViewController",
            @"KSActivityShareViewModel" : @"KSActivityShareViewController",
            @"KSActivityConsultReplyViewModel" : @"KSActivityConsultReplyViewController",
            @"KSActivityWelfareManagerViewModel" : @"KSActivityWelfareManagerViewController",
            @"KSActivitySignManagerViewModel" : @"KSActivitySignManagerViewController",
            @"KSActivityAdminManagerViewModel" : @"KSActivityAdminManagerViewController",
            @"KSBrowseDetailViewModel" : @"KSBrowseDetailViewController",
            @"KSEnrollDetailViewModel" : @"KSEnrollDetailViewController",
            @"KSEnrollRecordViewModel" : @"KSEnrollRecordViewController",
            @"KSEnrollRecordDetailViewModel" : @"KSEnrollRecordDetailViewController",
            @"KSActivitySignRecordViewModel" : @"KSActivitySignRecordViewController",
            @"KSActivityUserSignViewModel" : @"KSActivityUserSignViewController",
            @"KSActivitySignCodeViewModel" : @"KSActivitySignCodeViewController",
            @"KSSignCodeResultViewModel" : @"KSSignCodeResultViewController",
            @"KSActivitySignQRCodeViewModel" : @"KSActivitySignQRCodeViewController",
            @"KSActivityWelfareQRCodeViewModel" : @"KSActivityWelfareQRCodeViewController",
            @"KSActivityWelfareSmsCodeViewModel" : @"KSActivityWelfareSmsCodeViewController",
            @"KSSignRecordDetailViewModel" : @"KSSignRecordDetailViewController",
            @"KSActivityWelfareRecordViewModel" : @"KSActivityWelfareRecordViewController",
            @"KSWelfareCodeResultViewModel" : @"KSWelfareCodeResultViewController",
            @"KSActivityWelfareGiftListViewModel" : @"KSWelfareGiftListViewController",
            @"KSConfirmGfitViewModel" : @"KSConfirmGfitViewController",
            @"KSConfirmResultViewModel" : @"KSConfirmResultViewController",
            @"KSKuaidiWebViewModel" : @"KSKuaidiWebViewController",
            @"KSActivityAdminListViewModel" : @"KSActivityAdminListViewController",
            @"KSWelfareRecordItemDetailViewModel" : @"KSWelfareRecordItemDetailViewController",
            @"KSWelfareStatisticsViewModel" : @"KSWelfareStatisticsViewController",
            @"KSProfileDetailViewModel" : @"KSProfileDetailViewController",
            @"KSFeedBackViewModel" : @"KSFeedBackViewController",
            @"KSAboutUsViewModel" : @"KSAboutUsViewController",
            @"KSDrawMoneyViewModel" : @"KSDrawMoneyViewController",
            @"KSCumulativeAmountListViewModel":@"KSCumulativeAmountListViewController",
            @"KSWithdrawMoneyListViewModel":@"KSWithdrawMoneyListViewController"
    };
}


@end
