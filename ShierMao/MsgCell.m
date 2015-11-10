//
//  MsgCell.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/8.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "MsgCell.h"

@interface MsgCell ()

@property (nonatomic, strong) UIImageView *contentImageView;

@end

@implementation MsgCell {
    BOOL _collectBtnClicked;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.likeLabel];
    [self.contentView addSubview:self.collectButton];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.titleLabel.superview).offset(12);
        make.left.equalTo(self.titleLabel.superview).offset(15);
        make.right.equalTo(self.titleLabel.superview).offset(-12);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self.titleLabel);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.detailLabel.mas_bottom).offset(15);
        make.left.equalTo(self.detailLabel);
        make.bottom.equalTo(self.timeLabel.superview).offset(-5);
    }];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.timeLabel.mas_right).offset(10);
        make.centerY.equalTo(self.timeLabel);
    }];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.collectButton.superview).offset(-10);
        make.bottom.equalTo(self.collectButton.superview).offset(-5);
    }];
}

#pragma mark - event

- (void)collectButtonClicked:(UIButton *)button {
    [self.delegate collectButtonClicked:button];
}

#pragma mark - getter

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [UIImageView new];
    }
    return _contentImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:GLOBAL_HEAD_FONT];
        _titleLabel.textColor = GLOBAL_TEXT_COLOR;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        _detailLabel.font = [UIFont systemFontOfSize:GLOBAL_DERAIL_FONT];
        _detailLabel.textColor = GLOBAL_DETAIL_COLOR;
        _detailLabel.numberOfLines = 2;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _detailLabel;
}

- (UIButton *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UIButton new];
        [_timeLabel setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal];
        [_timeLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _timeLabel.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _timeLabel;
}

- (UIButton *)likeLabel {
    if (!_likeLabel) {
        _likeLabel = [UIButton new];
        [_likeLabel setImage:[UIImage imageNamed:@"fireS.png"] forState:UIControlStateNormal];
        [_likeLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _likeLabel.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _likeLabel;
}

- (UIButton *)collectButton {
    if (!_collectButton) {
        _collectButton = [UIButton new];
        [_collectButton setImage:[UIImage imageNamed:@"collectD.png"] forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateHighlighted];
        [_collectButton addTarget:self action:@selector(collectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _collectButton.tag = 1;
    }
    return _collectButton;
}
@end
