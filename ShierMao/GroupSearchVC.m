//
//  GroupSearchVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/23.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "GroupSearchVC.h"
#import "GroupCell.h"
#import "WebServiceClient.h"
#import "GroupPreview.h"
#import "GroupRegistVC.h"
#import "GroupDetailVC.h"

@interface GroupSearchVC ()<UISearchBarDelegate>

@property (nonatomic, strong) NSArray *groupAry;

@end

@implementation GroupSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查找群";
    [self.tableView registerClass:[GroupCell class] forCellReuseIdentifier:@"cell"];
    [self setupUI];
}

- (void)setupUI {
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    searchBar.placeholder = NSLocalizedString(@"搜索", nil);
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.groupAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.groupName.text = ((GroupPreview *)self.groupAry[indexPath.row]).name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupPreview *preview = (GroupPreview *)self.groupAry[indexPath.row];
    NSNumber *num = preview.groupID;
    BOOL isMyGroup = [self.myGroupAry bk_any:^BOOL(NSDictionary *obj){
            return [obj[@"group_id"] isEqualToNumber:num];
            }];
    if (isMyGroup) {
        GroupDetailVC *detailVC = [GroupDetailVC new];
        detailVC.groupInfo = @{@"group_id": preview.groupID, @"group": @{@"name": preview.name, @"desc": preview.desc}};
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        GroupRegistVC *registVC = [GroupRegistVC new];
        registVC.preview = preview;
        [self.navigationController pushViewController:registVC animated:YES];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.groupAry = nil;
        [self.tableView reloadData];
    } else {
        [WebServiceClient searchGroupWithGroupName:searchText
                                           success:^(NSArray *ary){
                                               self.groupAry = ary;
                                               [self.tableView reloadData];
                                           } failure:^(NSString *msg){
                                               [SVProgressHUD showErrorWithStatus:msg];
                                           }];
    }
}

@end
