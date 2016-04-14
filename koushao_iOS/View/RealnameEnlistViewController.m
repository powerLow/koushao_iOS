//
//  RealnameEnlistViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/2.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "RealnameEnlistViewController.h"
#import "Masonry.h"
#import "KSTicketButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "InsetsUILabel.h"
#import "AddEnlistFeeItemViewController.h"
#import "HorizonalTagFlowLayout.h"
#import "KSActivityCreatManager.h"
#import "UITextField+maxLength.h"
#import "TicketBenefitsTipsViewController.h"
#define screenHeight [[UIScreen mainScreen]bounds].size.height //屏幕高度
#define screenWidth [[UIScreen mainScreen]bounds].size.width   //屏幕宽度


@interface RealnameEnlistViewController ()
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)KSActivityCreatManager* activityManager;
@property(nonatomic,assign)NSInteger limit;
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)NSMutableArray* insetFormInfo;
@property(nonatomic,strong)UIView* inputCustomInfoView;
@property(nonatomic,strong)UITextField* inputCustomInfoTextField;
@property(nonatomic,assign)BOOL isInputViewShow;
@end

@implementation RealnameEnlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self initTitleBar];
    [self registerSoftKeyboardNotification];
    
}
-(void)initData
{
    self.isInputViewShow=NO;
    self.activityManager=[KSActivityCreatManager sharedManager];
    self.insetFormInfo=[[NSMutableArray alloc]init];
    [self.insetFormInfo addObject:@"姓名"];
    [self.insetFormInfo addObject:@"性别"];
    [self.insetFormInfo addObject:@"手机号码"];
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
    self.isInputViewShow=YES;
}

- (void)keyboardShow:(NSNotification *)notif {
}

- (void)keyboardWillHide:(NSNotification *)notif {
    
    self.isInputViewShow=NO;
}

- (void)keyboardHide:(NSNotification *)notif {
    
}


#pragma mark 定义报名表单信息的瀑布流布局
-(void)initFlowLayoutCollectionView
{
    HorizonalTagFlowLayout *flowLayout=[[HorizonalTagFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth ,200) collectionViewLayout:flowLayout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:@"UICollectionViewCell"];
    self.collectionView.scrollEnabled=NO;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.insetFormInfo.count+self.activityManager.enlist_form_info_array.count+1;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    InsetsUILabel* textLabel=[[InsetsUILabel alloc]init];
    textLabel.clipsToBounds=YES;
    textLabel.layer.cornerRadius=7.0;
    textLabel.font=[UIFont fontWithName:@"Arial" size:15];
    textLabel.textColor=[KSUtil colorWithHexString:@"#34BC87"];
    if(indexPath.row<3)
    {
        textLabel.textAlignment=NSTextAlignmentCenter;
        textLabel.text=[self.insetFormInfo objectAtIndex:indexPath.row];
        [cell.contentView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        textLabel.layer.borderWidth=1;
        textLabel.layer.borderColor=[KSUtil colorWithHexString:@"#34BC87"].CGColor;
        
    }
    else if(indexPath.row>=3&&indexPath.row<(self.insetFormInfo.count+self.activityManager.enlist_form_info_array.count))
    {
        textLabel.textAlignment=NSTextAlignmentLeft;
        textLabel.insets=UIEdgeInsetsMake(0, 10, 0, 0);
        textLabel.text=[self.activityManager.enlist_form_info_array objectAtIndex:indexPath.row-3];
        [cell.contentView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        
        CGSize cellSize=  CGSizeMake([KSUtil textWidth:textLabel.text withFont:[UIFont fontWithName:@"Arial" size:16]]+40,34);
        borderLayer.frame = CGRectMake(0, 0, cellSize.width, cellSize.height);
        borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.frame cornerRadius:7.0].CGPath;
        borderLayer.lineWidth = 2;
        borderLayer.lineDashPattern = @[@4, @4];
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = [KSUtil colorWithHexString:@"#34BC87"].CGColor;
        textLabel.layer.cornerRadius = 7.0;
        
        [textLabel.layer addSublayer:borderLayer];
        
        
        UIButton* deleButton=[[UIButton alloc]init];
        [deleButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [cell.contentView addSubview:deleButton];
        [deleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.right.mas_equalTo(cell.contentView.mas_right).with.offset(-8);
            make.width.mas_equalTo(18);
            make.height.mas_equalTo(18);
        }];
        [[deleButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            [self.activityManager.enlist_form_info_array removeObjectAtIndex:indexPath.row-3];
            [self.collectionView reloadData];
        }];
    }
    else if(indexPath.row==self.insetFormInfo.count+self.activityManager.enlist_form_info_array.count)
    {
        UIButton* addButton=[[UIButton alloc]init];
        [cell.contentView addSubview:addButton];
        addButton.layer.cornerRadius=7.0;
        [addButton setTitle:@"添加自定义" forState:UIControlStateNormal];
        addButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
        addButton.titleLabel.textColor=[UIColor whiteColor];
        [addButton setBackgroundColor:[UIColor grayColor]];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        @weakify(self);
        [[addButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            @strongify(self)
            if(self.activityManager.enlist_form_info_array.count<3)
            {
                if(!self.isInputViewShow)
                    [self showCommentText];
            }
            else
            {
                KSError(@"最多只能添加三个字段");
            }
            
        }];
    }
    return cell;
}

- (void)createCommentsView {
    if (!self.inputCustomInfoView) {
        
        self.inputCustomInfoView = [[UIView alloc] initWithFrame:CGRectMake(0.0, SCREEN_HEIGHT - 80 - 40.0, SCREEN_WIDTH, 40.0)];
        self.inputCustomInfoView.backgroundColor = [UIColor whiteColor];
        UIView* topBorder=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topBorder.backgroundColor=[UIColor grayColor];
        [self.inputCustomInfoView addSubview:topBorder];
        
        self.inputCustomInfoTextField = [[UITextField alloc] init];
        self.inputCustomInfoTextField.layer.borderColor   = [KSUtil colorWithHexString:@"#C7C8CC"].CGColor;
        self.inputCustomInfoTextField.layer.borderWidth   = 0.6;
        self.inputCustomInfoTextField.layer.cornerRadius  = 3.0;
        self.inputCustomInfoTextField.layer.masksToBounds = YES;
        self.inputCustomInfoTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        //设置显示模式为永远显示(默认不显示)
        self.inputCustomInfoTextField.leftViewMode = UITextFieldViewModeAlways;
        
        self.inputCustomInfoTextField.inputAccessoryView  = self.inputCustomInfoView;
        self.inputCustomInfoTextField.backgroundColor     = [UIColor clearColor];
        self.inputCustomInfoTextField.returnKeyType       = UIReturnKeySend;
        [self.inputCustomInfoTextField setMaxTextLength:6];
        self.inputCustomInfoTextField.font		= [UIFont systemFontOfSize:15.0];
        [self.inputCustomInfoView addSubview:self.inputCustomInfoTextField];
        [self.inputCustomInfoTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(5, 8, 5, 60));
        }];
        
        UIButton * confirmButton=[[UIButton alloc]init];
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[KSUtil colorWithHexString:@"#34BC87"] forState:UIControlStateNormal];
        [self.inputCustomInfoView addSubview:confirmButton];
        @weakify(self)
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self)
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(50);
            make.centerY.mas_equalTo(self.inputCustomInfoView.mas_centerY);
            make.right.mas_equalTo(self.inputCustomInfoView.mas_right);
        }];
        [[confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
            if(self.inputCustomInfoTextField.text.length>0&&self.inputCustomInfoTextField.text.length<7)
            {
                [self.activityManager.enlist_form_info_array addObject:self.inputCustomInfoTextField.text];
                [self.collectionView reloadData];
                self.inputCustomInfoTextField.text=@"";
                [self.inputCustomInfoTextField resignFirstResponder];
            }
            else
            {
                KSError(@"字段名称字数超出限制！");
            }
        }];
        
    }
    [self.view.window addSubview:self.inputCustomInfoView];
    [self.inputCustomInfoTextField becomeFirstResponder];
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row<3)
    {
        return CGSizeMake([KSUtil textWidth:[self.insetFormInfo objectAtIndex:indexPath.row] withFont:[UIFont fontWithName:@"Arial" size:16]]+40,34);
    }
    
    else if(indexPath.row>=3&&indexPath.row<(self.insetFormInfo.count+self.activityManager.enlist_form_info_array.count))
    {
        return CGSizeMake([KSUtil textWidth:[self.activityManager.enlist_form_info_array objectAtIndex:indexPath.row-3] withFont:[UIFont fontWithName:@"Arial" size:16]]+40,34);
    }
    else if(indexPath.row==self.insetFormInfo.count+self.activityManager.enlist_form_info_array.count)
    {
        
        return CGSizeMake([KSUtil textWidth:@"添加自定义" withFont:[UIFont fontWithName:@"Arial" size:16]]+40,34);
        
    }
    return CGSizeMake(0, 0);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat padding=10;
    return UIEdgeInsetsMake(padding,padding,padding, padding);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)showCommentText {
    [self createCommentsView];
    
    [self.inputCustomInfoTextField becomeFirstResponder];
}

-(void)initView
{
    [self initFlowLayoutCollectionView];
    self.title=@"实名制报名";
    self.tableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
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
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在提交数据";
    self.activityManager.enlist_isOpen=1;
    self.activityManager.enlist_type=0;
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
#pragma mark 主tableView的相关方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 1;
    }
    else if(section==1)
    {
        return 2;
    }
    else if (section==2)
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
        {
            [tableViewCell.contentView addSubview:self.collectionView];
            [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(tableViewCell.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }
            break;
        case 1:
        {
            UILabel* titleLabel=[[UILabel alloc]init];
            [tableViewCell.contentView addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(tableViewCell.contentView.mas_left).with.offset(16);
                make.bottom.mas_equalTo(tableViewCell.contentView.mas_bottom);
                make.top.mas_equalTo(tableViewCell.contentView.mas_top);
                //make.width.mas_equalTo(240);
            }];
            
            UISwitch* limitSwitch=[[UISwitch alloc]init];
            limitSwitch.onTintColor=[KSUtil colorWithHexString:@"#2CBD86"];
            tableViewCell.accessoryView = limitSwitch;
            if(indexPath.row==0)
            {
                titleLabel.text=@"允许一个账号为多个人报名";
                if(self.activityManager.enlist_limit==1)
                {
                    limitSwitch.on=NO;
                }
                else if (self.activityManager.enlist_limit==100)
                {
                    limitSwitch.on=YES;
                }
                [[limitSwitch rac_signalForControlEvents:UIControlEventValueChanged]subscribeNext:^(id x) {
                    if(limitSwitch.isOn)
                    {
                        self.activityManager.enlist_limit=100;
                    }
                    else
                    {
                        self.activityManager.enlist_limit=1;
                    }
                }];
                
            }
            else if (indexPath.row==1)
            {
                titleLabel.text=@"生成报名凭证";
                
                UIButton *button = [UIButton new];
                [button setBackgroundImage:[UIImage imageNamed:@"wenhao"] forState:UIControlStateNormal];
                [tableViewCell.contentView addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(titleLabel.mas_right).offset(5);
                    make.centerY.equalTo(tableViewCell.contentView);
                    make.width.mas_equalTo(25);
                    make.height.mas_equalTo(25);
                }];
                [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                    TicketBenefitsTipsViewController *vc = [[TicketBenefitsTipsViewController alloc] initWithType:3];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                //是否生成报名凭证 0不生成 1生成
                if(self.activityManager.enlist_generate_enlist_certificate==0)
                {
                    limitSwitch.on=NO;
                }
                else if (self.activityManager.enlist_generate_enlist_certificate==1)
                {
                    limitSwitch.on=YES;
                }
                [[limitSwitch rac_signalForControlEvents:UIControlEventValueChanged]subscribeNext:^(id x) {
                    if(limitSwitch.isOn)
                    {
                        self.activityManager.enlist_generate_enlist_certificate=1;
                    }
                    else
                    {
                        self.activityManager.enlist_generate_enlist_certificate=0;
                    }
                }];
            }
            
        }
            
            break;
        case 2:
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
            addEnlistFeeItemViewController.type=0;
            
            if(indexPath.row==0)
            {
                ticketButton.buttonStyle=KSTicketButtonStyleAdd;
                ticketButton.titleText=@"添加费用方案";
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
                
                [self.navigationController pushViewController:addEnlistFeeItemViewController animated:YES];
            }];
            ticketButton.deleteButtonPressed=^(){
                [self.activityManager.enlist_fee_item_array removeObjectAtIndex:indexPath.row-1];
                [self.tableView beginUpdates];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
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
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==2)
    {
        if(indexPath.row==0)
            return (SCREEN_WIDTH-32)*0.382+25+20;
        else if(indexPath.row==_activityManager.enlist_fee_item_array.count)
        {
            return (SCREEN_WIDTH-32)*0.382+25+10;
        }
        else
            return (SCREEN_WIDTH-32)*0.382+25;
    }
    if(indexPath.section==1)return 44;
    if(indexPath.section==0)return 144;
    return 0;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return @"报名信息";
    }
    else if (section==2)
    {
        return @"选填项目";
    }
    return @"";
}

#pragma mark 添加费用方案的ViewController的代理方法
-(void)onEnlistFeeitemUpdated
{
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
}
-(void)onEnlistFeeitemAdded:(EnlistFeeItem *)enlistFeeItem
{
    [self.activityManager.enlist_fee_item_array addObject:enlistFeeItem];
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}
@end
