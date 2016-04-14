//
//  KSKuaidiWebViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/17.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSKuaidiWebViewController.h"
#import "KSKuaidiWebViewModel.h"
#import "Masonry.h"
@interface KSKuaidiWebViewController ()<UIWebViewDelegate>{
    UIActivityIndicatorView *activityIndicatorView;
}

@property (nonatomic,strong,readwrite) KSKuaidiWebViewModel *viewModel;

@end

@implementation KSKuaidiWebViewController
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [UIWebView new];
    [self.view addSubview:webView];
    
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
    [self.view addSubview : activityIndicatorView] ;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    @weakify(self)
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    webView.delegate =self;
    NSString *strUrl = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",self.viewModel.company,self.viewModel.nu];
    NSString *query = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"查询快递网址:%@",strUrl);
//    strUrl = @"http://www.baidu.com";
    NSURL* url = [NSURL URLWithString:query];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];//加载
    
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载web");
    [activityIndicatorView startAnimating] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"加载web结束");
    [activityIndicatorView stopAnimating];
}
@end
