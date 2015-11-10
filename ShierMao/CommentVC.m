//
//  CommentVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/21.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "CommentVC.h"
#import "CommentCell.h"
#import "WriteComVC.h"
#import "WebServiceClient.h"
#import "Reply.h"
#import <UIImageView+AFNetworking.h>

@interface CommentVC ()

@property (nonatomic, strong) NSArray *replyAry;
@property (nonatomic, strong) NSDateFormatter *formatter;


@end

@implementation CommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(commentBtnClicked:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [WebServiceClient fetchReplyListWithMsgID:self.replyDto
                                      success:^(NSArray *replyAry){
                                          self.replyAry = replyAry;
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
    return [self.replyAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    Reply *rep = self.replyAry[indexPath.row];
    cell.nameLabel.text = rep.user.name;
    if (rep.user.imgUrl) {
        [cell.avatarV.avatarImageView setImageWithURL:[NSURL URLWithString:rep.user.imgUrl]];
        cell.avatarV.placeholderImageView.hidden  = YES;
    }
    cell.contentLabel.text = rep.body;
    cell.timeLabel.text = [self.formatter stringFromDate:rep.replyTime];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - event

- (void)commentBtnClicked:(UIButton *)sender {
    WriteComVC *wcVC = [WriteComVC new];
    wcVC.msgID = self.replyDto.msgID;
    [self.navigationController pushViewController:wcVC animated:YES];
}

#pragma mark - getter

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [NSDateFormatter new];
        [_formatter setDateFormat:@"YY年MM月dd日 HH:mm:ss"];
    }
    return _formatter;
}

@end
