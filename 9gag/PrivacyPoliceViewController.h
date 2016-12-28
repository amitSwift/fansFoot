//
//  PrivacyPoliceViewController.h
//  9gag
//
//  Created by Pankaj Sharma on 28/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyPoliceViewController : UIViewController<UIWebViewDelegate>
{
    
    IBOutlet UIWebView *Obj_WebVW;
    IBOutlet GADBannerView *bannerView;
    
}
- (IBAction)BackAction:(id)sender;


@end
