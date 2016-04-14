//
//  RichEditTableViewCellText.m
//  RichiEditDemo
//
//  Created by 陈奇 on 15/10/16.
//  Copyright © 2015年 陈奇. All rights reserved.
//

#import "RichEditTableViewCellText.h"
#import "KSUtil.h"

@implementation RichEditTableViewCellText

UITextView *textView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView
{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

-(void)textViewDidChange:(UITextView *)textView
{
    textView.frame=CGRectMake(0, 0, [self tableView].frame.size.width, [KSUtil textHeight:textView.text withFont:textView.font targetWidth:[self tableView].frame.size.width]+20);
    if(self.textChanged!=nil)
    {
        self.textChanged([KSUtil textHeight:textView.text withFont:textView.font targetWidth:[self tableView].frame.size.width]+20,textView.text,textView);
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(self.textShouldBeginEdit)
    {
        self.textShouldBeginEdit(textView);
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(self.textDidBeginEdit)
    {
        self.textDidBeginEdit(textView);
    }
}
-(CGFloat)cellTextHeight
{
    return textView.contentSize.height;
}
- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

-(void) setContentText:(NSString*)contentString
{
    while ([self.contentView.subviews lastObject] != nil) {
        [(UIView*)[self.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
    }
    textView=[[UITextView alloc]initWithFrame:self.contentView.frame];
    textView.delegate=self;
    textView.scrollEnabled=NO;

    textView.font = [UIFont fontWithName:@"Arial" size:16];
    textView.textColor=[KSUtil colorWithHexString:@"#666666"];
    textView.contentInset = UIEdgeInsetsMake(0,-5,0,0);
    textView.text=contentString;
    textView.frame=CGRectMake(0, 0, [self tableView].frame.size.width, [KSUtil textHeight:textView.text withFont:textView.font targetWidth:[self tableView].frame.size.width]+20);
    
    [self.contentView addSubview:textView];
    if(self.textChanged)
    {
        self.textChanged([KSUtil textHeight:textView.text withFont:textView.font targetWidth:[self tableView].frame.size.width]+20,textView.text,textView);
    }
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if(self.textSelectionChanged)
    {
        self.textSelectionChanged(textView);
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(range.location==0&&range.length==0&&text.length==0)
    {
        if(self.deletePreviousItem)
        {
            self.deletePreviousItem();
        }
    }
    return YES;
}
-(UITextView *)getTextView
{
    for(UIView *subview in self.contentView.subviews)
    {
        if([subview isKindOfClass:[UITextView class]])
        {
            return (UITextView *)subview;
            break;
        }
    }
    return nil;
}
@end
