//
//  KSViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewController.h"
#import "KSViewModel.h"
#import "KSViewProtocol.h"
#import "MobClick.h"
@interface KSViewController ()

@property (nonatomic, strong, readwrite) KSViewModel *viewModel;


@end

@implementation KSViewController

@synthesize viewModel = _viewModel;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    KSViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    
    return viewController;
}

- (id<KSViewProtocol>)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@",[NSString stringWithUTF8String:object_getClassName(self)]);
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
    [self.viewModel.willDisappearSignal sendNext:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)bindViewModel {
    // System title view
    RAC(self, title) = RACObserve(self.viewModel, title);
    
//    UIView *titleView = self.navigationItem.titleView;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return isPad ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
