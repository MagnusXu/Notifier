//
//  AvatarView.h
//  ShierMao
//
//  Created by 孙铭 on 15/9/9.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AvatarViewClickedDelegate <NSObject>

- (void)avatarViewClicked;

@end

@interface AvatarView : UIView

@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *placeholderImageView;

@property (nonatomic, weak) id<AvatarViewClickedDelegate> delegate;

@end
