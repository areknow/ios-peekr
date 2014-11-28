//
//  testViewController.h
//  peekr
//
//  Created by Arnaud Crowther on 11/8/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface testViewController : UIViewController <ADBannerViewDelegate>
{
    IBOutlet ADBannerView *adView;
    BOOL bannerIsVisible;
}

@end
