//
//  RegisterVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/9.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "AppDelegate.h"
#import "RegisterVC.h"
#import "SUMTextField.h"
#import "SUMButton.h"
#import "MainPageTableVC.h"
#import "WebServiceClient.h"
#import "RegistDTO.h"
#import "UniversityVC.h"

@interface RegisterVC () <UIScrollViewDelegate, SUMTextFieldDelegate>

@property (nonatomic, strong) SUMTextField *userNameField;
@property (nonatomic, strong) SUMTextField *stuNoField;
@property (nonatomic, strong) SUMTextField *realNameFiled;
@property (nonatomic, strong) UISegmentedControl *genderControl;
@property (nonatomic, strong) SUMTextField *pswField;
@property (nonatomic, strong) SUMTextField *checkPswField;

@end

@implementation RegisterVC {
    BOOL _keyboardIsShown;
    UIScrollView *_scrollView;
    UITextField *_currentTextField;
    BOOL _hasKBFrame;
    CGRect _KBFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpUI];
    self.title = @"注册";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_keyboardIsShown) {
        CGRect viewFrame = self.view.frame;
        viewFrame.size.height += _KBFrame.size.height;
        self.view.frame = viewFrame;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpUI {
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *backGroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    backGroundView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-63);
    backGroundView.backgroundColor = [UIColor whiteColor];
    backGroundView.delegate = self;
    self.view = backGroundView;
    _scrollView = backGroundView;
    
    [backGroundView addSubview:self.userNameField];
    [backGroundView addSubview:self.stuNoField];
    [backGroundView addSubview:self.realNameFiled];
    [backGroundView addSubview:self.genderControl];
    [backGroundView addSubview:self.pswField];
    [backGroundView addSubview:self.checkPswField];
    
    SUMButton *OKButton = [[SUMButton alloc] initWithTitle:@"注  册"];
    OKButton.frame = CGRectMake(15, CGRectGetMaxY(self.checkPswField.frame)+30, CGRectGetWidth(self.view.frame)-30, 40);
    [OKButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [backGroundView addSubview:OKButton];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_currentTextField endEditing:YES];
}

#pragma mark - KeyboardNotif

- (void)keyboardDidShow:(NSNotification *)notif {
    if (_keyboardIsShown) {
        return;
    }
    if (!_hasKBFrame) {
        NSDictionary *info = notif.userInfo;
        NSValue *keyBoardValue = info[UIKeyboardFrameEndUserInfoKey];
        _KBFrame = [self.view convertRect:[keyBoardValue CGRectValue] fromView:nil];
        _hasKBFrame = YES;
    }
    CGRect viewFrame = _scrollView.frame;
    viewFrame.size.height -= _KBFrame.size.height;
    self.view.frame = viewFrame;
    _keyboardIsShown = YES;
    
    viewFrame = _currentTextField.frame;
    viewFrame.origin.y -= viewFrame.size.height;
    [_scrollView scrollRectToVisible:viewFrame animated:YES];
}

- (void)keyboardDidHide:(NSNotification *)notif {
    if (!_hasKBFrame) {
        NSDictionary *info = notif.userInfo;
        NSValue *keyBoardValue = info[UIKeyboardFrameEndUserInfoKey];
        _KBFrame = [self.view convertRect:[keyBoardValue CGRectValue] fromView:nil];
    }
    CGRect viewFrame = _scrollView.frame;
    viewFrame.size.height += _KBFrame.size.height;
    self.view.frame = viewFrame;
    _keyboardIsShown = NO;
}

#pragma mark - SUMTextFieldDelegate

- (void)setCurrentTextField:(UITextField *)textField {
    _currentTextField = textField;
}

#pragma mark - UIScrollViewDelegate

#pragma mark - event

- (void)registerButtonClicked:(UIButton *)sender {
    NSLog(@"注  册");
    // 验证

    NSString *username = self.userNameField.inputField.text;
    NSString *password = self.pswField.inputField.text;
    NSString *checkPsw = self.checkPswField.inputField.text;
    NSString *name = self.realNameFiled.inputField.text;
    NSNumber *studentID = [NSNumber numberWithInt:self.stuNoField.inputField.text.intValue];
    NSNumber *gender = [NSNumber numberWithInteger:self.genderControl.selectedSegmentIndex];
    
    switch (gender.intValue) {
        case 0:
            gender = @2;
            break;
        case 1:
            gender = @1;
            break;
        default:
            break;
    }
    
    BOOL checkUsername = username.length >= 2 && username.length <= 15;
    BOOL checkPassword = password.length >= 6 && password.length <= 18;
    BOOL checkName = name.length >= 2 && name.length <= 6;
    BOOL checkStuID = ![studentID isEqualToNumber:@0];
    if (checkUsername && checkPassword && checkName && checkStuID) {
        if ([checkPsw isEqualToString:password]) {
            RegistDTO *dto = [RegistDTO new];
            dto.username = username;
            dto.password = password;
            dto.name = name;
            dto.studentID = studentID;
            dto.gender = gender;
            UniversityVC *newVC = [UniversityVC new];
            newVC.registDTO = dto;
            [self.navigationController pushViewController:newVC animated:YES];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"请输入正确信息"];
    }
    
    

}

#pragma mark - getter

- (SUMTextField *)userNameField {
    if (!_userNameField) {
        _userNameField = [[SUMTextField alloc] initWithTitle:@"用户名"
                                                    minLenth:2
                                                    maxLenth:15
                                                 hasTipLabel:YES frame:CGRectMake(15, 15, self.view.bounds.size.width-30, 66)];
        _userNameField.inputField.placeholder = @"请输入用户名";
        _userNameField.delegate = self;
        //font, color.
        
    }
    return _userNameField;
}

- (SUMTextField *)stuNoField {
    if (!_stuNoField) {
        _stuNoField = [[SUMTextField alloc] initWithTitle:@"学号"
                                                 minLenth:0
                                                 maxLenth:0
                                              hasTipLabel:NO frame:CGRectMake(15, 15+66, self.view.bounds.size.width-30, 66)];
        _stuNoField.inputField.placeholder = @"请输入学号";
        _stuNoField.delegate = self;
        _stuNoField.inputField.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    return _stuNoField;
}

- (SUMTextField *)realNameFiled {
    if (!_realNameFiled) {
        _realNameFiled = [[SUMTextField alloc] initWithTitle:@"姓名"
                                                    minLenth:2
                                                    maxLenth:6
                                                 hasTipLabel:YES frame:CGRectMake(15, 15+66*2, self.view.bounds.size.width-150, 66)];
        _realNameFiled.inputField.placeholder = @"请输入真实姓名";
        _realNameFiled.delegate = self;
        
    }
    return _realNameFiled;
}

- (UISegmentedControl *)genderControl {
    if (!_genderControl) {
        _genderControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"男", @"女", nil]];
        _genderControl.frame = CGRectMake(CGRectGetMaxX(self.view.bounds) - 115, 15+66*2+20, 100, 30);
        _genderControl.tintColor = GLOBAL_BG_COLOR;
        _genderControl.selectedSegmentIndex = 0;
    }
    return _genderControl;
}

- (SUMTextField *)pswField {
    if (!_pswField) {
        _pswField = [[SUMTextField alloc] initWithTitle:@"密码"
                                               minLenth:6
                                               maxLenth:18
                                            hasTipLabel:YES frame:CGRectMake(15, 15+66*3, self.view.bounds.size.width-30, 66)];
        _pswField.inputField.secureTextEntry = YES;
        _pswField.inputField.placeholder = @"请输入密码";
        _pswField.delegate = self;
        
        
    }
    return _pswField;
}

- (SUMTextField *)checkPswField {
    if (!_checkPswField) {
        _checkPswField = [[SUMTextField alloc] initWithTitle:@""
                                                    minLenth:0
                                                    maxLenth:0
                                                 hasTipLabel:NO frame:CGRectMake(15, 15+66*4-20, self.view.bounds.size.width-30, 66)];
        _checkPswField.inputField.secureTextEntry = YES;
        _checkPswField.inputField.placeholder = @"请再次输入密码";
        _checkPswField.delegate = self;
        
    }
    return _checkPswField;
}

@end