//
//  NRDDialView.m
//  RotaryDial
//
//  Created by Ben Dolmar on 4/14/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "NRDDialView.h"
#import "NRDArcView.h"

@interface NRDDialView ()

@property (nonatomic, strong) NRDArcView *leftButtonView;
@property (nonatomic, strong) NRDArcView *rightButtonView;
@property (nonatomic, strong) NRDArcView *handleButtonView;

@property (nonatomic, assign) CGFloat currentOrigin;

@end

static const CGFloat circleTickCount = 12;
static const CGFloat circleTickPrecision = .01;

@implementation NRDDialView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentOrigin = -M_PI_2;
        self.currentValue = 0;
        [self createSubviews];
        [self registerUserInteractionHandlers];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.currentOrigin = -M_PI_2;
        self.currentValue = 0;
        [self createSubviews];
        [self registerUserInteractionHandlers];
    }
    return self;
}

- (void)createSubviews
{
    UIColor *lightGrayColor = [UIColor colorWithWhite:.82 alpha:1.0];
    
    self.leftButtonView = [[NRDArcView alloc] initWithFrame:self.bounds fillColor:lightGrayColor arcWidth:44.0];
    self.leftButtonView.arcLength = M_PI;
    [self addSubview:self.leftButtonView];
    
    self.rightButtonView = [[NRDArcView alloc] initWithFrame:self.bounds fillColor:lightGrayColor arcWidth:44.0];
    self.rightButtonView.arcLength = M_PI;
    [self addSubview:self.rightButtonView];
    
    self.handleButtonView = [[NRDArcView alloc] initWithFrame:self.bounds fillColor:[UIColor colorWithWhite:.47 alpha:1.0] arcWidth:44.0];
    CGFloat innerCircumference = 2*M_PI*(self.handleButtonView.radius-44.0);
    self.handleButtonView.arcLength = 44.0/innerCircumference * 2 * M_PI;
    [self addSubview:self.handleButtonView];
}

- (void)registerUserInteractionHandlers
{
    [self.leftButtonView addTarget:self action:@selector(leftButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButtonView addTarget:self action:@selector(rightButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.handleButtonView addGestureRecognizer:panGestureRecognizer];
}

#pragma mark - UIView Lifecycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat dialCenter = [self currentAngleForValue:self.currentValue];
    self.leftButtonView.arcOrigin = dialCenter + M_PI;
    self.rightButtonView.arcOrigin = dialCenter;
    self.handleButtonView.arcOrigin = dialCenter - self.handleButtonView.arcLength*.5;
}

#pragma mark - User Interaction Handlers
- (void)leftButtonTapped
{
    CGFloat currentIncrement = self.currentValue*circleTickCount;
    CGFloat flooredIncrement = floor(currentIncrement);
    BOOL isOnTick = flooredIncrement - circleTickPrecision <= currentIncrement && currentIncrement <= flooredIncrement + circleTickPrecision;
    CGFloat updatedValue = isOnTick ? flooredIncrement - 1 : flooredIncrement;
    
    [self setCurrentValue:updatedValue/12 animated:YES];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)rightButtonTapped
{
    CGFloat currentIncrement = self.currentValue*circleTickCount;
    CGFloat flooredIncrement = ceil(currentIncrement);
    BOOL isOnTick = flooredIncrement - circleTickPrecision <= currentIncrement && currentIncrement <= flooredIncrement + circleTickPrecision;
    CGFloat updatedValue = isOnTick ? flooredIncrement + 1 : flooredIncrement;
    
    [self setCurrentValue:updatedValue/12 animated:YES];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)handlePanGesture:(UIGestureRecognizer *)gestureRecognizer
{
    
    CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer locationInView:self.handleButtonView];
    translation = CGPointMake(translation.x - self.handleButtonView.arcCenter.x, translation.y - self.handleButtonView.arcCenter.y);
    CGFloat currentAngle = atan2(translation.y, translation.x);
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat updatedValue = [self currentValueForAngle:currentAngle];
        [self setCurrentValue:updatedValue animated:NO];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Value Transformers

- (CGFloat)currentValueForAngle:(CGFloat)angle
{
    CGFloat normalizedAngle = angle - self.currentOrigin;
    if (normalizedAngle < 0) {
        normalizedAngle += 2*M_PI;
    }else if(normalizedAngle > 2*M_PI){
        normalizedAngle -= 2*M_PI;
    }
    return (normalizedAngle/(M_PI*2));
}

- (CGFloat)currentAngleForValue:(CGFloat)value
{
    return self.currentOrigin + value*M_PI*2;
}


#pragma mark - Accessor Overrides

- (void)setCurrentOrigin:(CGFloat)currentOrigin
{
    _currentOrigin = currentOrigin;
    [self setNeedsLayout];
}

- (void)setCurrentValue:(CGFloat)currentValue
{
    CGFloat normalizedValue = floor(currentValue);
    _currentValue = currentValue - normalizedValue;
    [self setNeedsLayout];
}

- (void)setCurrentValue:(CGFloat)currentValue animated:(BOOL)animated
{
    if (!animated) {
        self.currentValue = currentValue;
        return;
    }
    
    [UIView animateWithDuration:0.33
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         self.currentValue = currentValue;
                     }
                     completion:NULL];
}

@end
