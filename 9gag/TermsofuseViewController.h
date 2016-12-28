//
//  TermsofuseViewController.h
//  9gag
//
//  Created by Pankaj Sharma on 28/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsofuseViewController : UIViewController<UIWebViewDelegate>
{
    
    IBOutlet GADBannerView *bannerView;
    IBOutlet UIWebView *Obj_WebVW;

}
- (IBAction)backAction:(id)sender;


@end
