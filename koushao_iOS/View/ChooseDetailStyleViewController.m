//
//  ChooseDetailStyleViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/10/30.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "ChooseDetailStyleViewController.h"
#import "ChooseCoverStyleViewController.h"
#import "InternalPhotoSlectorViewController.h"
#import "Masonry.h"
#import <YYWebImage.h>
#import "KSActivityCreatManager.h"

@interface ChooseDetailStyleViewController ()
@property(nonatomic,copy)NSArray* styleImageArray;
@property(nonatomic,strong)UIImageView* styleImageView;
@property(nonatomic,strong)UIImageView* contentImageView;
@property(nonatomic,strong)UITableView* styleListTableView;
@property(nonatomic,strong)KSActivityCreatManager* activitymanager;
@end

@implementation ChooseDetailStyleViewController

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
-(void)initData
{
    self.title=@"详情版式";
    self.styleImageArray=[NSArray arrayWithObjects:@"hdbs1",@"hdbs2",@"hdbs3",nil];
    self.activitymanager=[KSActivityCreatManager sharedManager];
    if(self.activitymanager.detailPosterArray.count==0)
    {
        self.activitymanager.detailPosterArray=[[NSMutableArray alloc]initWithArray:[NSArray arrayWithObjects:@"http://7xkafo.com2.z0.glb.qiniucdn.com/pic_7-1.jpg",@ "http://7xkafo.com2.z0.glb.qiniucdn.com/pic_6-3.jpg",@"http://7xkafo.com2.z0.glb.qiniucdn.com/pic_8-1.jpg", nil]];
        [self.activitymanager ks_saveOrUpdate];
    }
}
-(void)initView
{
    [self initBigArea];
    [self initStylesList];
}
#pragma mark 初始化大……的区域
-(void)initBigArea
{
    UIView* mainDisplayArea=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width/4*3, [[UIScreen mainScreen]bounds].size.height)];
    mainDisplayArea.backgroundColor=[KSUtil colorWithHexString:@"#F9FAFB"];
    [self.view addSubview:mainDisplayArea];
    
    UILabel* textLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 65, 200, 40)];
    textLabel.font=[UIFont fontWithName:@"Arial" size:14];
    textLabel.text=@"你选定的版式";
    textLabel.textColor=[UIColor grayColor];
    [mainDisplayArea addSubview:textLabel];
    
    CGFloat mainDisplayWidth=([[UIScreen mainScreen]bounds].size.width/4*3)-40;
    UIView* mainDisplayPhoneContainer=[[UIView alloc]initWithFrame:CGRectMake(20, 100, mainDisplayWidth, mainDisplayWidth*2.02)];
    [mainDisplayArea addSubview:mainDisplayPhoneContainer];
    
    UIImageView* phoneShellImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainDisplayWidth, mainDisplayWidth*2.02)];
    phoneShellImageView.image=[UIImage imageNamed:@"ic_mp1"];
    [mainDisplayPhoneContainer addSubview:phoneShellImageView];
    
    UIView* contentView=[[UIView alloc]initWithFrame:CGRectMake(mainDisplayWidth*0.07, mainDisplayWidth*0.406, mainDisplayWidth*0.86, mainDisplayWidth*1.379)];
    
    self.contentImageView=[[UIImageView alloc]init];
    [self.contentImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.contentImageView.clipsToBounds=YES;
    [self setContentImageByIndex:self.activitymanager.detailStyle toImageView:self.contentImageView];
    self.contentImageView.frame=[self getContentImageFrameByIndex:self.activitymanager.detailStyle andContentViewWidth:mainDisplayWidth*0.86];
    [contentView addSubview:self.contentImageView];
    
    self.styleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,mainDisplayWidth*0.86, mainDisplayWidth*1.379)];
    self.styleImageView.image=[UIImage imageNamed:[self.styleImageArray objectAtIndex:self.activitymanager.detailStyle]];
    [mainDisplayPhoneContainer addSubview:contentView];
    [contentView addSubview:  self.styleImageView];
    
    UIButton* changePictureButton=[[UIButton alloc]init];
    [contentView addSubview:changePictureButton];
    [changePictureButton setTitle:@"点击可替换图片" forState:UIControlStateNormal];
    [changePictureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changePictureButton.titleLabel.font=[UIFont fontWithName:@"Arial" size:20];
    changePictureButton.backgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
    @weakify(self)
    [changePictureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(self.styleImageView.mas_width);
        make.bottom.mas_equalTo(self.styleImageView.mas_bottom);
        make.left.mas_equalTo(self.styleImageView.mas_left);
    }];
    
    [[changePictureButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        InternalPhotoSlectorViewController* internalPhotoSlectorViewController=[[InternalPhotoSlectorViewController alloc]init];
        NSInteger detailPos=self.styleListTableView.indexPathForSelectedRow.row;
        NSInteger aspectX = 1;
        NSInteger aspectY = 1;
        internalPhotoSlectorViewController.cropMode=RSKImageCropModeCircle;
        if(detailPos!=1){
            if(detailPos==0)
            {
                aspectX = 8;
                aspectY = 5;}
            else
            {
                aspectX = 99;
                aspectY =64;
            }
            
            internalPhotoSlectorViewController.cropMode=RSKImageCropModeCustom;
        }
        internalPhotoSlectorViewController.aspectX=aspectX;
        internalPhotoSlectorViewController.aspectY=aspectY;
        internalPhotoSlectorViewController.delegate=self;
        [self.navigationController pushViewController:internalPhotoSlectorViewController animated:YES];
    }];
}

#pragma mark 初始化样式列表
-(void)initStylesList
{
    UIView* StylesListArea=[[UIView alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/4*3, 0, [[UIScreen mainScreen] bounds].size.width/4, [[UIScreen mainScreen]bounds].size.height)];
    StylesListArea.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:StylesListArea];
    
    CGFloat mainDisplayWidth=([[UIScreen mainScreen]bounds].size.width/4)-10;
    self.styleListTableView=[[UITableView alloc]initWithFrame:CGRectMake(5, 0, mainDisplayWidth, [[UIScreen mainScreen]bounds].size.height)];
    [StylesListArea addSubview:self.styleListTableView];
    
    self.styleListTableView.dataSource=self;
    NSIndexPath* indexPath=[NSIndexPath indexPathForRow:self.activitymanager.detailStyle inSection:0];
    [self.styleListTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    self.styleListTableView.delegate=self;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(100, 0.0, 0.0, 0.0);
    self.styleListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.styleListTableView setContentInset:contentInsets];
    self.styleListTableView.tableFooterView = [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tableViewCell=[[UITableViewCell alloc]init];
    tableViewCell.selectedBackgroundView = [[UIView alloc] initWithFrame:tableViewCell.frame];
//    tableViewCell.selectedBackgroundView.backgroundColor = [KSUtil colorWithHexString:@"#2CBD86"];
    tableViewCell.selectedBackgroundView.layer.borderWidth = 1;
    tableViewCell.selectedBackgroundView.layer.borderColor = BASE_COLOR.CGColor;
    CGFloat mainDisplayWidth=([[UIScreen mainScreen]bounds].size.width/4);
    
    UIView* contentView=[[UIView alloc]initWithFrame:CGRectMake(mainDisplayWidth*0.02, 8, mainDisplayWidth*0.86, mainDisplayWidth*1.379)];
    
//    contentView.layer.borderWidth = 2;
//    contentView.layer.borderColor = BASE_COLOR.CGColor;
    
    UIImageView* insetCoverImageView=[[UIImageView alloc]init];
    [insetCoverImageView setContentMode:UIViewContentModeScaleAspectFill];
    insetCoverImageView.frame=[self getContentImageFrameByIndex:indexPath.row andContentViewWidth:contentView.frame.size.width];
    
    insetCoverImageView.clipsToBounds=YES;
    [self setContentImageByIndex:indexPath.row toImageView:insetCoverImageView];
    [contentView addSubview:insetCoverImageView];
    
    
    UIImageView* styleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,mainDisplayWidth*0.86, mainDisplayWidth*1.379)];
    styleImageView.image=[UIImage imageNamed:[self.styleImageArray objectAtIndex:indexPath.row]];
    
    [contentView addSubview:styleImageView];
    [tableViewCell.contentView addSubview:contentView];
    
    return tableViewCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat mainDisplayWidth=([[UIScreen mainScreen]bounds].size.width/4)-10;
    return mainDisplayWidth*1.6+10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(CGRect)getContentImageFrameByIndex:(NSInteger)index andContentViewWidth:(CGFloat)contentViewWidth
{
    if(index==2)
    {
        return CGRectMake(0, contentViewWidth*0.54, contentViewWidth*0.99, contentViewWidth*0.64);
    }
    else if(index==1)
    {
        return CGRectMake(contentViewWidth*0.25, contentViewWidth*0.06, contentViewWidth*0.53,contentViewWidth*0.53);
    }
    else
    {
        return CGRectMake(contentViewWidth*0.03, contentViewWidth*0.03, contentViewWidth*0.94,contentViewWidth*0.59);
    }
    return CGRectMake(0, 0, 0, 0);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=self.activitymanager.detailStyle)
    {
        CGFloat mainDisplayWidth=([[UIScreen mainScreen]bounds].size.width/4*3)-40;
        self.styleImageView.image=[UIImage imageNamed:[self.styleImageArray objectAtIndex:indexPath.row]];
        [self setContentImageByIndex:indexPath.row toImageView:self.contentImageView];
        self.contentImageView.frame=[self getContentImageFrameByIndex:indexPath.row andContentViewWidth:mainDisplayWidth*0.86];
        self.activitymanager.detailStyle=indexPath.row;
        NSString* coverPosterPath=[self.activitymanager.detailPosterCroppedImage2OriginImageHashMap objectForKey:[self.activitymanager.detailPosterArray objectAtIndex:indexPath.row]];
        if(!coverPosterPath)
        {
            self.activitymanager.coverPosterPath=[self.activitymanager.detailPosterArray objectAtIndex:indexPath.row];
        }else
        {
            self.activitymanager.coverPosterPath=coverPosterPath;
        }
        self.activitymanager.coverPosterOriginalImagePath=coverPosterPath;
        [self.activitymanager ks_saveOrUpdate];
    }
}

-(void)initTitleBar
{
    self.navigationItem.backBarButtonItem.title=@"";
    UILabel* rightTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 80, 40)];
    rightTitleLabel.backgroundColor = [UIColor clearColor];
    rightTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    rightTitleLabel.textColor = [UIColor whiteColor];
    rightTitleLabel.text = @"下一步";
    rightTitleLabel.textAlignment=NSTextAlignmentRight;
    UIButton* rightTitleButton=[[UIButton alloc] initWithFrame:CGRectMake(0,0,80,40)];
    [rightTitleButton addSubview:rightTitleLabel];
    [rightTitleButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightTitleButton];
    
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
}

-(void)backToActivityList
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)nextStep
{
    self.activitymanager.detailStyle=self.styleListTableView.indexPathForSelectedRow.row;
    if((!self.activitymanager.coverPosterPath)||self.activitymanager.coverPosterPath.length==0)
    {
        self.activitymanager.coverPosterPath=[self.activitymanager.detailPosterArray objectAtIndex:self.activitymanager.detailStyle];
        self.activitymanager.coverPosterOriginalImagePath=self.activitymanager.coverPosterPath;
    }
    [self.activitymanager ks_saveOrUpdate];
    ChooseCoverStyleViewController * chooseCoverStyleViewController=[[ChooseCoverStyleViewController alloc]init];
    chooseCoverStyleViewController.isModify=self.isModify;
    chooseCoverStyleViewController.title=@"封面版式";
    chooseCoverStyleViewController.view.backgroundColor=[KSUtil colorWithHexString:@"#F9FAFB"];
    [self.navigationController pushViewController:chooseCoverStyleViewController animated:YES];
}
-(void)onImageSelectFinished:(NSString *)cropedimagePath withOriginPath:(NSString *)originPath
{
    [self.activitymanager.detailPosterCroppedImage2OriginImageHashMap setObject:originPath forKey:cropedimagePath];
    
    NSInteger detailPos=self.styleListTableView.indexPathForSelectedRow.row;
    [self.activitymanager.detailPosterArray setObject:cropedimagePath atIndexedSubscript:detailPos];
    [self.activitymanager ks_saveOrUpdate];
    [self.styleListTableView reloadData];
    [self.styleListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:detailPos inSection:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
    [self setContentImageByIndex:detailPos toImageView:self.contentImageView];
    NSString* coverPosterPath=[self.activitymanager.detailPosterCroppedImage2OriginImageHashMap objectForKey:[self.activitymanager.detailPosterArray objectAtIndex:detailPos]];
    
    if(!coverPosterPath)
    {
        self.activitymanager.coverPosterPath=[self.activitymanager.detailPosterArray objectAtIndex:detailPos];
    }else
    {
        self.activitymanager.coverPosterPath=coverPosterPath;
    }
    self.activitymanager.coverPosterOriginalImagePath=coverPosterPath;
    [self.activitymanager ks_saveOrUpdate];
    
}

-(UIImage*) getImageFileWithLocalName:(NSString*)filePath
{
    NSError* err = [[NSError alloc] init];
    NSData* data = [[NSData alloc] initWithContentsOfFile:filePath
                                                  options:NSDataReadingMapped
                                                    error:&err];
    UIImage* img = nil;
    if(data != nil)
    {
        img = [[UIImage alloc] initWithData:data];
    }
    else
    {
        NSLog(@"getImageFileWithName error code : %ld",(long)[err code]);
    }
    return img;
}

-(void)setContentImageByIndex:(NSInteger)index toImageView:(UIImageView*)imageView
{
    NSString* imagePath=[self.activitymanager.detailPosterArray objectAtIndex:index];
    if([imagePath hasPrefix:KS_SANDBOX])
    {
        imageView.image=[self getImageFileWithLocalName:[NSString stringWithFormat:@"%@/%@",LOCAL_IMAGE_DIC,[imagePath stringByReplacingOccurrencesOfString:KS_SANDBOX withString:@""]]];
    }
    else if([imagePath containsString:@"http://"])
    {
        NSURL* url=[NSURL URLWithString:imagePath];
        [imageView yy_setImageWithURL:url placeholder:nil];
    }
    else
    {
        imageView.image=[UIImage imageNamed:imagePath];
    }
}
@end
