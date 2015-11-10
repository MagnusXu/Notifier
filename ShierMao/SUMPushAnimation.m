//
//  SUMPushAnimation.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/11.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "SUMPushAnimation.h"

@implementation SUMPushAnimation

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.layer.shadowOpacity = 0.4;
    toVC.view.clipsToBounds = NO;
    toVC.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toVC.view aboveSubview:fromVC.view];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         fromVC.view.transform = CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width*0.6, 0);
                         toVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:^(BOOL finished){
                         fromVC.view.transform = CGAffineTransformIdentity;
                         toVC.view.transform = CGAffineTransformIdentity;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];}
     ];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
