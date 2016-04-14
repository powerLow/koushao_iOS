//
//  TicketEnlistViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/2.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "TicketEnlistViewController.h"
#import "Masonry.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "AddEnlistFeeItemViewController.h"
#import "KSTicketButton.h"
#import "ActivityFunctionViewController.h"
#import "KSActivityCreatManager.h"
#import "UITextField+maxLength.h"

@interface TicketEnlistViewController ()
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)KSActivityCreatManager* activityManager;
@property(nonatomic,assign)NSInteger limit;
@end

@implementation TicketEnlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self initTitleBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initView
{
    self.title=@"非实名制售票";
    self.tableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
}
-(void)initData
{
    self.activityManager=[KSActivityCreatManager sharedManager];
}
-(void)initTitleBar
{
    UIButton* addOrUpdateButton=[[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
    [addOrUpdateButton setTitle:@"确定" forState:UIControlStateNormal];
    [addOrUpdateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addOrUpdateButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    
    UIButton* deleteButton=[[UIButton alloc] initWithFrame:CGRectMake(0,20,40,40)];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    
    UIView* rightBarButtonsContainer=[[UIView alloc]init];
    //未开启
    if(self.activityManager.enlist_isOpen==0)
    {
        rightBarButtonsContainer.frame=CGRectMake(0, 0,40, 40);
    }
    //已经开启 更新或者删除
    else
    {
        rightBarButtonsContainer.frame=CGRectMake(0, 0, 90, 40);
        [rightBarButtonsContainer addSubview:deleteButton];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightBarButtonsContainer.mas_right);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(rightBarButtonsContainer.mas_centerY);
        }];
    }
    [addOrUpdateButton addTarget:self action:@selector(addOrUpdateEnlist) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton addTarget:self action:@selector(deleteEnlist) forControlEvents:UIControlEventTouchUpInside];
    [rightBarButtonsContainer addSubview:addOrUpdateButton];
    [addOrUpdateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.activityManager.enlist_isOpen==0)
        {
            make.right.mas_equalTo(rightBarButtonsContainer.mas_right);
        }
        else
        {
            make.left.mas_equalTo(rightBarButtonsContainer.mas_left);
        }
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(rightBarButtonsContainer.mas_centerY);
    }];
    
    
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBarButtonsContainer];
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
}

#pragma mark 信息填写完毕的相关方法
-(void)finishSelf
{
    NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
    if([[self.navigationController.viewControllers objectAtIndex:index-1] isKindOfClass:[ChooseEnlistTypeViewController class]])
    {
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)addOrUpdateEnlist
{
    if(self.activityManager.enlist_limit==0)
    {
        KSError(@"请填写单人售票限制");
        return;
    }
    if(self.activityManager.enlist_fee_item_array.count==0)
    {
        KSError(@"请至少添加一种售票方案");
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在提交数据";
    self.activityManager.enlist_isOpen=1;
    self.activityManager.enlist_type=1;
    [[KSClientApi setActivityModuleInfo]subscribeNext:^(id x) {
        [[KSClientApi setActivityEnlistInfo]subscribeNext:^(id x) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.activityManager ks_saveOrUpdate];
            [self finishSelf];
        } error:^(NSError *error) {
            KSError([error.userInfo objectForKey:@"tips"]);
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        }];
    } error:^(NSError *error) {
        KSError([error.userInfo objectForKey:@"tips"]);
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}
-(void)deleteEnlist
{
    UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"删除报名信息" message:@"确定删除报名信息吗？" delegate:self cancelButtonTitle:@"确定"otherButtonTitles: @"取消",nil];
    alertView.delegate=self;
    alertView.tag=ALERT_VIEW_DELETE_ENLIST;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==ALERT_VIEW_DELETE_ENLIST)
    {
        if(buttonIndex==0)
        {
            [self.activityManager deleteEnlistInfo];
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在删除报名信息";
            [[KSClientApi setActivityModuleInfo]subscribeNext:^(id x) {
                [[KSClientApi setActivityEnlistInfo]subscribeNext:^(id x) {
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    [self.activityManager ks_saveOrUpdate];
                    [self finishSelf];
                } error:^(NSError *error) {
                    
                    KSError([error.userInfo objectForKey:@"tips"]);
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                }];
            } error:^(NSError *error) {
                KSError([error.userInfo objectForKey:@"tips"]);
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            }];
        }
    }
}


#pragma mark 主tableView的相关方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }
    else if (section==1)
    {
        return self.activityManager.enlist_fee_item_array.count+1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableViewCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    tableViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
        {  UILabel* titleLabel=[[UILabel alloc]init];
            UITextField* textField=[[UITextField alloc]init];
            [tableViewCell.contentView addSubview:titleLabel];
            [tableViewCell.contentView addSubview:textField];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(tableViewCell.contentView.mas_left).with.offset(16);
                make.bottom.mas_equalTo(tableViewCell.contentView.mas_bottom);
                make.top.mas_equalTo(tableViewCell.contentView.mas_top);
                make.width.mas_equalTo(150);
            }];
            titleLabel.text=@"单人最大购票张数";
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLabel.mas_right).with.offset(12);
                make.bottom.mas_equalTo(tableViewCell.contentView.mas_bottom);
                make.top.mas_equalTo(tableViewCell.contentView.mas_top);
                make.right.mas_equalTo(tableViewCell.contentView.mas_right);
            }];
            textField.placeholder=@"范围1-100";
            textField.keyboardType=UIKeyboardTypeNumberPad;
            [textField setMaxTextLength:6];
            [textField setMaxNumberValue:100];
            [textField setMinNumberValue:1];
            if(self.activityManager.enlist_limit!=0)
            {
                textField.text=[NSString stringWithFormat:@"%li",(long)self.activityManager.enlist_limit];
            }
            [[textField rac_textSignal]subscribeNext:^(NSString* x) {
                self.activityManager.enlist_limit=[x integerValue];
            }];
        }
            break;
            
        case 1:
        {
            tableViewCell.separatorInset = UIEdgeInsetsMake(0, 600, 0, 0);
            KSTicketButton* ticketButton=[[KSTicketButton alloc]init];
            [tableViewCell.contentView addSubview:ticketButton];
            [ticketButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(tableViewCell.contentView.mas_left).with.offset(16);
                make.height.mas_equalTo((SCREEN_WIDTH-32)*0.382);
                make.top.mas_equalTo(tableViewCell.contentView.mas_top).with.offset(indexPath.row==0?25:5);
                make.right.mas_equalTo(tableViewCell.contentView.mas_right).with.offset(-16);
            }];
            AddEnlistFeeItemViewController* addEnlistFeeItemViewController=[[AddEnlistFeeItemViewController alloc]init];
            addEnlistFeeItemViewController.delegate=self;
            addEnlistFeeItemViewController.type=1;
            if(indexPath.row==0)
            {
                ticketButton.buttonStyle=KSTicketButtonStyleAdd;
                ticketButton.titleText=@"添加门票方案";
            }
            else
            {
                EnlistFeeItem* feeItem=[self.activityManager.enlist_fee_item_array objectAtIndex:indexPath.row-1];
                ticketButton.buttonStyle=KSTicketButtonStyleGreen;
                ticketButton.titleText=[NSString stringWithFormat:@"￥%.2f",feeItem.price];
                ticketButton.subtitleText=feeItem.title;
                ticketButton.bottomLeftText=[NSString stringWithFormat:@"数量：%li",(long)feeItem.amount];
                addEnlistFeeItemViewController.enlistFeeItem=feeItem;
            }
            [[ticketButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                [self.view endEditing:YES];
                [self.navigationController pushViewController:addEnlistFeeItemViewController animated:YES];
            }];
            ticketButton.deleteButtonPressed=^(){
                [self.activityManager.enlist_fee_item_array removeObjectAtIndex:indexPath.row-1];
                [self.tableView beginUpdates];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            };
        }
            break;
            
        default:
            break;
    }
    return tableViewCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section!=1)return 44;
    else {
        if(indexPath.row==0)
            return (SCREEN_WIDTH-32)*0.382+25+20;
        else if(indexPath.row==_activityManager.enlist_fee_item_array.count)
        {
            return (SCREEN_WIDTH-32)*0.382+25+10;
        }
        else
            return (SCREEN_WIDTH-32)*0.382+25;
    }
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return @"";
}

#pragma mark 添加费用方案的ViewController的代理方法
-(void)onEnlistFeeitemUpdated
{
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
}
-(void)onEnlistFeeitemAdded:(EnlistFeeItem *)enlistFeeItem
{
    [self.activityManager.enlist_fee_item_array addObject:enlistFeeItem];
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}
@end
