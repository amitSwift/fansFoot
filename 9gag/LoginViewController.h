//
//  LoginViewController.h
//  9gag
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proxyService.h"

@interface LoginViewController : UIViewController<WebServiceDelegate>
{
    IBOutlet UITextField *txt_email;
    IBOutlet UITextField *txt_password;
    NSString *FacebookImageString;
    NSString *str_name;
    NSString *FacebookIdString;
    NSString *FacebookEmailString;
    NSString *FacebookFirstName;
    NSString *FacebookLastName;
    NSString *FaceBookUserFullname;
    NSString* FacebookNameString;

    NSString *status;
    BOOL fbOpen;
    NSString *userImageURL;
    NSMutableString *first_name;
    NSMutableString *last_name;
    NSMutableString *email1;
    NSMutableString *facebook_gender;
    NSMutableString *user_id;
    NSMutableString *imageUrl1;
    NSString *str_social_id;
    
    //    NSString *status;
    NSString *location_str;
    
    BOOL fbsession;

    IBOutlet GADBannerView *bannerView;
}
@end
