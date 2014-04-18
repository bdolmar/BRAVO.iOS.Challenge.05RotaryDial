//
//  NRDArcView.h
//  RotaryDial
//
//  Created by Ben Dolmar on 4/14/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRDArcView : UIButton

@property (nonatomic, strong) UIColor *arcFillColor;
@property (nonatomic, assign) CGFloat arcWidth;
@property (nonatomic, assign) CGFloat arcOrigin;
@property (nonatomic, assign) CGFloat arcLength;
@property (nonatomic, readonly) CGFloat radius;
@property (nonatomic, readonly) CGPoint arcCenter;

- (instancetype)initWithFrame:(CGRect)frame fillColor:(UIColor *)fillColor arcWidth:(CGFloat)arcWidth;

- (void)setArcOrigin:(CGFloat)arcOrigin animated:(BOOL)animated;

@end
