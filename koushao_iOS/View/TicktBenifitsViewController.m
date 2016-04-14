//
//  TicktBenifitsViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/11/2.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "TicktBenifitsViewController.h"
#import "Masonry.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "KSTicketButton.h"
#import "AddTicketBenefitsWelfareItemViewController.h"

@interface TicktBenifitsViewController ()
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSMutableArray* welfareItems;
@property(nonatomic,assign)CGFloat textViewHeight;
@end

@implementation TicktBenifitsViewController

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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, kbSize.height+40, 0.0);
    [self.tableView setContentInset:contentInsets];
    [self.tableView setScrollIndicatorInsets:contentInsets];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)keyboardShow:(NSNotification *)notif {
}

- (void)keyboardWillHide:(NSNotification *)notif {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, 40.0, 0.0);
    [self.tableView setContentInset:contentInsets];
    [self.tableView setScrollIndicatorInsets:contentInsets];
}

- (void)keyboardHide:(NSNotification *)notif {

}
-(void)initView
{
    self.title=@"奖券抽奖";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.top.mas_equalTo(self.view.mas_top).with.offset(-36);
    }];
}
-(void)initData
{
    self.welfareItems=[[NSMutableArray alloc]init];
    self.textViewHeight=130;
    
}
-(void)initTitleBar
{
    UILabel* rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 80, 40)];
    rightTitleLabel.backgroundColor = [UIColor clearColor];
    rightTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightTitleLabel.textColor = [UIColor whiteColor];
    rightTitleLabel.text = @"确定";
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
    if(section==0)
    {
        return self.welfareItems.count+3;
    }
    else if (section==1)
    {
        return 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableViewCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    tableViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 1:
        {
            UITextView* textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, tableViewCell.contentView.frame.size.width, self.textViewHeight)];
            textView.scrollEnabled=NO;
            [tableViewCell.contentView addSubview:textView];
            textView.font=[UIFont fontWithName:@"Arial" size:14];
            @weakify(self)
            [textView.rac_textSignal subscribeNext:^(NSString* x) {
                @strongify(self)
                CGFloat nowHeight=[KSUtil textHeight:x withFont:textView.font targetWidth:[UIScreen mainScreen].bounds.size.width];
                if(nowHeight>self.textViewHeight)
                {
                    self.textViewHeight=nowHeight;
                    textView.frame=CGRectMake(0, 0, tableViewCell.contentView.frame.size.width, self.textViewHeight);
                    [self.tableView beginUpdates];
                    [self.tableView endUpdates];
                }
                else if(nowHeight<=130&&self.textViewHeight!=130)
                {
                    self.textViewHeight=130;
                    textView.frame=CGRectMake(0, 0, tableViewCell.contentView.frame.size.width, self.textViewHeight);
                    [self.tableView beginUpdates];
                    [self.tableView endUpdates];
                }
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
                make.height.mas_equalTo(80);
                make.top.mas_equalTo(tableViewCell.contentView.mas_top).with.offset(5);
                make.right.mas_equalTo(tableViewCell.contentView.mas_right).with.offset(-16);
            }];
            if(indexPath.row==0)
            {
                ticketButton.buttonStyle=KSTicketButtonStyleAdd;
                ticketButton.titleText=@"添加奖券方案";
            }
            else
            {
                ticketButton.buttonStyle=KSTicketButtonStyleRed;
                ticketButton.titleText=@"生成券";
                ticketButton.subtitleText=@"iPhone6s一部";
                ticketButton.bottomLeftText=@"数量:999223";
                
            }
            [[ticketButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                AddTicketBenefitsWelfareItemViewController* addTicketBenefitsWelfareItemViewController=[[AddTicketBenefitsWelfareItemViewController alloc]init];
                [self.navigationController pushViewController:addTicketBenefitsWelfareItemViewController animated:YES];
            }];
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
    if(indexPath.section==0)return 90;
    else return self.textViewHeight;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return @"";
    else return @"福利说明";
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)return 90;
    else return self.textViewHeight;
}
@end
