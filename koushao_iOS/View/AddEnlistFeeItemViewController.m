//
//  AddEnlistFeeItemViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/3.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "AddEnlistFeeItemViewController.h"
#import "Masonry.h"
#import "UITextField+maxLength.h"
@interface AddEnlistFeeItemViewController ()

@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,copy)NSString* tips;
@property(nonatomic,assign)float price;
@property(nonatomic,assign)NSInteger amount;
@property(nonatomic,copy)NSString* itemTitle;
@end

@implementation AddEnlistFeeItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    [self initTitleBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initView
{
    self.view.backgroundColor=[UIColor whiteColor];
    //0实名制 1非实名制
    if(self.type==0)
    {
        self.title=@"费用方案";
        self.tips=@"该缴费形式为实名制，一个人仅可进行一种形式的缴费";
    }
    else
    {
        self.title=@"门票方案";
        self.tips=@"该缴费形式为非实名制，一个账号可购买多种类、多张票";
    }
    self.tableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
}
-(void)initData
{
    if(self.enlistFeeItem)
    {
        self.itemTitle=self.enlistFeeItem.title;
        self.price=self.enlistFeeItem.price;
        self.amount=self.enlistFeeItem.amount;
    }
}
-(void)initTitleBar
{
    UILabel* rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 80, 40)];
    rightTitleLabel.backgroundColor = [UIColor clearColor];
    rightTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightTitleLabel.textColor = [UIColor whiteColor];
    
    if(!self.enlistFeeItem)
    {
        rightTitleLabel.text = @"添加";
    }
    else
    {
        rightTitleLabel.text=@"确定";
    }
    
    rightTitleLabel.textAlignment=NSTextAlignmentRight;
    UIButton* rightTitleButton=[[UIButton alloc] initWithFrame:CGRectMake(0,0,80,40)];
    [rightTitleButton addSubview:rightTitleLabel];
    [rightTitleButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightTitleButton];
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
}
-(void)nextStep
{
    if((!self.itemTitle)||self.itemTitle.length==0)
    {
        KSError(@"名称不能为空！");
        return;
    }
    if(self.amount==0)
    {
        KSError(@"数量不能为0！");
        return;
    }
    if(self.enlistFeeItem)
    {
        self.enlistFeeItem.title=self.itemTitle;
        self.enlistFeeItem.price=self.price;
        self.enlistFeeItem.amount=self.amount;
        [self.delegate onEnlistFeeitemUpdated];
    }
    else
    {
        EnlistFeeItem * feeItem=[[EnlistFeeItem alloc]initWithTitle:self.itemTitle andPrice:self.price andAmount:self.amount];
        [self.delegate onEnlistFeeitemAdded:feeItem];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableViewCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    UILabel* titleLabel=[[UILabel alloc]init];
    UITextField* textField=[[UITextField alloc]init];
    [tableViewCell.contentView addSubview:titleLabel];
    [tableViewCell.contentView addSubview:textField];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tableViewCell.contentView.mas_left).with.offset(16);
        make.bottom.mas_equalTo(tableViewCell.contentView.mas_bottom);
        make.top.mas_equalTo(tableViewCell.contentView.mas_top);
        make.width.mas_equalTo(130);
    }];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).with.offset(12);
        make.bottom.mas_equalTo(tableViewCell.contentView.mas_bottom);
        make.top.mas_equalTo(tableViewCell.contentView.mas_top);
        make.right.mas_equalTo(tableViewCell.contentView.mas_right);
    }];
    switch (indexPath.row) {
        case 0:
        {
            if(self.type==0)
                titleLabel.text=@"费用名称";
            else titleLabel.text=@"票务名称";
            textField.placeholder=self.type==0?@"例如：大赛参赛费":@"例如：VIP票";
            [textField setMaxTextLength:15];
            if(self.enlistFeeItem)textField.text=self.enlistFeeItem.title;
            [[textField rac_textSignal]subscribeNext:^(NSString* x) {
                self.itemTitle=x;
            }];
            
        }
            break;
        case 1:
        {
            titleLabel.text=@"金额（元）";
            textField.placeholder=@"如果没有则不填";
            textField.keyboardType=UIKeyboardTypeDecimalPad;
            [textField setMaxTextLength:10];
            [textField setMaxNumberValue:999999];
            [textField setMinNumberValue:0];
            [textField setDemcialDigit:2];
            if(self.enlistFeeItem)
                textField.text=[NSString stringWithFormat:@"%.2f",self.enlistFeeItem.price];
            [[textField rac_textSignal]subscribeNext:^(NSString* x) {
                self.price=[x floatValue];
            }];
        }
            break;
        case 2:
        {
            if(self.type==0)
                titleLabel.text=@"名额数量";
            else titleLabel.text=@"票务数量（张）";
            textField.keyboardType=UIKeyboardTypeNumberPad;
            textField.placeholder=@"如果没有则不填";
            
            if(self.enlistFeeItem)
                textField.text=[NSString stringWithFormat:@"%li",(long)self.enlistFeeItem.amount];
            [textField setMaxTextLength:10];
            [textField setMaxNumberValue:999999];
            [textField setMinNumberValue:1];
            [[textField rac_textSignal]subscribeNext:^(NSString* x) {
                self.amount=[x integerValue];
            }];
        }
            break;
        default:
            break;
    }
    return tableViewCell;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.tips;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
@end
