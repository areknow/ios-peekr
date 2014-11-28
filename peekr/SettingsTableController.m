//
//  SettingsTableController.m
//  peekr
//
//  Created by Arnaud Crowther on 10/29/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import "SettingsTableController.h"
#import "KeychainItemWrapper.h"
#import "ViewController.h"


@interface SettingsTableController ()

@end

@implementation SettingsTableController

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults valueForKey:@"peekrAppDataSwitchSimpleID"] isEqualToString: @"TRUE"]) {
        [switchSimple setOn:YES];
    }
    else if ([[defaults valueForKey:@"peekrAppDataSwitchSimpleID"] isEqualToString: @"FALSE"]) {
        [switchSimple setOn:NO];
    }
    
    textID.text = ID;
    textPW.text = PW;
    
    //adView = [[ADBannerView alloc]initWithFrame:CGRectZero];
    //adView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(enterBGmode)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)enterBGmode
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)doneButton:(id)sender
{
    if (switchReseter.on) {

        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];//erase login info
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"1" forKey:@"BG"];
        
        KeychainItemWrapper * kc = [[KeychainItemWrapper alloc] init];
        [kc resetKeychainItem];
        
        reset = TRUE;//flag reset for front page
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *viewController = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"home"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (!switchReseter.on) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if (![textID.text isEqualToString:@""] && ![textPW.text isEqualToString:@""]) {
            KeychainItemWrapper *keychain =[[KeychainItemWrapper alloc] initWithIdentifier:@"peekrLogin" accessGroup:nil];
            
            [keychain setObject:[textID text] forKey:(__bridge id)kSecAttrAccount];//save username
            [keychain setObject:[textPW text] forKey:(__bridge id)kSecValueData];//save password
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (switchSimple.on) {
        [defaults setValue:@"TRUE" forKey:@"peekrAppDataSwitchSimpleID"];
    }
    else if (!switchSimple.on) {
        [defaults setValue:@"FALSE" forKey:@"peekrAppDataSwitchSimpleID"];
    }
}

//- (IBAction)segUI:(id)sender
//{
//    if (segUI.selectedSegmentIndex == 0) {
//        NSLog(@"light");
//    }
//    if (segUI.selectedSegmentIndex == 1) {
//        NSLog(@"dark");
//        
//    }
//}

#pragma iAd Banner

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    //NSLog(@"bannerview did not receive any banner due to %@", error);
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    //NSLog(@"bannerview was selected");
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{return willLeave;}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    //NSLog(@"banner was loaded");
}
@end
