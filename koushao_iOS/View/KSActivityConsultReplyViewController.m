//
//  KSActivityConsultReplyViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/10/26.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSActivityConsultReplyViewController.h"
#import "KSActivityConsultReplyViewModel.h"
#import "Masonry.h"
#import "KSQuestionCell.h"
#import "KSQuestionReplyItemViewModel.h"
#import "KSMessageInputView.h"
@interface KSActivityConsultReplyViewController ()<KSMessageInputViewDelegate>

@property (nonatomic,strong,readwrite) KSActivityConsultReplyViewModel *viewModel;
@property (nonatomic, strong) KSMessageInputView *inputView;
@property (nonatomic, strong) UIView *commentSender;

@end

@implementation KSActivityConsultReplyViewController
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

- (void)setupView
{
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"未回复",@"已回复",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedData];
    segmentedControl.tintColor = [UIColor whiteColor];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[segmentedControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISegmentedControl *Seg) {
        //切换
        NSLog(@"切换 = %ld",(long)Seg.selectedSegmentIndex);
        NSInteger Index = Seg.selectedSegmentIndex;
        [self.viewModel.didSwitchTypeCommand execute:@(Index)];
    }];
    NSInteger height = 40;
    @weakify(self)
    UIView* topBackgroundView = [[UIView alloc] init];
    [self.view addSubview:topBackgroundView];
    topBackgroundView.backgroundColor = BASE_COLOR;
    [topBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(height);
    }];
    
    [topBackgroundView addSubview:segmentedControl];
    
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(height * 0.15);
        make.height.equalTo(topBackgroundView).multipliedBy(0.7);
        make.left.equalTo(topBackgroundView).offset(25);
        make.right.equalTo(topBackgroundView).offset(-25);
    }];

    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.equalTo(topBackgroundView);
        make.top.equalTo(topBackgroundView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}
- (void)initInputView {
    _inputView = [KSMessageInputView messageInputViewWithPlaceHolder:@"请输入回复"];
    _inputView.isAlwaysShow = NO;
    _inputView.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self initInputView];
    [self.tableView registerClass:[KSQuestionCell class] forCellReuseIdentifier:@"KSQuestionCell"];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    // 键盘
    if (_inputView) {
        [_inputView prepareToShow];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    if (_inputView) {
        [_inputView prepareToDismiss];
    }
}
#pragma mark - 回复
- (void)sendCommentMessage:(NSString*)text{
    NSLog(@"评论 = %@",text);
    KSQuestionCell *cell = (KSQuestionCell*)_commentSender;
    [self.viewModel.didSendReplyCommand execute:RACTuplePack_(cell.viewModel.itemModel.id,text)];
    _commentSender = nil;
    [self.inputView isAndResignFirstResponder];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.viewModel.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.dataSource[section] count];
}
#pragma mark - UITableViewDelegate
- (KSQuestionCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"KSQuestionCell" forIndexPath:indexPath];
}
- (KSQuestionCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KSQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KSQuestionCell" forIndexPath:indexPath];
    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    //评论点击事件
    @weakify(self)
    cell.commentClickedBlock = ^(id sender){
        if ([self.inputView isAndResignFirstResponder]) {
            return ;
        }
        @strongify(self)
        self.commentSender = sender;
        [self.inputView notAndBecomeFirstResponder];
    };
    //删除问题点击事件
    cell.deleteQuestionClickedBlock = ^(KSQuestionCell *cell) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除该提问?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
            NSLog(@"确认删除该提问? ＝ %@",x);
            if ([x boolValue]) {
                [self.viewModel.didDeleteQuestionCommand execute:cell.viewModel.itemModel.id];
            }
        }];
        [alert show];
    };
    //删除回复点击事件
    cell.deleteReplyClickedBlock = ^(KSQuestionCell *cell) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除该回复?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *x) {
            NSLog(@"确认删除该回复? = %@",x);
            if ([x boolValue]) {
                [self.viewModel.didDeleteReplyCommand execute:cell.viewModel.itemModel.id];
            }
        }];

        [alert show];
    };
    return cell;
}
- (void)configureCell:(KSQuestionCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{
    [cell bindViewModel:object];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel.dataSource[indexPath.section][indexPath.row] cellHeight];
}
#pragma mark - 隐藏弹出的选择菜单
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *cells =  [tableView visibleCells];
    for (KSQuestionCell* cell in cells) {
        [cell hiddenBtns];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSArray *cells =  [self.tableView visibleCells];
    for (KSQuestionCell* cell in cells) {
        [cell hiddenBtns];
    }
}
#pragma mark - KSMessageInputViewDelegate
- (void)messageInputView:(KSMessageInputView *)inputView sendText:(NSString *)text
{
    [self sendCommentMessage:text];
}

- (void)messageInputView:(KSMessageInputView *)inputView heightToBottomChanged:(CGFloat)heightToBottom
{
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//        UIEdgeInsets contentInsets= UIEdgeInsetsMake(0.0, 0.0, MAX(CGRectGetHeight(inputView.frame), heightToBottom), 0.0);;
        UIEdgeInsets contentInsets= UIEdgeInsetsMake(0.0, 0.0, MAX(0, heightToBottom), 0.0);
        CGFloat msgInputY = SCREEN_HEIGHT - heightToBottom - 64 - 40 - 1;//40是SegmentedControl的高度
        
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
        
        if ([_commentSender isKindOfClass:[UIView class]] && !self.tableView.isDragging && heightToBottom > 60) {
            KSQuestionCell *senderView = (KSQuestionCell*)_commentSender;
            CGFloat senderViewBottom = [self.tableView convertPoint:CGPointZero fromView:senderView].y+ CGRectGetMaxY(senderView.bounds);
//            NSLog(@"y = %f,CGRectGetMaxY = %f , input = %f",[self.tableView convertPoint:CGPointZero fromView:senderView].y,CGRectGetMaxY(senderView.bounds),CGRectGetHeight(inputView.frame));
            CGFloat contentOffsetY = MAX(0, senderViewBottom - msgInputY);
            [self.tableView setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
        }
    } completion:nil];
}
@end
