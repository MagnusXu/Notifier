//
//  PersonVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/9.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "PersonVC.h"
#import "SUMButton.h"
#import "AvatarView.h"
#import "LabelCell.h"
#import "ChangeAvatarVC.h"
#import <UIImageView+AFNetworking.h>

@interface PersonVC () <UITableViewDelegate, UITableViewDataSource, AvatarViewClickedDelegate>

@property (nonatomic, strong) AvatarView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *signLabel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PersonVC

- (void)setUpUI {
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *backGroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    backGroundView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300);
    backGroundView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:backGroundView];
    [self.view addSubview:self.avatarView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.signLabel];
    [self.view insertSubview:self.tableView belowSubview:backGroundView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatarView.superview);
        make.centerY.equalTo(self.avatarView.superview).offset(-130);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.avatarView);
        make.top.equalTo(self.avatarView.mas_bottom).offset(15);
    }];
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(@(CGRectGetHeight(self.view.bounds)/2));
        make.width.equalTo(self.tableView.superview);
        make.top.equalTo(backGroundView.mas_bottom).offset(5);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    NSString *imageUrl = [USER_DEFAULT objectForKey:USER_INFO_HEAD_IMAGE_URL];
    NSData *imageData = [USER_DEFAULT objectForKey:USER_INFO_HEAD_IMAGE];
    if (imageUrl || imageData) {
        if (imageUrl) {
            [self.avatarView.avatarImageView setImageWithURL:[NSURL URLWithString:imageUrl]];
        }
        if (imageData) {
            [self.avatarView.avatarImageView setImage:[UIImage imageWithData:imageData]];
        }
        self.avatarView.placeholderImageView.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    switch (indexPath.row) {
        case 0:{
            cell.itemLabel.text = @"用户名";
            cell.contentLabel.text = [USER_DEFAULT objectForKey:USER_INFO_USERNAME_DEFAULT_KEY];
        }
            break;
        case 1:{
            cell.itemLabel.text = @"性别";
            NSString *gender;
            switch (((NSNumber *)[USER_DEFAULT objectForKey:USER_INFO_GENDER_DEFAULT_KEY]).intValue) {
                case 0:
                    gender = @"未设置";
                    break;
                case 1:
                    gender = @"女";
                    break;
                case 2:
                    gender = @"男";
                    break;
                default:
                    break;
            }
            cell.contentLabel.text = gender;
        }
            break;
        case 2:{
            cell.itemLabel.text = @"学院";
            cell.contentLabel.text = [USER_DEFAULT objectForKey:USER_INFO_UNIVERSITY_NAME_DEFAULT_KEY];
        }
            break;
        case 3:{
            cell.itemLabel.text = @"学号";
            cell.contentLabel.text = [NSString stringWithFormat:@"%@", [USER_DEFAULT objectForKey:USER_INFO_STUID_DEFAULT_KEY]];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - AvatarViewDelegate

- (void)avatarViewClicked {
    NSLog(@"AvatarViewClicked");
    
    //FIXME:判断用户是否为自己，是则push到下一界面，否则没有反应
    [self.navigationController pushViewController:[ChangeAvatarVC new] animated:YES];
}

#pragma mark - getter

- (AvatarView *)avatarView {
    if(!_avatarView){
        _avatarView = [AvatarView new];
        _avatarView.sideLength = 75;
        _avatarView.delegate = self;
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = [USER_DEFAULT objectForKey:USER_INFO_NAME_DEFAULT_KEY];
        _nameLabel.font = [UIFont systemFontOfSize:24];
    }
    return _nameLabel;
}

- (UILabel *)signLabel {
    if (!_signLabel) {
        _signLabel = [UILabel new];
        _signLabel.textColor = [UIColor whiteColor];
        _signLabel.text = [USER_DEFAULT objectForKey:USER_INFO_DESC_DEFAULT_KEY]?:@"还未设置签名";
    }
    return _signLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [UITableView new];
        [_tableView registerClass:[LabelCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
