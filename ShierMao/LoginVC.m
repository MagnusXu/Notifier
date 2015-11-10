//
//  LoginVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/11.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "LoginVC.h"
#import "SUMButton.h"
#import "SUMTextField.h"
#import "AppDelegate.h"
#import "WebServiceClient.h"
#import "LoginDTO.h"

@interface LoginVC () <SUMTextFieldDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) SUMTextField *stuNoField;
@property (nonatomic, strong) SUMTextField *pswField;
@end

@implementation LoginVC {
    UIScrollView *_scrollView;
    UITextField *_currentTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    self.title = @"登陆";
}

- (void)setUpUI {
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-47);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    self.view = _scrollView;
    
    [_scrollView addSubview:self.stuNoField];
    [_scrollView addSubview:self.pswField];
    
    SUMButton *loginButton = [[SUMButton alloc] initWithTitle:@"登  陆"];
    loginButton.frame = CGRectMake(15, 15+46+66+20, self.view.bounds.size.width-30, 40);
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:loginButton];
}

#pragma mark - SUMTextFieldDelegate

- (void)setCurrentTextField:(UITextField *)textField {
    _currentTextField = textField;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_currentTextField endEditing:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_currentTextField endEditing:YES];
}

#pragma mark - event

- (void)loginButtonClicked:(UIButton *)sender {
    NSLog(@"登  陆");
    
    
    LoginDTO *loginDto = [LoginDTO new];
    loginDto.username = self.stuNoField.inputField.text;
    loginDto.password = self.pswField.inputField.text;
    [WebServiceClient loginWithLoginDTO:loginDto
                                success:^(){
                                    [APP_DELEGATE setRootVC2MainPage];
                                } failure:^(NSString *msg){
                                    [SVProgressHUD showErrorWithStatus:msg];
                                }];
}

#pragma mark - getter

- (SUMTextField *)stuNoField {
    if (!_stuNoField) {
        _stuNoField = [[SUMTextField alloc] initWithTitle:@"用户名"
                                                 minLenth:0
                                                 maxLenth:0
                                              hasTipLabel:NO frame:CGRectMake(15, 15, self.view.bounds.size.width-30, 66)];
        _stuNoField.inputField.placeholder = @"请输入用户名";
        _stuNoField.inputField.keyboardType = UIKeyboardTypeURL;
        _stuNoField.delegate = self;
    }
    return _stuNoField;
}

- (SUMTextField *)pswField {
    if (!_pswField) {
        _pswField = [[SUMTextField alloc] initWithTitle:@"密码"
                                               minLenth:6
                                               maxLenth:18
                                            hasTipLabel:YES frame:CGRectMake(15, 10+60, self.view.bounds.size.width-30, 66)];
        _pswField.inputField.secureTextEntry = YES;
        _pswField.inputField.placeholder = @"请输入密码";
        _pswField.delegate = self;
        
        
    }
    return _pswField;
}
@end
