//
//  AddNewTableController.h
//  peekr
//
//  Created by Arnaud Crowther on 10/28/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UITableView.h>
#import <UIKit/UIKitDefines.h>

@interface AddNewTableController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSTimer *aTimer;

    IBOutlet UITextField *textAddNewAccount;
    IBOutlet UITextField *textAddNewUser;
    IBOutlet UITextField *textAddNewPassw;
    IBOutlet UISwitch *switchHider;
    IBOutlet UIBarButtonItem *buttonSave;
    IBOutlet UISwitch *switchIcon;
    IBOutlet UIImageView *imgIconBlank;
    IBOutlet UIStepper *steperColor;
    IBOutlet UITableViewCell *cellAppearance;
}
- (IBAction)stepColor:(id)sender;
- (IBAction)switchIconShow:(id)sender;

- (id)initWithStyle:(UITableViewStyle)style;

- (IBAction)CancelBtn:(id)sender;
- (IBAction)SaveBtn:(id)sender;




@end
