//
//  KSMessageInputView.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/11/23.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KSMessageInputViewState) {
    KSMessageInputViewStateSystem,
    KSMessageInputViewStateEmotion,
};

@protocol KSMessageInputViewDelegate;

@interface KSMessageInputView : UIView

@property (strong, nonatomic) NSString *placeHolder;
@property (assign, nonatomic) BOOL isAlwaysShow;

@property (nonatomic, weak) id<KSMessageInputViewDelegate> delegate;

+ (instancetype)messageInputViewWithPlaceHolder:(NSString *)placeHolder;

- (void)prepareToShow;
- (void)prepareToDismiss;
- (BOOL)notAndBecomeFirstResponder;
- (BOOL)isAndResignFirstResponder;
- (BOOL)isCustomFirstResponder;

@end

@protocol KSMessageInputViewDelegate <NSObject>

@optional
- (void)messageInputView:(KSMessageInputView *)inputView sendText:(NSString *)text;
- (void)messageInputView:(KSMessageInputView *)inputView heightToBottomChanged:(CGFloat)heightToBottom;

@end