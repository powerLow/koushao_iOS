//
//  TicketBenefitsTipsViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 16/1/11.
//  Copyright © 2016年 kuaicuhmen. All rights reserved.
//

#import "TicketBenefitsTipsViewController.h"
@interface TicketBenefitsTipsViewController()
@property (nonatomic,assign) NSUInteger type;

@end
@implementation TicketBenefitsTipsViewController

- (instancetype)initWithType:(NSUInteger)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"说明";
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    NSString *filepath;
    if (self.type == 1) {
        //奖券
        filepath = @"tips01";
    }else if(self.type == 2){
        filepath = @"tips02";
    }else{
        filepath = @"tips03";
    }
    
    NSString* path = [[NSBundle mainBundle] pathForResource:filepath ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [webView loadRequest:request];
}
@end
