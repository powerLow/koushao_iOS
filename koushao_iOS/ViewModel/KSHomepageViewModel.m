//
//  KSHomepageViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSHomepageViewModel.h"
#import "KSStartpageViewModel.h"
#import "KSActivityConsultReplyViewModel.h"
#import "KSActivity.h"
#import "APService.h"
@interface KSHomepageViewModel ()

@property(nonatomic, strong, readwrite) KSActivityListViewModel *activityListViewModel;
@property(nonatomic, strong, readwrite) KSProfileViewModel *profileViewModel;
@property (nonatomic,strong,readwrite) RACCommand *didLogoutBtnClick;
@end

@implementation KSHomepageViewModel


- (void)initialize {
    [super initialize];
    KSUser *user = [KSUser currentUser];
    //初始化数据库,以当前用户手机号为数据库名字
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:user.mobilePhone];
    //用户表
    [store createTableWithName:KS_DATABASE_TABLENAME_USER];
    //活动表
    [store createTableWithName:KS_DATABASE_TABLENAME_ACTIVITY];
    //myinfo
    [store createTableWithName:KS_DATABASE_TABLENAME_MYINFO];
    //缓存
    [[KSMemoryCache sharedInstance] setObject:store forKey:@"userdb"];
    
    self.profileViewModel = [[KSProfileViewModel alloc] initWithServices:self.services params:nil];
    self.activityListViewModel = [[KSActivityListViewModel alloc] initWithServices:self.services params:nil];
    
    self.didLogoutBtnClick = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"子账户退出登陆");
        KSStartpageViewModel *startViewModel = [[KSStartpageViewModel alloc] initWithServices:self.services params:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.services resetRootViewModel:startViewModel];
        });
        [[KSClientApi logout] subscribeCompleted:^{
            [APService setAlias:@"" callbackSelector:nil object:nil];
            
        }];
        return [RACSignal empty];
    }];
    
    //推送通知跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToConsult:) name:NOTIFICATION_NEW_CONSULT object:nil];
    
}
-(instancetype)initWithServices:(id<KSViewModelServices>)services params:(id)params
{
    self= [super initWithServices:services params:params];
    if(self)
    {
        NSString* isStartPressed=[params valueForKey:@"isStartButtonPressed"];
        if(isStartPressed&&[isStartPressed isEqualToString:@"YES"])
        {
            _isStartButtonPressed=YES;
        }
        else _isStartButtonPressed=NO;
    }
    return self;
    
}
-(void)jumpToConsult:(NSNotification*) notification
{
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    NSString* hashCode = [notification object];
    KSActivity *curAct = [KSUtil getCurrentActivity];
    if (![hashCode isEqualToString:curAct.hashCode]) {
        //如果不是当前使用的activity对象，再重新构造一个
        KSActivity* activity=[[KSActivity alloc]init];
        activity.hashCode=hashCode;
        [KSUtil cacheCurrentActivity:activity];
    }
    KSActivityConsultReplyViewModel *viewModel = [[KSActivityConsultReplyViewModel alloc] initWithServices:self.services params:nil];
    [self.services pushViewModel:viewModel animated:YES];
}

@end
