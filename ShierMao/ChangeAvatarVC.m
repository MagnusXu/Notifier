//
//  ChangeAvatarVC.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/23.
//  Copyright © 2015年 SSSTA. All rights reserved.
//

#import "ChangeAvatarVC.h"
#import "SUMButton.h"
#import "WebServiceClient.h"
#import <UIImageView+AFNetworking.h>

@interface ChangeAvatarVC () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) SUMButton *changeBtn;
@property (nonatomic, strong) SUMButton *keepBtn;

@property (nonatomic, strong) SUMButton *fromA;
@property (nonatomic, strong) SUMButton *fromC;
@property (nonatomic, strong) SUMButton *cancleBtn;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation ChangeAvatarVC

- (instancetype)init {
    if (self = [super init]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    [self.view addSubview:self.avatarView];
    [self.view addSubview:self.changeBtn];
    [self.view addSubview:self.keepBtn];
    [self.view addSubview:self.fromA];
    [self.view addSubview:self.fromC];
    [self.view addSubview:self.cancleBtn];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.avatarView.superview);
        make.top.equalTo(self.avatarView.superview).offset(74);
        make.height.equalTo(@200);
    }];
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.avatarView.mas_bottom).offset(20);
        make.left.equalTo(self.changeBtn.superview).offset(20);
        make.right.equalTo(self.changeBtn.superview).offset(-20);
        make.height.equalTo(@40);
    }];
    [self.fromA mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.changeBtn);
        make.height.equalTo(@40);
    }];
    [self.keepBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.changeBtn.mas_bottom).offset(10);
        make.left.right.equalTo(self.changeBtn);
        make.height.equalTo(@40);
    }];
    [self.fromC mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.keepBtn);
        make.height.equalTo(@40);
    }];
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.keepBtn.mas_bottom).offset(10);
        make.left.right.equalTo(self.keepBtn);
        make.height.equalTo(@40);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.avatarView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - event

- (void)chooseMode {
    self.changeBtn.hidden = YES;
    self.keepBtn.hidden = YES;
    self.fromA.hidden = NO;
    self.fromC.hidden = NO;
    self.cancleBtn.hidden = NO;
}

- (void)keepBtnClicked {
    [WebServiceClient sendHeadImage:self.avatarView.image success:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)cancleBtnClicked {
    self.changeBtn.hidden = NO;
    self.keepBtn.hidden = NO;
    self.fromA.hidden = YES;
    self.fromC.hidden = YES;
    self.cancleBtn.hidden = YES;
}

- (void)choosePickerOrigin:(SUMButton *)sender {
    self.imagePicker = [UIImagePickerController new];
    if (self.fromA == sender) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            return;
        }
    }
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.delegate = self;
    
    self.changeBtn.hidden = NO;
    self.keepBtn.hidden = NO;
    self.fromA.hidden = YES;
    self.fromC.hidden = YES;
    self.cancleBtn.hidden = YES;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - getter

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        NSString *imageUrl = [USER_DEFAULT objectForKey:USER_INFO_HEAD_IMAGE_URL];
        NSData *imageData = [USER_DEFAULT objectForKey:USER_INFO_HEAD_IMAGE];
        if (imageUrl || imageData) {
            if (imageUrl) {
                [_avatarView setImageWithURL:[NSURL URLWithString:imageUrl]];
            }
            if (imageData) {
                [_avatarView setImage:[UIImage imageWithData:imageData]];
            }
        } else {
            [_avatarView setImage:[UIImage imageNamed:@"touxiang_白底.png"]];
        }
        _avatarView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _avatarView;
}

- (SUMButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [[SUMButton alloc] initWithTitle:@"更换头像"];
        [_changeBtn addTarget:self action:@selector(chooseMode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}

- (SUMButton *)keepBtn {
    if (!_keepBtn) {
        _keepBtn = [[SUMButton alloc] initWithTitle:@"保存"];
        [_keepBtn addTarget:self action:@selector(keepBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keepBtn;
}

- (SUMButton *)fromA {
    if (!_fromA) {
        _fromA = [[SUMButton alloc] initWithTitle:@"从相册中选择"];
        _fromA.hidden = YES;
        [_fromA addTarget:self action:@selector(choosePickerOrigin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fromA;
}

- (SUMButton *)fromC {
    if (!_fromC) {
        _fromC = [[SUMButton alloc] initWithTitle:@"照相"];
        _fromC.hidden = YES;
        [_fromC addTarget:self action:@selector(choosePickerOrigin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fromC;
}

- (SUMButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [[SUMButton alloc] initWithTitle:@"取消"];
        _cancleBtn.hidden = YES;
        [_cancleBtn addTarget:self action:@selector(cancleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

@end
