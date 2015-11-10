//
//  SideMenuVC.h
//  ShierMao
//
//  Created by 孙铭 on 15/9/13.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainPageTableVC.h"

@interface SideMenuVC : UIViewController

@property (nonatomic, strong) MainPageTableVC *mainVC;
@property (nonatomic, strong) NSArray *groupArray;

- (instancetype)initWithBackGroundImage:(UIImage *)bgImg;

@end
