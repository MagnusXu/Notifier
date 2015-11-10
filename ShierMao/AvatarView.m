//
//  AvatarView.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/9.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "AvatarView.h"

static const CGFloat height = 77;

@interface AvatarView ()

@end

@implementation AvatarView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.avatarImageView];
        [self addSubview:self.placeholderImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewClicked)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)updateConstraints {
    [self mas_makeConstraints:^(MASConstraintMaker *make){
        if (!(_sideLength > 0.0)) {
            make.width.height.equalTo(@(height));
        } else {
            make.width.height.equalTo(@(_sideLength));
        }
    }];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(_avatarImageView.superview).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_placeholderImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(_placeholderImageView.superview);
    }];
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatarImageView.layer.borderWidth = 3;
    self.layer.cornerRadius = CGRectGetWidth(self.frame) / 2;
    _avatarImageView.layer.cornerRadius = CGRectGetWidth(_avatarImageView.frame) / 2;
}

#pragma mark - Delegate

- (void)avatarViewClicked {
    [self.delegate avatarViewClicked];
}

#pragma mark - getter

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [UIImageView new];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImageView.backgroundColor = [UIColor whiteColor];
        _avatarImageView.clipsToBounds = YES;
    }
    return _avatarImageView;
}

- (UIImageView *)placeholderImageView {
    if (!_placeholderImageView) {
        _placeholderImageView = [UIImageView new];
        _placeholderImageView.image = [UIImage imageNamed:@"touxiang_白底.png"];
        _placeholderImageView.contentMode = UIViewContentModeScaleAspectFit;
        _placeholderImageView.clipsToBounds = YES;
    }
    return _placeholderImageView;
}

@end
