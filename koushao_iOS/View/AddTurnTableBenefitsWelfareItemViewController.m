//
//  AddTurnTableBenefitsWelfareItemViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "AddTurnTableBenefitsWelfareItemViewController.h"
#import "Masonry.h"
#import "UITextField+maxLength.h"

@interface AddTurnTableBenefitsWelfareItemViewController ()
@property(nonatomic,strong)UITableView* offlineTableView;
@property(nonatomic,strong)UITableView* onlineTableView;
@property(nonatomic,strong)UIView* offlineView;
@property(nonatomic,strong)UIView* onlineView;

@property(nonatomic,copy)NSString* welfateItem_name;
@property(nonatomic,copy)NSString* welfateItem_content;
@property(nonatomic,assign)NSInteger welfateItem_amount;
@property(nonatomic,assign)NSInteger welfateItem_delivery;
@end

@implementation AddTurnTableBenefitsWelfareItemViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)initData
{
    if(self.welfareItem)
    {
        self.welfateItem_name=self.welfareItem.name;
        self.welfateItem_delivery=self.welfareItem.delivery;
        self.welfateItem_amount=self.welfateItem_amount;
        self.welfateItem_content=self.welfateItem_content;
    }
    
}
-(void)initView
{
    self.title=@"添加奖品方案";
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTitleBar];
    //[self initSegmentedControl];
    int marginTop=64;
    self.onlineView=[[UIView alloc]initWithFrame:CGRectMake(0,marginTop, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-marginTop)];
    self.offlineView=[[UIView alloc]initWithFrame:CGRectMake(0, marginTop, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-marginTop)];
    
    self.onlineTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.onlineView.frame.size.width, self.onlineView.frame.size.height) style:UITableViewStyleGrouped];
    
    self.offlineTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.onlineView.frame.size.width, self.onlineView.frame.size.height) style:UITableViewStyleGrouped];
    // [self.onlineView addSubview:self.onlineTableView];
    [self.offlineView addSubview:self.offlineTableView];
    [self.view addSubview:self.onlineView];
    [self.view addSubview:self.offlineView];
    self.onlineTableView.delegate=self;
    self.onlineTableView.dataSource=self;
    self.offlineTableView.delegate=self;
    self.offlineTableView.dataSource=self;
}
- (void)initSegmentedControl
{
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"自动生成奖品",@"用户导入奖品",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    
    @weakify(self)
    UIView* topBackgroundView=[[UIView alloc]init];
    [self.view addSubview:topBackgroundView];
    topBackgroundView.backgroundColor=[KSUtil colorWithHexString:@"#34BC87"];
    [topBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.mas_equalTo(self.view.mas_top).with.offset(62);
        make.height.mas_equalTo(39);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
    
    [self.view addSubview:segmentedControl];
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.mas_equalTo(self.view.mas_top).with.offset(64);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.view.mas_left).with.offset(25);
        make.right.mas_equalTo(self.view.mas_right).with.offset(-25);
    }];
}

-(void)doSomethingInSegment:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index)
    {
        case 0:
        {
            self.offlineView.alpha=1;
            self.onlineView.alpha=0;
        }
            break;
        case 1:
        {
            self.offlineView.alpha=0;
            self.onlineView.alpha=1;
        }
            break;
        default:
            break;
    }
}

-(void)initTitleBar
{
    UILabel* rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 80, 40)];
    rightTitleLabel.backgroundColor = [UIColor clearColor];
    rightTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightTitleLabel.textColor = [UIColor whiteColor];
    rightTitleLabel.text = @"添加";
    rightTitleLabel.textAlignment=NSTextAlignmentRight;
    UIButton* rightTitleButton=[[UIButton alloc] initWithFrame:CGRectMake(0,0,80,40)];
    [rightTitleButton addSubview:rightTitleLabel];
    [rightTitleButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightTitleButton];
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
}
-(void)nextStep
{
    if(!(self.welfateItem_name)||self.welfateItem_name.length==0)
    {
        KSError(@"福利名称不可为空");
        return;
    }
    if(!(self.welfateItem_content)||self.welfateItem_content.length==0)
    {
        KSError(@"福利内容不可为空");
        return;
    }
    if(self.welfateItem_amount==0)
    {
        KSError(@"奖项数量不可为0");
        return;
    }
    if(self.welfareItem)
    {
        self.welfareItem.amount=self.welfateItem_amount;
        self.welfareItem.name=self.welfateItem_name;
        self.welfareItem.content=self.welfateItem_content;
        self.welfareItem.delivery=self.welfateItem_delivery;
        [self.delegate onBenefitsWelfareItemUpdated];
    }
    else
    {
        WelfareItem * welfareItem=[[WelfareItem alloc]init];
        welfareItem.amount=self.welfateItem_amount;
        welfareItem.name=self.welfateItem_name;
        welfareItem.content=self.welfateItem_content;
        welfareItem.delivery=self.welfateItem_delivery;
        [self.delegate onBenefitsWelfareItemAdded:welfareItem];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.offlineTableView])
    {
        if(section==0)
            return 3;
        else return 1;
    }
    
    else
    {
        if(section==0)
            return 2;
        else
            return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableViewCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    tableViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
    if([tableView isEqual:self.offlineTableView])
    {
        
        UILabel* titleLabel=[[UILabel alloc]init];
        UITextField* textField=[[UITextField alloc]init];
        [tableViewCell.contentView addSubview:titleLabel];
        [tableViewCell.contentView addSubview:textField];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tableViewCell.contentView.mas_left).with.offset(16);
            make.bottom.mas_equalTo(tableViewCell.contentView.mas_bottom);
            make.top.mas_equalTo(tableViewCell.contentView.mas_top);
            make.width.mas_equalTo(100);
        }];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).with.offset(12);
            make.bottom.mas_equalTo(tableViewCell.contentView.mas_bottom);
            make.top.mas_equalTo(tableViewCell.contentView.mas_top);
            make.right.mas_equalTo(tableViewCell.contentView.mas_right);
        }];
        @weakify(self);
        if(indexPath.section==0)
        {
            switch (indexPath.row) {
                case 0:
                {
                    titleLabel.text=@"奖券名称";
                    textField.placeholder=@"例如：一等奖";
                    [textField setMaxTextLength:5];
                    if(self.welfareItem)textField.text=self.welfareItem.name;
                    [[textField rac_textSignal]subscribeNext:^(NSString* x) {
                        @strongify(self);
                        self.welfateItem_name=x;
                    }];
                    
                }
                    break;
                case 1:
                {
                    titleLabel.text=@"奖品内容";
                    textField.placeholder=@"例如:iPhone6s一部";
                    [textField setMaxTextLength:15];
                    if(self.welfareItem)textField.text=self.welfareItem.content;
                    [[textField rac_textSignal]subscribeNext:^(NSString* x) {
                        @strongify(self);
                        self.welfateItem_content=x;
                    }];
                }
                    
                    break;
                case 2:
                {
                    titleLabel.text=@"数量";
                    textField.placeholder=@"填写张数";
                    textField.keyboardType=UIKeyboardTypeNumberPad;
                    [textField setMaxTextLength:10];
                    [textField setMaxNumberValue:999999];
                    [textField setMinNumberValue:1];
                    if(self.welfareItem&&self.welfareItem.amount!=0)textField.text=[NSString stringWithFormat:@"%li",self.welfareItem.amount];
                    [[textField rac_textSignal]subscribeNext:^(NSString* x) {
                        @strongify(self);
                        self.welfateItem_amount=[x integerValue];
                    }];
                }
                    break;
                default:
                    break;
            }
        }
        else if(indexPath.section==1)
        {
            tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            titleLabel.text=@"发放形式";
//            textField.text=@"以奖券形式发放";
            textField.enabled=NO;
//            textField.textColor=[UIColor grayColor];
            UILabel *textLabel = [UILabel new];
            textLabel.textColor = [UIColor grayColor];
            [tableViewCell.contentView addSubview:textLabel];
            [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(tableViewCell).offset(-30);
                make.centerY.equalTo(tableViewCell);
            }];
            NSArray *tips = @[@"以奖券形式兑换",@"以实物形式寄送",@"以实物形式寄送"];
            [RACObserve(self, welfateItem_delivery) subscribeNext:^(NSNumber* x) {
                NSUInteger index = [x integerValue];
                textLabel.text = tips[index];
            }];
            if(self.welfareItem)
            {
                NSUInteger index = self.welfareItem.delivery;
                textLabel.text = tips[index];
            }
        }
        
    }
    else if([tableView isEqual:self.onlineTableView])
    {
        if(indexPath.section==0)
        {
            UILabel* titleLabel=[[UILabel alloc]init];
            UITextField* textField=[[UITextField alloc]init];
            [tableViewCell.contentView addSubview:titleLabel];
            [tableViewCell.contentView addSubview:textField];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(tableViewCell.contentView.mas_left).with.offset(16);
                make.bottom.mas_equalTo(tableViewCell.contentView.mas_bottom);
                make.top.mas_equalTo(tableViewCell.contentView.mas_top);
                make.width.mas_equalTo(100);
            }];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleLabel.mas_right).with.offset(12);
                make.bottom.mas_equalTo(tableViewCell.contentView.mas_bottom);
                make.top.mas_equalTo(tableViewCell.contentView.mas_top);
                make.right.mas_equalTo(tableViewCell.contentView.mas_right);
            }];
            if(indexPath.row==0)
            {
                titleLabel.text=@"奖品名称";
                textField.placeholder=@"例如：一等奖";
            }
            else
            {
                titleLabel.text=@"奖品内容";
                textField.placeholder=@"例如：iPhone6s一部";
            }
            
        }
        else if (indexPath.section==1)
        {
            UITextView* textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, tableViewCell.contentView.frame.size.width, 160)];
            textView.scrollEnabled=NO;
            [tableViewCell.contentView addSubview:textView];
            textView.font=[UIFont fontWithName:@"Arial" size:14];
        }
    }
    return tableViewCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==1)
    {
        NSUInteger curType = 0;
        //Todo
        if (self.welfateItem_delivery != 0)
        {
            curType = 1;
        }
        KSChooseTicketBenefitsGrantMethodViewController* viewController=[[KSChooseTicketBenefitsGrantMethodViewController alloc ] initWithType:curType];
        viewController.delegate=self;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if(section==1)
//    {
//        UIView* footerView=[[UIView alloc]init];
//        int margin=20;
//        int width=[UIScreen mainScreen].bounds.size.width-(margin*2);
//        UIButton * submitButton=[[UIButton alloc]initWithFrame:CGRectMake(margin, 20, width, 40)];
//        [submitButton setTitle:@"提交奖券码" forState:UIControlStateNormal];
//        submitButton.titleLabel.textColor=[UIColor whiteColor];
//        submitButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
//        submitButton.backgroundColor=[KSUtil colorWithHexString:@"#FCA461"];
//        submitButton.titleLabel.textAlignment=NSTextAlignmentCenter;
//        [footerView addSubview:submitButton];
//
//        UIButton* tipsButton=[[UIButton alloc]init];
//        [footerView addSubview:tipsButton];
//        [tipsButton setImage:[UIImage imageNamed:@"wenhao"] forState:UIControlStateNormal];
//        [tipsButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(20);
//            make.height.mas_equalTo(20);
//            make.bottom.mas_equalTo(footerView.mas_bottom);
//            make.centerX.mas_equalTo(footerView.mas_centerX);
//        }];
//
//        return footerView;
//    }
//    return [UIView new];
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==1)
    {
        return 100;
    }
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.offlineTableView])
        return 44;
    else
    {
        if(indexPath.section==0)
            return 44;
        else if(indexPath.section==1)
        {
            return 160;
        }
        else if(indexPath.section==2)
        {
            return 50;
        }
    }
    return 0;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:self.onlineTableView])
    {
        if(section==1)
            return @"手动输入奖券码";
    }
    return @"";
}


-(void)onDeliverySelectFinished:(NSInteger)delivery
{
    self.welfateItem_delivery=delivery;
}
@end
