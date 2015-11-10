//
//  CollectVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/23.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "CollectVC.h"
#import "MsgCell.h"
#import "MsgC.h"
#import "CollectHelper.h"
#import "DetailPageVC.h"

@interface CollectVC () <MsgCellCollectButtonDelegate>

@property (nonatomic, strong) NSArray *msgArray;
@property (nonatomic, strong) NSDateFormatter *formate;

@end

@implementation CollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[MsgCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.msgArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    cell.collectButton.highlighted = YES;
    MsgC *msg = self.msgArray[indexPath.row];
    cell.titleLabel.text = msg.title;
    cell.detailLabel.text = msg.preview;
    [cell.timeLabel setTitle:[self.formate stringFromDate:msg.addTime] forState:UIControlStateNormal];
    [cell.likeLabel setTitle:[NSString stringWithFormat:@"%@", msg.readCount] forState:UIControlStateNormal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailPageVC *detail = [DetailPageVC new];
    detail.msgID = ((MsgC *)self.msgArray[indexPath.row]).ID;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - MsgCellCollectButtonDelegate

- (void)collectButtonClicked:(UIButton *)collectButton {
    CGPoint point = collectButton.center;
    point = [self.tableView convertPoint:point fromView:collectButton.superview];
    NSInteger row = [self.tableView indexPathForRowAtPoint:point].row;
    MsgC *msg = (MsgC *)self.msgArray[row];
    [CollectHelper removeCollectMsgWithID:msg.ID withIndex:msg.rowIndex.integerValue];
    [self.tableView reloadData];
}

#pragma mark - getter

- (NSArray *)msgArray {
    _msgArray = [CollectHelper getCollectMsgAry];
    return _msgArray;
}

- (NSDateFormatter *)formate {
    if (!_formate) {
        _formate = [NSDateFormatter new];
        [_formate setDateFormat:@"YY年MM月dd日 HH:mm:ss"];
    }
    return _formate;
}

@end
