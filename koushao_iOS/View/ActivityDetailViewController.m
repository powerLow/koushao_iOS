//
//  ActivityDetailViewController.m
//  koushao_iOS
//
//  Created by 陈奇 on 15/10/29.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "RichEditContentItem.h"
#import "KSUtil.h"
#import "RichEditTableViewCellImage.h"
#import "RichEditTableViewCellText.h"
#import "RichEditTableViewCellTitle.h"
#import "ChooseDetailStyleViewController.h"
#import "KSActivityCreatManager.h"
#import "ImageUploader.h"
#import "Masonry.h"
#import "ImageUploadProgress.h"

@interface ActivityDetailViewController ()
{
}
@property (nonatomic,strong) NSMutableArray* richcontent;
@property (nonatomic,strong) UITableView* richeditTableView;
@property (nonatomic,strong) UIScrollView* richEditorBackgroundScrollView;
@property (nonatomic,strong) UIImageView* richEditorBackgroundImageView;
@property (nonatomic,strong) UIView* toolbarView;
@property(nonatomic,strong) KSActivityCreatManager* activityManager;

@property(nonatomic,assign) NSInteger seletPosition;
@property(nonatomic,assign) NSRange selectTextRange;
@property(nonatomic,strong) UITextView *activeTextView;
@property(nonatomic,strong) UITextField *activeTextField;
@property(nonatomic,assign)BOOL isKeyboardShow;
@end

@implementation ActivityDetailViewController

#pragma mark 富文本编辑框列表相关的常量
NSString *TableViewCellIdImage=@"TableViewCellIdImage";
NSString *TableViewCellIdText=@"TableViewCellIdText";
NSString *TableViewCellIdTitle=@"TableViewCellIdTitle";


NSArray *presetString;
const int TEXT=0;
const int IMAGE=1;
const int TITLE=2;

BOOL isFromImage=NO;
BOOL isToolbarShow=NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self initView];
    [RACObserve(self, selectTextRange)subscribeNext:^(id x) {
        NSRange range;
        [x getValue:&range];
        NSLog(@"location: %li",range.location);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setImagePercent:)   name:NOTIFICATION_IMAGE_UPLOAD object:nil];
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

-(void)initData
{
    self.title=@"活动详情";
    self.isKeyboardShow=NO;
    self.richcontent=[[NSMutableArray alloc]init]; //初始化富文本框的内容数组
    self.activityManager=[KSActivityCreatManager sharedManager];
    self.richcontent=self.activityManager.detailItems;
    NSString *presetString_1=@"尽量用一句话来描述你的活动\n\n\n\n";
    NSString *presetString_2=@"输入你的编辑内容\n\n\n\n";
    presetString=[NSArray arrayWithObjects:presetString_1,presetString_2,nil];
    
    if(self.richcontent)
    {
        if(self.richcontent.count==0)
        {
            
            RichEditContentItem *richEditContentItem1 = [[RichEditContentItem alloc]init];
            richEditContentItem1.contentType=TITLE;
            richEditContentItem1.contentString=@"活动简介";
            [self.richcontent addObject:richEditContentItem1];
            
            
            RichEditContentItem *richEditContentItem2 =[[RichEditContentItem alloc]init];
            richEditContentItem2.contentType=TEXT;
            richEditContentItem2.contentString= presetString[0];
            [self.richcontent addObject:richEditContentItem2];
            
            RichEditContentItem *richEditContentItem3 = [[RichEditContentItem alloc]init];
            richEditContentItem3.contentType=TITLE;
            richEditContentItem3.contentString=@"活动安排";
            [self.richcontent addObject:richEditContentItem3];
            
            RichEditContentItem *richEditContentItem4 = [[RichEditContentItem alloc]init];
            richEditContentItem4.contentType=TEXT;
            richEditContentItem4.contentString=presetString[1];
            [self.richcontent addObject:richEditContentItem4];
            
            RichEditContentItem *richEditContentItem5 =[[RichEditContentItem alloc]init];
            richEditContentItem5.contentType=TITLE;
            richEditContentItem5.contentString=@"注意事项";
            [self.richcontent addObject:richEditContentItem5];
            
            RichEditContentItem *richEditContentItem6 =[[RichEditContentItem alloc]init];
            richEditContentItem6.contentType=TEXT;
            richEditContentItem6.contentString=presetString[1];
            [self.richcontent addObject:richEditContentItem6];
            
        }
    }
}

-(void)setImagePercent:(NSNotification*) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ImageUploadProgress* imageUploadProgress=[notification object];
        NSArray* visibleCellIndexPathArray=[self.richeditTableView indexPathsForVisibleRows];
        NSInteger position=0;
        for(NSIndexPath* indexPath in visibleCellIndexPathArray)
        {
            RichEditContentItem* richContentItem=[self.richcontent objectAtIndex:indexPath.row];
            if([richContentItem.contentString isEqualToString:imageUploadProgress.filePath])
            {
                UITableViewCell* cell=[[self.richeditTableView visibleCells]objectAtIndex:position];
                if([cell isKindOfClass:[RichEditTableViewCellImage class]])
                {
                    NSLog(@"position %li",(long)position);
                    RichEditTableViewCellImage* imageCell=(RichEditTableViewCellImage*)cell;
                    [imageCell setPercent:imageUploadProgress.percent];
                }
            }
            position++;
        }
    });
}

-(void)initToolBar
{
    self.toolbarView=[[UIView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-104, [[UIScreen mainScreen] bounds].size.width, 100)];
    self.toolbarView.backgroundColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8];
    UIImageView *insertImageImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"insert_img_gray"]];
    UIButton *insertImageButton=[[UIButton alloc]initWithFrame:CGRectMake(40, 6, 60, 27)];
    [insertImageButton addSubview:insertImageImageView];
    
    UIImageView *insertTitleImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title_gray"]];
    UIButton *insertTitleButton=[[UIButton alloc]initWithFrame:CGRectMake(120, 6, 60, 27)];
    [insertTitleButton addSubview:insertTitleImageView];
    self.toolbarView.alpha=0;
    [self.toolbarView addSubview:insertImageButton];
    [self.toolbarView addSubview:insertTitleButton];
    
    [insertImageButton addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [insertTitleButton addTarget:self action:@selector(insertTitle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *topBorder=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 0.5)];
    topBorder.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.toolbarView addSubview:topBorder];
    [self.view addSubview:self.toolbarView];
}

-(void)initRichEditor
{
    self.richeditTableView=[[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    self.richeditTableView.delegate=self;
    self.richeditTableView.dataSource=self;
    self.richeditTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.richeditTableView registerClass:[RichEditTableViewCellImage class]forCellReuseIdentifier:TableViewCellIdImage];
    [self.richeditTableView registerClass:[RichEditTableViewCellText class] forCellReuseIdentifier:TableViewCellIdText];
    [self.richeditTableView registerClass:[RichEditTableViewCellTitle class] forCellReuseIdentifier:TableViewCellIdTitle];
    self.richeditTableView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(40, 0.0, 40.0, 0.0);
    [self.richeditTableView setContentInset:contentInsets];
    [self.richeditTableView setScrollIndicatorInsets:contentInsets];
    [self.view addSubview:self.richeditTableView];
    self.richeditTableView.showsVerticalScrollIndicator=NO;
    
    @weakify(self);
    [self.richeditTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 30, 0, 30));
    }];
    
}

-(void)initRichEditorBackground
{
    self.richEditorBackgroundScrollView=[[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(40, 0.0, 40.0, 0.0);
    [self.richEditorBackgroundScrollView setContentInset:contentInsets];
    [self.richEditorBackgroundScrollView setScrollIndicatorInsets:contentInsets];
    self.richEditorBackgroundScrollView.scrollEnabled=NO;
    self.richEditorBackgroundScrollView.contentSize=CGSizeMake([[UIScreen mainScreen] bounds].size.width, 10000);
    //添加四个边阴影
    self.richEditorBackgroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10,-13, [[UIScreen mainScreen] bounds].size.width-20, 10000)];
    
    self.richEditorBackgroundImageView.translatesAutoresizingMaskIntoConstraints=NO;
    self.richEditorBackgroundImageView.backgroundColor=[UIColor whiteColor];
    self.richEditorBackgroundImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.richEditorBackgroundImageView.layer.shadowOffset = CGSizeMake(0, 0);
    self.richEditorBackgroundImageView.layer.shadowOpacity = 0.5;
    [self.richEditorBackgroundScrollView addSubview:self.richEditorBackgroundImageView];
    [self.view addSubview:self.richEditorBackgroundScrollView];
}

-(void)initTitleBar
{
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
    // self.navigationItem.leftBarButtonItem=leftBarButtonItem;
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
    self.richeditTableView.keyboardDismissMode  = UIScrollViewKeyboardDismissModeOnDrag;
}

-(void)backToActivityList
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)isImageUploadFinish
{
    for(RichEditContentItem* richEditContentItem in self.richcontent)
    {
        if (richEditContentItem.contentType==IMAGE) {
            
            if([richEditContentItem.contentString containsString:@"assets-library://"])
            {
                return NO;
                break;
            }
        }
    }
    return YES;
}
-(void)nextStep
{
    if([self isImageUploadFinish])
    {
        [self.view endEditing:YES];
        
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在提交数据";
        NSString* jsonString=[[RichEditContentItem mj_keyValuesArrayWithObjectArray:self.activityManager.detailItems].mj_keyValues mj_JSONString];
        
        NSString* str2=[presetString[0]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        NSString* str3=[presetString[1]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        
        NSString* detailString=[[jsonString stringByReplacingOccurrencesOfString:str2 withString:@""]stringByReplacingOccurrencesOfString:str3 withString:@""];
        
        
        NSMutableDictionary *params=
        [NSMutableDictionary dictionaryWithDictionary:
         @{
           @"detail": detailString,
           }];
        [[KSClientApi upDateActivity:params]subscribeNext:^(id x) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                if(self.isModify)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    ChooseDetailStyleViewController * chooseDetailStyleViewController=[[ChooseDetailStyleViewController alloc]init];
                    chooseDetailStyleViewController.title=@"详情版式";
                    chooseDetailStyleViewController.view.backgroundColor=[KSUtil colorWithHexString:@"#F9FAFB"];
                    [self.navigationController pushViewController:chooseDetailStyleViewController animated:YES];
                }
                
            });
            
        } error:^(NSError *error) {
            KSError([error.userInfo objectForKey:@"tips"]);
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
        } completed:^{
            
        }];
    }
    else
    {
        KSError(@"图片尚未上传完毕！请稍等片刻！");
    }
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

#pragma mark 初始化页面控件
-(void)initView
{
    self.view.backgroundColor=[UIColor whiteColor];
    [self registerSoftKeyboardNotification];
    [self initRichEditorBackground];
    [self initRichEditor];
    [self initTitleBar];
    [self initToolBar];
}

- (void)keyboardWillShow:(NSNotification *)notif {
    self.isKeyboardShow=YES;
    NSDictionary* info = [notif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(40, 0.0, kbSize.height+40, 0.0);
    [self.richeditTableView setContentInset:contentInsets];
    [self.richeditTableView setScrollIndicatorInsets:contentInsets];
    [self.richEditorBackgroundScrollView setContentInset:contentInsets];
    [self.richEditorBackgroundScrollView setScrollIndicatorInsets:contentInsets];
    @try {
        [self.richeditTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_seletPosition inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        self.toolbarView.alpha=1;
        self.toolbarView.frame=CGRectMake(self.toolbarView.frame.origin.x, [[UIScreen mainScreen] bounds].size.height-104-kbSize.height,self.toolbarView.frame.size.width, self.toolbarView.frame.size.height);
    }
    @catch (NSException *exception) {
        NSLog(@"UITableView exception!!");
    }
    @finally {
        
    };
    
}

- (void)keyboardShow:(NSNotification *)notif {
    
}

- (void)keyboardWillHide:(NSNotification *)notif {
    self.isKeyboardShow=NO;
    self.toolbarView.alpha=0;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(40, 0.0, 40.0, 0.0);
    [self.richeditTableView setContentInset:contentInsets];
    [self.richeditTableView setScrollIndicatorInsets:contentInsets];
    [self.richEditorBackgroundScrollView setContentInset:contentInsets];
    [self.richEditorBackgroundScrollView setScrollIndicatorInsets:contentInsets];
    self.toolbarView.alpha=0;
    self.toolbarView.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-104, [[UIScreen mainScreen] bounds].size.width, 40);
}

- (void)keyboardHide:(NSNotification *)notif {
    if(isToolbarShow)
    {
        isToolbarShow=NO;
        self.toolbarView.alpha=0;
        self.toolbarView.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-104, [[UIScreen mainScreen] bounds].size.width, 40);
    }
}

#pragma mark 插入标题
-(IBAction)insertTitle:(id)sender
{
    RichEditContentItem *richContentTargetTitleItem=[[RichEditContentItem alloc]init];
    [richContentTargetTitleItem setContentType:TITLE];
    [richContentTargetTitleItem setContentString:@""];
    if(_seletPosition==-1)
    {
        [self.richcontent addObject:richContentTargetTitleItem];
    }
    else
    {
        RichEditContentItem *selectRichContentItem=[self.richcontent objectAtIndex:_seletPosition];
        if(selectRichContentItem.contentType==TEXT)
        {
            if(_seletPosition==0&&_selectTextRange.location==0)
            {
                [self.richcontent insertObject:richContentTargetTitleItem atIndex:_seletPosition];
            }
            else if(_selectTextRange.location!=selectRichContentItem.contentString.length)
            {   NSString *oraginString=selectRichContentItem.contentString;
                NSString *splitString_1=[oraginString substringToIndex:_selectTextRange.location];
                NSString *splitString_2=[oraginString substringFromIndex:_selectTextRange.location];
                RichEditContentItem *stringItem1=[[RichEditContentItem alloc]init];
                stringItem1.contentType=TEXT;
                stringItem1.contentString=splitString_1;
                RichEditContentItem *stringItem2=[[RichEditContentItem alloc]init];
                stringItem2.contentType=TEXT;
                stringItem2.contentString=splitString_2;
                [self.richcontent removeObjectAtIndex:_seletPosition];
                [self.richcontent insertObject:stringItem1 atIndex:_seletPosition];
                [self.richcontent insertObject:richContentTargetTitleItem atIndex:_seletPosition+1];
                [self.richcontent insertObject:stringItem2 atIndex:_seletPosition+2];
            }
            else
            {
                [self.richcontent insertObject:richContentTargetTitleItem atIndex:_seletPosition+1];
                if((_seletPosition+2)<=self.richcontent.count-1)
                {
                    RichEditContentItem *nextRichContentItem=[self.richcontent objectAtIndex:_seletPosition+2];
                    if(nextRichContentItem.contentType==IMAGE)
                    {
                        RichEditContentItem* spaceRichContent=[[RichEditContentItem alloc]init];
                        spaceRichContent.contentType=TEXT;
                        spaceRichContent.contentString=@"";
                        [self.richcontent insertObject:spaceRichContent atIndex:_seletPosition+2];
                    }
                }
            }
            
        }
        else if(selectRichContentItem.contentType==TITLE)
        {
            RichEditContentItem* spaceRichContent=[[RichEditContentItem alloc]init];
            spaceRichContent.contentType=TEXT;
            spaceRichContent.contentString=@"";
            
            [self.richcontent insertObject:spaceRichContent atIndex:_seletPosition+1];
            [self.richcontent insertObject:richContentTargetTitleItem atIndex:_seletPosition+2];
        }
    }
    [self checkRichContent];
    [self.richeditTableView reloadData];
    [self.activityManager ks_saveOrUpdate];
    
}

#pragma mark 根据图片路径插入图片
-(void)insertImage:(NSString*) imageUrl withImage:(UIImage *) targetImage
{
    NSLog([NSString stringWithFormat:@"selectposition :%li",(long)_seletPosition ],nil);
    RichEditContentItem *richContentTargetImageItem=[[RichEditContentItem alloc]init];
    [richContentTargetImageItem setContentType:IMAGE];
    [richContentTargetImageItem setContentString:imageUrl];
    [richContentTargetImageItem setHeight:[self calcImageSize:targetImage].height];
    [richContentTargetImageItem setWidth:[self calcImageSize:targetImage].width];
    if(_seletPosition==-1)
    {
        [self.richcontent addObject:richContentTargetImageItem];
        [self checkRichContent];
        [self.richeditTableView reloadData];
        [self.richeditTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.richcontent.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        RichEditContentItem *selectRichContentItem=[self.richcontent objectAtIndex:_seletPosition];
        if(selectRichContentItem.contentType==TEXT)
        {
            if(_selectTextRange.location!=selectRichContentItem.contentString.length)
            {   NSString *oraginString=selectRichContentItem.contentString;
                NSString *splitString_1=[oraginString substringToIndex:_selectTextRange.location];
                NSString *splitString_2=[oraginString substringFromIndex:_selectTextRange.location];
                RichEditContentItem *stringItem1=[[RichEditContentItem alloc]init];
                stringItem1.contentType=TEXT;
                stringItem1.contentString=splitString_1;
                RichEditContentItem *stringItem2=[[RichEditContentItem alloc]init];
                stringItem2.contentType=TEXT;
                stringItem2.contentString=splitString_2;
                [self.richcontent removeObjectAtIndex:_seletPosition];
                [self.richcontent insertObject:stringItem1 atIndex:_seletPosition];
                [self.richcontent insertObject:richContentTargetImageItem atIndex:_seletPosition+1];
                [self.richcontent insertObject:stringItem2 atIndex:_seletPosition+2];
                [self checkRichContent];
                [self.richeditTableView reloadData];
                [self.richeditTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_seletPosition+1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            else
            {
                RichEditContentItem* spaceRichContent=[[RichEditContentItem alloc]init];
                spaceRichContent.contentType=TEXT;
                spaceRichContent.contentString=@"";
                [self.richcontent insertObject:richContentTargetImageItem atIndex:_seletPosition+1];
                [self.richcontent insertObject:spaceRichContent atIndex:_seletPosition+2];
                [self checkRichContent];
                [self.richeditTableView reloadData];
                [self.richeditTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_seletPosition+1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            
        }
        else if(selectRichContentItem.contentType==TITLE)
        {
            RichEditContentItem* spaceRichContent=[[RichEditContentItem alloc]init];
            spaceRichContent.contentType=TEXT;
            spaceRichContent.contentString=@"";
            [self.richcontent insertObject:spaceRichContent atIndex:_seletPosition+1];
            [self.richcontent insertObject:richContentTargetImageItem atIndex:_seletPosition+2];
            [self.richeditTableView reloadData];
            [self.richeditTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_seletPosition+1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    [self.activityManager ks_saveOrUpdate];
    
}


-(void)checkRichContent
{
    for (int i = 0; i < self.richcontent.count; i++) {
        if (i != (self.richcontent.count - 1)) {
            RichEditContentItem *richEditContentItem1 = [self.richcontent objectAtIndex:i];
            RichEditContentItem *richEditContentItem2 = [self.richcontent objectAtIndex:i+1];
            if (richEditContentItem1.contentType== TEXT && richEditContentItem2.contentType == TEXT) {
                richEditContentItem1.contentString=[NSString stringWithFormat:@"%@\n%@", richEditContentItem1.contentString ,richEditContentItem2.contentString];
                [self.richcontent removeObject:richEditContentItem2];
                i--;
            }
        }
    }
    if(self.richcontent.count==0)
    {
        RichEditContentItem *richEditContentItem=[[RichEditContentItem alloc]init];
        richEditContentItem.contentType=TEXT;
        richEditContentItem.contentString=@"";
        [self.richcontent addObject:richEditContentItem];
    }
    RichEditContentItem *richEditContentItemlast=self.richcontent.lastObject;
    if (richEditContentItemlast.contentType!= TEXT) {
        RichEditContentItem *richEditContentItem=[[RichEditContentItem alloc]init];
        richEditContentItem.contentType=TEXT;
        richEditContentItem.contentString=@"";
        [self.richcontent addObject:richEditContentItem];
    }
}

-(void)checkImageItem
{
    for(UITableViewCell *cell in [self.richeditTableView visibleCells])
    {
        if ([cell isKindOfClass:[RichEditTableViewCellImage class]]) {
            RichEditTableViewCellImage* richEditImageCell=(RichEditTableViewCellImage*)cell;
            [richEditImageCell hideCover];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([scrollView isEqual:self.richeditTableView])
    {
        CGPoint offset = self.richeditTableView.contentOffset;
        self.richEditorBackgroundScrollView.bouncesZoom=YES;
        [self.richEditorBackgroundScrollView setContentOffset:CGPointMake(offset.x, offset.y+10)];
    }
}

#pragma mark 启动imagePicker选择图片
-(IBAction)chooseImage:(id)sender
{
    isFromImage=YES;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark 计算合适的图片尺寸
-(CGSize) calcImageSize:(UIImage *)image
{
    int MaxLength = self.richeditTableView.frame.size.width;
    int Width, Height;
    if (image.size.width > image.size.height) {
        float ratio = image.size.height / (float) image.size.width;
        Width = MaxLength;
        Height = (int) (Width * ratio);
    } else {
        float ratio = image.size.width / (float) image.size.height;
        Height = MaxLength;
        Width = (int) (Height * ratio);
    }
    return CGSizeMake(Width,Height);
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:true completion:nil];
    isToolbarShow=NO;
    self.toolbarView.alpha=0;
    self.toolbarView.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-104, [[UIScreen mainScreen] bounds].size.width, 40);
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    if(imageURL!=nil)
    {
        UIImage * image=[info objectForKey:UIImagePickerControllerOriginalImage];
        NSString* netUrl=[self.activityManager.localImage2NetUrl objectForKey:[imageURL absoluteString]];
        if(netUrl)
        {
            [self insertImage:netUrl withImage:image];
        }
        else
        {
            [self insertImage:[imageURL absoluteString] withImage:image];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                ImageUploader* imageUploader=[[ImageUploader alloc]init];
                imageUploader.imagePath=[imageURL absoluteString];
                imageUploader.action=2;
                [imageUploader beginUploadImageWithSuccessBlock:^(NSString *url) {
                    for (int i=0; i<self.richcontent.count; i++) {
                        RichEditContentItem* richContentItem=[self.richcontent objectAtIndex:i];
                        if(richContentItem.contentType==IMAGE)
                        {
                            if(richContentItem.contentString==imageUploader.imagePath)
                            {
                                richContentItem.contentString=url;
                            }
                            [self.activityManager ks_saveOrUpdate];
                        }
                    }
                    [self.activityManager.localImage2NetUrl setObject:url forKey:imageUploader.imagePath];
                    [self.activityManager.NetUrl2localImage setObject:imageUploader.imagePath forKey:url];
                    [self.activityManager ks_saveOrUpdate];
                } andFailureBlock:^{
                    
                }];
            });
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:nil];
    isToolbarShow=NO;
    self.toolbarView.alpha=0;
    self.toolbarView.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-104, [[UIScreen mainScreen] bounds].size.width, 40);
}

-(void)showImageCover:(NSInteger)positon
{
    RichEditContentItem *richContentItem=[self.richcontent objectAtIndex:positon];
    if(richContentItem.contentType==IMAGE)
    {
        NSIndexPath *firstIndexPath=[self.richeditTableView indexPathsForVisibleRows][0];
        int relativePosition=(int)(positon-[firstIndexPath row]);
        RichEditTableViewCellImage* richEditImageCell=[self.richeditTableView visibleCells][relativePosition];
        [richEditImageCell showCover];
    }
}

#pragma mark 返回selection行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.richcontent count];
}

#pragma mark 返回每一个row得到TableViewCell
-(BOOL)isPresetString:(NSString*)text
{
    NSString* str1=[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    NSString* str2=[presetString[0]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    NSString* str3=[presetString[1]  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    if([str1 isEqualToString:str2]||[str1 isEqualToString:str3])
    {
        return YES;
    }
    return NO;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RichEditContentItem *richeditContentItem=[self.richcontent objectAtIndex:[indexPath row]];
    int type=richeditContentItem.contentType;
    switch (type) {
        case TEXT:
        {
            RichEditTableViewCellText *richEditTableViewCellText=[tableView dequeueReusableCellWithIdentifier:TableViewCellIdText forIndexPath:indexPath];
            
            richEditTableViewCellText.textChanged=^(CGFloat height,NSString *string,UITextView *textView)
            {
                int height_1=height;
                richeditContentItem.contentString=string;
                if(self.isKeyboardShow)
                    if(_seletPosition==indexPath.row)
                        self.selectTextRange=textView.selectedRange;
                if([self isPresetString:richeditContentItem.contentString])
                {
                    textView.textColor=[KSUtil colorWithHexString:@"#999999"];
                }
                else
                {
                    textView.textColor=[KSUtil colorWithHexString:@"#333333"];
                }
                if(height_1!=richeditContentItem.Height)
                {
                    richeditContentItem.Height=height;
                    [self.richeditTableView beginUpdates];
                    [self.richeditTableView endUpdates];
                }
                [self.activityManager ks_saveOrUpdate];
            };
            [richEditTableViewCellText getTextView].tag=[indexPath row];
            richEditTableViewCellText.textSelectionChanged=^(UITextView *textView){
                if(self.isKeyboardShow)
        
                    if(_seletPosition==indexPath.row)
                        self.selectTextRange=textView.selectedRange;
            };
            if([richeditContentItem.contentString isEqualToString:presetString[0]]||[richeditContentItem.contentString isEqualToString:presetString[1]])
            {
                [richEditTableViewCellText getTextView].textColor=[KSUtil colorWithHexString:@"#999999"];
            }
            else
            {
                [richEditTableViewCellText getTextView].textColor=[KSUtil colorWithHexString:@"#333333"];
            }
            richEditTableViewCellText.textShouldBeginEdit=^(UITextView* textView)
            {
                self.selectTextRange=textView.selectedRange;
                if([self isPresetString:textView.text])
                {
                    textView.text=@"\n\n\n\n\n";
                    richeditContentItem.contentString=@"\n\n\n\n\n";
                }
                _activeTextView=textView;
                _activeTextField=nil;
                [self checkImageItem];
            };
            richEditTableViewCellText.textDidBeginEdit=^(UITextView* textView)
            {
                _seletPosition=[indexPath row];
                self.selectTextRange=textView.selectedRange;
            };
            richEditTableViewCellText.deletePreviousItem=^(){
                
                if([indexPath row]!=0)
                {
                    RichEditContentItem *previousRichContentItem=[self.richcontent objectAtIndex:[indexPath row]-1];
                    if(previousRichContentItem.contentType==IMAGE)
                    {
                        if(_activeTextView)
                        {
                            [_activeTextView resignFirstResponder];
                        }
                        if(_activeTextField)
                        {
                            [_activeTextField resignFirstResponder];
                        }
                        [self showImageCover:[indexPath row]-1];
                        [self.richeditTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                }
            };
            richeditContentItem.Height=[KSUtil textHeight:richeditContentItem.contentString withFont:[UIFont fontWithName:@"Arial" size:16] targetWidth:self.richeditTableView.frame.size.width]+20;
            [richEditTableViewCellText setContentText:richeditContentItem.contentString];
            
            return richEditTableViewCellText;
        }
            break;
        case IMAGE:
        {
            RichEditTableViewCellImage *richEditTableViewCellImage=[tableView dequeueReusableCellWithIdentifier:TableViewCellIdImage forIndexPath:indexPath];
            if([self.activityManager.NetUrl2localImage objectForKey:richeditContentItem.contentString])
            {
                [richEditTableViewCellImage setImage:[self.activityManager.NetUrl2localImage objectForKey:richeditContentItem.contentString] imageWidth:richeditContentItem.Width imageHeight:richeditContentItem.Height];
            }
            else
            {
                [richEditTableViewCellImage setImage:richeditContentItem.contentString imageWidth:richeditContentItem.Width imageHeight:richeditContentItem.Height];
            }
            
            if([self.activityManager.imageUploadProgressHashMap objectForKey:richeditContentItem.contentString])
            {
                NSNumber* percentNumber=[self.activityManager.imageUploadProgressHashMap objectForKey:richeditContentItem.contentString];
                [richEditTableViewCellImage setPercent:percentNumber.floatValue];
            }
            richEditTableViewCellImage.imageDelete=^(){
                //图片删除逻辑
                UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"删除图片" message:@"确定删除这张图片吗？" delegate:self cancelButtonTitle:@"确定"otherButtonTitles: @"取消",nil];
                alertView.tag=[indexPath row];
                [alertView show];
            };
            richEditTableViewCellImage.coverTouched=^()
            {
                [self checkImageItem];
                if(_activeTextView)
                {
                    [_activeTextView resignFirstResponder];
                }
                if(_activeTextField)
                {
                    [_activeTextField resignFirstResponder];
                }
            };
            return richEditTableViewCellImage;
        }
            break;
        case TITLE:
        {
            RichEditTableViewCellTitle *richEditTableViewCellTitle=[tableView dequeueReusableCellWithIdentifier:TableViewCellIdTitle forIndexPath:indexPath];
            [richEditTableViewCellTitle setTitle:richeditContentItem.contentString];
            richEditTableViewCellTitle.textChanged=^(NSString *string){
                richeditContentItem.contentString=string;
                [self.activityManager ks_saveOrUpdate];
            };
            [richEditTableViewCellTitle getTextFied].tag=[indexPath row];
            richEditTableViewCellTitle.beginEdit=^(UITextField *textField)
            {
                _seletPosition=[indexPath row];
                _activeTextField=textField;
                _activeTextView=nil;
                [self checkImageItem];
            };
            richEditTableViewCellTitle.titleDelete=^(){
                UIAlertView* alertView=[[UIAlertView alloc] initWithTitle:@"删除标题" message:@"确定删除该标题吗？" delegate:self cancelButtonTitle:@"确定"otherButtonTitles: @"取消",nil];
                alertView.tag=[indexPath row];
                [alertView show];
            };
            return richEditTableViewCellTitle;
        }
            break;
        default:
            break;
    }
    return nil;
}

//定义的委托，buttonindex就是按下的按钮的index值

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView.title isEqual:@"删除图片"])
    {
        NSLog(@"删除图片");
        if(buttonIndex==0)
        {
            [self deleteImage:alertView.tag];
            [self.activityManager ks_saveOrUpdate];
        }
    }
    else
    {
        NSLog(@"删除标题");
        if(buttonIndex==0)
        {
            [self deleteTitle:alertView.tag];
            [self.activityManager ks_saveOrUpdate];
        }
    }
}
//-(BOOL)isPresetString:(NSString *)string
//{
//    NSString* presetString_1 = [presetString[0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    NSString* presetString_2 = [presetString[1] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    string=[string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    if ([string isEqualToString:presetString_1]||[string isEqualToString:presetString_2]) {
//        return YES;
//    } else
//        return NO;
//}

-(void)deleteTitle:(NSInteger)position
{
    RichEditContentItem *richEditContentItem;
    if (position != self.richcontent.count-1) {
        richEditContentItem = [self.richcontent objectAtIndex:position+1];
        if (richEditContentItem.contentType== TEXT) {
            if ([self isPresetString:richEditContentItem.contentString])
            {
                [self.richcontent removeObject:richEditContentItem];
            }
        }
    }
    [self.richcontent removeObjectAtIndex:position];
    [self checkRichContent];
    [self.richeditTableView reloadData];
    
}
-(void)deleteImage:(NSInteger)position
{
    [self.richcontent removeObjectAtIndex:position];
    [self checkRichContent];
    [self.richeditTableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RichEditContentItem *richContentItem=[self.richcontent objectAtIndex:[indexPath row]];
    if(richContentItem!=nil)
    {
        if(richContentItem.contentType==TEXT)
        {
            return  richContentItem.Height;
        }
        else if (richContentItem.contentType==IMAGE)
        {
            return  richContentItem.Height+10;
        }
        else if(richContentItem.contentType==TITLE)
        {
            return 34;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RichEditContentItem *richContentItem=[self.richcontent objectAtIndex:[indexPath row]];
    if(richContentItem!=nil)
    {
        if(richContentItem.contentType==TEXT)
        {
            return  richContentItem.Height;
        }
        else if (richContentItem.contentType==IMAGE)
        {
            return  richContentItem.Height+10;
        }
        else if(richContentItem.contentType==TITLE)
        {
            return 34;
        }
    }
    return 0;
}
@end
