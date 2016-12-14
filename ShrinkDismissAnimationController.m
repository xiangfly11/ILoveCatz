//
//  ShrinkDismissAnimationController.m
//  ILoveCatz
//
//  Created by jiaxiang on 16/12/1.
//  Copyright © 2016年 com.razeware. All rights reserved.
//

#import "ShrinkDismissAnimationController.h"

@implementation ShrinkDismissAnimationController

-(NSTimeInterval) transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

-(void) animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    UIView *containerView = [transitionContext containerView];
    
    toViewController.view.alpha = 0.5;
    toViewController.view.frame = finalFrame;
    
    [containerView addSubview:toViewController.view];
    [containerView sendSubviewToBack:toViewController.view];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect shrunkenFrame = CGRectInset(fromViewController.view.frame, fromViewController.view.frame.size.width/4, fromViewController.view.frame.size.height/4);
    
    CGRect fromFinalFram = CGRectOffset(shrunkenFrame, 0, screenBounds.size.height);
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *intermediaView = [fromViewController.view snapshotViewAfterScreenUpdates:NO];
    intermediaView.frame = fromViewController.view.frame;
    
    [containerView addSubview: intermediaView];
    [fromViewController.view removeFromSuperview];
    
    
    [UIView animateKeyframesWithDuration:duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            intermediaView.frame = shrunkenFrame;
            toViewController.view.alpha = 0.5;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            intermediaView.frame = fromFinalFram;
            toViewController.view.alpha = 1.0;
        }];
    } completion:^(BOOL finished) {
        [intermediaView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
    
}

@end
