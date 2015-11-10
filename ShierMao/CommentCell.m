//
//  CommentCell.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/21.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell ()

@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self.contentView addSubview:self.avatarV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentLabel];
    
    [self.avatarV mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.avatarV.superview).offset(5);
        make.left.equalTo(self.avatarV.superview).offset(10);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.avatarV).offset(2);
        make.left.equalTo(self.avatarV.mas_right).offset(2);
        make.width.equalTo(@150);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.width.equalTo(@150);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.timeLabel);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentLabel.superview).offset(-10);
        make.right.equalTo(self.contentLabel.superview).offset(-10);
    }];
}

#pragma mark - getter

- (AvatarView *)avatarV {
    if (!_avatarV) {
        _avatarV = [AvatarView new];
        _avatarV.sideLength = 36;
    }
    
    return _avatarV;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = GLOBAL_BG_COLOR;
        _nameLabel.font = [UIFont systemFontOfSize:GLOBAL_DERAIL_FONT];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = GLOBAL_DETAIL_COLOR;
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = GLOBAL_TEXT_COLOR;
        _contentLabel.font = [UIFont systemFontOfSize:GLOBAL_DERAIL_FONT];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
