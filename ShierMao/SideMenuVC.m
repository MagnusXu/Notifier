//
//  SideMenuVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/13.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "SideMenuVC.h"
#import "SideMenuView.h"
#import "PersonVC.h"
#import "AppDelegate.h"
#import "GroupVC.h"
#import "CollectVC.h"

@interface SideMenuVC () <SideMenuViewDelegate>
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) SideMenuView *menuView;
@end

@implementation SideMenuVC

- (instancetype)initWithBackGroundImage:(UIImage *)img {
    self = [super init];
    if (self) {
        self.bgView = [[UIImageView alloc] initWithImage:img];
        
        UIButton *blackView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.5;
        [blackView addTarget:self action:@selector(backgroundTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.bgView];
        [self.view addSubview:blackView];
        [self.view addSubview:self.menuView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sideMenuShow];
}

#pragma mark - SideMenuViewDelegate

- (void)showAvatarVC {
    NSLog(@"ShowAvatar");
    [self dismissViewControllerAnimated:NO completion:^{
        [self.mainVC.navigationController pushViewController:[PersonVC new] animated:YES];
    }];
}
- (void)showCollectVC {
    NSLog(@"ShowCollect");
    [self dismissViewControllerAnimated:NO completion:^{
        CollectVC *cVC = [CollectVC new];
        [self.mainVC.navigationController pushViewController:cVC animated:YES];
    }];
}
- (void)showAboutVC {
    NSLog(@"ShowAbout");
}
- (void)showQunVC {
    NSLog(@"ShowQun");
    GroupVC *group = [GroupVC new];
    group.groupArray = self.groupArray;
    [self dismissViewControllerAnimated:NO completion:^{
        [self.mainVC.navigationController pushViewController:group animated:YES];
    }];
}

- (void)outBtnClicked {
    NSLog(@"Out!!");
    [USER_DEFAULT removeObjectForKey:ACCESS_TOKEN_USER_DEFAULT_KEY];
    [self dismissViewControllerAnimated:NO completion:^{
        [APP_DELEGATE setRootVC2FirstOpen];
    }];
}

#pragma mark - event

- (void)backgroundTapped:(UIButton *)sender {
    [self sideMenuHidden];
}

#pragma mark - privite

- (void)sideMenuShow {
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.menuView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)*0.7, CGRectGetHeight(self.view.bounds));
    } completion:^(BOOL finished){
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)sideMenuHidden {
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.menuView.frame = CGRectMake(-CGRectGetWidth(self.view.bounds)*0.7, 0, CGRectGetWidth([UIScreen mainScreen].bounds)*0.7, CGRectGetHeight([UIScreen mainScreen].bounds));
    } completion:^(BOOL finished){
        self.view.userInteractionEnabled = YES;
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - getter

- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [[SideMenuView alloc] initWithFrame:CGRectMake(-CGRectGetWidth(self.view.bounds)*0.7, 0, CGRectGetWidth([UIScreen mainScreen].bounds)*0.7, CGRectGetHeight([UIScreen mainScreen].bounds))];
        _menuView.delegate = self;
    }
    return _menuView;
}

@end
