//
//  KSNavigationControllerStack.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSNavigationControllerStack.h"
#import "KSRouter.h"
#import "KSNavigationController.h"


@interface KSNavigationControllerStack()

@property (nonatomic, strong) id<KSViewModelServices> services;
@property (nonatomic, strong) NSMutableArray *navigationControllers;

@end

@implementation KSNavigationControllerStack


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    KSNavigationControllerStack *navigationControllerStack = [super allocWithZone:zone];
    
    @weakify(navigationControllerStack)
    [[navigationControllerStack
      rac_signalForSelector:@selector(initWithServices:)]
    	subscribeNext:^(id x) {
            @strongify(navigationControllerStack)
            [navigationControllerStack registerNavigationHooks];
        }];
    
    return navigationControllerStack;
}

- (instancetype)initWithServices:(id<KSViewModelServices>)services {
    self = [super init];
    if (self) {
        _services = services;
        _navigationControllers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)pushNavigationController:(UINavigationController *)navigationController {
    if ([self.navigationControllers containsObject:navigationController]) return;
    [self.navigationControllers addObject:navigationController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController *navigationController = self.navigationControllers.lastObject;
    [self.navigationControllers removeLastObject];
    return navigationController;
}

- (UINavigationController *)topNavigationController {
    return self.navigationControllers.lastObject;
}

//Nav的跳转控制
- (void)registerNavigationHooks {
    @weakify(self)
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(pushViewModel:animated:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         UIViewController *viewController = (UIViewController *)[KSRouter.sharedInstance viewControllerForViewModel:tuple.first];
         [self.navigationControllers.lastObject pushViewController:viewController animated:[tuple.second boolValue]];
     }];
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
        	@strongify(self)
        	[self.navigationControllers.lastObject popViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popToRootViewModelAnimated:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self.navigationControllers.lastObject popToRootViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(presentViewModel:animated:completion:)]
     subscribeNext:^(RACTuple *tuple) {
        	@strongify(self)
         UIViewController *viewController = (UIViewController *)[KSRouter.sharedInstance viewControllerForViewModel:tuple.first];
         
         UINavigationController *presentingViewController = self.navigationControllers.lastObject;
         if (![viewController isKindOfClass:UINavigationController.class]) {
             viewController = [[KSNavigationController alloc] initWithRootViewController:viewController];
         }
         [self pushNavigationController:(UINavigationController *)viewController];
         
         [presentingViewController presentViewController:viewController animated:[tuple.second boolValue] completion:tuple.third];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(dismissViewModelAnimated:completion:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         [self popNavigationController];
         [self.navigationControllers.lastObject dismissViewControllerAnimated:[tuple.first boolValue] completion:tuple.second];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(resetRootViewModel:)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         UIViewController *viewController = (UIViewController *)[KSRouter.sharedInstance viewControllerForViewModel:tuple.first];
         
         if (![viewController isKindOfClass:UINavigationController.class]) {
             viewController = [[KSNavigationController alloc] initWithRootViewController:viewController];
         }
         
         [self.navigationControllers removeAllObjects];
         [self pushNavigationController:(UINavigationController *)viewController];
         
         KSSharedAppDelegate.window.rootViewController = viewController;
     }];
}

@end
