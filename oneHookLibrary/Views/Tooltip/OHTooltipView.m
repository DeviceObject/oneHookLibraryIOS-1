//
//  TooltipView.m
//  oneHookLibrary
//
//  Created by Eagle Diao on 2015-06-08.
//  Copyright (c) 2015 oneHook inc. All rights reserved.
//

#import "OHTooltipView.h"

@interface OHTooltipView() {
    CALayer* _containerLayer;
    CALayer* _blackLayer;
    CAShapeLayer* _maskLayer;
}

@end

@implementation OHTooltipView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTooltipViewClicked:)]];
    
    /* Create a containing layer and set it contents with an image */
    _containerLayer = [CALayer layer];
    
    /* Create your translucent black layer and set its opacity */
    _blackLayer = [CALayer layer];
    _blackLayer.backgroundColor = [UIColor blackColor].CGColor;
    _blackLayer.opacity = 0.8f;
    
    [_containerLayer addSublayer:_blackLayer];
    
    /* Create a mask layer with a shape layer that has a circle path */
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    [_blackLayer setMask:_maskLayer];
    [self.layer addSublayer:_containerLayer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.frame = self.bounds;
    _containerLayer.frame = self.bounds;
    _blackLayer.frame = self.bounds;
    _maskLayer.frame = self.bounds;
}

- (void)setFocusArea:(CGRect)focusArea
{
    _focusArea = focusArea;
    
    // When you create a path, remember that origin is in upper left hand
    // corner, so you have to treat it as if it has an anchor point of 0.0,
    // 0.0
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:focusArea];
    
    // Append a rectangular path around the mask layer so that
    // we can use the even/odd fill rule to invert the mask
    [path appendPath:[UIBezierPath bezierPathWithRect:self.bounds]];
    
    // Set the path's fill color since layer masks depend on alpha
    [_maskLayer setFillColor:[[UIColor blackColor] CGColor]];
    [_maskLayer setPath:[path CGPath]];
}

- (void)onTooltipViewClicked:(UITapGestureRecognizer*)rec {
    [self animateDismiss];
}

- (void)animateReveal
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.duration = 0.3f;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [_containerLayer addAnimation:animation forKey:@"alphaanimation"];
}

- (void)animateDismiss
{
    [CATransaction begin];
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.duration = 0.3f;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [CATransaction setCompletionBlock:^{
        [self removeFromSuperview];
    }];
    [_containerLayer addAnimation:animation forKey:@"alphaanimation"];
    [CATransaction commit];
}

@end
