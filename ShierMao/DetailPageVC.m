//
//  DetailPageVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/20.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "DetailPageVC.h"
#import "CommentVC.h"
#import "WebServiceClient.h"
#import "MsgD.h"
#import "UserInfo.h"
#import "ReplyDTO.h"

@interface DetailPageVC ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIWebView *contentView;
@property (nonatomic, strong) UIBarButtonItem *upButton;
@property (nonatomic, strong) UIBarButtonItem *commentButton;

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation DetailPageVC {
    BOOL _isRead;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    self.title = @"正文";
    [WebServiceClient fetchMsgDetailWithMsgID:self.msgID
                                      success:^(MsgD *msgDetails){
                                          _isRead = msgDetails.read;
                                          self.titleLabel.text = msgDetails.title;
                                          
                                          self.nameLabel.text = [NSString stringWithFormat:@"%@ . %@", msgDetails.user.name, [self.formatter stringFromDate:msgDetails.addTime]];
                                          [self.contentView loadHTMLString:msgDetails.bodyHTML baseURL:nil];
                                          [(UIButton *)self.upButton.customView setTitle:[NSString stringWithFormat:@"%@", msgDetails.readCount] forState:UIControlStateNormal];
                                          [(UIButton *)self.commentButton.customView setTitle:[NSString stringWithFormat:@"%@", msgDetails.replyCount] forState:UIControlStateNormal];
                                          if (_isRead) {
                                              UIButton *upBtn = (UIButton *)self.upButton.customView;
                                              upBtn.highlighted = YES;
                                          }
                                      } failure:^(NSString *msg){
                                          [SVProgressHUD showErrorWithStatus:msg];
                                      }];
}

- (void)setUpUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *lineOne = [UIView new];
    lineOne.backgroundColor = GLOBAL_DETAIL_COLOR;
    
    UIView *lineTwo = [UIView new];
    lineTwo.backgroundColor = GLOBAL_DETAIL_COLOR;
    
    
    [self.view addSubview:lineOne];
    [self.view addSubview:lineTwo];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.contentView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.right.equalTo(self.imageView.superview);
        make.height.lessThanOrEqualTo(@200);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.nameLabel.superview).offset(20);
        make.top.equalTo(self.nameLabel.superview).offset(64);
    }];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(lineOne.superview).offset(-20);
        make.height.equalTo(@0.5);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.titleLabel.superview).offset(30);
        make.right.equalTo(self.titleLabel.superview).offset(-30);
        make.width.lessThanOrEqualTo(@([UIScreen mainScreen].bounds.size.width-55));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
    }];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@0.5);
        make.left.equalTo(lineTwo.superview).offset(20);
        make.right.equalTo(lineTwo.superview).offset(-20);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(lineTwo.mas_bottom).offset(5);
        make.left.right.equalTo(self.contentView.superview);
        make.bottom.equalTo(self.contentView.superview).offset(-10);
    }];
    [self updateToolBar];
}

- (void)updateToolBar {
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *itemAry = @[flexible, self.upButton, flexible, self.commentButton, flexible];

    self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
    self.navigationController.toolbar.barTintColor = [UIColor whiteColor];
    self.toolbarItems = itemAry;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:animated];
}

#pragma mark - event

- (void)commentButtonClicked {
    NSLog(@"comment");
    CommentVC *comVC = [CommentVC new];
    ReplyDTO *dto = [ReplyDTO new];
    dto.msgID = self.msgID;
    dto.lastID = @0;
    dto.nums = @10;
    comVC.replyDto = dto;
    
    [self.navigationController pushViewController:comVC animated:YES];
}

- (void)upButtonClicked {
    if (_isRead) {
        [WebServiceClient sendReadWithMsgID:self.msgID
                                    success:^{
                                        UIButton *upBtn = (UIButton *)self.upButton.customView;
                                        upBtn.highlighted = NO;
                                        NSString *oldNum = upBtn.titleLabel.text;
                                        NSInteger newNum = oldNum.integerValue - 1;
                                        [upBtn setTitle:[NSString stringWithFormat:@"%ld", (long)newNum] forState:UIControlStateNormal];
                                    }];
        _isRead = NO;
    } else {
        [WebServiceClient sendReadWithMsgID:self.msgID
                                    success:^{
                                        UIButton *upBtn = (UIButton *)self.upButton.customView;
                                        upBtn.highlighted = YES;
                                        NSString *oldNum = upBtn.titleLabel.text;
                                        NSInteger newNum = oldNum.integerValue + 1;
                                        [upBtn setTitle:[NSString stringWithFormat:@"%ld", (long)newNum] forState:UIControlStateNormal];
                                    }];
        _isRead = YES;
    }
}

#pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = GLOBAL_DETAIL_COLOR;
        _nameLabel.font = [UIFont systemFontOfSize:GLOBAL_DERAIL_FONT];
    }
    return _nameLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = GLOBAL_T_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:GLOBAL_T_FONT];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIWebView *)contentView {
    if (!_contentView) {
        _contentView = [UIWebView new];
        _contentView.scrollView.bounces = NO;
    }
    return _contentView;
}

- (UIBarButtonItem *)upButton {
    if (!_upButton) {
        UIButton *upbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/4, 20)];
        upbtn.titleLabel.font = [UIFont systemFontOfSize:GLOBAL_DERAIL_FONT];
        [upbtn setImage:[UIImage imageNamed:@"fire.png"] forState:UIControlStateNormal];
        [upbtn setImage:[UIImage imageNamed:@"fireH.png"] forState:UIControlStateHighlighted];
        [upbtn setTitleColor:GLOBAL_DETAIL_COLOR forState:UIControlStateNormal];
        [upbtn setTitleColor:GLOBAL_BG_COLOR forState:UIControlStateHighlighted];
        [upbtn addTarget:self action:@selector(upButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _upButton = [[UIBarButtonItem alloc] initWithCustomView:upbtn];
    }
    return _upButton;
}

- (UIBarButtonItem *)commentButton {
    if (!_commentButton) {
        UIButton *comBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/4, 20)];
        comBtn.titleLabel.font = [UIFont systemFontOfSize:GLOBAL_DERAIL_FONT];
        [comBtn setImage:[UIImage imageNamed:@"com.png"] forState:UIControlStateNormal];
        [comBtn setImage:[UIImage imageNamed:@"comH.png"] forState:UIControlStateHighlighted];
        [comBtn setTitleColor:GLOBAL_DETAIL_COLOR forState:UIControlStateNormal];
        [comBtn setTitleColor:GLOBAL_BG_COLOR forState:UIControlStateHighlighted];
        [comBtn addTarget:self action:@selector(commentButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _commentButton = [[UIBarButtonItem alloc] initWithCustomView:comBtn];
    }
    return _commentButton;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [NSDateFormatter new];
        [_formatter setDateFormat:@"YY年MM月dd日 HH:mm:ss"];
    }
    return _formatter;
}

@end
