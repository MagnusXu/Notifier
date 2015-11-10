//
//  SUMTextField.h
//  ShierMao
//
//  Created by 孙铭 on 15/9/9.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SUMTextFieldDelegate <NSObject>

@required
- (void)setCurrentTextField:(UITextField *)textField;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface SUMTextField : UIControl

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, weak) id<SUMTextFieldDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title minLenth:(int)minLen maxLenth:(int)maxLen hasTipLabel:(BOOL)has frame:(CGRect)frame;

@end
