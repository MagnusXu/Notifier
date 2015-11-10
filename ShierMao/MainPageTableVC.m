//
//  MainPageTableVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/8.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "MainPageTableVC.h"
#import "MsgCell.h"
#import <MJRefresh.h>
#import "SideMenuVC.h"
#import "DetailPageVC.h"
#import "WebServiceClient.h"
#import "MsgListDTO.h"
#import "MsgC.h"
#import "GroupSearchVC.h"
#import "CollectHelper.h"

@interface MainPageTableVC () <MsgCellCollectButtonDelegate>

@property (nonatomic, strong) NSArray *groupArray;
@property (nonatomic, strong) NSArray *msgArray;
@property (nonatomic, strong) UIBarButtonItem *leftButton;
@property (nonatomic, strong) UITableView *myTableV;

@property (nonatomic, strong) NSDateFormatter *formate;

@end

@implementation MainPageTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(searchGroup)];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[MsgCell class] forCellReuseIdentifier:@"cell"];
    
    self.navigationItem.leftBarButtonItem = self.leftButton;
    [CollectHelper setMainVC:self];
    
    [self setUpRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)setUpRefresh {
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchNewMsg)];
    [self.tableView.header beginRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.msgArray.count) {
        return [self.msgArray count];
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    MsgC *msg = self.msgArray[indexPath.row];
    cell.titleLabel.text = msg.title;
    cell.detailLabel.text = msg.preview;
    [cell.timeLabel setTitle:[self.formate stringFromDate:msg.addTime] forState:UIControlStateNormal];
    [cell.likeLabel setTitle:[NSString stringWithFormat:@"%@", msg.readCount] forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DetailPageVC *detailVC = [DetailPageVC new];
    detailVC.msgID = ((MsgC *)self.msgArray[indexPath.row]).ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - MsgCellCollectButtonDelegate

- (void)collectButtonClicked:(UIButton *)collectButton {
    CGPoint point = collectButton.center;
    point = [self.tableView convertPoint:point fromView:collectButton.superview];
    NSInteger row = [self.tableView indexPathForRowAtPoint:point].row;
    if (collectButton.tag == 1) {
        collectButton.tag = 0;
        [collectButton setImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
        [CollectHelper addCollectMsg:(MsgC *)self.msgArray[row] withIndex:row];
    } else {
        collectButton.tag = 1;
        [collectButton setImage:[UIImage imageNamed:@"collectD.png"] forState:UIControlStateNormal];
        [CollectHelper removeCollectMsgWithID:((MsgC *)self.msgArray[row]).ID withIndex:0];
    }
}

#pragma mark - Event

- (void)leftBarShow {
    NSLog(@"显示侧边栏");
    if (!self.tableView.header.isRefreshing) {
        SideMenuVC *sidemenuVC = [[SideMenuVC alloc] initWithBackGroundImage:[self capture]];
        sidemenuVC.mainVC = self;
        sidemenuVC.groupArray = self.groupArray;
        [self.navigationController presentViewController:sidemenuVC animated:NO completion:nil];
    }
}

- (void)fetchNewMsg {
    [WebServiceClient fetchMyGroupsWithSuccess:^(NSArray *ary) {
        if (ary.count) {
            self.groupArray = ary;
            MsgListDTO *dto = [MsgListDTO new];
            dto.groupID = ary[0][@"group_id"];
            dto.firstID = @0;
            dto.nums = @0;
            [WebServiceClient fetchMsgListWithGroupID:dto success:^(NSArray *arry){
                BOOL is = self.msgArray ? NO : YES;
                self.msgArray = arry;
                [self.tableView reloadData];
                
                if (is) {
                    [self showCollectedRow];
                }
            } failure:^(NSString *msg){
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }
    } failure:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    if (self.groupArray.count) {
        MsgListDTO *dto = [[MsgListDTO alloc] initWithGroupID:self.groupArray[0][@"group_id"] firstID:@0 nums:@0];
        [WebServiceClient fetchMsgListWithGroupID:dto success:^(NSArray *array){
            self.msgArray = array;
            [self.tableView reloadData];
            
            [self.tableView.header endRefreshing];
        }failure:^(NSString *msg){
            [self.tableView.header endRefreshing];
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    } else {
        [self.tableView.header endRefreshing];
    }
}

- (void)searchGroup {
    GroupSearchVC *groupSearchVC = [GroupSearchVC new];
    groupSearchVC.myGroupAry = self.groupArray;
    [self.navigationController pushViewController:groupSearchVC animated:YES];
}

#pragma mark - Utility Methods -
// get the current view screen shot
- (UIImage *)capture
{
    self.leftButton.customView.hidden = YES;
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    self.leftButton.customView.hidden = NO;
    return img;
}

#pragma mark - getter

- (UIBarButtonItem *)leftButton {
    if (!_leftButton) {
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
        [leftButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(leftBarShow) forControlEvents:UIControlEventTouchUpInside];
        _leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
    return _leftButton;
}

- (NSDateFormatter *)formate {
    if (!_formate) {
        _formate = [NSDateFormatter new];
        [_formate setDateFormat:@"YY年MM月dd日 HH:mm:ss"];
    }
    return _formate;
}

- (NSArray *)groupArray {
    if (!_groupArray) {
        _groupArray = [NSArray new];
    }
    return _groupArray;
}

#pragma mark - helper

- (void)cancelHightedWithRowIndex:(NSInteger)row {
    MsgCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    cell.collectButton.tag = 1;
    [cell.collectButton setImage:[UIImage imageNamed:@"collectD.png"] forState:UIControlStateNormal];
}

- (void)showCollectedRow {
    NSArray *collectMsgA = [CollectHelper getCollectMsgAry];
    [collectMsgA bk_each:^(MsgC *aMsgc){
        [self.msgArray bk_each:^(MsgC *another){
            if ([another.ID isEqual:aMsgc.ID]) {
                MsgCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:aMsgc.rowIndex.integerValue inSection:0]];
                cell.collectButton.tag = 0;
                [cell.collectButton setImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
            }
        }];
    }];
}

@end
