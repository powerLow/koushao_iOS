//
//  ActivityPreviewViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/20.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "ActivityPreviewViewController.h"
#import "KSActivityCreatManager.h"
#import "Masonry.h"

@interface ActivityPreviewViewController ()
@property(nonatomic,strong)UIWebView* webView;
@property(nonatomic,strong)KSActivityCreatManager* activityManager;
@property(nonatomic,strong)UILabel* cover;

@end
@implementation ActivityPreviewViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self initTitleBar];
}
-(void)initData
{
    self.activityManager=[KSActivityCreatManager sharedManager];
    self.title=@"活动预览";
}

-(void)initView
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    NSString *url=[NSString stringWithFormat:@"%@%@?%@",PREVIEW_URL,self.activityManager.sig,timeString];
    self.webView=[[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    self.webView.delegate=self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:request];
    self.cover=[[UILabel alloc]init];
    self.cover.textAlignment=NSTextAlignmentCenter;
    self.cover.text=@"预览界面 仅供参考";
    self.cover.textColor=[UIColor whiteColor];
    self.cover.backgroundColor=[KSUtil colorWithHexString:@"#666666"];
    self.cover.alpha=0.2;
    self.cover.font=[UIFont boldSystemFontOfSize:40];
    [self.view addSubview:self.cover];
    [self.cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-48);
    }];
    self.cover.hidden=YES;
    self.cover.userInteractionEnabled=YES;
}

-(void)initTitleBar
{
    
    UIButton* backButton=[[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
    [backButton setTitle:@"后退" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    
    UIView* ButtonsContainer=[[UIView alloc]init];
    
    ButtonsContainer.frame=CGRectMake(0, 0, 40, 40);
    
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [ButtonsContainer addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(ButtonsContainer.mas_left);
        
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(ButtonsContainer.mas_centerY);
    }];
    
    
    UIBarButtonItem *barButtonItem=[[UIBarButtonItem alloc]initWithCustomView:ButtonsContainer];
    self.navigationItem.rightBarButtonItem=barButtonItem;
    
}

-(void)backButtonPressed
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    NSString* url=webView.request.URL.absoluteString;
//    NSLog(url,nil);
//    if ([url containsString:@"welfare"] || [url containsString:@"question"] || [url containsString:@"signin"]) {
//        self.cover.hidden=NO;
//    } else {
//        self.cover.hidden=YES;
//    }
//}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url=request.URL.absoluteString;
    if([request.URL.absoluteString containsString:@"http://m.koushaoapp.com"])
    {
        if ([url containsString:@"welfare"] || [url containsString:@"question"] || [url containsString:@"signin"]) {
            self.cover.hidden=NO;
        } else {
            self.cover.hidden=YES;
        }
    }
    return YES;
}
@end
