//
//  ChangePasswordViewController.h
//  9gag
//
//  Created by Pankaj Sharma on 28/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
{
    
    IBOutlet GADBannerView *bannerView;
    IBOutlet UITextField *txt_email;
}
- (IBAction)BackAction:(id)sender;

@end
