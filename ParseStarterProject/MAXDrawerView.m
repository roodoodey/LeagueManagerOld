//
//  MAXDrawerView.m
//  ReusableComponentsApp
//
//  Created by Mathieu Skulason on 03/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXDrawerView.h"

@interface MAXDrawerView () <UIGestureRecognizerDelegate> {
    
    CGRect _originalRect;
    CGRect *_superViewRect;
    
    MAXDrawerAnimationDirection _animationDirection;
    MAXDrawerAnimationType _animationType;
    
    float _animationTime;
    float _animationDistance;
    
    CGPoint _gestureLastPoint;
}

@property (nonatomic, strong) UIView *propertyRecognizerView;

@end

@implementation MAXDrawerView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self p_commonDrawerViewSetupWithFrame:frame];
        
    }
    
    return self;
}

-(id)init {
    if (self = [super initWithFrame:CGRectZero]) {
        
        [self p_commonDrawerViewSetupWithFrame:CGRectZero];
        
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        [self p_commonDrawerViewSetupWithFrame:CGRectZero];
        
    }
    
    return self;
}

-(void)p_commonDrawerViewSetupWithFrame:(CGRect)theFrame {
    
    _animationDirection = kMAXDrawerRightAnimation;
    _animationType = kMAXDrawerAnimationTypeOver;
    
    _originalRect = theFrame;
    _superViewRect = nil;
    
    _animationTime = 0.2;
    _dragOpenDistanceRatio = 0.5;
    if (theFrame.size.width == 0 && theFrame.size.height == 0) {
        _animationDistance = 100;
    }
    // need this for some reason to capture the gesture recognizer?
    self.propertyRecognizerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(theFrame), CGRectGetHeight(theFrame))];
    [self addSubview:self.propertyRecognizerView];
    
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(theFrame), CGRectGetHeight(theFrame))];
    [self addSubview:self.contentView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_moveWithGestureRecognizer:)];
    [self addGestureRecognizer:panGesture];
    
}


#pragma mark - Setters

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.propertyRecognizerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

-(void)setDrawerAnimationDirection:(MAXDrawerAnimationDirection)theAnimationDirect {
    _animationDirection = theAnimationDirect;
}

-(void)setDrawerAnimationType:(MAXDrawerAnimationType)theAnimationType {
    _animationType = theAnimationType;
}

-(void)setAnimationDistance:(float)theAnimationDistance {
    _animationDistance = theAnimationDistance;
}

-(void)setAnimationTime:(float)theAnimationTime {
    _animationTime = theAnimationTime;
}

-(void)setOriginalRect:(CGRect)theOriginalRect {
    _originalRect = theOriginalRect;
    _animationDistance = CGRectGetWidth(self.frame);
}

-(void)setSuperviewRect:(CGRect)theSuperviewRect {
    
    if (_superViewRect == nil) {
        _superViewRect = malloc(sizeof(CGRect));
    }
    
    *_superViewRect = theSuperviewRect;
}


-(void)animateInWithCompletion:(void (^)(void))completion {
    [completion copy];
    
    [self p_bringToFront];
    
    [UIView  animateWithDuration:_animationTime animations:^{
        
        if (_animationType == kMAXDrawerAnimationTypeOver) {
            if (_animationDirection == kMAXDrawerLeftAnimation) {
                self.frame = CGRectMake(_originalRect.origin.x - _animationDistance, _originalRect.origin.y, _originalRect.size.width, _originalRect.size.height);
            }
            else {
                self.frame = CGRectMake(_originalRect.origin.x + _animationDistance, _originalRect.origin.y, _originalRect.size.width, _originalRect.size.height);
            }
        }
        else if(_animationType == kMAXDrawerAnimationTypeMoveView) {
            
            if (self.superview != nil && _superViewRect == nil) {
                _superViewRect = malloc(sizeof(CGRect));
                *_superViewRect = self.superview.frame;
            }
            
            CGRect theSuperViewRect;
            
            if (_superViewRect != nil) {
                theSuperViewRect = *_superViewRect;
            }
            
            if (_animationDirection == kMAXDrawerLeftAnimation && self.superview != nil) {
                
                self.superview.frame = CGRectMake(theSuperViewRect.origin.x - _animationDistance , theSuperViewRect.origin.y, theSuperViewRect.size.width, theSuperViewRect.size.height);
                
            } else if (_animationDirection == kMAXDrawerRightAnimation && self.superview != nil) {
                
                self.superview.frame = CGRectMake(theSuperViewRect.origin.x + _animationDistance , theSuperViewRect.origin.y, theSuperViewRect.size.width, theSuperViewRect.size.height);
                
            }
        }
        
    } completion:^(BOOL isFinished) {
        
        if (isFinished == YES && completion != nil) {
            completion();
        }
        
    }];
    
}

-(void)animateOutWithCompletion:(void (^)(void))completion {
    [completion copy];
    
    [UIView animateWithDuration:_animationTime animations:^{
        
        if (_animationType == kMAXDrawerAnimationTypeOver) {
            self.frame = _originalRect;
        }
        else if(_animationType == kMAXDrawerAnimationTypeMoveView) {
            
            if (_superViewRect != nil) {
                self.superview.frame = *_superViewRect;
            }
            
        }
        
        
    } completion:^(BOOL isFinished) {
        
        if (isFinished == YES && completion != nil) {
            completion();
        }
        
    }];
    
}



#pragma mark - Private helpers and overridden methods

-(void)p_moveWithGestureRecognizer:(UIPanGestureRecognizer *)theGestureRecognizer {
    
    if (theGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _gestureLastPoint = [theGestureRecognizer locationInView:self.superview];
    }
    
    if (theGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint touchLocation = [theGestureRecognizer locationInView:self.superview];
        CGPoint diff = CGPointMake(_gestureLastPoint.x - touchLocation.x, _gestureLastPoint.y - touchLocation.y);
        self.center = CGPointMake(self.center.x - diff.x, self.center.y);
        
        _gestureLastPoint = touchLocation;
    }
    
    if (theGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        float distBetweenOriginAndCurrentPosition = sqrt(pow(self.frame.origin.x - _originalRect.origin.x, 2));
        
        if (distBetweenOriginAndCurrentPosition > _animationDistance * _dragOpenDistanceRatio ) {
            [self animateInWithCompletion:nil];
        }
        else {
            [self animateOutWithCompletion:nil];
        }
    }
    
}

/**
 @description: This method was defined so that objects outside the views frame could be tapped
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                return result;
            }
        }
    }
    
    return nil;
}

-(void)p_bringToFront {
    if (self.superview != nil) {
        [self.superview bringSubviewToFront:self];
    }
}
@end
