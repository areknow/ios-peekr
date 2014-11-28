//
//  SettingsTableController.h
//  peekr
//
//  Created by Arnaud Crowther on 10/29/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface SettingsTableController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ADBannerViewDelegate>
{
    IBOutlet UISwitch *switchSimple;
    IBOutlet UISwitch *switchReseter;
    IBOutlet UITextField *textID;
    IBOutlet UITextField *textPW;
    //IBOutlet UISegmentedControl *segUI;
    //IBOutlet ADBannerView *adView;
    BOOL bannerIsVisible;
}
- (IBAction)doneButton:(id)sender;
//- (IBAction)segUI:(id)sender;

@end
