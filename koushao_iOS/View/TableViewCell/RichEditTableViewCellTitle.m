//
//  RichEditTableViewCellTitle.m
//  RichiEditDemo
//
//  Created by 陈奇 on 15/10/16.
//  Copyright © 2015年 陈奇. All rights reserved.
//

#import "RichEditTableViewCellTitle.h"
#import "Masonry.h"

@implementation RichEditTableViewCellTitle

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

-(void) initSubView
{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
}

-(void)textChangedEvent:(UITextField*)textField
{
    if(self.textChanged)
    {
        self.textChanged(textField.text);
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.beginEdit)
    {
        self.beginEdit(textField);
    }
}

-(void) setTitle:(NSString*) title{
    while ([self.contentView.subviews lastObject] != nil) {
        [(UIView*)[self.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
    }
    UITextField *titleTextField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 30)];
    titleTextField.textColor=[UIColor blackColor];
    titleTextField.font = [UIFont fontWithName:@"Arial" size:16];
    titleTextField.placeholder=@"请输入标题内容";
    titleTextField.delegate=self;
    [titleTextField addTarget:self action:@selector(textChangedEvent:)   forControlEvents:UIControlEventEditingChanged];
    UILabel *borderLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 1)];
    borderLabel.backgroundColor=[UIColor grayColor];
    titleTextField.text=title;
    [self.contentView addSubview:titleTextField];
    [self.contentView addSubview:borderLabel];
    
    @weakify(self);
    [borderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    //关闭按钮位置约束
    UIImageView *closedImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    closedImage.image=[UIImage imageNamed:@"cross_gray.png"];
    //关闭按钮
    UIButton* closedButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [closedButton addSubview:closedImage];
    [closedButton addTarget:self action:@selector(deleteTitle:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:closedButton];
    
    [closedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.mas_equalTo(20);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-8);
    }];
}


-(void)deleteTitle:(UIButton*)button
{
    if(self.titleDelete)
    {
        self.titleDelete();
    }
}

-(UITextField *)getTextFied
{
    for(UIView *subview in self.contentView.subviews)
    {
        if([subview isKindOfClass:[UITextField class]])
        {
            return (UITextField *)subview;
            break;
        }
    }
    return nil;
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}
@end
