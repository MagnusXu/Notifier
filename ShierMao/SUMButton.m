//
//  SUMButton.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/8.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "SUMButton.h"

@implementation SUMButton

- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:GLOBAL_BG_COLOR forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = GLOBAL_BG_COLOR.CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 2.0;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        self.backgroundColor = GLOBAL_BG_COLOR;
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    [super setHighlighted:highlighted];
}

@end
