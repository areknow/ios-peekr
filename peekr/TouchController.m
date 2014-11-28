//
//  TouchController.m
//  peekr
//
//  Created by Arnaud Crowther on 10/21/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import "TouchController.h"
#import "ViewController.h"

@implementation TouchController


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self];
    CGPoint previousLocation = [aTouch previousLocationInView:self];
    
    int yBound=0;
    if( location.y-previousLocation.y >= 320)
    {
        yBound = 320;
    }
    
    self.frame = CGRectOffset(self.frame, 0, yBound);
    
    //self.viewBlur.frame = CGRectOffset(self.frame, location.x-previousLocation.x, location.y-previousLocation.y);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
