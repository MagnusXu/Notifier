//
//  SUMBackAnimation.h
//  ShierMao
//
//  Created by 孙铭 on 15/9/8.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SUMBackAnimation : NSObject <UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>

- (instancetype)initWithNav:(UINavigationController *)nav;
- (void)handlePanGesture:(UIPanGestureRecognizer *)pan;

@end
