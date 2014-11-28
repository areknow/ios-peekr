//
//  TextController.m
//  peekr
//
//  Created by Arnaud Crowther on 10/15/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import "TextController.h"

@implementation TextController


- (CGRect)textRectForBounds:(CGRect)bounds
{//set the rectangle bounds for non edit text
    int margin = 13;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}
- (CGRect)editingRectForBounds:(CGRect)bounds
{//set the rectangle bounds for edit text
    int margin = 13;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}
- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{//set margin for clear button
    int margin = 245;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (BOOL)becomeFirstResponder
{//open textbox gets blue glow
    BOOL outcome = [super becomeFirstResponder];
    if (outcome){
        self.background = [UIImage imageNamed:@"tbFocus60.png"];
        //self.alpha = 0.5;
        
    }
    return outcome;
}
- (BOOL)resignFirstResponder
{//closed textbox gets regular image
    BOOL outcome = [super resignFirstResponder];
    if (outcome){
        self.background = [UIImage imageNamed:@"tbFocus.png"];
        //self.alpha = 1;
    }
    return outcome;
}

@end
