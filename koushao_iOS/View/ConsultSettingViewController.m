//
//  ConsultSettingViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/2.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "ConsultSettingViewController.h"
#import "KSActivityCreatManager.h"
#import "KSClientApi.h"

@interface ConsultSettingViewController ()
@property(nonatomic,strong)KSActivityCreatManager* activityManager;
@end

@implementation ConsultSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self initTitleBar];
}
-(void)initData
{
    self.activityManager=[KSActivityCreatManager sharedManager];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)initView
{
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"活动咨询";
    UILabel* textLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 65, 300, 40)];
    textLabel.font=[UIFont fontWithName:@"Arial" size:14];
    textLabel.text=@"当用户收到答复时，我们会以短信方式告知";
    textLabel.textColor=[KSUtil colorWithHexString:@"#FBA35E"];
    [self.view addSubview:textLabel];
    
    CGFloat mainDisplayWidth=[[UIScreen mainScreen]bounds].size.width/4*3-40;
    CGFloat marginLeft=([[UIScreen mainScreen]bounds].size.width-mainDisplayWidth)/2;
    UIView* mainDisplayPhoneContainer=[[UIView alloc]initWithFrame:CGRectMake(marginLeft, 110, mainDisplayWidth, mainDisplayWidth*2.02)];
    [self.view addSubview:mainDisplayPhoneContainer];
    
    UIImageView* phoneShellImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainDisplayWidth, mainDisplayWidth*2.02)];
    phoneShellImageView.image=[UIImage imageNamed:@"ic_activity_consult"];
    [mainDisplayPhoneContainer addSubview:phoneShellImageView];
}

-(void)initTitleBar
{
    self.navigationItem.backBarButtonItem.title=@"";
    //下一步按钮
    UILabel* rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 80, 40)];
    rightTitleLabel.backgroundColor = [UIColor clearColor];
    rightTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightTitleLabel.textColor = [UIColor whiteColor];
    if(self.activityManager.consult_isOpen==0)
        rightTitleLabel.text = @"开启";
    else rightTitleLabel.text=@"关闭";
    rightTitleLabel.textAlignment=NSTextAlignmentRight;
    UIButton* rightTitleButton=[[UIButton alloc] initWithFrame:CGRectMake(0,0,80,40)];
    [rightTitleButton addSubview:rightTitleLabel];
    [rightTitleButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightTitleButton];
    //设置NavigationBar的相关属性
    // self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
}
-(void)nextStep
{
    if(self.activityManager.consult_isOpen==0)
    {
        self.activityManager.consult_isOpen=1;
        [self commitData];
    }
    
    else
    {
        UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"关闭咨询模块" message:@"确定关闭咨询模块吗？" delegate:self cancelButtonTitle:@"确定"otherButtonTitles: @"取消",nil];
        alertView.delegate=self;
        [alertView show];
    }
}
-(void)commitData
{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在提交数据";
    [[KSClientApi setActivityModuleInfo]subscribeNext:^(id x) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self.activityManager ks_saveOrUpdate];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError *error) {
        KSError([error.userInfo objectForKey:@"tips"]);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0)
    {
        self.activityManager.consult_isOpen=0;
        [self commitData];
    }
}
-(void)backToPrevious
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
