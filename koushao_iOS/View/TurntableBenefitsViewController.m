//
//  TurntableBenefitsViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/2.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "TurntableBenefitsViewController.h"
#import "Masonry.h"
#import "KSTicketButton.h"
#import "AddTurnTableBenefitsWelfareItemViewController.h"
#import "KSActivityCreatManager.h"
#import "ChooseBenefitsTypeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "KSPlaceHolderTextView.h"
#import "UITextField+maxLength.h"
#define ALERT_VIEW_DELETE_WELFARE 0

@interface TurntableBenefitsViewController ()
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,assign)CGFloat textViewHeight;
@property(nonatomic,assign)NSInteger selectSection;
@property(nonatomic,strong)UITextField* problityTextField;
@property(nonatomic,strong)KSActivityCreatManager* activityManager;
@end

@implementation TurntableBenefitsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self initTitleBar];
    [self registerSoftKeyboardNotification];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)registerSoftKeyboardNotification
{
    //软键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notif {
    NSDictionary* info = [notif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, kbSize.height, 0.0);
    [self.tableView setContentInset:contentInsets];
    [self.tableView setScrollIndicatorInsets:contentInsets];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.selectSection] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)keyboardShow:(NSNotification *)notif {
}

- (void)keyboardWillHide:(NSNotification *)notif {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, 0.0, 0.0);
    [self.tableView setContentInset:contentInsets];
    [self.tableView setScrollIndicatorInsets:contentInsets];
}

- (void)keyboardHide:(NSNotification *)notif {
    
}
-(void)initView
{
    self.title=@"转盘抽奖";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.problityTextField=[[UITextField alloc]init];
    @weakify(self)
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.top.mas_equalTo(self.view.mas_top).with.offset(-2);
    }];
}
-(void)initData
{
    self.textViewHeight=130;
    self.activityManager=[KSActivityCreatManager sharedManager];
    if(self.activityManager.welfare_items.count==0)
    {
        WelfareItem* welfareItem1=[[WelfareItem alloc]init];
        welfareItem1.name=@"一等奖";
        welfareItem1.content=@"";
        welfareItem1.amount=0;
        
        WelfareItem* welfareItem2=[[WelfareItem alloc]init];
        welfareItem2.name=@"二等奖";
        welfareItem2.content=@"";
        welfareItem2.amount=0;
        
        WelfareItem* welfareItem3=[[WelfareItem alloc]init];
        welfareItem3.name=@"三等奖";
        welfareItem3.content=@"";
        welfareItem3.amount=0;
        
        [self.activityManager.welfare_items addObject:welfareItem1];
        [self.activityManager.welfare_items addObject:welfareItem2];
        [self.activityManager.welfare_items addObject:welfareItem3];
        [self.activityManager ks_saveOrUpdate];
    }
    
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
    if(self.activityManager.welfare_isOpen==0)
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
    [addOrUpdateButton addTarget:self action:@selector(addOrUpdateBenefits) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton addTarget:self action:@selector(deleteBenefits) forControlEvents:UIControlEventTouchUpInside];
    
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
    if([[self.navigationController.viewControllers objectAtIndex:index-1] isKindOfClass:[ChooseBenefitsTypeViewController class]])
    {
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)addOrUpdateBenefits
{
    [self.view endEditing:YES];
    if(self.activityManager.welfare_items.count==0)
    {
        KSError(@"请至少添加一种奖项！");
        return;
    }
    if(![self checkPrize])
    {
        KSError(@"奖项信息填写不完整！");
        return;
    }
    if((!self.problityTextField.text)||self.problityTextField.text.length==0)
    {
        KSError(@"不中奖概率不能为空！");
        return;
    }
    if(!self.activityManager.welfare_description||self.activityManager.welfare_description.length==0)
    {
        KSError(@"福利说明不能为空！");
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在提交数据";
    self.activityManager.welfare_isOpen=1;
    self.activityManager.welfare_Category=3;
    [[KSClientApi setActivityModuleInfo]subscribeNext:^(id x) {
        [[KSClientApi setActivityWelfareInfo]subscribeNext:^(id x) {
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
-(void)deleteBenefits
{
    [self.view endEditing:YES];
    UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"删除福利信息" message:@"确定删除福利信息吗？" delegate:self cancelButtonTitle:@"确定"otherButtonTitles: @"取消",nil];
    alertView.delegate=self;
    alertView.tag=ALERT_VIEW_DELETE_WELFARE;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==ALERT_VIEW_DELETE_WELFARE)
    {
        if(buttonIndex==0)
        {
            [self.activityManager deleteWelfareInfo];
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在删除福利信息";
            [[KSClientApi setActivityModuleInfo]subscribeNext:^(id x) {
                [[KSClientApi deleteActivityWelfareInfo]subscribeNext:^(id x) {
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return self.activityManager.welfare_items.count+1;
    }
    else if (section==2||section==1)
    {
        return 1;
    }
    return 0;
}


-(BOOL)checkPrize
{
    BOOL pass=YES;
    for(WelfareItem * welfateItem in self.activityManager.welfare_items)
    {
        if(!welfateItem.content||welfateItem.content.length==0)
        {
            pass=NO;
            break;
        }
    }
    return pass;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    UITableViewCell* tableViewCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    tableViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 1:
        {
            //不中奖概率
            UILabel* titleLabel=[[UILabel alloc]init];
            UILabel* rightLabel=[[UILabel alloc]init];
            
            [tableViewCell.contentView addSubview:titleLabel];
            [tableViewCell.contentView addSubview: self.problityTextField];
            [tableViewCell.contentView addSubview:rightLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(tableViewCell.contentView.mas_left).with.offset(16);
                make.bottom.mas_equalTo(tableViewCell.contentView.mas_bottom);
                make.top.mas_equalTo(tableViewCell.contentView.mas_top);
                make.width.mas_equalTo(130);
            }];
            [ self.problityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLabel.mas_right).with.offset(12);
                make.bottom.mas_equalTo(tableViewCell.contentView.mas_bottom);
                make.top.mas_equalTo(tableViewCell.contentView.mas_top);
                make.right.mas_equalTo(tableViewCell.contentView.mas_right).with.offset(-36);
            }];
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(16);
                make.bottom.mas_equalTo(tableViewCell.contentView.mas_bottom);
                make.top.mas_equalTo(tableViewCell.contentView.mas_top);
                make.right.mas_equalTo(tableViewCell.contentView.mas_right).with.offset(-16);
            }];
            titleLabel.text=@"不中奖概率";
            rightLabel.text=@"%";
            self.problityTextField.textColor=[UIColor grayColor];
            self.problityTextField.textAlignment=NSTextAlignmentRight;
            self.problityTextField.delegate=self;
            self.problityTextField.tag=indexPath.section;
            self.problityTextField.text=[NSString stringWithFormat:@"%li",(long)self.activityManager.welfare_Probability];
            [[self.problityTextField rac_textSignal]subscribeNext:^(NSString* x) {
                self.activityManager.welfare_Probability=[x integerValue];
            }];
            self.problityTextField.keyboardType=UIKeyboardTypeNumberPad;
            [self.problityTextField setMaxTextLength:3];
            [self.problityTextField setMaxNumberValue:100];
            [self.problityTextField setMinNumberValue:0];
        }
            break;
        case 2:
        {
            //福利描述
            KSPlaceHolderTextView* textView=[[KSPlaceHolderTextView alloc]initWithFrame:CGRectMake(0, 0, tableViewCell.contentView.frame.size.width, self.textViewHeight)];
            textView.scrollEnabled=NO;
            [tableViewCell.contentView addSubview:textView];
            textView.font=[UIFont fontWithName:@"Arial" size:14];
            textView.tag=indexPath.section;
            textView.delegate=self;
            textView.placeholder=@"请填写福利说明";
            textView.text=self.activityManager.welfare_description;
            [[textView rac_textSignal]subscribeNext:^(NSString* x) {
                self.activityManager.welfare_description=x;
            }];
        }
            break;
            
        case 0:
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
            WelfareItem* welfareItem;
            
            if(indexPath.row==self.activityManager.welfare_items.count)
            {
                ticketButton.buttonStyle=KSTicketButtonStyleAdd;
                ticketButton.titleText=@"添加其他奖项";
            }
            else
            {
                welfareItem=[self.activityManager.welfare_items objectAtIndex:indexPath.row];
                if((indexPath.row==0||indexPath.row==1||indexPath.row==2)&&((!welfareItem.content)||welfareItem.content.length==0))
                {
                    ticketButton.buttonStyle=KSTicketButtonStyleAdd;
                    ticketButton.titleText=indexPath.row==0?@"添加一等奖":indexPath.row==1?@"添加二等奖":@"添加三等奖";
                }
                else
                {
                    if(welfareItem.delivery==0)
                        ticketButton.buttonStyle=KSTicketButtonStyleRed;
                    else
                    {
                        ticketButton.buttonStyle=KSTicketButtonStyleGreen;
                        [ticketButton setTicketIconImage:[UIImage imageNamed:@"shiw"]];
                    }
                    ticketButton.titleText=welfareItem.name;
                    ticketButton.subtitleText=welfareItem.content;
                    ticketButton.bottomLeftText=[NSString stringWithFormat:@"数量:%li",(long)welfareItem.amount];
                    if(indexPath.row==0||indexPath.row==1||indexPath.row==2)
                    {
                        [ticketButton hideDeleButton];
                    }
                }
            }
            ticketButton.deleteButtonPressed=^(){
                [self.activityManager.welfare_items removeObjectAtIndex:indexPath.row];
                [self.tableView beginUpdates];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            };
            
            [[ticketButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                [self.view endEditing:YES];
                @strongify(self);
                AddTurnTableBenefitsWelfareItemViewController* addTurnTableBenefitsWelfareItemViewController=[[AddTurnTableBenefitsWelfareItemViewController alloc]init];
                if(welfareItem)addTurnTableBenefitsWelfareItemViewController.welfareItem=welfareItem;
                addTurnTableBenefitsWelfareItemViewController.delegate=self;
                
                if(indexPath.row==self.activityManager.welfare_items.count)
                {
                    if(self.activityManager.welfare_items.count<5)
                    {
                        [self.navigationController pushViewController:addTurnTableBenefitsWelfareItemViewController animated:YES];
                    }
                    else
                    {
                        KSError(@"已达到奖项设置上限！");
                    }
                }
                else
                {
                    [self.navigationController pushViewController:addTurnTableBenefitsWelfareItemViewController animated:YES];
                }
            }];
        }
            break;
            
        default:
            break;
    }
    return tableViewCell;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.selectSection=textField.tag;
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.selectSection=textView.tag;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat nowHeight=[KSUtil textHeight:textView.text withFont:textView.font targetWidth:[UIScreen mainScreen].bounds.size.width];
    if(nowHeight>self.textViewHeight)
    {
        self.textViewHeight=nowHeight;
        textView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.textViewHeight);
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
    else if(nowHeight<=130&&self.textViewHeight!=130)
    {
        self.textViewHeight=130;
        textView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.textViewHeight);
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
            return (SCREEN_WIDTH-32)*0.382+25+20;
        else if(indexPath.row==_activityManager.welfare_items.count)
        {
            return (SCREEN_WIDTH-32)*0.382+25+10;
        }
        else
            return (SCREEN_WIDTH-32)*0.382+25;
        
    }
    else if(indexPath.section==1)return 44;
    else return self.textViewHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return 1;
    return 20;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return @"";
    else if(section==2) return @"福利说明";
    else return @"";
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
            return (SCREEN_WIDTH-32)*0.382+25+20;
        else if(indexPath.row==_activityManager.welfare_items.count)
        {
            return (SCREEN_WIDTH-32)*0.382+25+10;
        }
        else
            return (SCREEN_WIDTH-32)*0.382+25;
        
    }
    else if(indexPath.section==1)return 44;
    else return self.textViewHeight;
}

//福利项目更新或添加完毕回来之后的代理方法
- (void)onBenefitsWelfareItemAdded:(WelfareItem*)welfareItem
{
    [self.activityManager.welfare_items addObject:welfareItem];
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}
- (void)onBenefitsWelfareItemUpdated
{
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}
@end
