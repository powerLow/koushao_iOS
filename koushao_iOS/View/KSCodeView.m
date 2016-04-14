//
//  KSCodeView.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/6.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSCodeView.h"
#import "KSFieldView.h"
#import "UIView+Extension.h"
static const NSInteger InputViewNumCount = 5;


@interface KSCodeView()<UITextFieldDelegate>
/** 数字数组 */
@property (nonatomic, strong) NSMutableArray *numsArr;
@property (strong, nonatomic) KSFieldView *fieldView;

@end
@implementation KSCodeView

#pragma mark - LazyLoad

- (NSMutableArray *)numsArr
{
    if (!_numsArr) {
        _numsArr = [NSMutableArray array];
    }
    return _numsArr;
}

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setupSubViewsWith];
        [self setupResponsder];
    }
    return self;
}

/** 添加子控件 */
- (void)setupSubViewsWith
{
//    UIView *line = [[UIView alloc]init];
//    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
//    line.frame = CGRectMake(0, 0, self.width, 1);
//    [self addSubview:line];
//    line.alpha = 0.9;
    
    KSFieldView *fieldView = [[KSFieldView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) fieldNum:@(InputViewNumCount)];
    [self addSubview:fieldView];
    fieldView.alpha = 0.8;
    fieldView.layer.cornerRadius = 5;
    fieldView.layer.borderWidth = 1;
    fieldView.layer.borderColor = [[UIColor grayColor] CGColor];
    fieldView.layer.masksToBounds = YES;
    fieldView.backgroundColor = [UIColor whiteColor];
    self.fieldView = fieldView;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.fieldView.bounds;
    [self insertSubview:effectView atIndex:0];
}
- (void)clear {
    [self.numsArr removeAllObjects];
    [self drawRect:CGRectZero];
}
#pragma mark - Private

// 删除
- (void)delete
{
    [self.numsArr removeLastObject];
    [self drawRect:CGRectZero];
}

/** 响应者 */
- (void)setupResponsder
{
    UITextField *responsder = [[UITextField alloc] init];
    [self addSubview:responsder];
    responsder.delegate = self;
//    responsder.keyboardType = UIKeyboardTypeNumberPad;
    responsder.keyboardType = UIKeyboardTypeASCIICapable;
    self.responsder = responsder;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    // 此处判断点击的是否是删除按钮,当输入键盘类型为number pad(数字键盘时)准确,其他类型未可知
    if (![string isEqualToString:@""]) {
        
        //过滤长度大于1的输入
        if (![string length] == 1) {
            return NO;
        }
        //过滤非字母数字
        int a = [string characterAtIndex:0];
        if (!isalnum(a)) {
            
            return NO;
        }
        
        if (_numsArr.count < InputViewNumCount) {
             NSLog(@"string = %@",string);
            [_numsArr addObject:string];
            [self drawRect:CGRectZero];
            
            if (_numsArr.count == InputViewNumCount) {
                if ([self.delegate respondsToSelector:@selector(finish:)]) {
                    [self.delegate finish:[_numsArr componentsJoinedByString:@""]];
                }
                [self.responsder endEditing:YES];
            }
            
            return YES;
        }else{
            return NO;
        }
        
    }else{
        [self delete];
        return YES;
    }
}

- (void)drawRect:(CGRect)rect
{
    [self.fieldView drawRect:CGRectZero string:self.numsArr];
    // ok按钮状态
//    BOOL statue = NO;
//    if (self.numsArr.count == InputViewNumCount) {
//        statue = YES;
//    } else {
//        statue = NO;
//    }
}

@end
