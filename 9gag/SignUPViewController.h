//
//  SignUPViewController.h
//  9gag
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "proxyService.h"
@import GoogleMobileAds;


@interface SignUPViewController : UIViewController<WebServiceDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    IBOutlet UITextField *txt_firstName;
    IBOutlet UITextField *txt_emailAdd;
    IBOutlet UITextField *txt_pass;
    IBOutlet UITextField *txt_confirmpassword;
    IBOutlet UIButton *btn_Camera;
    IBOutlet UIImageView *imageViewProfile;
    UIImage *obj_imagePick;
    NSData *dataImage;
    NSString *encryptedString;
    NSString *FacebookImageString;
    NSString *str_name;
    NSString *FacebookIdString;
    NSString *FacebookEmailString;
    NSString *FacebookFirstName;
    NSString *FacebookLastName;
    NSString *FaceBookUserFullname;
    NSString* FacebookNameString;

    
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
//    NSString *str_name;
    NSString *location_str;
    
    BOOL fbsession;
    
    IBOutlet GADBannerView *bannerView;
}
- (IBAction)termsofuseAction:(id)sender;
- (IBAction)PrivacyPolicyAction:(id)sender;
- (IBAction)BackAction:(id)sender;

@end
