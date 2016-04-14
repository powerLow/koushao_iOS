//
//  RichEditTableViewCellText.h
//  RichiEditDemo
//
//  Created by 陈奇 on 15/10/16.
//  Copyright © 2015年 陈奇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichEditTableViewCellText : UITableViewCell<UITextViewDelegate>
-(void) setContentText:(NSString*)contentString;
-(UITextView *)getTextView;
-(CGFloat) cellTextHeight;
@property(nonatomic,copy) void (^textChanged)(CGFloat height,NSString* string,UITextView * textView);
@property(nonatomic,copy) void (^textShouldBeginEdit)(UITextView * textView);
@property(nonatomic,copy) void (^textSelectionChanged)(UITextView * textView);
@property(nonatomic,copy) void (^textDidBeginEdit)(UITextView * textView);
@property(nonatomic,copy)void(^deletePreviousItem)(void);
@end
