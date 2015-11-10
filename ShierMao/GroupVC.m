//
//  GroupVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/22.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "GroupVC.h"
#import "GroupCell.h"
#import "GroupDetailVC.h"
#import "GroupSearchVC.h"

@interface GroupVC ()

@end

@implementation GroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的群";
    [self.tableView registerClass:[GroupCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.groupArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.groupName.text = self.groupArray[indexPath.row][@"group"][@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupDetailVC *detail = [GroupDetailVC new];
    detail.groupInfo = self.groupArray[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
