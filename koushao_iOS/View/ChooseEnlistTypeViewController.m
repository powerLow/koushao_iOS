//
//  ChooseEnlistTypeViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/2.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "ChooseEnlistTypeViewController.h"
#import "AddEnlistFeeItemViewController.h"
#import "RealnameEnlistViewController.h"
#import "TicketEnlistViewController.h"
#import "Masonry.h"
#import "KSActivityCreatManager.h"


@interface ChooseEnlistTypeViewController ()
@property(nonatomic,strong)UIImageView* image1;
@property(nonatomic,strong)UIImageView* image2;
@property(nonatomic,assign) CGColorRef colorrefUnselect;
@property(nonatomic,assign) CGColorRef colorrefSelect;
@property(nonatomic,assign)NSInteger choice;
@property(nonatomic,strong)KSActivityCreatManager* activityManager;
@end

@implementation ChooseEnlistTypeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"活动报名";
    [self initData];
    [self initTitleBar];
    [self initView];
    [self initBottomButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initView
{
    self.title=@"活动报名";
    UILabel* textLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 65, 300, 40)];
    textLabel.font=[UIFont fontWithName:@"Arial" size:14];
    textLabel.text=@"报名有两种形式，可以根据活动需求选择哦";
    textLabel.textColor=[KSUtil colorWithHexString:@"#FBA35E"];
    [self.view addSubview:textLabel];
    
    self.view.backgroundColor=[UIColor whiteColor];
    UIScrollView* mainScrollVIew=[[UIScrollView alloc]init];
    [self.view addSubview:mainScrollVIew];
    [mainScrollVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(104, 0, 60, 0));
    }];
    mainScrollVIew.backgroundColor=[KSUtil colorWithHexString:@"#F9FAFB"];
    mainScrollVIew.contentSize=CGSizeMake(mainScrollVIew.frame.size.width,mainScrollVIew.frame.size.height);
    
    CGFloat mainDisplayWidth=([[UIScreen mainScreen]bounds].size.width/4*3)-40;
    CGFloat marginLeft=([[UIScreen mainScreen]bounds].size.width-mainDisplayWidth)/2;
    UIView* mainDisplayPhoneContainer=[[UIView alloc]initWithFrame:CGRectMake(marginLeft, 10, mainDisplayWidth, mainDisplayWidth*2.02)];
    [mainScrollVIew addSubview:mainDisplayPhoneContainer];
    
    UIImageView* phoneShellImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainDisplayWidth, mainDisplayWidth*2.02)];
    phoneShellImageView.image=[UIImage imageNamed:@"phoneshell"];
    [mainDisplayPhoneContainer addSubview:phoneShellImageView];
    
    UIView* contentView=[[UIView alloc]initWithFrame:CGRectMake(mainDisplayWidth*0.07, mainDisplayWidth*0.25, mainDisplayWidth*0.86, mainDisplayWidth*1.379)];
    
    self.image2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,mainDisplayWidth*0.86, mainDisplayWidth*1.535)];
    self.image2.image=[UIImage imageNamed:@"baoming2"];
    [contentView addSubview:  self.image2];
    
    
    self.image1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,mainDisplayWidth*0.86, mainDisplayWidth*1.535)];
    self.image1.image=[UIImage imageNamed:@"baoming1"];
    [contentView addSubview:  self.image1];
    
    [mainDisplayPhoneContainer addSubview:contentView];
    
}
-(void)initData
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    self.colorrefUnselect = CGColorCreate(colorSpace,(CGFloat[]){ 0.8, 0.8, 0.8, 1 });
    self.colorrefSelect = CGColorCreate(colorSpace,(CGFloat[]){ 44/255.0, 189/255.0 , 134/255.0, 1 });
    self.choice=1;
    self.activityManager=[KSActivityCreatManager sharedManager];
}
-(void)initTitleBar
{
    UILabel* rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 80, 40)];
    rightTitleLabel.backgroundColor = [UIColor clearColor];
    rightTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightTitleLabel.textColor = [UIColor whiteColor];
    rightTitleLabel.text = @"开启";
    
    rightTitleLabel.textAlignment=NSTextAlignmentRight;
    UIButton* rightTitleButton=[[UIButton alloc] initWithFrame:CGRectMake(0,0,80,40)];
    [rightTitleButton addSubview:rightTitleLabel];
    [rightTitleButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightTitleButton];
    
    //设置NavigationBar的相关属性
    //self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
}
//选中按钮的样式
-(void)selectButton:(UIButton*)button isSelect:(BOOL)select
{
    if(select)
    {
        [button.layer setBorderColor:self.colorrefSelect];
    }
    else
    {
        [button.layer setBorderColor:self.colorrefUnselect];
    }
}

-(void)showImage:(UIImageView*)imageView show:(BOOL)show
{
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.autoreverses = NO;
    alphaAnimation.fillMode = kCAFillModeBoth;
    alphaAnimation.removedOnCompletion=NO;
    alphaAnimation.duration = 0.5;
    if(show)
    {
        alphaAnimation.fromValue = [NSNumber numberWithFloat:0];
        alphaAnimation.toValue = [NSNumber numberWithFloat:1];
    }
    else
    {
        alphaAnimation.fromValue = [NSNumber numberWithFloat:1];
        alphaAnimation.toValue = [NSNumber numberWithFloat:0];
    }
    [imageView.layer addAnimation:alphaAnimation forKey:nil];
}

-(void)initBottomButton
{
    
    UIButton* leftButton=[[UIButton alloc]init];
    UIButton* rightButton=[[UIButton alloc]init];
    
    //leftButton
    [self.view addSubview:leftButton];
    [leftButton.layer setMasksToBounds:YES];
    [leftButton.layer setBorderWidth:1.0]; //边框宽度
    [leftButton.layer setBorderColor:self.colorrefSelect];//边框颜色
    [leftButton setTitle:@"实名制报名" forState:UIControlStateNormal];//button title
    [leftButton setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forState:UIControlStateNormal];
    
    [leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).with.offset(-80);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(34);
    }];
    [[leftButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        if(self.choice==2)
        {
            self.choice=1;
            [self selectButton:leftButton isSelect:YES];
            [self selectButton:rightButton isSelect:NO];
            [self showImage:self.image1 show:YES];
            [self showImage:self.image2 show:NO];
        }
    }];
    
    //rightButton
    
    [self.view addSubview:rightButton];
    [rightButton.layer setMasksToBounds:YES];
    [rightButton.layer setBorderWidth:1.0]; //边框宽度
    [rightButton.layer setBorderColor:self.colorrefUnselect];//边框颜色
    [rightButton setTitle:@"非实名制售票" forState:UIControlStateNormal];//button title
    [rightButton setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forState:UIControlStateNormal];
    
    @weakify(self)
    [rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.centerX.mas_equalTo(self.view.mas_centerX).with.offset(80);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(34);
    }];
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        if(self.choice==1)
        {
            self.choice=2;
            [self selectButton:leftButton isSelect:NO];
            [self selectButton:rightButton isSelect:YES];
            [self showImage:self.image1 show:NO];
            [self showImage:self.image2 show:YES];
        }
    }];
}
-(void)nextStep
{
    [self.activityManager deleteEnlistInfo];
    switch (self.choice) {
        case 1:
        {
            RealnameEnlistViewController* realnameEnlistViewController=[[RealnameEnlistViewController alloc]init];
            [self.navigationController pushViewController:realnameEnlistViewController animated:YES];
        }
            break;
        case 2:
        {
            TicketEnlistViewController* ticketEnlistViewController=[[TicketEnlistViewController alloc]init];
            [self.navigationController pushViewController:ticketEnlistViewController animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}
-(void)backToPrevious
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
