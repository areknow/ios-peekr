//
//  ViewController.m
//  peekr
//
//  Created by Arnaud Crowther on 10/2/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"
#import "SettingsTableController.h"
#import "AMBlurView.h"
#import <QuartzCore/QuartzCore.h>
#import "KeychainItemWrapper.h"

@interface ViewController ()

@property (nonatomic,strong) AMBlurView *blurView;

@end

@implementation ViewController

@synthesize formsView = _formsView;
@synthesize viewBlur = _viewBlur;
@synthesize BG = _BG;

BOOL initTest=FALSE;//initialize the globals
BOOL reset = FALSE;
NSString *ID;
NSString *PW;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"initt"]) {//if init key exists, throw flag
        initTest = TRUE;
    }
    else {//if init key doesnt exist, alert user
        initTest = FALSE;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"Please enter an identifier and a secure password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];//change back text
    barButton.title = @"";
    self.navigationItem.backBarButtonItem = barButton;
    
    CGRect newRect = CGRectMake(_viewBlur.bounds.origin.x,_viewBlur.bounds.origin.y,_viewBlur.bounds.size.height,_viewBlur.bounds.size.width);
    [self setBlurView:[AMBlurView new]];
    [[self blurView] setFrame:newRect];
    [[self blurView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_viewBlur addSubview:[self blurView]];//give blur to blurView
    
    [self.view bringSubviewToFront:formsView];//put text boxes infront
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (!initTest || reset) {
        self.BG.image = [UIImage imageNamed:@"BG1.png"];//no clue why this worked
        [defaults setValue:@"1" forKey:@"BG"];
    }
    
    if (reset){//if reset flag was thrown, alert user
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset" message:@"All application data has been removed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        reset = FALSE;//change back to false or it will keep poping alert
        
        //this is necessary for init and reset
        if (BG.image == [UIImage imageNamed:@"BG1@2x.png"] || BG.image == [UIImage imageNamed:@"BG1.png"])
        {
            [defaults setValue:@"1" forKey:@"BG"];
        }
        else if (BG.image == [UIImage imageNamed:@"BG2@2x.png"] || BG.image == [UIImage imageNamed:@"BG2.png"])
        {
            [defaults setValue:@"2" forKey:@"BG"];
        }
        else if (BG.image == [UIImage imageNamed:@"BG3@2x.png"] || BG.image == [UIImage imageNamed:@"BG3.png"])
        {
            [defaults setValue:@"3" forKey:@"BG"];
        }
    }
    textID.text = @"";//clear text fields
    textPW.text = @"";
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];//hide nav bar
    
    [defaults synchronize];
    
    [self cycleBG];
    
    KeychainItemWrapper *keychain =[[KeychainItemWrapper alloc] initWithIdentifier:@"peekrLogin" accessGroup:nil];
    if ([[defaults valueForKey:@"peekrAppDataSwitchSimpleID"] isEqualToString: @"TRUE"]) {
        textID.secureTextEntry = NO;
        textID.text = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    }
    else if ([[defaults valueForKey:@"peekrAppDataSwitchSimpleID"] isEqualToString: @"FALSE"]) {
        textID.secureTextEntry = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];//show nav bar
}

- (IBAction)enter:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!initTest){//setup hasnt been initialized yet. store ID and PW
        [defaults setValue:@"1" forKey:@"initt"];//create init key
        
        if (![textID.text isEqual: @""] || ![textPW.text isEqual:@""]){//if text fields are not blank save them
            ID = textID.text;
            PW = textPW.text;
            
            KeychainItemWrapper *keychain =[[KeychainItemWrapper alloc] initWithIdentifier:@"peekrLogin" accessGroup:nil];
            
            [keychain setObject:[textID text] forKey:(__bridge id)kSecAttrAccount];//save username
            [keychain setObject:[textPW text] forKey:(__bridge id)kSecValueData];//save password
            
            initTest = TRUE;//setup has been initialized, update bool
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];//push to next view
            ViewController2 *viewController = (ViewController2 *)[storyboard instantiateViewControllerWithIdentifier:@"vc2"];
            [self.navigationController pushViewController:viewController animated:YES];
            
            
            [self moveBlurDown];
            [self bgShrink];
        }
        else {//if they are blank alert user and dont allow push - CHANGE TO MIN LENGTH
            [self shakeDown];
        }
    }
    else if (initTest) {//setup has been initialized, check ID and PW
        ID = textID.text;
        PW = textPW.text;
        
        KeychainItemWrapper *keychain =[[KeychainItemWrapper alloc] initWithIdentifier:@"peekrLogin" accessGroup:nil];
        
        if ([ID isEqualToString: [keychain objectForKey:(__bridge id)kSecAttrAccount]] &&//if both ID and PW match resp. keys, allow push
            [PW isEqualToString: [keychain objectForKey:(__bridge id)kSecValueData]]){
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];//push to next view
            ViewController2 *viewController = (ViewController2 *)[storyboard instantiateViewControllerWithIdentifier:@"vc2"];
            [self.navigationController pushViewController:viewController animated:YES];
                        
            [self moveBlurDown];
            [self bgShrink];
        }
        else{//if ID and PW dont match, dont allow push
            
            textID.text = NULL;
            textPW.text = NULL;
            
            [self shakeDown];
            
            if ([[defaults valueForKey:@"peekrAppDataSwitchSimpleID"] isEqualToString: @"TRUE"]) {
                textID.secureTextEntry = NO;
                textID.text = [keychain objectForKey:(__bridge id)kSecAttrAccount];
            }
        }
    }
    [defaults synchronize];
    
    [textID resignFirstResponder];
    [textPW resignFirstResponder];
}

- (IBAction)closeKeyb:(id)sender
{
    [self moveBlurDown];
    [self bgShrink];
    
    [textID resignFirstResponder];
    [textPW resignFirstResponder];
}

- (BOOL)textFieldShouldReturn: (UITextField *)TheTextField//aka done button on KB
{
    [textID resignFirstResponder];
    [textPW resignFirstResponder];
    
    if(![textID.text isEqual: @""] && ![textPW.text isEqual: @""]){
        [self enter:(ID)];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveBlurUp];
    [self bgGrow];
}

- (void)moveBlurUp
{
    CGRect BLUR = _viewBlur.frame;
    BLUR.origin.x = 17;
    BLUR.origin.y = 40;
    [UIView animateWithDuration:0.35f
                     animations:^{
                         _viewBlur.frame = BLUR;}];
    
    CGRect FORMS = _formsView.frame;
    FORMS.origin.x = 17;
    FORMS.origin.y = 40;
    [UIView animateWithDuration:0.35f
                     animations:^{
                         _formsView.frame = FORMS;}];
}
- (void)moveBlurDown
{
    CGRect BLUR = _viewBlur.frame;
    BLUR.origin.x = 17;
    BLUR.origin.y = 141;
    [UIView animateWithDuration:0.35f delay:0 options:0 animations:^{
        _viewBlur.frame = BLUR;
    } completion:^(BOOL finished){}];
    
    CGRect FORMS = _formsView.frame;
    FORMS.origin.x = 17;
    FORMS.origin.y = 141;
    [UIView animateWithDuration:0.35f delay:0 options:0 animations:^{
        _formsView.frame = FORMS;
    } completion:^(BOOL finished){}];
}

- (void)shakeDown
{
    [self bgShrink];
    
    CGRect BLUR = _viewBlur.frame;
    BLUR.origin.x = 17;
    BLUR.origin.y = 141;
    [UIView animateWithDuration:0.35f delay:0 options:0 animations:^{
        _viewBlur.frame = BLUR;
    } completion:^(BOOL finished){}];
    
    CGRect FORMS = _formsView.frame;
    FORMS.origin.x = 17;
    FORMS.origin.y = 141;
    [UIView animateWithDuration:0.35f delay:0 options:0 animations:^{
        _formsView.frame = FORMS;
    } completion:^(BOOL finished)
    {
        [self formShake];
    }];
}

- (void)bgGrow
{
    CGRect FORMS = _BG.frame;
    FORMS.size.width = 520;
    FORMS.size.height = 680;
    FORMS.origin.x = -100;
    FORMS.origin.y = -56;
    [UIView animateWithDuration:0.35f
                     animations:^{
                         _BG.frame = FORMS;}];
}

- (void)bgShrink
{
    CGRect FORMS = _BG.frame;
    FORMS.size.width = 420;
    FORMS.size.height = 580;
    FORMS.origin.x = -50;
    FORMS.origin.y = -6;
    [UIView animateWithDuration:0.35f
                     animations:^{
                         _BG.frame = FORMS;}];
}

- (void)formShake
{
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:2];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint: CGPointMake(_formsView.center.x - 5,_formsView.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint: CGPointMake(_formsView.center.x + 5, _formsView.center.y)]];
    [_formsView.layer addAnimation:shake forKey:@"position"];
    
    CABasicAnimation *shake2 = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake2 setDuration:0.1];
    [shake2 setRepeatCount:2];
    [shake2 setAutoreverses:YES];
    [shake2 setFromValue:[NSValue valueWithCGPoint: CGPointMake(_viewBlur.center.x - 5,_viewBlur.center.y)]];
    [shake2 setToValue:[NSValue valueWithCGPoint: CGPointMake(_viewBlur.center.x + 5, _viewBlur.center.y)]];
    [_viewBlur.layer addAnimation:shake2 forKey:@"position"];
}

- (void)cycleBG
{
    UIImage *newImage1 = [UIImage imageNamed: @"BG1.png"];
    UIImage *newImage2 = [UIImage imageNamed: @"BG2.png"];
    UIImage *newImage3 = [UIImage imageNamed: @"BG3.png"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults valueForKey:@"BG"] isEqualToString: @"1"])
    {
        [self.BG setImage:newImage2];
        [defaults setValue:@"2" forKey:@"BG"];
    }
    else if ([[defaults valueForKey:@"BG"] isEqualToString: @"2"])
    {
        [self.BG setImage:newImage3];
        [defaults setValue:@"3" forKey:@"BG"];
    }
    else if ([[defaults valueForKey:@"BG"] isEqualToString: @"3"])
    {
        [self.BG setImage: newImage1];
        [defaults setValue:@"1" forKey:@"BG"];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
