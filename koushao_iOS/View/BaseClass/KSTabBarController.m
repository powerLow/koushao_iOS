//
//  KSTabBarController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSTabBarController.h"

@interface KSTabBarController ()

@end

@implementation KSTabBarController

@synthesize viewModel = _viewModel;

- (id<KSViewProtocol>)initWithViewModel:(id)viewModel {
    _viewModel = viewModel;
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}

@end
