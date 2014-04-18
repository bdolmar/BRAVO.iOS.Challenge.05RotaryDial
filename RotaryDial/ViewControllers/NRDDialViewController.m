//
//  NRDDialViewController.m
//  RotaryDial
//
//  Created by Ben Dolmar on 4/14/14.
//  Copyright (c) 2014 The Nerdery. All rights reserved.
//

#import "NRDDialViewController.h"
#import "NRDDialView.h"

@interface NRDDialViewController ()

@property (nonatomic, strong) IBOutlet UILabel *valueLabel;
@property (nonatomic, strong) IBOutlet NRDDialView *dialView;
@property (nonatomic, strong) NSNumberFormatter *labelNumberFormatter;

@end

static const CGFloat minimumDisplayValue = 1;
static const CGFloat maximumDisplayValue = 100;

@implementation NRDDialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.labelNumberFormatter = [[NSNumberFormatter alloc] init];
        self.labelNumberFormatter.roundingMode = NSNumberFormatterRoundFloor;
        self.labelNumberFormatter.groupingSize = 3;
        self.labelNumberFormatter.usesGroupingSeparator = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat currentValue = self.dialView.currentValue*maximumDisplayValue + minimumDisplayValue;
    self.valueLabel.text = [self.labelNumberFormatter stringFromNumber:@(currentValue)];
}

- (IBAction)dialValueDidChange:(id)sender
{
    CGFloat currentValue = self.dialView.currentValue*maximumDisplayValue + minimumDisplayValue;
    self.valueLabel.text = [self.labelNumberFormatter stringFromNumber:@(currentValue)];
}

@end
