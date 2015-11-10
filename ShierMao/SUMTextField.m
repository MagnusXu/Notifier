//
//  SUMTextField.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/9.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "SUMTextField.h"

@interface SUMTextField () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *breakline;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation SUMTextField {
    int minlen;
    int maxlen;
}

- (instancetype)initWithTitle:(NSString *)title minLenth:(int)minLen maxLenth:(int)maxLen hasTipLabel:(BOOL)has frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        minlen = minLen;
        maxlen = maxLen;
        [self addSubview:self.titleLabel];
        [self addSubview:self.inputField];
        [self addSubview:self.breakline];
        [self addSubview:self.tipLabel];

        self.titleLabel.text = title;
        self.titleLabel.hidden = YES;
        
        self.tipLabel.text = [NSString stringWithFormat:@"0 / %d-%d", minLen, maxLen];
        if (has) {
            self.tipLabel.hidden = NO;
        } else {
            self.tipLabel.hidden = YES;
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resignFirstResponder];
    [self.delegate touchesBegan:touches withEvent:event];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger currentLen = [currentString length];
    
    self.tipLabel.text = [NSString stringWithFormat:@"%lu / %d-%d", (unsigned long)currentLen, minlen, maxlen];
    if (minlen == 0 && maxlen == 0) {
        if (currentLen > 0 && currentLen <16) {
            self.titleLabel.hidden = NO;
            return YES;
        }
    } else {
        if (currentLen > 0 && currentLen < minlen) {
            self.breakline.backgroundColor = [UIColor redColor];
            self.tipLabel.textColor = [UIColor redColor];
            self.titleLabel.hidden = NO;
        } else if (currentLen == 0) {
            self.titleLabel.hidden = YES;
            self.breakline.backgroundColor = GLOBAL_BG_COLOR;
            self.tipLabel.textColor = [UIColor grayColor];
        } else if (currentLen >= minlen && currentLen < maxlen) {
            self.breakline.backgroundColor = GLOBAL_BG_COLOR;
            self.tipLabel.textColor = [UIColor grayColor];
        } else {
            self.breakline.backgroundColor = [UIColor redColor];
            self.tipLabel.textColor = [UIColor redColor];
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.breakline.backgroundColor == [UIColor grayColor]) {
        self.breakline.backgroundColor = GLOBAL_BG_COLOR;
    }
    [self.delegate setCurrentTextField:self.inputField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        self.breakline.backgroundColor = [UIColor grayColor];
        self.titleLabel.hidden = YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    textField.text = @"";
    self.tipLabel.text = [NSString stringWithFormat:@"0 / %d-%d", minlen, maxlen];
    self.tipLabel.textColor = [UIColor grayColor];
    self.breakline.backgroundColor = GLOBAL_BG_COLOR;
    return YES;
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:GLOBAL_DERAIL_FONT];
        _titleLabel.textColor = GLOBAL_BG_COLOR;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UITextField *)inputField {
    if (!_inputField) {
        _inputField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 30)];
        _inputField.borderStyle = UITextBorderStyleNone;
        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputField.delegate = self;
    }
    return _inputField;
}

- (UIView *)breakline {
    if (!_breakline) {
        _breakline = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.bounds.size.width, 1)];
        _breakline.backgroundColor = [UIColor grayColor];
        _breakline.layer.cornerRadius = 0.5;
    }
    return _breakline;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds), 51, self.bounds.size.width/2, 15)];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentRight;
        _tipLabel.textColor = [UIColor grayColor];
    }
    return _tipLabel;
}

@end