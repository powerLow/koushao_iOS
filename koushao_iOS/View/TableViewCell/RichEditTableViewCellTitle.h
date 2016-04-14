//
//  RichEditTableViewCellTitle.h
//  RichiEditDemo
//
//  Created by 陈奇 on 15/10/16.
//  Copyright © 2015年 陈奇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichEditTableViewCellTitle : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,copy) void (^textChanged)(NSString* string);
@property(nonatomic,copy) void (^titleDelete)();
@property(nonatomic,copy) void (^beginEdit)(UITextField * textView);
-(void)setTitle:(NSString*)title;
-(UITextField *)getTextFied;
@end
