//
//  UIColor+UIColor_RotaryDial.m
//  RotaryDial
//
//  Created by Ben Dolmar on 4/14/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "UIColor+RotaryDial.h"

@implementation UIColor (RotaryDial)

- (UIColor *)colorWithBrightness:(CGFloat)brightness
{
    CGFloat currentHue;
    CGFloat currentSaturation;
    CGFloat currentBrightness;
    CGFloat currentAlpha;
    BOOL success = [self getHue:&currentHue saturation:&currentSaturation brightness:&currentBrightness alpha:&currentAlpha];
    if (success) {
        return [UIColor colorWithHue:currentHue saturation:currentSaturation brightness:brightness alpha:currentAlpha];
    }
    
    CGFloat whiteComponent;
    CGFloat alphaComponent;
    success = [self getWhite:&whiteComponent alpha:&alphaComponent];
    if (success) {
        return [UIColor colorWithWhite:brightness alpha:alphaComponent];
    }
    
    return self;
}

@end
