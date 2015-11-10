//
//  GroupDetailVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/22.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "GroupDetailVC.h"
#import "MsgCell.h"
#import "GroupHeadView.h"
#import "PersonVC.h"
#import "DetailPageVC.h"
#import "MsgC.h"
#import "WebServiceClient.h"
#import "MsgListDTO.h"

@interface GroupDetailVC ()

@property (nonatomic, strong) NSArray *msgList;
@property (nonatomic, strong) NSDateFormatter *formate;

@end

@implementation GroupDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群资料";
    GroupHeadView *head = [[GroupHeadView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 130)];
    self.tableView.tableHeaderView = head;
    head.name.text = self.groupInfo[@"group"][@"name"];
    head.detail.text = self.groupInfo[@"group"][@"desc"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[MsgCell class] forCellReuseIdentifier:@"cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MsgListDTO *dto = [[MsgListDTO alloc] initWithGroupID:self.groupInfo[@"group_id"] firstID:@0 nums:@0];
    [WebServiceClient fetchMsgListWithGroupID:dto
                                      success:^(NSArray *msgList){
                                          self.msgList = msgList;
                                          [self.tableView reloadData];
                                      } failure:^(NSString *msg){
                                          [SVProgressHUD showErrorWithStatus:msg];
                                      }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.msgList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    MsgC *msg = self.msgList[indexPath.row];
    cell.titleLabel.text = msg.title;
    cell.detailLabel.text = msg.preview;
    [cell.timeLabel setTitle:[self.formate stringFromDate:msg.addTime] forState:UIControlStateNormal];
    [cell.likeLabel setTitle:[NSString stringWithFormat:@"%@", msg.readCount] forState:UIControlStateNormal];
    cell.collectButton.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailPageVC *page = [DetailPageVC new];
    page.msgID = ((MsgC *)self.msgList[indexPath.row]).ID;
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark - getter

- (NSDateFormatter *)formate {
    if (!_formate) {
        _formate = [NSDateFormatter new];
        [_formate setDateFormat:@"YY年MM月dd日 HH:mm:ss"];
    }
    return _formate;
}
@end
