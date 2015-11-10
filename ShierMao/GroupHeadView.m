//
//  GroupHeadView.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/22.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "GroupHeadView.h"

@implementation GroupHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self addSubview:self.headImage];
    [self addSubview:self.name];
    
    UILabel *deLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 100, 10)];
    deLabel.text = @"群资料";
    deLabel.font = [UIFont systemFontOfSize:14];
    deLabel.textColor = UIColorFromHex(0x4A4A4A);
    [self addSubview:deLabel];
    
    [self addSubview:self.detail];
}

#pragma mark - getter

- (UIImageView *)headImage {
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxiang_白底.png"]];
        _headImage.frame = CGRectMake(20, 20, 40, 40);
    }
    return _headImage;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 200, 30)];
        _name.text = @"西安电子科技大学";
        _name.textColor = UIColorFromHex(0x4A4A4A);
        _name.font = [UIFont systemFontOfSize:20];
    }
    return _name;
}

- (UILabel *)detail {
    if (!_detail) {
        _detail = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, CGRectGetWidth(self.bounds)-40, 60)];
        _detail.text = @"此群用于biabiabiabiabiabiabiabiabia";
        _detail.textColor = GLOBAL_DETAIL_COLOR;
        _detail.font = [UIFont systemFontOfSize:GLOBAL_DERAIL_FONT];
    }
    return _detail;
}

@end
