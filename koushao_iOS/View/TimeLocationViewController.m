//
//  TimeLocationViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/10/28.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "TimeLocationViewController.h"
#import "ActivityDetailViewController.h"
#import "MapSelectViewController.h"
#import "UITextField+maxLength.h"
#import "Masonry.h"
#import "KSActivityCreatManager.h"
#import "KSClientApi.h"
#import "KSActivityCreatApiResult.h"
#import "MapSelectNavigationController.h"
#import "UITextField+maxLength.h"
#import "KSPlaceHolderTextView.h"

@interface TimeLocationViewController ()
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)UITextField *startTimeUITextField;
@property(nonatomic,strong)UITextField *endTimeUITextField;
@property(nonatomic,strong)UITextField* activityNameTextField;
@property(nonatomic,strong)KSPlaceHolderTextView* activityLocationTextView;
@property(nonatomic,strong)UIView* accessoryView;
@property(nonatomic,strong)UIView* locationView;
@property(nonatomic,strong)UIDatePicker* datePciker;
@property(nonnull,strong)UILabel* maxLengthLabel;

@property(nonatomic,strong)NSDate* startDate;
@property(nonatomic,strong)NSDate* endDate;

@property(nonatomic,strong)KSActivityCreatManager *activityCreatManager;
@end

@implementation TimeLocationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initTitleBar];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.activityCreatManager=[KSActivityCreatManager sharedManager];
    self.activityLocationTextView.text=self.activityCreatManager.location;
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
    
    //下一步按钮
    UILabel* rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 80, 40)];
    rightTitleLabel.backgroundColor = [UIColor clearColor];
    rightTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightTitleLabel.textColor = [UIColor whiteColor];
    if(self.isModify)rightTitleLabel.text = @"完成";
    else rightTitleLabel.text = @"下一步";
    rightTitleLabel.textAlignment=NSTextAlignmentRight;
    UIButton* rightTitleButton=[[UIButton alloc] initWithFrame:CGRectMake(0,0,80,40)];
    [rightTitleButton addSubview:rightTitleLabel];
    [rightTitleButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightTitleButton];
    
    //设置NavigationBar的相关属性
    self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}
-(void)initData
{
    self.title=@"活动基本信息";
    self.activityCreatManager=[KSActivityCreatManager sharedManager];
}

-(void)backToActivityList
{
    if(self.isModify)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

//导航到下一个页面
-(void)navigateToNext
{
    if(self.isModify)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        ActivityDetailViewController *activityDetailViewController=[[ActivityDetailViewController alloc]init];
        activityDetailViewController.view.backgroundColor=[UIColor whiteColor];
        activityDetailViewController.title=@"活动详情";
        [self.navigationController pushViewController:activityDetailViewController animated:YES];
    }
}


-(void)nextStep
{
    if(!self.activityCreatManager.title||self.activityCreatManager.title.length==0)
    {
        KSError(@"活动名称不能为空！");
        return;
    }
    if(!self.activityCreatManager.location||self.activityCreatManager.location.length==0)
    {
        KSError(@"活动地点不能为空！");
        return;
    }
    //修改的是已经创建的活动
    if(self.activityCreatManager.hashCode&&self.activityCreatManager.hashCode.length!=0)
    {
        [self.view endEditing:YES];
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在提交数据";
        BOOL hasEndTime=self.activityCreatManager.hasEndTime==0;
        NSMutableDictionary *params=
        [NSMutableDictionary dictionaryWithDictionary:
         @{
           @"title": self.activityCreatManager.title,
           @"location": self.activityCreatManager.location,
           @"startTime" :@(self.activityCreatManager.startTime),
           @"endTime":@(hasEndTime?self.activityCreatManager.endTime:0),
           @"isday":@(self.activityCreatManager.allDay)
           }];
        if(self.activityCreatManager.longitude!=0)
        {
            [params setObject:[NSNumber numberWithFloat:self.activityCreatManager.longitude] forKey:@"longitude"];
            [params setObject:[NSNumber numberWithFloat:self.activityCreatManager.latitude] forKey:@"latitude"];
        }
        [[KSClientApi upDateActivity:params]subscribeNext:^(id x) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                [self navigateToNext];
            });
            
        } error:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            KSError([error.userInfo objectForKey:@"tips"]);
            
        } completed:^{
            
        }];
        
    }
    //新创建的活动
    else
    {
        [self.view endEditing:YES];
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"活动正在创建中";
        [[KSClientApi creatActivity]subscribeNext:^(KSActivityCreatApiResult* x) {
            self.activityCreatManager.hashCode=x.hashCode;
            self.activityCreatManager.sig=x.sig;
            [self.activityCreatManager ks_saveOrUpdate];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                [self navigateToNext];
            });
            
        } error:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            KSError([error.userInfo objectForKey:@"tips"]);
        } completed:^{
            
        }];
    }
    
}
-(NSDate*)coverTimeStamp2Date:(NSInteger)timestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return publishDate;
}
-(NSString*)coverTimeStamp2String:(NSInteger)timestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    publishDate = [publishDate  dateByAddingTimeInterval: interval];
    
    if(self.activityCreatManager.allDay==1)
        [formatter setDateFormat:@"YYYY年MM月dd日"];
    else
        [formatter setDateFormat:@"YYYY年MM月dd日 HH点mm分"];
    return[formatter stringFromDate:publishDate];
}
-(void)initView
{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    //开始时间的UILabel
    self.startTimeUITextField=[[UITextField alloc]init];
    self.startTimeUITextField.textAlignment=NSTextAlignmentRight;
    self.startTimeUITextField.font=[UIFont fontWithName:@"Helvetica" size:15];
    //结束时间的UILabel
    self.endTimeUITextField=[[UITextField alloc]init];
    self.endTimeUITextField.textAlignment=NSTextAlignmentRight;
    self.endTimeUITextField.font=[UIFont fontWithName:@"Helvetica" size:15];
    @weakify(self)
    [[self.startTimeUITextField rac_signalForControlEvents:
      UIControlEventEditingDidBegin]subscribeNext:^(id x) {
        @strongify(self)
        self.datePciker.date=[self coverTimeStamp2Date:self.activityCreatManager.startTime];
    }];
    [[self.endTimeUITextField rac_signalForControlEvents:UIControlEventEditingDidBegin]subscribeNext:^(id x) {
        @strongify(self)
        self.datePciker.date=[self coverTimeStamp2Date:self.activityCreatManager.endTime];
    }];
    
    if(self.activityCreatManager.startTime==0)
    {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        self.activityCreatManager.startTime=a;
    }
    self.startTimeUITextField.text=[self coverTimeStamp2String:self.activityCreatManager.startTime];
    
    if(self.activityCreatManager.endTime==0)
    {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        self.activityCreatManager.endTime=a+86400;
    }
    self.endTimeUITextField.text=[self coverTimeStamp2String:self.activityCreatManager.endTime];
    
    //活动名称的文本框
    self.activityNameTextField=[[UITextField alloc]initWithFrame:CGRectMake(18, 3, [[UIScreen mainScreen]bounds].size.width-30, 40)];
    self.activityNameTextField.placeholder=@"活动名称";
    self.activityNameTextField.text=self.activityCreatManager.title;
    [self.activityNameTextField setMaxTextLength:30]; //活动名称最多30个字
    [[self.activityNameTextField rac_textSignal]subscribeNext:^(id x) {
        @strongify(self)
        self.activityCreatManager.title=self.activityNameTextField.text;
        [self.activityCreatManager ks_saveOrUpdate];
    }];
    
    
    
    //活动地点的TextField及定位的按钮
    UILabel* locationTitle=[[UILabel alloc]initWithFrame:CGRectMake(18, 0, [[UIScreen mainScreen]bounds].size.width-90, 40)];
    locationTitle.text=@"活动地点";
    
    self.locationView=[[UIView alloc]initWithFrame:CGRectMake(0, 3, [[UIScreen mainScreen]bounds].size.width-30, 40)];
    [self.locationView addSubview:locationTitle];
    
    self.activityLocationTextView=[[KSPlaceHolderTextView alloc]init];
    self.activityLocationTextView.delegate=self;
    
    self.activityLocationTextView.text=_activityCreatManager.location;
    self.activityLocationTextView.placeholder=@"手动输入活动地点";
    self.activityLocationTextView.font=[UIFont systemFontOfSize:15];
    [RACObserve(self.activityLocationTextView, text)subscribeNext:^(id x) {
        _maxLengthLabel.text=[NSString stringWithFormat:@"%li",_activityLocationTextView.text.length];
    }];
    
    self.maxLengthLabel=[[UILabel alloc]init];
    self.maxLengthLabel.font=[UIFont systemFontOfSize:13];
    self.maxLengthLabel.textColor=[UIColor grayColor];
    
    
    
    //地图选点按钮
    UIButton* locatedButton=[[UIButton alloc]initWithFrame:CGRectMake(self.locationView.frame.size.width-20, 10, 40, 40)];
    UIImageView* locatedImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    locatedImageView.image=[UIImage imageNamed:@"icon_location_map"];
    
    [locatedButton addSubview:locatedImageView];
    [self.locationView addSubview:locatedButton];
    [locatedButton addTarget:self action:@selector(MapSelect) forControlEvents:UIControlEventTouchUpInside];
    
    //日期的选择视图
    self.accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    UIButton* btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(self.accessoryView.frame.size.width-70, 7, 60, 30);
    [btnDone setTitle:@"确定" forState:UIControlStateNormal];
    [btnDone setTitleColor:KS_Maintheme_Color forState:(UIControlStateNormal)];
    [self.accessoryView addSubview:btnDone];
    [btnDone addTarget:self action:@selector(OnDateSelectDone) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(70, 7, 60, 30);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:KS_Maintheme_Color forState:(UIControlStateNormal)];[self.accessoryView addSubview:cancelButton];
    [[cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self.startTimeUITextField resignFirstResponder];
        [self.endTimeUITextField resignFirstResponder];
    }];
    
    self.datePciker = [[UIDatePicker alloc] init];
    self.datePciker.backgroundColor=[UIColor whiteColor];
    [self.datePciker addTarget:self action:@selector(datePickerDataChanged:) forControlEvents:UIControlEventValueChanged];
    [self.accessoryView addSubview:self.datePciker];
    
    self.startTimeUITextField.inputAccessoryView = self.accessoryView;
    self.startTimeUITextField.inputView = self.datePciker;
    
    self.endTimeUITextField.inputAccessoryView = self.accessoryView;
    self.endTimeUITextField.inputView = self.datePciker;
}
-(void)OnDateSelectDone
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate* dateNow= [NSDate dateWithTimeIntervalSinceNow:0];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:dateNow];
    long day=[comps day];//获取日期对应的长整形字符串
    long year=[comps year];//获取年对应的长整形字符串
    long month=[comps month];//获取月对应的长整形字符串
    NSString* dateString=[NSString stringWithFormat:@"%li-%li-%li",year,month,day];
    NSDate* dateToday=[dateFormatter dateFromString:dateString];
    
    if(self.startTimeUITextField.isFirstResponder)
    {
        if([self.datePciker.date timeIntervalSinceDate:dateToday]<0)
        {
            KSError(@"活动开始时间不能早于当前时间");
        }
        else
        {
            self.activityCreatManager.startTime=[self.datePciker.date timeIntervalSince1970];
            self.startTimeUITextField.text=[self coverTimeStamp2String:self.activityCreatManager.startTime];
            [self.activityCreatManager ks_saveOrUpdate];
            [self.startTimeUITextField resignFirstResponder];
            
            if([self.datePciker.date timeIntervalSince1970]-self.activityCreatManager.endTime>0)
            {
                //设置结束时间
                self.activityCreatManager.endTime=[self.datePciker.date timeIntervalSince1970]+86400;
                self.endTimeUITextField.text=[self coverTimeStamp2String:self.activityCreatManager.endTime];
                [self.activityCreatManager ks_saveOrUpdate];
                [self.endTimeUITextField resignFirstResponder];
            }
        }
        
    }
    else if(self.endTimeUITextField.isFirstResponder)
    {
        if([self.datePciker.date timeIntervalSince1970]-self.activityCreatManager.startTime<0)
        {
            KSError(@"活动开始时间不能大于结束时间");
        }
        else
        {
            self.activityCreatManager.endTime=[self.datePciker.date timeIntervalSince1970];
            self.endTimeUITextField.text=[self coverTimeStamp2String:self.activityCreatManager.endTime];
            [self.activityCreatManager ks_saveOrUpdate];
            [self.endTimeUITextField resignFirstResponder];
        }
    }
}
-(void)datePickerDataChanged:(UIDatePicker*)sender
{
    
}

-(void)MapSelect
{
    MapSelectNavigationController* mapSelectViewController=[[MapSelectNavigationController alloc]init];
    [self presentViewController:mapSelectViewController animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if(self.activityCreatManager.hasEndTime==0)
                return 4;
            else
                return 3;
            break;
        case 2:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewcell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
    tableViewcell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(indexPath.section==0)
    {
        switch (indexPath.row) {
            case 0:
            {
                [tableViewcell.contentView addSubview:self.activityNameTextField];
                return tableViewcell;
            }
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section==1)
    {
        switch (indexPath.row) {
            case 0:
            {
                UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(18, 0, 200, 40)];
                label1.text=@"全天";
                [tableViewcell.contentView addSubview:label1];
                UISwitch* wholeDaySwitch=[[UISwitch alloc]init];
                wholeDaySwitch.onTintColor=[KSUtil colorWithHexString:@"#2CBD86"];
                tableViewcell.accessoryView = wholeDaySwitch;
                if(self.activityCreatManager.allDay==1)
                {
                    wholeDaySwitch.on=YES;
                    self.datePciker.datePickerMode=UIDatePickerModeDate;
                }
                else
                {
                    wholeDaySwitch.on=NO;
                    self.datePciker.datePickerMode=UIDatePickerModeDateAndTime;
                }
                [[wholeDaySwitch rac_signalForControlEvents:UIControlEventValueChanged]subscribeNext:^(id x) {
                    UISwitch *switchButton = (UISwitch*)x;
                    BOOL isButtonOn = [switchButton isOn];
                    if (isButtonOn) {
                        self.activityCreatManager.allDay=1;
                        [self.activityCreatManager ks_saveOrUpdate];
                        self.datePciker.datePickerMode=UIDatePickerModeDate;
                        self.endTimeUITextField.text=[self coverTimeStamp2String:self.activityCreatManager.endTime];
                        self.startTimeUITextField.text=[self coverTimeStamp2String:self.activityCreatManager.startTime];
                    }else {
                        self.activityCreatManager.allDay=0;
                        [self.activityCreatManager ks_saveOrUpdate];
                        self.datePciker.datePickerMode=UIDatePickerModeDateAndTime;
                        self.endTimeUITextField.text=[self coverTimeStamp2String:self.activityCreatManager.endTime];
                        self.startTimeUITextField.text=[self coverTimeStamp2String:self.activityCreatManager.startTime];
                    }
                }];
                return tableViewcell;
            }
                break;
            case 1:
            {
                UISwitch* deleteEndTimeDaySwitch=[[UISwitch alloc]init];
                deleteEndTimeDaySwitch.onTintColor=[KSUtil colorWithHexString:@"#2CBD86"];
                tableViewcell.accessoryView = deleteEndTimeDaySwitch;
                UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(18, 0, 200, 40)];
                label1.text=@"取消结束时间";
                [tableViewcell.contentView addSubview:label1];
                NSIndexPath* endTimeIndexPath=[NSIndexPath indexPathForRow:3 inSection:1];
                if(self.activityCreatManager.hasEndTime==0)
                {
                    deleteEndTimeDaySwitch.on=NO;
                }
                else
                {
                    deleteEndTimeDaySwitch.on=YES;
                }
                [[deleteEndTimeDaySwitch rac_signalForControlEvents:UIControlEventValueChanged]subscribeNext:^(id x) {
                    UISwitch *switchButton = (UISwitch*)x;
                    BOOL isButtonOn = [switchButton isOn];
                    if (isButtonOn) {
                        self.activityCreatManager.hasEndTime=1;
                        [self.activityCreatManager ks_saveOrUpdate];
                        [self.tableView beginUpdates];
                        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:endTimeIndexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
                        [self.tableView endUpdates];
                        
                    }else {
                        self.activityCreatManager.hasEndTime=0;
                        [self.activityCreatManager ks_saveOrUpdate];
                        [self.tableView beginUpdates];
                        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:endTimeIndexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
                        [self.tableView endUpdates];
                    }
                }];
                
                return tableViewcell;
            }
                break;
            case 2:
            {
                UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(18, 0, 60, 40)];
                label1.text=@"开始";
                tableViewcell.selectionStyle=UITableViewCellSelectionStyleNone;
                [tableViewcell.contentView addSubview:label1];
                [tableViewcell.contentView addSubview:self.startTimeUITextField];
                [self.startTimeUITextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(label1.mas_right).with.offset(12);
                    make.bottom.mas_equalTo(tableViewcell.contentView.mas_bottom);
                    make.top.mas_equalTo(tableViewcell.contentView.mas_top);
                    make.right.mas_equalTo(tableViewcell.contentView.mas_right).with.offset(-12);
                }];
                return tableViewcell;
            }
                break;
                
            case 3:
            {
                UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(18, 0, 60, 40)];
                label1.text=@"结束";
                tableViewcell.selectionStyle=UITableViewCellSelectionStyleNone;
                [tableViewcell.contentView addSubview:label1];
                [tableViewcell.contentView addSubview:self.endTimeUITextField];
                [self.endTimeUITextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(label1.mas_right).with.offset(12);
                    make.bottom.mas_equalTo(tableViewcell.contentView.mas_bottom);
                    make.top.mas_equalTo(tableViewcell.contentView.mas_top);
                    make.right.mas_equalTo(tableViewcell.contentView.mas_right).with.offset(-12);
                }];
                return tableViewcell;
            }
                
                break;
            default:
                break;
        }
    }
    else if (indexPath.section==2)
    {
        switch (indexPath.row) {
            case 0:
                [tableViewcell.contentView addSubview:self.locationView];
                break;
            case 1:
            {
                [tableViewcell.contentView addSubview:_activityLocationTextView];
                [tableViewcell.contentView addSubview:_maxLengthLabel];
                [_activityLocationTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(UIEdgeInsetsMake(5, 16, 20, 16));
                }];
                _maxLengthLabel.textAlignment=NSTextAlignmentRight;
                [_maxLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(tableViewcell.contentView.mas_bottom).with.offset(-6);
                    make.right.mas_equalTo(tableViewcell.contentView.mas_right).with.offset(-16);
                    make.height.mas_equalTo(20);
                    make.width.mas_equalTo(60);
                }];
            }
                break;
            default:
                break;
        }
    }
    return tableViewcell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==2&&indexPath.row==1)return 130;
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)textViewDidChange:(UITextView *)textView
{
    int length = 40;
    bool isChinese;
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    if ([current.primaryLanguage isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    NSString *str = [[_activityLocationTextView text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) {
        UITextRange *selectedRange = [_activityLocationTextView markedTextRange];
        UITextPosition *position = [_activityLocationTextView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if ( str.length>=length) {
                NSString *strNew = [NSString stringWithString:str];
                [_activityLocationTextView setText:[strNew substringToIndex:length]];
                
            }
        }
        else
        {
            
        }
    }else{
        if ([str length]>=length) {
            NSString *strNew = [NSString stringWithString:str];
            [_activityLocationTextView setText:[strNew substringToIndex:length]];
        }
    }
    _maxLengthLabel.text=[NSString stringWithFormat:@"%li",_activityLocationTextView.text.length];
    _activityCreatManager.location=_activityLocationTextView.text;
}

@end
