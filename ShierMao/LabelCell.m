//
//  LabelCell.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/18.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "LabelCell.h"

@implementation LabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self.contentView addSubview:self.itemLabel];
    [self.contentView addSubview:self.contentLabel];
    
    [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.bottom.left.equalTo(self.itemLabel.superview);
        make.width.equalTo(@100);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.bottom.equalTo(self.itemLabel);
        make.left.equalTo(self.itemLabel.mas_right);
        make.right.equalTo(self.contentLabel.superview);
    }];
}

#pragma mark - getter

- (UILabel *)itemLabel {
    if (!_itemLabel) {
        _itemLabel = [UILabel new];
        _itemLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _itemLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _contentLabel;
}

@end
