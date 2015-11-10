//
//  FirstOpenVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/8.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "FirstOpenVC.h"
#import "SUMButton.h"
#import "RegisterVC.h"
#import "LoginVC.h"

@interface FirstOpenVC ()
@property (nonatomic, strong) SUMButton *registerButton;
@property (nonatomic, strong) SUMButton *loginButton;
@end

@implementation FirstOpenVC

- (void)setUpUI {
    UIImageView *backGroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg1.png"]];
    backGroundView.frame = [UIScreen mainScreen].bounds;
    backGroundView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backGroundView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.loginButton];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.view).offset(150);
        make.height.equalTo(@40);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.registerButton.mas_bottom).offset(20);
        make.left.right.equalTo(self.registerButton);
        make.height.equalTo(@40);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - event

- (void)registerButtonClicked:(UIButton *)sender {
    NSLog(@"注册");
    [self.navigationController pushViewController:[RegisterVC new] animated:YES];
}

- (void)loginButtonClicked:(UIButton *)sender {
    NSLog(@"登陆");
    [self.navigationController pushViewController:[LoginVC new] animated:YES];
}

#pragma mark - getter

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[SUMButton alloc] initWithTitle:NSLocalizedString(@"注  册", nil)];
        [_registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[SUMButton alloc] initWithTitle:NSLocalizedString(@"登  陆", nil)];
        [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

@end
