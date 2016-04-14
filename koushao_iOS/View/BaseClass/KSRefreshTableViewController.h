//
//  KSRefreshTableViewController.h
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/4.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSViewController.h"

@interface KSRefreshTableViewController : KSViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, assign, readonly) UIEdgeInsets contentInset;

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end
