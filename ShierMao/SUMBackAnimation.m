//
//  SUMBackAnimation.m
//  ShierMao
//
//  Created by 孙铭 on 15/9/8.
//  Copyright (c) 2015年 SSSTA. All rights reserved.
//

#import "SUMBackAnimation.h"
//#import "SUMPushAnimation.h"
#import "AppDelegate.h"
#import "SideMenuVC.h"

@interface SUMBackAnimation ()
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *transition;
@property (nonatomic, weak) UINavigationController *nav;
@end

@implementation SUMBackAnimation

- (instancetype)initWithNav:(UINavigationController *)nav {
    if (self = [super init]) {
        self.nav = nav;
        self.nav.delegate = self;
    }
    return self;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    [APP_DELEGATE.window endEditing:NO];
    
    CGFloat progress = [pan translationInView:pan.view].x / pan.view.bounds.size.width;
    progress = MIN(1.0, MAX(0.0, progress));
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            self.transition = [UIPercentDrivenInteractiveTransition new];
            [self.nav popViewControllerAnimated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            [self.transition updateInteractiveTransition:progress];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:{
            if (progress > 0.2) {
                [self.transition finishInteractiveTransition];
            } else {
                [self.transition cancelInteractiveTransition];
            }
            self.transition = nil;
        }
            break;
        default:
            break;
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (animationController == self) {
        return self.transition;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        return self;
    }
    return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVC.view.clipsToBounds = NO; 
    fromVC.view.layer.shadowOpacity = 0.5;
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.transform = CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width*0.6, 0);
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         fromVC.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
                         toVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
                     }
                     completion:^(BOOL finished){
                         toVC.view.transform = CGAffineTransformIdentity;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];}
     ];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
