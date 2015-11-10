//
//  SideMenuView.h
//  ShierMao
//
//  Created by 孙铭 on 15/9/17.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUMButton.h"

@protocol SideMenuViewDelegate <NSObject>

@required
- (void)showAvatarVC;
- (void)showCollectVC;
- (void)showAboutVC;
- (void)showQunVC;

@optional
- (void)outBtnClicked;

@end

@interface SideMenuView : UIView

@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIButton *aboutButton;
@property (nonatomic, strong) UIButton *qunButton;
@property (nonatomic, strong) SUMButton *outBtn;

@property (nonatomic, weak) id<SideMenuViewDelegate> delegate;

@end
