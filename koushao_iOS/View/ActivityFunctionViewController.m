//
//  ActivityFunctionViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/10/31.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "ActivityFunctionViewController.h"
#import "Masonry.h"
#import "TimeLocationViewController.h"
#import "ActivityDetailViewController.h"
#import "ChooseDetailStyleViewController.h"
#import "ChooseBenefitsTypeViewController.h"
#import "ChooseEnlistTypeViewController.h"
#import "ConsultSettingViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "KSActivityCreatManager.h"
#import "RealnameEnlistViewController.h"
#import "TicketEnlistViewController.h"
#import "ActivityPreviewViewController.h"
#import "TurntableBenefitsViewController.h"
#import "CustomIOSAlertView.h"
#import "KSClientApi.h"
#import "KSButton.h"

#import "KSViewModelServicesImpl.h"
#import "KSHomepageViewModel.h"
#import "KSHomepageViewController.h"
#import "KSNavigationControllerStack.h"
#import "KSNavigationController.h"
#import "APService.h"

#import "CTBottomPoper.h"
#import "CTIconButtonBottomPoper.h"
#import "CTIconButtonModel.h"

@interface ActivityFunctionViewController ()
@property(nonatomic,strong)NSMutableArray* buttonIcon;
@property(nonatomic,strong)NSMutableArray* buttonName;
@property(nonatomic,assign)CGFloat cellHeight;
@property(nonatomic,assign)CGFloat cellWidth;
@property(nonatomic,strong)UIButton* baseInfoButton; //活动基本信息
@property(nonatomic,strong)UIButton* activityDetailButton; //活动详情
@property(nonatomic,strong)UIButton* activityStyleButton; //活动版式
@property(nonatomic,strong)UIButton* enlistSettingButton; //报名设置
@property(nonatomic,strong)UIButton* consultSettingButton; //咨询设置
@property(nonatomic,strong)UIButton* benefitsSettingButton; //抽奖设置
@property(nonatomic,strong)UIImageView* enlistSettingButtonIcon;
@property(nonatomic,strong)UILabel* enlistSettingButtonLabel;
@property(nonatomic,strong)UIImageView* enlistSettingOptionalIcon;
@property(nonatomic,strong)UIImageView* consultSettingButtonIcon;
@property(nonatomic,strong)UILabel* consultSettingButtonLabel;
@property(nonatomic,strong)UIImageView* consultSettingOptionalIcon;
@property(nonatomic,strong)UIImageView* benefitsSettingButtonIcon;
@property(nonatomic,strong)UILabel* benefitsSettingButtonLabel;
@property(nonatomic,strong)UIImageView* benefitsSettingOptionalIcon;
@property(nonatomic,strong)KSActivityCreatManager* activityManager;
@end

@implementation ActivityFunctionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self initTitleBar];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self UpdateButtonIcon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initData
{
    self.title=@"活动功能";
    self.cellWidth=[[UIScreen mainScreen]bounds].size.width/2;
    self.cellHeight=([[UIScreen mainScreen]bounds].size.height-64-44)/3;
    self.buttonIcon=[[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:@"activity_baseinfo",@"activity_detail",@"activity_detail_style",@"activity_enroll",@"activity_consult",@"activity_welfare",nil]];
    self.buttonName=[[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:@"基本信息",@"图文详情",@"活动版式",@"报名设置",@"咨询设置",@"抽奖设置",nil]];
    self.activityManager=[KSActivityCreatManager sharedManager];
}
-(void)initTitleBar
{
    UIImageView *backButton=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , 12.5, 20)];
    backButton.image=[UIImage imageNamed:@"back_arrow"];
    
    //返回上一步按钮
    UIButton* leftTitleButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0 , 12.5, 20)];
    [leftTitleButton addSubview:backButton];
    [leftTitleButton addTarget:self action:@selector(backToActivityList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftTitleButton];
    
    //设置NavigationBar的相关属性
    self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    
}


-(void)backToActivityList{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)buttonClicked:(UIButton*)sender
{
    if([sender isEqual:self.baseInfoButton])
    {
        TimeLocationViewController* timeLocationViewController=[[TimeLocationViewController alloc]init];
        timeLocationViewController.isModify=YES;
        [self.navigationController pushViewController:timeLocationViewController animated:YES];
    }
    if([sender isEqual:self.activityDetailButton])
    {
        ActivityDetailViewController* activityDetailViewController=[[ActivityDetailViewController alloc]init];
        activityDetailViewController.isModify=YES;
        [self.navigationController pushViewController:activityDetailViewController animated:YES];
    }
    if([sender isEqual:self.activityStyleButton])
    {
        ChooseDetailStyleViewController* chooseDetailStyleViewController=[[ChooseDetailStyleViewController alloc]init];
        chooseDetailStyleViewController.isModify=YES;
        [self.navigationController pushViewController:chooseDetailStyleViewController animated:YES];
    }
    if([sender isEqual:self.enlistSettingButton])
    {
        if(self.activityManager.enlist_isOpen==0)
        {
            ChooseEnlistTypeViewController* chooseEnlistTypeViewController=[[ChooseEnlistTypeViewController alloc]init];
            [self.navigationController pushViewController:chooseEnlistTypeViewController animated:YES];
        }
        else
        {
            if(self.activityManager.enlist_type==0)
            {
                RealnameEnlistViewController* realnameEnlistViewController=[[RealnameEnlistViewController alloc]init];
                [self.navigationController pushViewController:realnameEnlistViewController animated:YES];
            }
            else{
                TicketEnlistViewController* ticketEnlistViewController=[[TicketEnlistViewController alloc]init];
                [self.navigationController pushViewController:ticketEnlistViewController animated:YES];
            }
        }
        
    }
    if([sender isEqual:self.consultSettingButton])
    {
        ConsultSettingViewController* consultSettingViewController=[[ConsultSettingViewController alloc]init];
        [self.navigationController pushViewController:consultSettingViewController animated:YES];
    }
    if([sender isEqual:self.benefitsSettingButton])
    {
        if(self.activityManager.welfare_isOpen==0)
        {
            if(self.activityManager.enlist_isOpen==1)
            {
                ChooseBenefitsTypeViewController* chooseBenefitsTypeViewController=[[ChooseBenefitsTypeViewController alloc]init];
                [self.navigationController pushViewController:chooseBenefitsTypeViewController animated:YES];
            }
            else
            {
                KSError(@"必须先开启报名模块才能设置福利信息！");
            }
            
        }
        else
        {
            if(self.activityManager.welfare_Category==3)
            {
                TurntableBenefitsViewController* turntableBenefitsViewController=[[TurntableBenefitsViewController alloc]init];
                [self.navigationController pushViewController:turntableBenefitsViewController animated:YES];
            }
        }
    }
}
-(void)initView
{
    [self drawLines];
    self.baseInfoButton=[self createUIButtonByRow:0 Column:0];
    self.activityDetailButton=[self createUIButtonByRow:0 Column:1];
    self.activityStyleButton=[self createUIButtonByRow:1 Column:0];
    self.enlistSettingButton=[self createUIButtonByRow:1 Column:1];
    self.consultSettingButton=[self createUIButtonByRow:2 Column:0];
    self.benefitsSettingButton=[self createUIButtonByRow:2 Column:1];
    [self.view addSubview:self.baseInfoButton];
    [self.view addSubview:self.activityDetailButton];
    [self.view addSubview:self.activityStyleButton];
    [self.view addSubview:self.enlistSettingButton];
    [self.view addSubview:self.consultSettingButton];
    [self.view addSubview:self.benefitsSettingButton];
    [self.baseInfoButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.activityDetailButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.activityStyleButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.enlistSettingButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.consultSettingButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.benefitsSettingButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self initBottomButton];
}
-(UIButton *)createUIButtonByRow:(NSInteger)row Column:(NSInteger)column
{
    UIButton* button=[[UIButton alloc]initWithFrame:CGRectMake(column*self.cellWidth, row*self.cellHeight+64, self.cellWidth, self.cellHeight)];
    
    UIImageView* buttonIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [button addSubview:buttonIcon];
    buttonIcon.image=[UIImage imageNamed:[self.buttonIcon objectAtIndex:row*2+column]];
    [buttonIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(button.mas_centerY).with.offset(-20);
        make.centerX.mas_equalTo(button.mas_centerX);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(35);
    }];
    
    UILabel* buttonLabel=[[UILabel alloc]init];
    buttonLabel.text=[self.buttonName objectAtIndex:row*2+column];
    buttonLabel.font=[UIFont fontWithName:@"Arial" size:14];
    buttonLabel.textAlignment=NSTextAlignmentCenter;
    [button addSubview:buttonLabel];
    
    [buttonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(button.mas_centerY).with.offset(20);
        make.centerX.mas_equalTo(button.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    if((row==1&&column==1)||row==2)
    {
        UIImageView* optionalIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [button addSubview:optionalIcon];
        optionalIcon.image=[UIImage imageNamed:@"ic_option"];
        [optionalIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(button.mas_right);
            make.bottom.mas_equalTo(button.mas_bottom);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        if(row==1&&column==1)
        {
            self.enlistSettingButtonIcon=buttonIcon;
            self.enlistSettingOptionalIcon=optionalIcon;
            self.enlistSettingButtonLabel=buttonLabel;
        }
        if(row==2&&column==0)
        {
            self.consultSettingButtonIcon=buttonIcon;
            self.consultSettingOptionalIcon=optionalIcon;
            self.consultSettingButtonLabel=buttonLabel;
        }
        if(row==2&&column==1)
        {
            self.benefitsSettingButtonIcon=buttonIcon;
            self.benefitsSettingOptionalIcon=optionalIcon;
            self.benefitsSettingButtonLabel=buttonLabel;
        }
        [self UpdateButtonIcon];
    }
    button.enabled=YES;
    
    return button;
}
-(void)UpdateButtonIcon
{
    self.activityManager=[KSActivityCreatManager sharedManager];
    if(self.activityManager.enlist_isOpen)
    {
        self.enlistSettingOptionalIcon.hidden=YES;
        //实名制
        if(self.activityManager.enlist_type==0)
        {
            self.enlistSettingButtonIcon.image=[UIImage imageNamed:@"shimingzhi"];
            self.enlistSettingButtonLabel.text=@"实名制报名";
        }
        //门票发售
        else{
            self.enlistSettingButtonIcon.image=[UIImage imageNamed:@"shimingzhishoup"];
            self.enlistSettingButtonLabel.text=@"门票发售";
        }
    }
    else
    {
        self.enlistSettingOptionalIcon.hidden=NO;
        self.enlistSettingButtonIcon.image=[UIImage imageNamed:@"activity_enroll"];
        self.enlistSettingButtonLabel.text=@"报名设置";
    }
    
    if(self.activityManager.consult_isOpen==0)
    {
        self.consultSettingOptionalIcon.hidden=NO;
        self.consultSettingButtonIcon.image=[UIImage imageNamed:@"activity_consult"];
        self.consultSettingButtonLabel.text=@"咨询设置";
    }
    
    else
    {
        self.consultSettingOptionalIcon.hidden=YES;
        self.consultSettingButtonIcon.image=[UIImage imageNamed:@"activity_consult_nm"];
        self.consultSettingButtonLabel.text=@"活动咨询";
    }
    
    if(self.activityManager.welfare_isOpen==0)
    {
        self.benefitsSettingOptionalIcon.hidden=NO;
        self.benefitsSettingButtonIcon.image=[UIImage imageNamed:@"activity_welfare"];
        self.benefitsSettingButtonLabel.text=@"福利设置";
    }
    else
    {
        if(self.activityManager.welfare_Category==3)
        {
            self.benefitsSettingOptionalIcon.hidden=YES;
            self.benefitsSettingButtonIcon.image=[UIImage imageNamed:@"dazhuanp"];
            self.benefitsSettingButtonLabel.text=@"转盘抽奖";
        }
    }
}
#pragma mark 绘制底部按钮
-(void)initBottomButton
{
    UIButton* previewButton=[[UIButton alloc]init];
    UIButton* publishButton=[[UIButton alloc]init];
    UILabel* previewLabel=[[UILabel alloc]init];
    previewLabel.text=@"预览";
    previewLabel.font=[UIFont fontWithName:@"Arial" size:15];
    previewLabel.textColor=[KSUtil colorWithHexString:@"#2CBD86"];
    previewLabel.textAlignment=NSTextAlignmentCenter;
    [previewButton addSubview:previewLabel];
    UILabel* publishLabel=[[UILabel alloc]init];
    publishLabel.text=@"发布";
    publishLabel.font=[UIFont fontWithName:@"Arial" size:15];
    publishLabel.textAlignment=NSTextAlignmentCenter;
    publishLabel.textColor=[KSUtil colorWithHexString:@"#2CBD86"];
    [publishButton addSubview:publishLabel];
    
    [self.view addSubview:previewButton];
    [self.view addSubview:publishButton];
    
    @weakify(self);
    [previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(self.cellWidth);
        make.height.mas_equalTo(40);
    }];
    
    [previewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(previewButton.mas_centerY);
        make.centerX.mas_equalTo(previewButton.mas_centerX);
        make.width.mas_equalTo(self.cellWidth);
        make.height.mas_equalTo(40);
    }];
    
    [publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(self.cellWidth);
        make.height.mas_equalTo(40);
    }];
    
    [publishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.mas_equalTo(publishButton.mas_centerY);
        make.centerX.mas_equalTo(publishButton.mas_centerX);
        make.width.mas_equalTo(self.cellWidth);
        make.height.mas_equalTo(40);
    }];
    [[previewButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        @strongify(self);
        if([self isOutOfDate])
            KSError(@"活动结束时间不能小于当前时间");
        else
        {
            ActivityPreviewViewController* activityPreviewViewController=[[ActivityPreviewViewController alloc]init];
            [self.navigationController pushViewController:activityPreviewViewController animated:YES];
        }
    }];
    
    
    [[publishButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        if([KSUser currentUser])
        {
            if([self isOutOfDate])
                KSError(@"活动结束时间不能小于当前时间");
            else
                [self createPublishActivityAlertView];
        }
    }];
}
-(BOOL)isOutOfDate
{
    
    NSDate* dateNow= [NSDate dateWithTimeIntervalSinceNow:0];
    if(_activityManager.endTime!=0)
    {
        if(_activityManager.endTime<[dateNow timeIntervalSince1970])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
        return NO;
    
}
#pragma mark 创建发布活动询问的AlertView
-(void)createPublishActivityAlertView
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
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"你确定发布该活动吗？活动一经发布，则不可更改！"];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(10, 13)];
    
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
    titleLabel.text=@"发布活动";
    titleLabel.font=[UIFont boldSystemFontOfSize:19];
    titleLabel.textColor=[UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    
    [alertView setContainerView:customView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
    [alertView setButtonColors:[NSMutableArray arrayWithObjects:[UIColor blackColor], KS_Maintheme_Color, nil]];
    
    [alertView show];
    
    @weakify(self);
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        if(buttonIndex==0)
            [alertView close];
        else
        {
            @strongify(self);
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在发布活动";
            [[KSClientApi startActivity]subscribeNext:^(KSActivity* x) {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                if([self.activityManager ks_delete])
                {
                    [self.activityManager clearInfo];
                    //    [self.delegate onActivityPublished];
                    [[NSNotificationCenter defaultCenter]postNotificationName:REFRESH_ACTIVITY_LIST object:nil userInfo:nil];
                    //KSHomepageViewController* homepage=[[KSHomepageViewController alloc]init];
                    //self.view.window.rootViewController = homepage;
                    [self dismissViewControllerAnimated:YES completion:^(void){
                        [[NSNotificationCenter defaultCenter]postNotificationName:ACTIVITY_PUBLISH_FINISH object:x userInfo:nil];
                    }];
                    
                    //Todo:跳转到活动列表
                }
            } error:^(NSError *error) {
                KSError([error.userInfo objectForKey:@"tips"]);
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            }];
        }
    }];
}


#pragma mark 创建登陆的AlertView
#pragma mark 绘制灰色的线条
-(void)drawLines
{
    for(int i=1;i<=3;i++)
    {
        UIView* lineView=[[UIView alloc]initWithFrame:CGRectMake(0, self.cellHeight*i+64, [[UIScreen mainScreen]bounds].size.width, 0.5)];
        lineView.backgroundColor=[KSUtil colorWithHexString:@"#C7C8CC"];
        [self.view addSubview:lineView];
    }
    UIView* lineView=[[UIView alloc]initWithFrame:CGRectMake(self.cellWidth,0,0.5, [[UIScreen mainScreen]bounds].size.height)];
    lineView.backgroundColor=[KSUtil colorWithHexString:@"#C7C8CC"];
    [self.view addSubview:lineView];
}
@end
