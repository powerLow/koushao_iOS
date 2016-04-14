//
//  KSExpressListViewController.m
//  koushao_iOS
//
//  Created by 廖哲琦 on 15/12/8.
//  Copyright © 2015年 kuaicuhmen. All rights reserved.
//

#import "KSExpressListViewController.h"
//#import "KSSearchResultsViewController.h"
#import "KSExpressSectionHeaderView.h"
#import "Express.h"
#import "UIView+Extension.h"

static NSString *SectionHeaderViewIdentifier = @"KSSectionHeaderViewIdentifier";


@interface KSExpressListViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) NSMutableArray *indexArray;
@property(strong, nonatomic) NSMutableArray *arrayDictKey;
@property(strong, nonatomic) NSMutableDictionary *arrayDict;
@property(strong, nonatomic) NSArray *dataScoure;

- (Express *)isSearchCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation KSExpressListViewController

- (void)init_SearchData {

    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"express" ofType:@"plist"];

    self.dataScoure = [NSArray arrayWithContentsOfFile:bundlePath];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"indexArray" ofType:@"plist"];

    NSMutableArray *indexArray = [NSMutableArray arrayWithContentsOfFile:path];
    NSMutableArray *arrayDictKey = [[NSMutableArray alloc] initWithCapacity:self.dataScoure.count];
    NSMutableDictionary *arrayDict = [[NSMutableDictionary alloc] init];

    for (int i = 0; i < indexArray.count; i++) {
        NSMutableArray *array = [self sortArray:indexArray[i]];
        [arrayDict setObject:array forKey:[indexArray objectAtIndex:i]];
        [arrayDictKey addObject:[indexArray objectAtIndex:i]];
    }

    self.indexArray = indexArray;
    self.arrayDictKey = arrayDictKey;
    self.arrayDict = arrayDict;
}

- (NSMutableArray *)sortArray:(NSString *)fl {

    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dic in self.dataScoure) {
        NSString *type = [dic objectForKey:@"index"];
        if ([fl isEqualToString:type]) {
            [array addObject:dic];
        }
    }
    return array;
}

- (void)cancelAction:(id)sender {

    if ([_delegate respondsToSelector:@selector(ExpressListViewDidCanceld:)]) {

        [_delegate ExpressListViewDidCanceld:self];

    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (Express *)isSearchCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [self.arrayDict valueForKey:[self.arrayDictKey objectAtIndex:indexPath.section]];
    NSDictionary *dic = array[indexPath.row];
    Express *express = [[Express alloc] initWithExpressDic:dic];
    return express;

}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择快递公司";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(cancelAction:)];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;


    self.tableView = tableView;

    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    UINib *sectionheaderNib = [UINib nibWithNibName:@"KSExpressSectionHeaderView" bundle:nil];
//    [self.tableView registerNib:sectionheaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    [self.tableView registerClass:[KSExpressSectionHeaderView class] forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    [self init_SearchData];

    _isPresent = NO;

}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


- (NSArray *)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K  contains[cd] %@", scope, searchText];
    NSArray *array = [self.dataScoure filteredArrayUsingPredicate:predicate];
    return array;

}

#pragma -mark UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

//    NSString *searchText = searchController.searchBar.text;
//    NSArray *resultsArray = [self filterContentForSearchText:searchText scope:[Express keyName]];
}

#pragma mark - TableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayDictKey.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *array = [self.arrayDict valueForKey:[self.arrayDictKey objectAtIndex:section]];

    return array.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

    SWTableViewCell *cell = (SWTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {

        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
                [UIColor whiteColor]                 icon:[UIImage imageNamed:@"icon_phone"]];
        [rightUtilityButtons sw_addUtilityButtonWithColor:
                [UIColor whiteColor]                 icon:[UIImage imageNamed:@"icon_network"]];
        [cell setRightUtilityButtons:rightUtilityButtons WithButtonWidth:45.0f];
        cell.delegate = self;

        UIImageView *expressImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 2, 40, 40)];
        expressImageView.contentMode = UIViewContentModeScaleAspectFit;
        expressImageView.clipsToBounds = YES;

        expressImageView.layer.cornerRadius = 19.5f;
        expressImageView.layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;

        expressImageView.tag = CellImageTag;


        UILabel *expressNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(expressImageView.right + 20, 10, 180, 24)];

        expressNameLabel.font = [UIFont fontWithName:@"American Typewriter Regular" size:14];

        expressNameLabel.tag = CellLabelTag;

        [cell.contentView addSubview:expressImageView];

        [cell.contentView addSubview:expressNameLabel];


    }

    Express *express = [self isSearchCellForRowAtIndexPath:indexPath];
    [self configureCell:cell forExpress:express];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forExpress:(Express *)express {
    //SWTableViewCell class
    UIImageView *expressImageView = (UIImageView *) [cell.contentView viewWithTag:CellImageTag];
    expressImageView.image = [UIImage imageNamed:express.imageName];
    UILabel *expressNameLabel = (UILabel *) [cell.contentView viewWithTag:CellLabelTag];
    expressNameLabel.text = express.expressName;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger count = 0;
    if ([title isEqualToString:@"{search}"]) {
        [self.tableView setContentOffset:CGPointMake(0, -10)];
        return -1;
    }
    for (NSString *indexString in self.arrayDictKey) {
        if ([indexString isEqualToString:title]) {
            return count;
        }
        count++;
    }
    return 0;
}

#pragma mark -
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Express *selectExpress = [self isSearchCellForRowAtIndexPath:indexPath];
    if ([_delegate respondsToSelector:@selector(ExpressListView:didSelectWithobject:)]) {
        [_delegate ExpressListView:self didSelectWithobject:selectExpress];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {

//        QueryViewController * queryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"queryViewController"];
//        queryViewController.express =selectExpress;
//        
//        [self.navigationController pushViewController:queryViewController animated:YES];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    KSExpressSectionHeaderView *sectionHeadView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    if (tableView != self.tableView) {
        sectionHeadView.headerLabel.textColor = [UIColor redColor];
        sectionHeadView.headerLabel.text = NSLocalizedString(@"Result", @"搜索结果");
    } else {
        NSString *string = [self.arrayDictKey objectAtIndex:section];
        if ([string isEqualToString:@"{search}"]) {
            sectionHeadView.headerLabel.textColor = [UIColor redColor];
            sectionHeadView.headerLabel.text = @"★常用快递";
        } else {
            sectionHeadView.headerLabel.text = [self.arrayDictKey objectAtIndex:section];
            sectionHeadView.headerLabel.textColor = [UIColor lightGrayColor];
        }
    }
    return sectionHeadView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

#pragma mark -
#pragma mark - SWTableViewCellDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Express *express = [self isSearchCellForRowAtIndexPath:indexPath];
    if (index == SWTableCellIndexTelTag) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", express.phone]]];
    } else if (index == SWTableCellIndexURlTag) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:express.expressWebUrl]];
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    return YES;
}

@end
