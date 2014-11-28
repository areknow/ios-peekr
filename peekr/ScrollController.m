//
//  ScrollController.m
//  peekr
//
//  Created by Arnaud Crowther on 10/21/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import "ScrollController.h"

@implementation ScrollController


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void) viewDidLoad
{
    //---set the viewable frame of the scroll view---
    //scrollView.frame = CGRectMake(0, 0, 320, 568);
    
    //---set the content size of the scroll view---
    //[scrollView setContentSize:CGSizeMake(1000, 1000)];
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
