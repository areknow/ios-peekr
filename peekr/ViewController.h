//
//  ViewController.h
//  peekr
//
//  Created by Arnaud Crowther on 10/2/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMBlurView.h"

//create globals
extern BOOL initTest;
extern BOOL reset;
extern NSString *ID;
extern NSString *PW;

@interface ViewController : UIViewController
{
    IBOutlet UITextField *textID;
    IBOutlet UITextField *textPW;
    IBOutlet UIView *formsView;
    IBOutlet UIView *viewBlur;
    IBOutlet UIImageView *BG;
}

@property (nonatomic,retain) IBOutlet UIImageView *BG;
@property (nonatomic,retain)
    UIView *viewBlur;
@property (nonatomic,retain)
UIView *formsView;

- (IBAction)closeKeyb:(id)sender;
- (IBAction)enter:(id)sender;


@end
