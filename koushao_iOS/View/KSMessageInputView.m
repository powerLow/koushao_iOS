//
//  KSMessageInputView.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSMessageInputView.h"
#import "KSPlaceHolderTextView.h"
#import "Masonry.h"

#define kKeyboardView_Height 216.0
#define kMessageInputView_Height 50.0
#define kMessageInputView_HeightMax 120.0
#define kMessageInputView_PadingHeight 7.0
#define kMessageInputView_Width_Tool 35.0
#define kMessageInputView_MediaPadding 1.0
#define kPaddingLeftWidth 15.0

#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define kKeyWindow [UIApplication sharedApplication].keyWindow

@interface KSMessageInputView ()<UITextViewDelegate>

@property (strong, nonatomic) UIScrollView *contentView;
@property (strong, nonatomic) KSPlaceHolderTextView *inputTextView;
@property (assign, nonatomic) CGFloat viewHeightOld;

@property (assign, nonatomic) KSMessageInputViewState inputState;

@end

static NSMutableDictionary *_inputStrDict;

@implementation KSMessageInputView

+ (instancetype)messageInputView{
    return [self messageInputViewWithPlaceHolder:nil];
}

+ (instancetype)messageInputViewWithPlaceHolder:(NSString *)placeHolder{
    KSMessageInputView *messageInputView = [[KSMessageInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kMessageInputView_Height)];
    [messageInputView customUI];
    if (placeHolder) {
        messageInputView.placeHolder = placeHolder;
    }else{
        messageInputView.placeHolder = @"说点什么吧...";
    }
    return messageInputView;
}
- (void)customUI{
    CGFloat contentViewHeight = kMessageInputView_Height -2*kMessageInputView_PadingHeight;
    
    NSInteger toolBtnNum;
    BOOL hasEmotionBtn, hasAddBtn, hasPhotoBtn, hasVoiceBtn;
    BOOL showBigEmotion;
    toolBtnNum = 0;
    hasEmotionBtn = NO;
    hasAddBtn = NO;
    hasPhotoBtn = NO;
    showBigEmotion = NO;
    hasVoiceBtn = NO;
    
    __weak typeof(self) weakSelf = self;
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.borderWidth = 0.5;
        _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _contentView.layer.cornerRadius = contentViewHeight/2;
        _contentView.layer.masksToBounds = YES;
        _contentView.alwaysBounceVertical = YES;
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat left = hasVoiceBtn ? (7+kMessageInputView_Width_Tool+7) : kPaddingLeftWidth;
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(kMessageInputView_PadingHeight, left, kMessageInputView_PadingHeight, kPaddingLeftWidth + toolBtnNum *kMessageInputView_Width_Tool));
        }];
    }
    
    if (!_inputTextView) {
        _inputTextView = [[KSPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - kPaddingLeftWidth - toolBtnNum *kMessageInputView_Width_Tool - (hasVoiceBtn ? 7+kMessageInputView_Width_Tool+7 : kPaddingLeftWidth), contentViewHeight)];
        _inputTextView.font = [UIFont systemFontOfSize:16];
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.scrollsToTop = NO;
        _inputTextView.delegate = self;
        
        //输入框缩进
        UIEdgeInsets insets = _inputTextView.textContainerInset;
        insets.left += 8.0;
        insets.right += 8.0;
        _inputTextView.textContainerInset = insets;
        
        [self.contentView addSubview:_inputTextView];
    }
    
    if (_inputTextView) {
        [[RACObserve(self.inputTextView, contentSize) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSValue *contentSize) {
            [weakSelf updateContentView];
        }];
    }
}
- (void)updateContentView{
    
    CGSize textSize = _inputTextView.contentSize, mediaSize = CGSizeZero;
    if (ABS(CGRectGetHeight(_inputTextView.frame) - textSize.height) > 0.5) {
        CGRect frame = _inputTextView.frame;
        frame.size.height = textSize.height;
        _inputTextView.frame = frame;
    }
    if (_contentView.hidden) {
        textSize.height = kMessageInputView_Height - 2*kMessageInputView_PadingHeight;
    }
    CGSize contentSize = CGSizeMake(textSize.width, textSize.height + mediaSize.height);
    CGFloat selfHeight = MAX(kMessageInputView_Height, contentSize.height + 2*kMessageInputView_PadingHeight);
    
    CGFloat maxSelfHeight = SCREEN_HEIGHT/2;
    if (kDevice_Is_iPhone5){
        maxSelfHeight = 230;
    }else if (kDevice_Is_iPhone6) {
        maxSelfHeight = 290;
    }else if (kDevice_Is_iPhone6Plus){
        maxSelfHeight = SCREEN_HEIGHT/2;
    }else{
        maxSelfHeight = 140;
    }
    
    selfHeight = MIN(maxSelfHeight, selfHeight);
    CGFloat diffHeight = selfHeight - _viewHeightOld;
    if (ABS(diffHeight) > 0.5) {
        CGRect selfFrame = self.frame;
        selfFrame.size.height += diffHeight;
        selfFrame.origin.y -= diffHeight;
        [self setFrame:selfFrame];
        self.viewHeightOld = selfHeight;
    }
    [self.contentView setContentSize:contentSize];
    
//    CGFloat bottomY = becauseOfMedia? contentSize.height: textSize.height;
    CGFloat bottomY = textSize.height;
    CGFloat offsetY = MAX(0, bottomY - (CGRectGetHeight(self.frame)- 2* kMessageInputView_PadingHeight));
    [self.contentView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}


- (void)setFrame:(CGRect)frame{
    CGFloat oldheightToBottom = SCREEN_HEIGHT - CGRectGetMinY(self.frame);
    CGFloat newheightToBottom = SCREEN_HEIGHT - CGRectGetMinY(frame);
    [super setFrame:frame];
    if (fabs(oldheightToBottom - newheightToBottom) > 0.1) {
        NSLog(@"heightToBottom-----:%.2f", newheightToBottom);
        if (oldheightToBottom > newheightToBottom) {//降下去的时候保存
            [self saveInputStr];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(messageInputView:heightToBottomChanged:)]) {
            [self.delegate messageInputView:self heightToBottomChanged:newheightToBottom];
        }
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder{
    if (_inputTextView && ![_inputTextView.placeholder isEqualToString:placeHolder]) {
        _placeHolder = placeHolder;
        _inputTextView.placeholder = placeHolder;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = HexRGB(0xf8f8f8);
//        [self addLineUp:YES andDown:NO andColor:[UIColor lightGrayColor]];
        _viewHeightOld = CGRectGetHeight(frame);
//        _inputState = UIMessageInputViewStateSystem;
        _isAlwaysShow = NO;
//        _curProject = nil;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didPan:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGFloat verticalDiff = [panGesture translationInView:self].y;
        if (verticalDiff > 60) {
            [self isAndResignFirstResponder];
        }
    }
}
#pragma mark - view 
- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
#pragma mark 
- (BOOL)isCustomFirstResponder{
    return ([_inputTextView isFirstResponder]);
}
- (void)prepareToShow{
    if ([self superview] == kKeyWindow) {
        return;
    }
    [self setY:SCREEN_HEIGHT];
    [kKeyWindow addSubview:self];
//    [kKeyWindow addSubview:_emojiKeyboardView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    if (_isAlwaysShow && ![self isCustomFirstResponder]) {
        [UIView animateWithDuration:0.25 animations:^{
            [self setY:SCREEN_HEIGHT - CGRectGetHeight(self.frame)];
        }];
    }
}
- (void)prepareToDismiss{
    if ([self superview] == nil) {
        return;
    }
    [self isAndResignFirstResponder];
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self setY:SCREEN_HEIGHT];
    } completion:^(BOOL finished) {
//        [_emojiKeyboardView removeFromSuperview];
        [self removeFromSuperview];
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (BOOL)notAndBecomeFirstResponder{
    self.inputState = KSMessageInputViewStateSystem;
    if ([_inputTextView isFirstResponder]) {
        return NO;
    }else{
        [_inputTextView becomeFirstResponder];
        return YES;
    }
}
- (BOOL)isAndResignFirstResponder{
    if ([_inputTextView isFirstResponder]) {
        [_inputTextView resignFirstResponder];
        return YES;
    }else{
        return NO;
    }
}
#pragma mark remember input
- (NSMutableDictionary *)shareInputStrDict{
    if (!_inputStrDict) {
        _inputStrDict = [[NSMutableDictionary alloc] init];
    }
    return _inputStrDict;
}

- (NSString *)inputStr{
    NSString *inputKey = [self inputKey];
    if (inputKey) {
        return [[self shareInputStrDict] objectForKey:inputKey];
    }
    return nil;
}

- (void)deleteInputData{
    NSString *inputKey = [self inputKey];
    if (inputKey) {
        [[self shareInputStrDict] removeObjectForKey:inputKey];
    }
}

- (void)saveInputStr{
    NSString *inputStr = _inputTextView.text;
    NSString *inputKey = [self inputKey];
    if (inputKey && inputKey.length > 0) {
        if (inputStr && inputStr.length > 0) {
            [[self shareInputStrDict] setObject:inputStr forKey:inputKey];
        }else{
            [[self shareInputStrDict] removeObjectForKey:inputKey];
        }
    }
}
- (NSString *)inputKey{
    NSString *inputKey = nil;
    inputKey = [NSString stringWithFormat:@"reply"];
    return inputKey;
}

#pragma mark UITextViewDelegate M
- (void)sendTextStr{
    [self deleteInputData];
    NSMutableString *sendStr = [NSMutableString stringWithString:self.inputTextView.text];
    if (sendStr && [sendStr length] && _delegate && [_delegate respondsToSelector:@selector(messageInputView:sendText:)]) {
        [self.delegate messageInputView:self sendText:sendStr];
    }
    _inputTextView.selectedRange = NSMakeRange(0, _inputTextView.text.length);
    [_inputTextView insertText:@""];
    [self updateContentView];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        //点击键盘自带的 发送 按钮
        [self sendTextStr];
        return NO;
    }else if ([text isEqualToString:@"@"]){
    }
    return YES;
}
#pragma mark - KeyBoard Notification Handlers
- (void)keyboardChange:(NSNotification*)aNotification{
    if ([aNotification name] == UIKeyboardDidChangeFrameNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    if ([self.inputTextView isFirstResponder]) {
        NSDictionary* userInfo = [aNotification userInfo];
        CGRect keyboardEndFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardY =  keyboardEndFrame.origin.y;
        
        CGFloat selfOriginY = keyboardY == SCREEN_HEIGHT? self.isAlwaysShow? SCREEN_HEIGHT - CGRectGetHeight(self.frame): SCREEN_HEIGHT : keyboardY - CGRectGetHeight(self.frame);
        if (selfOriginY == self.frame.origin.y) {
            return;
        }
        
        
        __weak typeof(self) weakSelf = self;
        void (^endFrameBlock)() = ^(){
            CGRect frame = weakSelf.frame;
            frame.origin.y = selfOriginY;
            self.frame = frame;
        };
        
        if ([aNotification name] == UIKeyboardWillChangeFrameNotification) {
            NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
            [UIView animateWithDuration:animationDuration delay:0.0f options:[self animationOptionsForCurve:animationCurve] animations:^{
                endFrameBlock();
            } completion:nil];
        }else{
            endFrameBlock();
        }
    }
}
- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    
    return kNilOptions;
}
@end
