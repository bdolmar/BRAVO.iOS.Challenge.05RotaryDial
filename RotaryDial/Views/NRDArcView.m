//
//  NRDArcView.m
//  RotaryDial
//
//  Created by Ben Dolmar on 4/14/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "NRDArcView.h"
#import "UIColor+RotaryDial.h"

@interface NRDArcView () {
    CGFloat _radius;
    CGPoint _arcCenter;
}

@property (nonatomic, strong) CAShapeLayer *arcMask;

@property (nonatomic, assign) BOOL invalidRadius;
@property (nonatomic, assign)BOOL invalidCenter;

@property (nonatomic, readonly) CGAffineTransform arcMaskTransform;

@end

@implementation NRDArcView

- (instancetype)initWithFrame:(CGRect)frame fillColor:(UIColor *)fillColor arcWidth:(CGFloat)arcWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
        self.arcFillColor = fillColor;
        self.arcWidth = arcWidth;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame fillColor:[UIColor greenColor] arcWidth:44.0];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self  = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (void)commonInitialization
{
    self.invalidRadius = YES;
    self.invalidCenter = YES;

    self.arcFillColor = [UIColor greenColor];
    self.arcWidth = 44.0;
    self.arcLength = M_PI;
    self.arcOrigin = 1.5*M_PI;
    
    self.arcMask = [[CAShapeLayer alloc] init];
    self.arcMask.fillColor = [[UIColor redColor] CGColor];
    self.arcMask.lineWidth = 1.0;
    self.arcMask.strokeColor = [[UIColor redColor] CGColor];
    self.arcMask.affineTransform = self.arcMaskTransform;
    self.layer.mask  = self.arcMask;
}

#pragma mark - View Lifecycle

- (void)drawRect:(CGRect)rect
{
    [self setBackgroundImage:[self renderArcWithColor:self.arcFillColor] forState:UIControlStateNormal];
    UIColor *darkColor = [self.arcFillColor colorWithBrightness:0.15];
    [self setBackgroundImage:[self renderArcWithColor:darkColor] forState:UIControlStateHighlighted];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIBezierPath *maskPath = [[UIBezierPath alloc] init];
    [maskPath moveToPoint:CGPointMake(0, 0)];
    [maskPath addLineToPoint:CGPointMake(self.radius, 0)];
    [maskPath addArcWithCenter:CGPointZero radius:self.radius startAngle:0 endAngle:self.arcLength clockwise:YES];
    [maskPath closePath];
    self.arcMask.path = [maskPath CGPath];
}

#pragma mark - Hit Test Handling

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL pointInside = [super pointInside:point withEvent:event];
    if (pointInside) {
        CGFloat distanceFromCenter = sqrt(pow((point.x - self.arcCenter.x), 2.0) + pow((point.y - self.arcCenter.y), 2.0));
        pointInside = distanceFromCenter < self.radius && distanceFromCenter > self.radius - self.arcWidth;
        
        if (pointInside) {
            CGFloat minimumAngle = self.arcOrigin;
            CGFloat maximumAngle = self.arcOrigin + self.arcLength;
            CGFloat angleFromCenter = atan2(point.y - self.arcCenter.y, point.x - self.arcCenter.x);
            if (angleFromCenter < minimumAngle) {
                angleFromCenter += 2*M_PI;
            }

            pointInside = minimumAngle <= angleFromCenter && angleFromCenter <= maximumAngle;
        }
    }
    
    return pointInside;
}

#pragma mark - Geometry and Rendering Logic

- (UIImage *)renderArcWithColor:(UIColor *)color
{
    CGRect backgroundRect = [self backgroundRectForBounds:self.bounds];
    UIGraphicsBeginImageContextWithOptions(backgroundRect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextAddArc(ctx, self.radius, self.radius, self.radius, 0, M_PI * 2, YES);
    CGContextAddArc(ctx, self.radius, self.radius, self.radius-self.arcWidth, 0, M_PI * 2, NO);
    CGContextFillPath(ctx);

    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return renderedImage;
}

- (CGRect)backgroundRectForBounds:(CGRect)bounds
{
    CGSize backgroundSize = CGSizeMake(self.radius*2, self.radius*2);
    CGFloat xOrigin = .5*(self.bounds.size.width - backgroundSize.width);
    CGFloat yOrigin = .5*(self.bounds.size.height - backgroundSize.height);
    CGRect backgroundRect = (CGRect){
        .origin = {.x = xOrigin, .y = yOrigin},
        .size = backgroundSize
    };
    return CGRectIntegral(backgroundRect);
}

- (CGFloat)radius
{
    if (self.invalidRadius) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat limitingAxis = width < height ? width : height;
        _radius = limitingAxis*.5;
        self.invalidRadius = NO;
    }
    return _radius;
}

- (CGPoint)arcCenter
{
    if (self.invalidCenter) {
        _arcCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        self.invalidCenter = NO;
    }
    return _arcCenter;
}

- (CGAffineTransform)arcMaskTransform
{
    CGAffineTransform arcOriginTransform = CGAffineTransformMakeTranslation(self.arcCenter.x, self.arcCenter.y);
    arcOriginTransform = CGAffineTransformRotate(arcOriginTransform, self.arcOrigin);
    return arcOriginTransform;
}

#pragma mark - arcProperty Overrides

- (void)setArcOrigin:(CGFloat)arcOrigin
{
    _arcOrigin = arcOrigin;
    self.arcMask.affineTransform = self.arcMaskTransform;
}

- (void)setArcOrigin:(CGFloat)arcOrigin animated:(BOOL)animated
{
    if (!animated) {
        self.arcOrigin = arcOrigin;
        return;
    }
    [UIView animateWithDuration:0.33
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.arcOrigin = arcOrigin;
                     }
                     completion:NULL];
    
}

- (void)setArcLength:(CGFloat)arcLength
{
    _arcLength = arcLength;
    [self setNeedsLayout];
}


@end
