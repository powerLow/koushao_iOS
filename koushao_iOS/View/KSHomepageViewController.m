//
//  KSHomepageViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/12.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSHomepageViewController.h"
#import "KSHomepageViewModel.h"
#import "KSActivityListViewController.h"
#import "KSProfileViewController.h"
#import "KSTabbar.h"
#import "KSCreateActivityViewNavController.h"
#import "HyPopMenuView.h"
#import "MenuLabel.h"
#import "KSActivityCreatManager.h"
#import "ActivityFunctionViewController.h"
#import "KSPopMenu.h"
#import "CustomIOSAlertView.h"
#import "Masonry.h"
#import "KSButton.h"
#import "CTIconButtonBottomPoper.h"
#import <MessageUI/MessageUI.h>
#import "KSActivity.h"
#import <YYWebImage.h>
#import "RACAFNetworking.h"

@interface KSHomepageViewController () <UITabBarControllerDelegate, KSTabBarDelegate,MFMessageComposeViewControllerDelegate>

@property(nonatomic, strong, readonly) KSHomepageViewModel *viewModel;
@property(nonatomic, strong) KSPopMenu *popMenu;

@property(nonatomic, strong) KSActivityListViewController *activityListViewController;
@property(nonatomic, strong) KSProfileViewController *profileViewController;

@property(nonatomic, strong) KSActivityCreatManager *activityManager;

@property(nonatomic,strong)UIImageView* thumbnailImageView;
@end

@implementation KSHomepageViewController

@dynamic viewModel;
- (KSPopMenu*)popMenu {
    if (!_popMenu) {
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:2];
        KSUser *user = [KSUser currentUser];
        NSArray *titles = @[[NSString stringWithFormat:@"账号:%@",user.username],@"退出"];
        for (int i=0; i<titles.count; ++i) {
            NSString *title = titles[i];
            KSPopMenuItem *popMenuItem = [[KSPopMenuItem alloc] initWithImage:nil title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        KSPopMenu *popMenu = [[KSPopMenu alloc] initWithMenus:popMenuItems];
        popMenu.popMenuSelected = ^(NSInteger index, KSPopMenuItem *item) {
            switch (index) {
                case 0:{
                    NSLog(@"账号被点击");
                    break;
                }
                case 1:{
                    NSLog(@"退出");
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定退出? " delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *indexNumber) {
                        if ([indexNumber intValue] == 1) {
                            NSLog(@"取消");
                        } else {
                            [self.viewModel.didLogoutBtnClick execute:@1];
                        }
                    }];
                    [alertView show];
                    break;
                }
            }
        };
        _popMenu = popMenu;
    }
    
    return _popMenu;
}

- (void)rightBtnClick:(id)button {
    NSLog(@"rightBtnClick = %@",self.popMenu);
    [self.popMenu showMenuOnView:self.view atPoint:CGPointZero];
}
-(void)createNewActivityAlertView
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    UIView *customView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 110)];
    UILabel* textLabel=[[UILabel alloc]init];
    [customView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(customView.mas_centerY).with.offset(30);
        make.left.mas_equalTo(customView.mas_left).with.offset(16);
        make.right.mas_equalTo(customView.mas_right).with.offset(-16);
        make.height.mas_equalTo(50);
    }];
    
    textLabel.textAlignment = NSTextAlignmentLeft;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"是否创建新活动,此操作会清除所有的未发布的活动草稿"];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(8, 17)];
    
    textLabel.attributedText = AttributedStr;
    textLabel.lineBreakMode=NSLineBreakByCharWrapping;
    textLabel.numberOfLines = 0;
    
    UILabel* titleLabel=[[UILabel alloc]init];
    [customView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(customView.mas_top).with.offset(30);
        make.left.mas_equalTo(customView.mas_left).with.offset(16);
        make.right.mas_equalTo(customView.mas_right).with.offset(-16);
        make.height.mas_equalTo(50);
    }];
    titleLabel.text=@"创建新活动";
    titleLabel.font=[UIFont boldSystemFontOfSize:19];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    
    [alertView setContainerView:customView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
    [alertView setButtonColors:[NSMutableArray arrayWithObjects:[UIColor blackColor], KS_Maintheme_Color, nil]];
    
    [alertView show];
    
    @weakify(self);
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        @strongify(self);
        if(buttonIndex==0)
            [alertView close];
        else
        {
            KSCreateActivityViewNavController *ksCreateActivityViewNavController = [[KSCreateActivityViewNavController alloc] init];
            [self.activityManager clearInfo];
            [self.activityManager ks_delete];
            self.activityManager = [KSActivityCreatManager sharedManager];
            [self presentViewController:ksCreateActivityViewNavController animated:YES completion:nil];
            [alertView close];
            
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityManager = [KSActivityCreatManager sharedManager];
    _thumbnailImageView=[[UIImageView alloc]init];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 使用自定义的TabBar
    KSTabbar *ksTabBar = [[KSTabbar alloc] init];
    ksTabBar.ksTabBarDelegate = self;
    // 重设tabBar，由于tabBar是只读成员，使用KVC相当于直接修改_tabBar
    [self setValue:ksTabBar forKey:@"tabBar"];
    KSUser *user = [KSUser currentUser];
    if (user.isSubAccount) {
        //子账号
        [self.tabBar setHidden:YES];
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"baritem_profile"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick:)];
        self.navigationItem.rightBarButtonItem = btn;
    }
    
    self.activityListViewController = [[KSActivityListViewController alloc] initWithViewModel:self.viewModel.activityListViewModel];
    UIImage *listImage = [UIImage imageNamed:@"activity_list_icon"];
    self.activityListViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"活动" image:listImage tag:1];
    [self setTabBarItemSelectImgae:self.activityListViewController.tabBarItem image:@"activity_list_icon_select"];
    
    
    self.profileViewController = [[KSProfileViewController alloc] initWithViewModel:self.viewModel.profileViewModel];
    UIImage *profileImage = [UIImage imageNamed:@"my_icon"];
    self.profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:profileImage tag:2];
    [self setTabBarItemSelectImgae:self.profileViewController.tabBarItem image:@"my_icon_select"];
    
    
    self.viewControllers = @[self.activityListViewController, self.profileViewController];
    
    [[[self
       rac_signalForSelector:@selector(tabBarController:didSelectViewController:)
       fromProtocol:@protocol(UITabBarControllerDelegate)]
      startWith:RACTuplePack(self, self.activityListViewController)]
     subscribeNext:^(RACTuple *tuple) {
         RACTupleUnpack(UITabBarController * tabBarController, UIViewController * viewController) = tuple;
         tabBarController.navigationItem.title = [((KSViewController *) viewController).viewModel title];
         if (viewController.tabBarItem.tag == 1) {
             tabBarController.navigationItem.titleView = nil;
         } else if (viewController.tabBarItem.tag == 2) {
             tabBarController.navigationItem.titleView = nil;
         }
     }];
    self.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onActivityPublished:) name:ACTIVITY_PUBLISH_FINISH object:nil];
    
    
}

- (void)setTabBarItemSelectImgae:(UITabBarItem *)tabBarItem image:(NSString *)imageName {
    UIImage *selectedImage = [UIImage imageNamed:imageName];
    // 如果是iOS7，不要渲染被选中的tab图标（iOS7中会自动渲染成为蓝色）
    if (iOS7) {
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    tabBarItem.selectedImage = selectedImage;
}

- (void)initPopView {
    NSArray *Objs = @[
                      [MenuLabel CreatelabelIconName:@"icon_creat_newact" Title:@"创建新活动"],
                      [MenuLabel CreatelabelIconName:@"icon_editor_oldact" Title:@"返回上次编辑"],
                      ];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    
    CGFloat marginX = SCREEN_WIDTH * 0.1;
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text =[NSString stringWithFormat:@"%li月%li日",(long)month,(long)day];
    dateLabel.font = [UIFont systemFontOfSize:50];
    dateLabel.frame = CGRectMake(marginX, 40 + 30, 260, 60);
    dateLabel.textColor = [UIColor blackColor];
    [topView addSubview:dateLabel];
    
    UILabel *weekLabel = [[UILabel alloc] init];
    weekLabel.text = [KSUtil weekdayStringFromDate:now];
    weekLabel.font = [UIFont systemFontOfSize:50];
    weekLabel.frame = CGRectMake(marginX, 90 + 30, 260, 60);
    weekLabel.textColor = [UIColor blackColor];
    [topView addSubview:weekLabel];
    
    UILabel *solganLabel = [[UILabel alloc] init];
    solganLabel.text = @"活动是生活的基础！ ——歌德";
    solganLabel.font = [UIFont systemFontOfSize:15];
    solganLabel.frame = CGRectMake(marginX, 150 + 60, 260, 60);
    solganLabel.textColor = [UIColor blackColor];
    [topView addSubview:solganLabel];
    
    [HyPopMenuView CreatingPopMenuObjectItmes:Objs TopView:topView OpenOrCloseAudioDictionary:nil SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
        //        NSLog(@"index:%ld ItmeNmae:%@", index, menuLabel.title);
        KSCreateActivityViewNavController *ksCreateActivityViewNavController = [[KSCreateActivityViewNavController alloc] init];
        
        if (index == 0) //创建新的活动
        {
            [self createNewActivityAlertView];
        }
        else //返回上次活动编辑
        {
            if(self.activityManager.isTempleteSettingComplete)
            {
                ActivityFunctionViewController *activityFunctionViewNavController = [[ActivityFunctionViewController alloc] init];
                ksCreateActivityViewNavController.startViewController = activityFunctionViewNavController;
            }
            [self presentViewController:ksCreateActivityViewNavController animated:YES completion:nil];
        }
        
    }];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.viewModel.isStartButtonPressed)
    {
        
        [self tabBarDidComposeButtonClick:nil];
        self.viewModel.isStartButtonPressed=NO;
    }
    
}
#pragma mark - HVWTabBarDelegate

- (void)tabBarDidComposeButtonClick:(KSTabbar *)tabBar {
    
    
    self.activityManager = [KSActivityCreatManager sharedManager];
    if (self.activityManager.hashCode && self.activityManager.hashCode.length != 0) {
        [self initPopView];
    }
    else {
        KSCreateActivityViewNavController *ksCreateActivityViewNavController = [[KSCreateActivityViewNavController alloc] init];
        [self presentViewController:ksCreateActivityViewNavController animated:YES completion:nil];
    }
}

- (void)onActivityPublished:(NSNotification*) notif {
    KSActivity* activity=notif.object;
    [self downloadImage:activity withSuccessBlock:nil];
    [[[self getShortUrl:activity] doNext:^(id x) {
        NSLog(@"读取缓存短网址 = %@",activity.shortUrl);
    }] subscribeNext:^(RACTuple *JSONAndHeaders) {
        RACTupleUnpack(NSArray *result, NSHTTPURLResponse *response) = JSONAndHeaders;
        if (response.statusCode == 200) {
            activity.shortUrl = result[0][@"url_short"];
            NSLog(@"url_short = %@", activity.shortUrl);
        }
    }];
    
    [self.activityManager ks_delete];
    [self.activityManager clearInfo];
    [self createSocialShareDialog:activity];
}
-(void)downloadImage:(KSActivity*)activity withSuccessBlock:(void (^)())successBlock
{
    NSString *defaultUrl = activity.poster;
    if ([defaultUrl length] == 0) {
        defaultUrl = activity.cover_pic;
    }
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",defaultUrl,@"?imageView2/0/h/70"];
    NSURL *url = [[NSURL alloc] initWithString:imageUrl];
    
    [self.thumbnailImageView yy_setImageWithURL:url
                                    placeholder:nil
                                        options:YYWebImageOptionSetImageWithFadeAnimation
                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                           
                                       }
                                      transform:^UIImage *(UIImage *image, NSURL *url) {
                                          
                                          return image;
                                      }
                                     completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                         if (from == YYWebImageFromDiskCache) {
                                             NSLog(@"load from disk cache");
                                         }
                                         activity.thumbnail = image;
                                         if(successBlock)
                                             successBlock();
                                     }];
}
- (RACSignal *)getShortUrl:(KSActivity*)activity {
    
    NSURL *shortUrl = [NSURL URLWithString:@"http://api.t.sina.com.cn/"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
                                              initWithBaseURL:shortUrl];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *longurl = [NSString stringWithFormat:@"http://m.koushaoapp.com/activity/%@", activity.sig];
    NSDictionary *params = @{
                             @"source" : @"3918506055",
                             @"url_long" : longurl,
                             };
    return [manager rac_GET:@"short_url/shorten.json" parameters:params];
}
-(void)createSocialShareDialog:(KSActivity*)activity
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    UIView *customView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 300)];
    UIImageView* rocketIcon=[[UIImageView alloc]init];
    rocketIcon.image=[UIImage imageNamed:@"rocket"];
    [customView addSubview:rocketIcon];
    [rocketIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(120);
        make.width.mas_equalTo(120);
        make.top.mas_equalTo(customView.mas_top).with.offset(30);
        make.centerX.mas_equalTo(customView.mas_centerX);
    }];
    UILabel* textLabel=[[UILabel alloc]init];
    textLabel.text=@"这么精彩的活动赶快分享出去吧～";
    textLabel.textAlignment=NSTextAlignmentCenter;
    textLabel.font=[UIFont systemFontOfSize:14];
    textLabel.textColor=[UIColor grayColor];
    
    [customView addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(rocketIcon.mas_bottom).with.offset(40);
        make.centerX.mas_equalTo(rocketIcon.mas_centerX);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(customView.mas_width);
    }];
    
    KSButton* shareButton=[[KSButton alloc]init];
    shareButton.buttonColor=KS_Maintheme_Color2;
    [shareButton setTitle:@"分享活动" forState:UIControlStateNormal];
    shareButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [customView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(customView.mas_left).with.offset(16);
        make.right.mas_equalTo(customView.mas_right).with.offset(-16);
        make.bottom.mas_equalTo(customView.mas_bottom).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
    [[shareButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        if(activity.thumbnail&&activity.shortUrl&&activity.shortUrl.length!=0)
            [self initSocialSharePopView:activity];
        else
        {
            if(!activity.thumbnail)
            {
                [self downloadImage:activity withSuccessBlock:^(){
                    if(activity.thumbnail&&activity.shortUrl&&activity.shortUrl.length!=0)
                        [self initSocialSharePopView:activity];
                    else
                    {
                        [[[self getShortUrl:activity] doNext:^(id x) {
                            NSLog(@"读取缓存短网址 = %@",activity.shortUrl);
                        }] subscribeNext:^(RACTuple *JSONAndHeaders) {
                            RACTupleUnpack(NSArray *result, NSHTTPURLResponse *response) = JSONAndHeaders;
                            if (response.statusCode == 200) {
                                activity.shortUrl = result[0][@"url_short"];
                                NSLog(@"url_short = %@", activity.shortUrl);
                                [self initSocialSharePopView:activity];
                            }
                        }];
                    }
                }];
            }
            if((!activity.shortUrl)||(activity.shortUrl.length==0))
            {
                [[[self getShortUrl:activity] doNext:^(id x) {
                    NSLog(@"读取缓存短网址 = %@",activity.shortUrl);
                }] subscribeNext:^(RACTuple *JSONAndHeaders) {
                    RACTupleUnpack(NSArray *result, NSHTTPURLResponse *response) = JSONAndHeaders;
                    if (response.statusCode == 200) {
                        activity.shortUrl = result[0][@"url_short"];
                        NSLog(@"url_short = %@", activity.shortUrl);
                        if(activity.thumbnail&&activity.shortUrl&&activity.shortUrl.length!=0)
                            [self initSocialSharePopView:activity];
                        else
                        {
                            [self downloadImage:activity withSuccessBlock:^(){
                                if(activity.thumbnail&&activity.shortUrl&&activity.shortUrl.length!=0)
                                    [self initSocialSharePopView:activity];
                            }];
                        }
                    }
                }];
            }
        }
        
        [alertView close];
    }];
    
    [alertView setContainerView:customView];
    [alertView show];
}

-(void)initSocialSharePopView:(KSActivity*)activity
{
    
    NSArray* socialSharebuttons=[NSArray arrayWithObjects:
                                 [CTIconButtonModel buttonWithText:@"微信" andIcon:@"weixin_icon"],
                                 [CTIconButtonModel buttonWithText:@"朋友圈" andIcon:@"pengyouquan_icon"],
                                 [CTIconButtonModel buttonWithText:@"QQ好友" andIcon:@"qq_icon"],
                                 [CTIconButtonModel buttonWithText:@"QQ空间" andIcon:@"qzone_icon"],
                                 [CTIconButtonModel buttonWithText:@"新浪微博" andIcon:@"weibo_icon"],
                                 nil];
    NSArray* localSharebuttons=[NSArray arrayWithObjects:
                                [CTIconButtonModel buttonWithText:@"复制活动链接" andIcon:@"copy_link_icon"],
                                [CTIconButtonModel buttonWithText:@"发送手机联系人" andIcon:@"send_to_phone_contact"],
                                nil];
    CTIconButtonBottomPoper* poper=[[CTIconButtonBottomPoper alloc]initWithButtons:[NSArray arrayWithObjects:socialSharebuttons,localSharebuttons, nil]];
    poper.onButtonItemClicked=^(NSIndexPath* indexPath){
        
        [UMSocialData defaultData].extConfig.title = activity.title;
        NSString *url = [NSString stringWithFormat:@"http://m.koushaoapp.com/activity/%@", activity.sig];
        //活动时间
        NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:[activity.startTime unsignedIntegerValue]];
        NSDateFormatter *ft = [NSDateFormatter new];
        ft.dateFormat = @"yyyy-MM-dd";
        NSString *strStartTime = [ft stringFromDate:startTime];
        
        NSString *content = [NSString stringWithFormat:@"活动时间:%@ 活动地点:%@ ", strStartTime, activity.location];
        
        if(indexPath.section==0)
        {
            switch (indexPath.row) {
                case 0:
                {
                    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
                    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:content image:activity.thumbnail location:nil urlResource:nil presentedController:(UIViewController *) self completion:^(UMSocialResponseEntity *response) {
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            NSLog(@"weixin 分享成功！");
                        }
                    }];
                }
                    break;
                case 1:
                {
                    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
                    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:activity.thumbnail location:nil urlResource:nil presentedController:(UIViewController *) self completion:^(UMSocialResponseEntity *response) {
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            NSLog(@"朋友圈 分享成功！");
                        }
                    }];
                }
                    break;
                case 2:
                {
                    [UMSocialData defaultData].extConfig.qqData.url = url;
                    [UMSocialQQHandler setQQWithAppId:QQID appKey:QQKey url:url];
                    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
                    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:content image:activity.thumbnail location:nil urlResource:nil presentedController:(UIViewController *) self completion:^(UMSocialResponseEntity *response) {
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            NSLog(@"QQ 分享成功！");
                        }
                    }];
                }
                    break;
                case 3:
                {
                    [UMSocialData defaultData].extConfig.qzoneData.url = url;
                    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:content image:activity.thumbnail location:nil urlResource:nil presentedController:(UIViewController *) self completion:^(UMSocialResponseEntity *response) {
                        if (response.responseCode == UMSResponseCodeSuccess) {
                            NSLog(@"空间 分享成功！");
                        }
                    }];
                }
                    break;
                case 4:
                {
                    NSString *wbcontent = [NSString stringWithFormat:@"我发起了活动【%@】 %@ 详情地址：%@", activity.title, content, activity.shortUrl];
                    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = url;
                    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
                    authRequest.redirectURI = WeiBoRedirectURI;
                    authRequest.scope = @"all";
                    
                    WBMessageObject *message = [WBMessageObject message];
                    WBImageObject *image = [WBImageObject object];
                    image.imageData = UIImagePNGRepresentation(activity.thumbnail);
                    message.imageObject = image;
                    message.text = wbcontent;
                    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
                    request.userInfo = @{@"ShareMessageFrom": @"KSActivityShareViewModel"};
                    [WeiboSDK sendRequest:request];
                }
                    
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            switch (indexPath.row) {
                case 0:
                {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = activity.shortUrl;
                    [[self rac_signalForSelector:@selector(backgroundColorForMessageType:) fromProtocol:@protocol(TWMessageBarStyleSheet)] map:^id(id value) {
                        return [UIColor redColor];
                    }];
                    KSSuccess(@"分享链接已经复制到剪贴板~");
                }
                    break;
                case 1:
                {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://13888888888"]];
                    //发送短信
                    MFMessageComposeViewController *smsController = [[MFMessageComposeViewController alloc] init];
                    smsController.navigationBar.tintColor = [UIColor whiteColor];
                    [smsController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
                    smsController.messageComposeDelegate = self;
                    
                    NSString *wbcontent = [NSString stringWithFormat:@"我发起了活动【%@】 %@ 详情地址：%@", activity.title, content, activity.shortUrl];;
                    [smsController setBody:wbcontent];
                    [self presentViewController:smsController animated:YES completion:nil];
                }
                    break;
                    
                default:
                    break;
            }
        }
    };
    poper.title=@"分享至";
    poper.showCancelButton=YES;
    poper.applyBlurEffect=YES;
    [poper pop];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    NSLog(@"发送短信完毕 = %d", result);
    switch (result) {
        case MessageComposeResultCancelled: NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent: NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送短信失败" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [[alert rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(id x) {
                NSLog(@"关闭 确定");
            }];
        }
            break;
        default: NSLog(@"Result: SMS not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
