//
//  AddTicketBenefitsWelfareItemViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "AddTicketBenefitsWelfareItemViewController.h"
#import "Masonry.h"

@interface AddTicketBenefitsWelfareItemViewController ()
@property(nonatomic,strong)UITableView* offlineTableView;
@property(nonatomic,strong)UITableView* onlineTableView;
@property(nonatomic,strong)UIView* offlineView;
@property(nonatomic,strong)UIView* onlineView;
@end

@implementation AddTicketBenefitsWelfareItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)initView
{
    self.title=@"添加奖券方案";
    self.view.backgroundColor=[UIColor whiteColor];
    [self initTitleBar];
    [self initSegmentedControl];
    int marginTop=101;
    self.onlineView=[[UIView alloc]initWithFrame:CGRectMake(0,marginTop, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-marginTop)];
    self.offlineView=[[UIView alloc]initWithFrame:CGRectMake(0, marginTop, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-marginTop)];
    
    self.onlineTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.onlineView.frame.size.width, self.onlineView.frame.size.height) style:UITableViewStyleGrouped];
    
    self.offlineTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.onlineView.frame.size.width, self.onlineView.frame.size.height) style:UITableViewStyleGrouped];
    [self.onlineView addSubview:self.onlineTableView];
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
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"自动生成奖券",@"用户导入奖券",nil];
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
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.offlineTableView])
        return 2;
    else
    {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableViewCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
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
        switch (indexPath.row) {
            case 0:
                titleLabel.text=@"奖券名称";
                textField.placeholder=@"例如：20元现金券";
                break;
            case 1:
                titleLabel.text=@"数量";
                textField.placeholder=@"填写张数";
                break;
            default:
                break;
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
            titleLabel.text=@"奖券名称";
            textField.placeholder=@"例如：20元现金券";
        }
        else if (indexPath.section==1)
        {
            UITextView* textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, tableViewCell.contentView.frame.size.width, 160)];
            textView.scrollEnabled=NO;
            [tableViewCell.contentView addSubview:textView];
            textView.font=[UIFont fontWithName:@"Arial" size:14];
        }
        else if(indexPath.section==2)
        {


          
            
        }
    }
    return tableViewCell;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==1)
    {
        UIView* footerView=[[UIView alloc]init];
        int margin=20;
        int width=[UIScreen mainScreen].bounds.size.width-(margin*2);
        UIButton * submitButton=[[UIButton alloc]initWithFrame:CGRectMake(margin, 20, width, 40)];
        [submitButton setTitle:@"提交奖券码" forState:UIControlStateNormal];
        submitButton.titleLabel.textColor=[UIColor whiteColor];
        submitButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:15];
        submitButton.backgroundColor=[KSUtil colorWithHexString:@"#FCA461"];
        submitButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        [footerView addSubview:submitButton];
        
        UIButton* tipsButton=[[UIButton alloc]init];
        [footerView addSubview:tipsButton];
        [tipsButton setImage:[UIImage imageNamed:@"wenhao"] forState:UIControlStateNormal];
        [tipsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(footerView.mas_bottom);
            make.centerX.mas_equalTo(footerView.mas_centerX);
        }];
        return footerView;
    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==1)
    {
        return 100;
    }
    else return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([tableView isEqual:self.offlineTableView])
        return 1;
    else
        return 2;
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
@end
