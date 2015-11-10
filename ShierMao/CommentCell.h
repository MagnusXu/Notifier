//
//  CommentCell.h
//  ShierMao
//
//  Created by 孙铭 on 15/9/21.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarView.h"

@interface CommentCell : UITableViewCell

@property (nonatomic, strong) AvatarView *avatarV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end
