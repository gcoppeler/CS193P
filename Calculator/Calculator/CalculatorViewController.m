//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Gary Coppeler on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:self.display.text];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
     self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)decimalPressed:(UIButton *)sender
{
    if ([self.display.text rangeOfString:@"."].location == NSNotFound)
        [self digitPressed:sender];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:operation];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:@" "];
}

- (IBAction)clearPressed
{
    self.display.text = [NSString stringWithFormat:@""];
    self.historyDisplay.text = [NSString stringWithFormat:@""];
    [self.brain clearOperandStack];
}

@end
