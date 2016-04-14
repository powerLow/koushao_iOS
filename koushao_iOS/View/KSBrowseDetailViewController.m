//
//  KSBrowseDetailViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/2.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSBrowseDetailViewController.h"
#import "KSBrowseDetailViewModel.h"
#import "Masonry.h"

#import "PNChart.h"

#define COLOR1 HexRGB(0xe94c3d)
#define COLOR2 HexRGB(0x3895db)
#define COLOR3 HexRGB(0xf4c30f)
#define COLOR4 HexRGB(0x22b89b)
#define COLOR5 HexRGB(0xe36497)
#define COLOR6 HexRGB(0x7a8382)

//微博 QQ 其他 微信
#define WEIBO_COLOR HexRGB(0xe94c3d)
#define QQ_COLOR HexRGB(0x3895db)
#define OTHER_COLOR HexRGB(0xf4c30f)
#define WEIXIN_COLOR HexRGB(0x22b89b)

//色块的大小
#define SQUARE_WIDTH_HEIGHT 15
//说明距左边的距离
#define Label_Left 10

@interface KSBrowsePageItem : NSObject

@property (nonatomic,strong) NSNumber *time;//停留时间
@property (nonatomic,assign) NSNumber *count;//访问次数
@property (nonatomic,copy) NSString* page_name;//页面颜色
@property (nonatomic,assign) NSUInteger *type;//是停留时间 还是访问次数
@property (nonatomic,strong) UIColor *color;//条的颜色
@property (nonatomic,assign) NSUInteger timeWidth;//条的长度
@property (nonatomic,assign) NSUInteger countWidth;
@end

@implementation KSBrowsePageItem

@end

@interface KSBrowseDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic, readwrite) KSBrowseDetailViewModel *viewModel;
@property (nonatomic) PNPieChart *pieChart;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray* dataSource;

@end

@implementation KSBrowseDetailViewController
@dynamic viewModel;

- (instancetype)initWithViewModel:(id<KSViewModelProtocol>)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                [self.viewModel.requestRemoteDataCommand execute:@1];
            }];
        }
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewModel.activity = [KSUtil getCurrentActivity];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    @weakify(self)
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = MBPROGRESSHUD_LABEL_TEXT;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.scrollView.hidden = NO;
        }
    }];
    
    //headerView
    UIView *headerView = [UIView new];
    [self.view addSubview:headerView];
    UILabel *browseLabel = [UILabel new];
    UILabel *interestingLabel = [UILabel new];
    UIButton *browseBtn = [UIButton new];
    UIButton *interestingBtn = [UIButton new];
    
    
    [headerView addSubview:browseBtn];
    [headerView addSubview:interestingBtn];
    
    [browseBtn addSubview:browseLabel];
    [interestingBtn addSubview:interestingLabel];
    
    [browseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(headerView);
        make.width.equalTo(interestingBtn);
    }];
    [interestingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(browseBtn.mas_right);
        make.right.top.bottom.equalTo(headerView);
    }];
    
    browseLabel.textColor = [UIColor whiteColor];
    browseLabel.textAlignment = NSTextAlignmentCenter;
    browseLabel.text = @"0";
    browseLabel.font = [UIFont boldSystemFontOfSize:50.0];
    
    interestingLabel.textColor = [UIColor whiteColor];
    interestingLabel.textAlignment = NSTextAlignmentCenter;
    interestingLabel.text = @"0";
    interestingLabel.font = [UIFont boldSystemFontOfSize:50.0];
    
    UILabel *visitsTextLabel = [UILabel new];
    visitsTextLabel.text = @"次浏览";
    visitsTextLabel.textAlignment = NSTextAlignmentCenter;
    visitsTextLabel.textColor = [UIColor whiteColor];
    [browseBtn addSubview:visitsTextLabel];
    
    UILabel *enrollTextLabel = [UILabel new];
    enrollTextLabel.text = @"人感兴趣";
    enrollTextLabel.textAlignment = NSTextAlignmentCenter;
    enrollTextLabel.textColor = [UIColor whiteColor];
    [interestingBtn addSubview:enrollTextLabel];
    
    //浏览次数
    [browseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(browseBtn);
        make.centerY.equalTo(browseBtn).offset(-10);
        make.height.equalTo(browseBtn).multipliedBy(0.5);
    }];
    
    //"次浏览" 在下面
    [visitsTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(browseBtn);
        make.top.equalTo(browseLabel.mas_bottom);
    }];
    //报名人数
    [interestingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(interestingBtn);
        make.centerY.equalTo(interestingBtn).offset(-10);
        make.height.equalTo(interestingBtn).multipliedBy(0.5);
    }];
    //"人感兴趣" 在下面
    [enrollTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(interestingBtn);
        make.top.equalTo(interestingLabel.mas_bottom);
    }];
    
    headerView.backgroundColor = BASE_COLOR;
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.2);
    }];
    
    //图表
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    UIView *container = [UIView new];
    [scrollView addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    self.scrollView = scrollView;
    self.scrollView.hidden = YES;
    //城市分布比例
    UIView *subContainer1 = [UIView new];
    [container addSubview:subContainer1];
    
    [subContainer1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(container);
        make.top.equalTo(container);
    }];
    
    
    //访问途径分布比例
    
    UIView *subContainer2 = [UIView new];
    [container addSubview:subContainer2];
    [subContainer2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.equalTo(self.view);
        make.top.equalTo(subContainer1.mas_bottom);
    }];
    
    //页面访问统计
    UIView *subContainer3 = [UIView new];
    [container addSubview:subContainer3];
    
    [subContainer3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(container);
        make.top.equalTo(subContainer2.mas_bottom);
    }];
    
    
    
    //自动计算contentSize
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(subContainer3.mas_bottom);
    }];
    
    
    
    //数据绑定 - 访问城市分布
    
    [RACObserve(self.viewModel, visitsInfo) subscribeNext:^(KSActivityVisitsInfo *info) {
        for (UIView* view in subContainer1.subviews) {
            [view removeFromSuperview];
        }
        NSArray *colors = @[COLOR1,COLOR2,COLOR3,COLOR4,COLOR5,COLOR6];
        if (info != nil) {
            subContainer1.hidden = NO;
            //填充数据
            NSMutableArray *items = [NSMutableArray new];
            NSMutableArray *imageViews = [NSMutableArray new];
            NSMutableArray *lables = [NSMutableArray new];
            
            CGFloat sum = 0;
            
            for (int i = 0 ; i< info.city.count; ++i) {
                NSDictionary *city = info.city[i];
                NSNumber* city_count = city.allValues[0];
                sum += [city_count floatValue];
            }
            
            
            for (int i = 0 ; i< info.city.count; ++i) {
                NSDictionary *city = info.city[i];
                NSString* city_name = city.allKeys[0];
                NSNumber* city_count = city.allValues[0];
                //NSLog(@"city = %@ , count = %@",city_name,city_count);
                if (![city_count isEqualToNumber:@0]) {
                    UIColor *color =colors[i];
                    PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:[city_count unsignedIntegerValue] color:color];
                    
                    [items addObject:item];
                    //小色块
                    UIImageView *imageView = [UIImageView new];
                    imageView.image = color.color2Image;
                    [imageViews addObject:imageView];
                    
                    //色块右边的标题
                    UILabel *label = [UILabel new];
                    CGFloat bfb = [city_count floatValue] * 100 / sum;
                    label.text = [NSString stringWithFormat:@"%@ %.2f%%",city_name,bfb];
//                    label.text = [NSString stringWithFormat:@"%@  %@",city_name,city_count];
//                    label.textColor = KS_GrayColor4;
                    
                    [lables addObject:label];
                    
                    [subContainer1 addSubview:imageView];
                    [subContainer1 addSubview:label];
                }
            }
            if (items.count > 0 ){
                //绘制图形
                UILabel *cityLabel = [UILabel new];
                cityLabel.text = @"城市分布比例(%)";
                [subContainer1 addSubview:cityLabel];
                
                [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    @strongify(self)
                    make.left.equalTo(self.view).offset(Label_Left);
                    make.top.equalTo(subContainer1.mas_top).offset(20);
                }];
                
                //说明图例
                const NSUInteger count = 2;        //2列
                UIImageView *lastView = nil;
                for (int i = 0; i < items.count; ++i) {
                    UIImageView *imageView = imageViews[i];
                    UILabel *label = lables[i];
                    //第几行
                    NSUInteger row = i / count;
                    //第几列
                    NSUInteger coloum = i % count;
                    //NSLog(@"第 %lu 行,第 %lu 列",(unsigned long)row,(unsigned long)coloum);
                    
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        if (row == 0) {
                            make.top.equalTo(cityLabel.mas_bottom).offset(10);
                        }else{
                            make.top.equalTo(cityLabel.mas_bottom).offset(SQUARE_WIDTH_HEIGHT*row+10*(row+1));
                        }
                        
                        if (coloum == 0) {
                            make.left.equalTo(subContainer1.mas_left).offset(20);
                        }else{
                            make.left.equalTo(subContainer1.mas_centerX).offset(20);
                        }
                        
                        make.height.width.equalTo(@(SQUARE_WIDTH_HEIGHT));
                    }];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(imageView);
                        make.left.equalTo(imageView.mas_right).offset(30);
                        make.height.equalTo(imageView);
                    }];
                    lastView = imageView;
                }
                
                
                PNPieChart *cityChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, 200, 200) items:items];
                
                cityChart.descriptionTextColor = [UIColor clearColor];
                cityChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
                cityChart.descriptionTextShadowColor = [UIColor clearColor];
                cityChart.showAbsoluteValues = NO;
                cityChart.showOnlyValues = NO;
                cityChart.shouldHighlightSectorOnTouch = NO;
                [cityChart strokeChart];
                
                [subContainer1 addSubview:cityChart];
                
                [cityChart mas_makeConstraints:^(MASConstraintMaker *make) {
                    @strongify(self)
                    make.height.width.equalTo(@200);
                    make.centerX.equalTo(self.view);
                    make.top.equalTo(lastView.mas_bottom).offset(30);
                }];
                
                UILabel *description = [UILabel new];
                description.text = @"城市分布";
                [cityChart addSubview:description];
                [description mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(cityChart);
                }];
                
                [subContainer1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(cityChart.mas_bottom).offset(10);
                }];
            }else{
                //没数据就不显示
                subContainer1.hidden = YES;
            }
            
        }
    }];
    
    //数据绑定 - 访问路径分布
    [RACObserve(self.viewModel, visitsInfo) subscribeNext:^(KSActivityVisitsInfo *info) {
        for (UIView* view in subContainer2.subviews) {
            [view removeFromSuperview];
        }
        NSArray *colors = @[COLOR1,COLOR2,COLOR3,COLOR4,COLOR5,COLOR6];
        if (info != nil) {
            subContainer2.hidden = NO;
            //填充数据
            NSMutableArray *items = [NSMutableArray new];
            NSMutableArray *imageViews = [NSMutableArray new];
            NSMutableArray *lables = [NSMutableArray new];
            NSDictionary *app = @{
                                  @"weixin" : @"微信",
                                  @"weibo":@"微博",
                                  @"QQ":@"QQ",
                                  @"other":@"其他",
                                  };
            NSNumber *sum = [info.app.allValues valueForKeyPath:@"@sum.self"];
            for (int i = 0; i< info.app.allKeys.count; ++i) {
                NSString* key = info.app.allKeys[i];
                //NSLog(@"app ---> key = %@ , value = %@",key,info.app[key]);
                NSString *value_name = key;
                NSNumber *value_count = info.app[key];
                if (![value_count isEqualToNumber:@0]) {
                    UIColor *color = colors[i];
                    PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:[value_count unsignedIntegerValue] color:colors[i]];
                    [items addObject:item];
                    
                    //小色块
                    UIImageView *imageView = [UIImageView new];
                    imageView.image = color.color2Image;
                    [imageViews addObject:imageView];
                    
                    //色块右边的标题
                    UILabel *label = [UILabel new];
                    CGFloat bfb = [value_count floatValue] * 100 / [sum floatValue] ;
                    label.text = [NSString stringWithFormat:@"%@ %.2f%%",app[value_name],bfb];
//                    label.textColor = KS_GrayColor4;
                    [lables addObject:label];
                    
                    [subContainer2 addSubview:imageView];
                    [subContainer2 addSubview:label];
                }
            }
            if (items.count > 0) {
                //绘制view
                UILabel *label2 = [UILabel new];
                label2.text = @"访问途径比例(%)";
                [subContainer2 addSubview:label2];
                
                [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    @strongify(self);
                    make.left.equalTo(self.view).offset(Label_Left);
                    make.top.equalTo(subContainer2.mas_top);
                }];
                
                
                //说明图例
                const NSUInteger count = 2;        //2列
                UIImageView *lastView = nil;
                for (int i = 0; i < items.count; ++i) {
                    UIImageView *imageView = imageViews[i];
                    UILabel *label = lables[i];
                    //第几行
                    NSUInteger row = i / count;
                    //第几列
                    NSUInteger coloum = i % count;
                    //NSLog(@"第 %lu 行,第 %lu 列",(unsigned long)row,(unsigned long)coloum);
                    
                    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        if (row == 0) {
                            make.top.equalTo(label2.mas_bottom).offset(10);
                        }else{
                            make.top.equalTo(label2.mas_bottom).offset(SQUARE_WIDTH_HEIGHT*row+10*(row+1));
                        }
                        
                        if (coloum == 0) {
                            make.left.equalTo(subContainer1.mas_left).offset(20);
                        }else{
                            make.left.equalTo(subContainer1.mas_centerX).offset(20);
                        }
                        
                        make.height.width.equalTo(@(SQUARE_WIDTH_HEIGHT));
                    }];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(imageView);
                        make.left.equalTo(imageView.mas_right).offset(30);
                        make.height.equalTo(imageView);
                    }];
                    lastView = imageView;
                }
                
                PNPieChart *browseChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, 200, 200) items:items];
                browseChart.descriptionTextColor = [UIColor clearColor];
                browseChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
                browseChart.descriptionTextShadowColor = [UIColor clearColor];
                browseChart.showAbsoluteValues = NO;
                browseChart.showOnlyValues = NO;
                browseChart.shouldHighlightSectorOnTouch = NO;
                [browseChart strokeChart];
                
                [subContainer2 addSubview:browseChart];
                
                
                [browseChart mas_makeConstraints:^(MASConstraintMaker *make) {
                    @strongify(self)
                    make.height.width.equalTo(@200);
                    make.centerX.equalTo(self.view);
                    make.top.equalTo(lastView.mas_bottom).offset(30);
                }];
                
                UILabel *browseDescriptionLabel = [UILabel new];
                browseDescriptionLabel.text = @"访问途径";
                [browseChart addSubview:browseDescriptionLabel];
                [browseDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(browseChart);
                }];
                
                
                [subContainer2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(browseChart.mas_bottom).offset(10);
                }];
            }else{
                //没数据就不显示
                subContainer2.hidden = YES;
                
            }
            
        }else{
            //没数据就不显示
            subContainer2.hidden = YES;
        }
    }];
    
    //数据绑定 - 页面访问统计
    [RACObserve(self.viewModel, visitsInfo) subscribeNext:^(KSActivityVisitsInfo *info) {
        UIColor *blueColor = HexRGB(0x93e2ff);
        UIColor *redColor = HexRGB(0xfc4563);
        for (UIView *view in subContainer3.subviews) {
            [view removeFromSuperview];
        }
        if (info != nil) {
            //展示出来
            subContainer3.hidden = NO;
            NSDictionary *title = @{
                                    @"welfare":@"抽奖页",
                                    @"detail":@"详情页",
                                    @"signin":@"报名页",
                                    @"cover":@"封面页",
                                    @"question":@"咨询页",
                                    };
            const NSUInteger left = 15;
            
            UILabel *pageLabel = [UILabel new];
            pageLabel.text = @"页面访问统计";
            [subContainer3 addSubview:pageLabel];
            
            [pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self)
                make.left.equalTo(self.view).offset(Label_Left);
                make.top.equalTo(subContainer3.mas_top).offset(20);
                
            }];
            //两个小方块
            UIImageView *timeImageView = [UIImageView new];
            UIImageView *countImageView = [UIImageView new];
            
            timeImageView.image = blueColor.color2Image;
            countImageView.image = redColor.color2Image;
            
            [subContainer3 addSubview:timeImageView];
            [subContainer3 addSubview:countImageView];
            
            //小方块旁边的说明文字
            UILabel *timeLabel = [UILabel new];
            UILabel *countLable = [UILabel new];
            [subContainer3 addSubview:timeLabel];
            [subContainer3 addSubview:countLable];
            
            
            timeLabel.text = @"停留时间";
            countLable.text = @"访问次数";
            
            [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.equalTo(@(SQUARE_WIDTH_HEIGHT));
                make.left.equalTo(subContainer3).offset(left);
                make.top.equalTo(pageLabel.mas_bottom).offset(8);
            }];
            [countImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.height.width.equalTo(timeImageView);
                make.top.equalTo(timeImageView.mas_bottom).offset(5);
            }];
            
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(timeImageView.mas_right).offset(8);
                make.top.height.equalTo(timeImageView);
            }];
            
            [countLable mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(countImageView.mas_right).offset(8);
                make.top.height.equalTo(countImageView);
            }];
            
            
            NSMutableArray *countArray = [NSMutableArray new];
            NSMutableArray *timeArray = [NSMutableArray new];
            for (NSString* key in info.page.allKeys) {
                //每个页面的访问次数和时间
                [countArray addObject:info.page[key][@"count"]];
                [timeArray addObject:info.page[key][@"time"]];
            }
            
            NSUInteger maxCount = [[countArray valueForKeyPath:@"@max.self"] unsignedIntegerValue];
            NSUInteger maxTime = [[timeArray valueForKeyPath:@"@max.self"] unsignedIntegerValue];
            NSUInteger maxWidth = self.view.bounds.size.width * 0.65;
            NSMutableArray *data = [NSMutableArray new];
            for (NSString* key in info.page.allKeys) {
                NSNumber *count = info.page[key][@"count"];
                NSNumber *time = info.page[key][@"time"];
                if ([count integerValue] == 0 || [time integerValue] == 0) {
                    //等于0 就不显示了;
                    continue;
                }
                KSBrowsePageItem *item = [KSBrowsePageItem new];
                item.page_name = title[key];
                item.count = info.page[key][@"count"];
                item.time = info.page[key][@"time"];
                item.timeWidth = [time floatValue] / maxTime * maxWidth;
                item.countWidth = [count floatValue] / maxCount * maxWidth;
//                imageView_time.image = blueColor.color2Image;
                [data addObject:item];
            }
            if (data.count == 0) {
                subContainer3.hidden = YES;
            }else{
                self.dataSource = [[NSArray alloc] initWithObjects:data,data, nil];
            }
            
            
            UITableView *tableView = [[UITableView alloc] init];
            tableView.delegate = self;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.dataSource = self;
            tableView.scrollEnabled = NO;
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
            [subContainer3 addSubview:tableView];
            NSUInteger tableHeight = data.count * 2 * 44 + 10*2;
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(subContainer1);
                make.top.equalTo(countLable.mas_bottom).offset(5);
                make.height.mas_equalTo(tableHeight);
            }];
            [subContainer3 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(tableView.mas_bottom).offset(10);
            }];
            [container mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(subContainer3.mas_bottom);
            }];
            
        }else{
            subContainer3.hidden = YES;
        }
        
    }];
    //标题 （次浏览,人感兴趣）
    [RACObserve(self.viewModel, visitsInfo) subscribeNext:^(KSActivityVisitsInfo *info) {
        if (info != nil) {
            KSActivity *act = [KSUtil getCurrentActivity];
            act.visits = info.visits;
            browseLabel.text = [NSString stringWithFormat:@"%@",info.visits];
            interestingLabel.text = [NSString stringWithFormat:@"%@",info.interested];
        }else{
            KSActivity *act = [KSUtil getCurrentActivity];
            browseLabel.text = [NSString stringWithFormat:@"%@",act.visits];
            interestingLabel.text = @"0";
        }
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataSource count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataSource[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    KSBrowsePageItem *item = self.dataSource[indexPath.section][indexPath.row];

    UILabel *name_label = [UILabel new];
    name_label.text = item.page_name;
    name_label.font = KS_FONT_16;
    [cell.contentView addSubview:name_label];
    
    UILabel *data_label = [UILabel new];
    data_label.textColor = KS_GrayColor4;
    data_label.font = KS_SMALL_FONT;
    if (indexPath.section == 0) {
        NSInteger secCount = [item.time integerValue];
        NSInteger hh = secCount/3600;
        NSInteger mm = (secCount/60)%60;
        NSInteger ss = secCount%60;
        if (ss >= 0) {
            data_label.text = [NSString stringWithFormat:@"%ld秒",(long)ss];
        }
        if (mm > 0) {
            data_label.text = [NSString stringWithFormat:@"%ld分%ld秒",(long)mm,(long)ss];
        }
        if (hh > 0) {
            data_label.text = [NSString stringWithFormat:@"%ld时%ld分%ld秒",(long)hh,(long)mm,(long)ss];
        }
    }else{
        data_label.text = [NSString stringWithFormat:@"%@次",item.count];
    }
    
    [cell.contentView addSubview:data_label];
    
    UIColor *blueColor = HexRGB(0x93e2ff);
    UIColor *redColor = HexRGB(0xfc4563);
    UIImageView *progressView = [UIImageView new];
    progressView.image = indexPath.section == 0 ? blueColor.color2Image : redColor.color2Image;
    [cell.contentView addSubview:progressView];
    
    [name_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(5);
        make.left.equalTo(cell.contentView).offset(10);
    }];
    [data_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name_label);
        make.top.equalTo(name_label.mas_bottom).offset(3);
    }];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name_label.mas_right).offset(30);
        make.centerY.equalTo(cell.contentView);
        make.height.equalTo(@35);
        make.width.mas_equalTo(MAX(indexPath.section == 0 ? item.timeWidth : item.countWidth,2));
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

@end
