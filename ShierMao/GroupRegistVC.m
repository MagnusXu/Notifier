//
//  GroupRegistVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/10/11.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "GroupRegistVC.h"
#import "GroupHeadView.h"
#import "SUMButton.h"
#import "WebServiceClient.h"
#import "GroupPreview.h"

@interface GroupRegistVC ()

@property (nonatomic, strong) UITextField *text;

@end

@implementation GroupRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群资料";
    [self setUpUI];
}

- (void)setUpUI {
    self.view.backgroundColor = [UIColor whiteColor];
    GroupHeadView *head = [[GroupHeadView alloc] initWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.bounds), 190)];
    head.name.text = self.preview.name;
    head.detail.text = self.preview.desc;
    SUMButton *registeBtn = [[SUMButton alloc] initWithTitle:@"申请加入"];
    registeBtn.frame = CGRectMake(20, 250, CGRectGetWidth(self.view.bounds)-40, 40);
    [registeBtn addTarget:self action:@selector(registeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:head];
    [self.view addSubview:registeBtn];
    [self.view addSubview:self.text];
}

#pragma mark - event
- (void)registeBtnClicked {
    if ([self.text.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证信息"];
        return;
    }
    [WebServiceClient applySentWithGroupID:self.preview.groupID body:self.text.text];
}

#pragma mark - getter
- (UITextField *)text {
    if (!_text) {
        _text = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, CGRectGetWidth(self.view.bounds)-40, 40)];
        _text.placeholder = @"请在此输入验证信息";
    }
    return _text;
}

@end