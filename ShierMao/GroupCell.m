//
//  GroupCell.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/22.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "GroupCell.h"

@interface GroupCell ()

@property (nonatomic, strong) UIImageView *headImage;

@end

@implementation GroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.groupName];
    }
    return self;
}

#pragma mark - getter

- (UIImageView *)headImage {
    if (!_headImage) {
        _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 4, 36, 36)];
        _headImage.image = [UIImage imageNamed:@"touxiang_白底.png"];
        _headImage.layer.cornerRadius = 20;
    }
    return _headImage;
}

- (UILabel *)groupName {
    if (!_groupName) {
        _groupName = [[UILabel alloc] initWithFrame:CGRectMake(50, 4, 200, 36)];
        _groupName.text = @"啊哈哈哈哈哈";
        _groupName.textColor = GLOBAL_T_COLOR;
    }
    return _groupName;
}

@end
