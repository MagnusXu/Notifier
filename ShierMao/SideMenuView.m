//
//  SideMenuView.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/17.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "SideMenuView.h"
#import <UIImageView+AFNetworking.h>

@interface SideMenuView ()


@end

@implementation SideMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 130)];
        bgView.backgroundColor = GLOBAL_BG_COLOR;
        [self addSubview:bgView];
        
        [self addSubview:self.avatarView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.collectButton];
        [self addSubview:self.qunButton];
        [self addSubview:self.outBtn];
    }
    return self;
}

#pragma mark - event

- (void)showAvatarVC {
    [self.delegate showAvatarVC];
}
- (void)showCollectVC {
    [self.delegate showCollectVC];
}

- (void)showQunVC {
    [self.delegate showQunVC];
}

- (void)outBtnClicked {
    if ([self.delegate respondsToSelector:@selector(outBtnClicked)]) {
        [self.delegate outBtnClicked];
    }
}

#pragma mark - getter

- (UIButton *)avatarView {
    if (!_avatarView) {
        _avatarView = [[UIButton alloc] initWithFrame:CGRectMake(25, 30, 50, 50)];
        NSString *imageUrl = [USER_DEFAULT objectForKey:USER_INFO_HEAD_IMAGE_URL];
        NSData *imageData = [USER_DEFAULT objectForKey:USER_INFO_HEAD_IMAGE];
        if (imageUrl || imageData) {
            if (imageUrl) {
                UIImageView *imageV = [UIImageView new];
                [imageV setImageWithURL:[NSURL URLWithString:imageUrl]];
                [_avatarView setImage:imageV.image forState:UIControlStateNormal];
            }
            if (imageData) {
                [_avatarView setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
            }
        } else {
            [_avatarView setImage:[UIImage imageNamed:@"touxiang_白底.png"] forState:UIControlStateNormal];
        }
        _avatarView.layer.cornerRadius = 25;
        _avatarView.clipsToBounds = YES;
        [_avatarView addTarget:self action:@selector(showAvatarVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 95, self.bounds.size.width-50, 20)];
        _nameLabel.text = [USER_DEFAULT objectForKey:USER_INFO_NAME_DEFAULT_KEY];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UIButton *)collectButton {
    if (!_collectButton) {
        _collectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, self.bounds.size.width-50, 30)];
        [_collectButton setTitle:@"    收藏" forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateHighlighted];
        [_collectButton setImage:[UIImage imageNamed:@"collectD.png"] forState:UIControlStateNormal];
        [_collectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_collectButton setTitleColor:GLOBAL_BG_COLOR forState:UIControlStateHighlighted];
        [_collectButton addTarget:self action:@selector(showCollectVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectButton;
}

- (UIButton *)qunButton {
    if (!_qunButton) {
        _qunButton = [[UIButton alloc] initWithFrame:CGRectMake(9, 190, self.bounds.size.width-50, 30)];
        [_qunButton setTitle:@"    我的群" forState:UIControlStateNormal];
        [_qunButton setImage:[UIImage imageNamed:@"ShapeD.png"] forState:UIControlStateNormal];
        [_qunButton setImage:[UIImage imageNamed:@"Shape.png"] forState:UIControlStateHighlighted];
        [_qunButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_qunButton setTitleColor:GLOBAL_BG_COLOR forState:UIControlStateHighlighted];
        [_qunButton addTarget:self action:@selector(showQunVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qunButton;
}

- (SUMButton *)outBtn {
    if (!_outBtn) {
        _outBtn = [[SUMButton alloc] initWithTitle:@"退  出"];
        _outBtn.frame = CGRectMake(10, CGRectGetMaxY(self.bounds)-50, CGRectGetWidth(self.bounds)-20, 40);
        [_outBtn addTarget:self action:@selector(outBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _outBtn;
}

@end
