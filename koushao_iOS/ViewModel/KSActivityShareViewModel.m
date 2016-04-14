//
//  KSActivityShareViewModel.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityShareViewModel.h"
#import "KSActivityShareViewController.h"
#import "KSActivity.h"
#import <MessageUI/MessageUI.h>

@interface KSActivityShareViewModel () <MFMessageComposeViewControllerDelegate>

@property(nonatomic, strong, readwrite) RACCommand *didClickWeixinBtnCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickFriendBtnCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickWeiboBtnCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickQQBtnCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickQzoneBtnCommand;

@property(nonatomic, strong, readwrite) RACCommand *didClickCopyLinkBtnCommand;
@property(nonatomic, strong, readwrite) RACCommand *didClickSendContactBtnCommand;

@property(nonatomic, strong, readwrite) KSActivity *activity;
@end

@implementation KSActivityShareViewModel

- (void)initialize {
    [super initialize];
    self.title = @"分享活动";
    self.activity = [KSUtil getCurrentActivity];
    [UMSocialData defaultData].extConfig.title = self.activity.title;
    NSString *url = [NSString stringWithFormat:@"http://m.koushaoapp.com/activity/%@", self.activity.sig];

    //活动时间
    NSDate *startTime = [NSDate dateWithTimeIntervalSince1970:[self.activity.startTime unsignedIntegerValue]];
    NSDateFormatter *ft = [NSDateFormatter new];
    ft.dateFormat = @"yyyy-MM-dd";
    NSString *strStartTime = [ft stringFromDate:startTime];

    NSString *content = [NSString stringWithFormat:@"活动时间:%@ 活动地点:%@ ", strStartTime, self.activity.location];

    @weakify(self)
    //微信分享
    self.didClickWeixinBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:content image:self.activity.thumbnail location:nil urlResource:nil presentedController:(UIViewController *) self.vc completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"weixin 分享成功！");
            }
        }];
        return [RACSignal empty];
    }];
    //朋友圈
    self.didClickFriendBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:content image:self.activity.thumbnail location:nil urlResource:nil presentedController:(UIViewController *) self.vc completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"朋友圈 分享成功！");
            }
        }];

        return [RACSignal empty];
    }];

    //微博
    self.didClickWeiboBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSString *wbcontent = [NSString stringWithFormat:@"我发起了活动【%@】 %@ 详情地址：%@", self.activity.title, content, self.activity.shortUrl];;
        [UMSocialData defaultData].extConfig.sinaData.urlResource.url = url;
//        KSAppDelegate *myDelegate =(KSAppDelegate*)[[UIApplication sharedApplication] delegate];
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = WeiBoRedirectURI;
        authRequest.scope = @"all";
        
        WBMessageObject *message = [WBMessageObject message];
        WBImageObject *image = [WBImageObject object];
        image.imageData = UIImagePNGRepresentation(self.activity.thumbnail);
        message.imageObject = image;
        message.text = wbcontent;
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
        request.userInfo = @{@"ShareMessageFrom": @"KSActivityShareViewModel"};
        //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        [WeiboSDK sendRequest:request];
        return [RACSignal empty];
    }];

    //QQ
    self.didClickQQBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {

        [UMSocialData defaultData].extConfig.qqData.url = url;

        [UMSocialQQHandler setQQWithAppId:QQID appKey:QQKey url:url];
        [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:content image:self.activity.thumbnail location:nil urlResource:nil presentedController:(UIViewController *) self.vc completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"QQ 分享成功！");
            }
        }];
        return [RACSignal empty];
    }];
    //空间
    self.didClickQzoneBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [UMSocialData defaultData].extConfig.qzoneData.url = url;
        [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:content image:self.activity.thumbnail location:nil urlResource:nil presentedController:(UIViewController *) self.vc completion:^(UMSocialResponseEntity *response) {
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"空间 分享成功！");
            }
        }];

        return [RACSignal empty];
    }];
    //复制链接
    self.didClickCopyLinkBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.activity.shortUrl;
        [[self rac_signalForSelector:@selector(backgroundColorForMessageType:) fromProtocol:@protocol(TWMessageBarStyleSheet)] map:^id(id value) {
            return [UIColor redColor];
        }];
        KSSuccess(@"分享链接已经复制到剪贴板~");
        return [RACSignal empty];
    }];
    //发送给联系人
    self.didClickSendContactBtnCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://13888888888"]];
        //发送短信
        MFMessageComposeViewController *smsController = [[MFMessageComposeViewController alloc] init];
        smsController.navigationBar.tintColor = [UIColor whiteColor];
        [smsController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        smsController.messageComposeDelegate = self;

        NSString *wbcontent = [NSString stringWithFormat:@"我发起了活动【%@】 %@ 详情地址：%@", self.activity.title, content, self.activity.shortUrl];;
        [smsController setBody:wbcontent];//可以写一个方法专门组复杂的字符串在这调用即可
        [self.vc presentViewController:smsController animated:YES completion:nil];
        return [RACSignal empty];
    }];

}

#pragma mark - MFMessageComposeViewControllerDelegate

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
    [self.vc dismissViewControllerAnimated:YES completion:nil];
}

@end
