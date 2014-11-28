//
//  AddNewTableController.m
//  peekr
//
//  Created by Arnaud Crowther on 10/28/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import "AddNewTableController.h"
#import "ViewController2.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@interface AddNewTableController ()

@end

@implementation AddNewTableController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(enterBGmode)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    
    aTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(counter:)
                                            userInfo:nil
                                             repeats:YES];
    [buttonSave setEnabled:NO];
    [imgIconBlank setHidden:YES];
    [cellAppearance setHidden:YES];
    
    if (editFlag) {//edit flag is on
        
        self.navigationItem.title = globalAccountsArray[editIndex];
        
        textAddNewAccount.text = globalAccountsArray[editIndex];
        textAddNewUser.text = globalUserArray[editIndex];
        textAddNewPassw.text = globalPasswArray[editIndex];
        
        if ([[globalBoolArray objectAtIndex:editIndex] isEqualToString:@"1"]) {
            [switchHider setOn:YES];
        }
        else if ([[globalBoolArray objectAtIndex:editIndex] isEqualToString:@"0"]) {
            [switchHider setOn:NO];
        }
        if ([[globalIconArray objectAtIndex:editIndex] isEqualToString:@"1"]) {
            [switchIcon setOn:YES];
            
            imgIconBlank.hidden = NO;
            [cellAppearance setHidden:NO];

            int colorVal = [globalColorArray[editIndex] intValue];
            steperColor.value = colorVal;
            
            switch (colorVal) {
                case 0: imgIconBlank.image =  [UIImage imageNamed:@"iconBlank.png"];break;
                case 1: imgIconBlank.image =  [UIImage imageNamed:@"iconRed.png"];break;
                case 2: imgIconBlank.image =  [UIImage imageNamed:@"iconOrange.png"];break;
                case 3: imgIconBlank.image =  [UIImage imageNamed:@"iconYellow.png"];break;
                case 4: imgIconBlank.image =  [UIImage imageNamed:@"iconGreen.png"];break;
                case 5: imgIconBlank.image =  [UIImage imageNamed:@"iconBlue.png"];break;
                case 6: imgIconBlank.image =  [UIImage imageNamed:@"iconPurple.png"];break;
                case 7: imgIconBlank.image =  [UIImage imageNamed:@"iconGray.png"];break;
            }
        }
        else if ([[globalIconArray objectAtIndex:editIndex] isEqualToString:@"0"]) {
            [switchIcon setOn:NO];
            [imgIconBlank setHidden:YES];
        }
//        if (isFiltered) {
//            textAddNewAccount.text = @"isFiltered";
//            isFiltered = FALSE;
//        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [aTimer invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (editFlag) {
        editFlag = FALSE;
    }
}

- (void)counter:(id)sender
{   //enable save if account/user are not blank
    if ([textAddNewAccount.text isEqualToString:@""] || [textAddNewUser.text isEqualToString:@""]) {
        [buttonSave setEnabled:NO];
    }
    else {
        [buttonSave setEnabled:YES];
    }
}

- (IBAction)stepColor:(UIStepper *)sender
{   //action takes place when stepper is touched
    int value = sender.value;
    if (switchIcon.on) {
        switch (value) {
            case 0: imgIconBlank.image =  [UIImage imageNamed:@"iconBlank.png"];break;
            case 1: imgIconBlank.image =  [UIImage imageNamed:@"iconRed.png"];break;
            case 2: imgIconBlank.image =  [UIImage imageNamed:@"iconOrange.png"];break;
            case 3: imgIconBlank.image =  [UIImage imageNamed:@"iconYellow.png"];break;
            case 4: imgIconBlank.image =  [UIImage imageNamed:@"iconGreen.png"];break;
            case 5: imgIconBlank.image =  [UIImage imageNamed:@"iconBlue.png"];break;
            case 6: imgIconBlank.image =  [UIImage imageNamed:@"iconPurple.png"];break;
            case 7: imgIconBlank.image =  [UIImage imageNamed:@"iconGray.png"];break;
        }
    }
}

- (IBAction)switchIconShow:(id)sender
{   //action takes place with show icon switch is hit
    if (switchIcon.on) {//switch is on
        [imgIconBlank setHidden:NO];
        [cellAppearance setHidden:NO];
    }
    else if (!switchIcon.on) {//switch is off
        [imgIconBlank setHidden:YES];
        [cellAppearance setHidden:YES];
    }
}

- (IBAction)SaveBtn:(id)sender
{   //save button actions
    NSString *tempAccStr = textAddNewAccount.text;
    NSString *tempUsnStr = textAddNewUser.text;
    NSString *tempPswStr = textAddNewPassw.text;
    int step = steperColor.value;
    
    if (!editFlag) {//edit flag off
        [globalAccountsArray addObject:tempAccStr];
        [globalUserArray addObject:tempUsnStr];
        [globalPasswArray addObject:tempPswStr];
        
        if (switchHider.on){//hide switch on
            [globalBoolArray addObject:@"1"];
        }
        else if (!switchHider.on){//hide switch off
            [globalBoolArray addObject:@"0"];
        }
        if (switchIcon.on){//icon switch on
            [globalIconArray addObject:@"1"];
            [globalColorArray addObject:[NSString stringWithFormat:@"%d",step]];
        }
        else if (!switchIcon.on){//icon switch off
            [globalIconArray addObject:@"0"];
            [globalColorArray addObject:@"0"];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (editFlag){//edit flag on
        [globalAccountsArray replaceObjectAtIndex:editIndex withObject:tempAccStr];
        [globalUserArray replaceObjectAtIndex:editIndex withObject:tempUsnStr];
        [globalPasswArray replaceObjectAtIndex:editIndex withObject:tempPswStr];

        if (switchHider.on){//hide switch on
            [globalBoolArray replaceObjectAtIndex:editIndex withObject:@"1"];
        }
        else if (!switchHider.on){//hide switch off
            [globalBoolArray replaceObjectAtIndex:editIndex withObject:@"0"];
        }
        if (switchIcon.on){//icon switch on
            [globalIconArray replaceObjectAtIndex:editIndex withObject:@"1"];
            [globalColorArray replaceObjectAtIndex:editIndex withObject:[NSString stringWithFormat:@"%d",step]];
        }
        else if (!switchIcon.on){//icon switch off
            [globalIconArray replaceObjectAtIndex:editIndex withObject:@"0"];
            [globalColorArray replaceObjectAtIndex:editIndex withObject:@"0"];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn: (UITextField *)TheTextField
{   //text field return button
    [textAddNewAccount resignFirstResponder];
    [textAddNewPassw resignFirstResponder];
    [textAddNewUser resignFirstResponder];
    
    if (![textAddNewAccount.text isEqualToString:@""] && ![textAddNewUser.text isEqualToString:@""]){
        [self SaveBtn:(self)];
    }
    return YES;
}

- (void)enterBGmode
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)CancelBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
