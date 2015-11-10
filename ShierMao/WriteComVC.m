//
//  WriteComVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/22.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "WriteComVC.h"
#import "SUMButton.h"
#import "WebServiceClient.h"

@interface WriteComVC ()

@property (nonatomic, strong) UITextView *commentField;
@property (nonatomic, strong) SUMButton *sendBtn;

@end

@implementation WriteComVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"写评论";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
}

- (void)setUpUI {
    [self.view addSubview:self.commentField];
    [self.view addSubview:self.sendBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.commentField becomeFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - event

- (void)sendBtnClicked {
    [WebServiceClient sendReplyWithMsgID:self.msgID body:self.commentField.text
                                 success:^{
                                     [self.navigationController popViewControllerAnimated:YES];
                                 } failure:^(NSString *msg){
                                     [SVProgressHUD showErrorWithStatus:msg];
                                 }];
}

#pragma mark - getter

- (UITextView *)commentField {
    if (!_commentField) {
        _commentField = [[UITextView alloc] initWithFrame:CGRectMake(20, 84, CGRectGetWidth(self.view.bounds)-40, 136)];
        _commentField.contentInset = UIEdgeInsetsMake(-70, 0, 0, 0);
        _commentField.layer.cornerRadius = 1;
        _commentField.backgroundColor = [UIColor whiteColor];
        _commentField.textColor = GLOBAL_DETAIL_COLOR;
        _commentField.font = [UIFont systemFontOfSize:GLOBAL_DERAIL_FONT];
        _commentField.keyboardType = UIKeyboardTypeTwitter;
    }
    return _commentField;
}

- (SUMButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[SUMButton alloc] initWithTitle:@"确定"];
        _sendBtn.frame = CGRectMake(20, 240, CGRectGetWidth(self.view.bounds)-40, 40);
        [_sendBtn addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

@end
