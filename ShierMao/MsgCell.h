//
//  MsgCell.h
//  ShierMao
//
//  Created by 孙铭 on 15/9/8.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MsgCellCollectButtonDelegate <NSObject>

- (void)collectButtonClicked:(UIButton *)collectButton;

@end

@interface MsgCell : UITableViewCell

@property (nonatomic, strong) UIButton *collectButton;

@property (nonatomic, weak) id<MsgCellCollectButtonDelegate> delegate;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *timeLabel;
@property (nonatomic, strong) UIButton *likeLabel;

@end
