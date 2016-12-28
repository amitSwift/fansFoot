//
//  ThirdViewController.h
//  9gag
//
//  Created by Pankaj Sharma on 20/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "proxyService.h"
#import "constant.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface ProfileViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,WebServiceDelegate,UITextFieldDelegate>
{
    NSData *dataImage;
    NSString *encryptedString,*aString;
    UIImage *obj_imagePick;
    IBOutlet UIButton *btn_camera,*editbtn,*btn_picker;
    IBOutlet UIImageView *imageViewCam;
    NSString *str_userID;
    IBOutlet UILabel *post_lbl,*comments_lbl,*points_lbl;
    IBOutlet UIButton *btn_back;
    IBOutlet UITextField *txt_name;
    IBOutlet UITextField *txt_city;
    IBOutlet UITextField *txt_country;
    IBOutlet UITextField *txt_birthday;
    IBOutlet UIView *date_picker_view;
    IBOutlet UIDatePicker *date_picker;
    BOOL profile,editprofile;
    
    IBOutlet GADBannerView *bannerView;
    
    
}
- (IBAction)backaction:(id)sender;
- (IBAction)EditProfileAction:(id)sender;



@end
