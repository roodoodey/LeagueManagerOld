//
//  MAXDrawerView.h
//  ReusableComponentsApp
//
//  Created by Mathieu Skulason on 03/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MAXDrawerAnimationDirection) {
    kMAXDrawerLeftAnimation,
    kMAXDrawerRightAnimation
};

typedef NS_ENUM(NSUInteger, MAXDrawerAnimationType) {
    kMAXDrawerAnimationTypeOver,
    kMAXDrawerAnimationTypeMoveView
} ;

@interface MAXDrawerView : UIView

@property (nonatomic, strong) UIView *contentView;
/**
 @description the distance the drawer has to be dragged to be fully opened when released. Takes a value of 0 - 1 where the value is multipled with the animation distance.
 */
@property (nonatomic) float dragOpenDistanceRatio;

-(void)setDrawerAnimationDirection:(MAXDrawerAnimationDirection)theAnimationDirect;
-(void)setDrawerAnimationType:(MAXDrawerAnimationType)theAnimationType;
-(void)setAnimationDistance:(float)theAnimationDistance;
-(void)setAnimationTime:(float)theAnimationTime;

/**
 @description The origin of this view so it can be animated back to its original position when animateOutWithCompletion is called.
 */
-(void)setOriginalRect:(CGRect)theOriginalRect;
/**
 @description The original frame of the superview so that we can animate it back to its original position when the animation type os move view.
 */
-(void)setSuperviewRect:(CGRect)theSuperviewRect;

-(void)animateInWithCompletion:(void (^)(void))completion;
-(void)animateOutWithCompletion:(void (^)(void))completion;

@end
