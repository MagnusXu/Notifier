//
//  SUMNavigationController.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/8.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "SUMNavigationController.h"
#import "SUMBackAnimation.h"

@interface SUMNavigationController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) SUMBackAnimation *panBackAnimation;
@end

@implementation SUMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIGestureRecognizer *oldGesture = self.interactivePopGestureRecognizer;
    oldGesture.enabled = NO;
    UIView *gestureView = oldGesture.view;
    
    self.popGesture = [UIPanGestureRecognizer new];
    self.popGesture.maximumNumberOfTouches = 1;
    self.popGesture.delegate = self;
    [gestureView addGestureRecognizer:self.popGesture];
    
    _panBackAnimation = [[SUMBackAnimation alloc] initWithNav:self];
    [self.popGesture addTarget:_panBackAnimation action:@selector(handlePanGesture:)];
}

@end