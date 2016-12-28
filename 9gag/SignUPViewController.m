//
//  SignUPViewController.m
//  9gag
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "SignUPViewController.h"
#import "proxyService.h"
//#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "AppManager.h"
#import "HeaderFile.h"
#import "TermsofuseViewController.h"
#import "PrivacyPoliceViewController.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SignUPViewController ()

@property (strong, nonatomic) IBOutlet UITextView *AddTextView;
@end

@implementation SignUPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAddress];
    bannerView.adUnitID = @"ca-app-pub-2063088545096347/2934377089";
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];
    // Do any additional setup after loading the view.
}




-(void)loadAddress
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       @{
                                         }];
    
    
    [[AppManager sharedManager] getDataForUrl:@"http://fansfoot.com/mobile/web/?type=advertisment"
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, NSMutableDictionary * responseObject)
     {
         // Get response from server
         NSLog(@"JSON: %@", responseObject);
         if ([responseObject count]>0)
         {
             _AddTextView.text=[[[responseObject valueForKey:@"advertisements"] objectAtIndex:0]valueForKey:@"code "];
             NSLog(@"%@",[[[responseObject valueForKey:@"advertisements"] objectAtIndex:0]valueForKey:@"description "]);
         }
         else
         {
             alert(@"Alert", @"Null Data.");
             [[AppManager sharedManager]hideHUD];
         }
     }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [[AppManager sharedManager]hideHUD];
     }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    UIView *paddingVw_fstName = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_emailAdd.leftView = paddingVw_fstName;
    txt_emailAdd.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingVw_fstName1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_confirmpassword.leftView = paddingVw_fstName1;
    txt_confirmpassword.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingVw_fstName2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_firstName.leftView = paddingVw_fstName2;
    txt_firstName.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingVw_fstName3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_pass.leftView = paddingVw_fstName3;
    txt_pass.leftViewMode = UITextFieldViewModeAlways;
    
    [proxyService sharedProxy].delegate = self;

}


#pragma mark - TextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    
    if(textField==txt_firstName)
    {
        [self moveUP:txt_firstName];
    }
    else if(textField==txt_emailAdd)
    {
        [self moveUP:txt_emailAdd];
    }
    else if(textField==txt_pass)
    {
        [self moveUP:txt_pass];
    }
    else if(textField==txt_confirmpassword)
    {
        [self moveUP:txt_confirmpassword];
    }
    [UIView commitAnimations];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_firstName)
    {
        [txt_emailAdd  becomeFirstResponder];
    }
    else if (textField == txt_emailAdd)
    {
        [txt_pass becomeFirstResponder];
    }
    else if (textField == txt_pass)
    {
        [txt_confirmpassword becomeFirstResponder];
    }
    else if (textField == txt_confirmpassword)
    {
        [txt_confirmpassword resignFirstResponder];
       
        [self movedown];
    }
    
    return YES;
}

#pragma mark  View Animation
-(void)moveUP:(UITextField *)textField
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    if(IS_IPHONE_5)
    {
        if(textField==txt_firstName)
        {
            self.view.frame=CGRectMake(0, -50, 320, self.view.frame.size.height);
        }
        else if(textField==txt_emailAdd)
        {
            self.view.frame=CGRectMake(0, -70, 320, self.view.frame.size.height);
        }
        else if(textField==txt_pass)
        {
            self.view.frame=CGRectMake(0, -90, 320, self.view.frame.size.height);
        }
        else if(textField==txt_confirmpassword)
        {
            self.view.frame=CGRectMake(0, -110, 320, self.view.frame.size.height);
        }
            }
    
    else if (IS_IPHONE_6)
    {
        if(textField==txt_firstName)
        {
            self.view.frame=CGRectMake(0, -50, 375, self.view.frame.size.height);
        }
        else if(textField==txt_emailAdd)
        {
            self.view.frame=CGRectMake(0, -70, 375, self.view.frame.size.height);
        }
        else if(textField==txt_pass)
        {
            self.view.frame=CGRectMake(0, -90, 375, self.view.frame.size.height);
        }
        else if(textField==txt_confirmpassword)
        {
            self.view.frame=CGRectMake(0, -110, 375, self.view.frame.size.height);
        }
        
    }
    else if (IS_IPHONE_6_PLUS)
    {
        if(textField==txt_firstName)
        {
            self.view.frame=CGRectMake(0, -50, 414, self.view.frame.size.height);
        }
        else if(textField==txt_emailAdd)
        {
            self.view.frame=CGRectMake(0, -70, 414, self.view.frame.size.height);
        }
        else if(textField==txt_pass)
        {
            self.view.frame=CGRectMake(0, -90, 414, self.view.frame.size.height);
        }
        else if(textField==txt_confirmpassword)
        {
            self.view.frame=CGRectMake(0, -110, 414, self.view.frame.size.height);
        }
           }
    
    [UIView commitAnimations];
}

-(void)movedown
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    
    if(IS_IPHONE_5)
    {
        self.view.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
    }
    else if (IS_IPHONE_6)
    {
        self.view.frame=CGRectMake(0, 0, 375, self.view.frame.size.height);
    }
    else if (IS_IPHONE_6_PLUS)
    {
        self.view.frame=CGRectMake(0, 0, 414, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_firstName resignFirstResponder];
    [txt_emailAdd resignFirstResponder];
    [txt_pass resignFirstResponder];
    [txt_confirmpassword resignFirstResponder];
    [self movedown];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



#pragma mark --Action Method--
- (IBAction)TappedOnCamera:(id)sender
{
    UIActionSheet *obj_ActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", nil),NSLocalizedString(@"Photo album", nil), nil];
    [obj_ActionSheet showInView:self.view];
}

#pragma mark  ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController *obj_ImagePicker=[[UIImagePickerController alloc]init];
                obj_ImagePicker.delegate=self;
                obj_ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                obj_ImagePicker.editing=NO;
                obj_ImagePicker.videoQuality=UIImagePickerControllerQualityTypeHigh;
                [self.navigationController presentViewController:obj_ImagePicker animated:YES completion:nil];
            }
            else
            {
//                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
                alert(@"Message", @"Device has no camera");
                
//                [myAlertView show];
            }
        }
            
            break;
        case 1:
        {
            UIImagePickerController *obj_ImagePicker=[[UIImagePickerController alloc]init];
            obj_ImagePicker.delegate=self;
            obj_ImagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            obj_ImagePicker.editing=YES;
            [self.navigationController presentViewController:obj_ImagePicker animated:YES completion:nil];
        }
            
            break;
        default:
            break;
    }
}


#pragma mark  UIImagePickerController Delegates

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info

{
    dataImage = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"],.1);
    //   _profilephoto.image = [[UIImage alloc] initWithData:dataImage];
    
    encryptedString = [dataImage base64EncodedStringWithOptions:0];
    //encryptedString=[NSString stringWithFormat:@"%@",[dataImage base64Encoding]];
    obj_imagePick=[info valueForKey:UIImagePickerControllerOriginalImage];
    CGSize imageSize;
    if(obj_imagePick.size.height>900 && obj_imagePick.size.width>700)
    {
        imageSize = CGSizeMake(500,500);
    }
    else if(obj_imagePick.size.height>960)
    {
        imageSize = CGSizeMake(500,500);
    }
    else if(obj_imagePick.size.width>640)
    {
        imageSize = CGSizeMake(500,500);
    }
    else
    {
        imageSize=CGSizeMake(400,400);
    }
    UIGraphicsBeginImageContext(imageSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.width);
    [obj_imagePick drawInRect:imageRect];
    obj_imagePick = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageViewProfile.image=obj_imagePick;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)TappedONFacebook:(id)sender
{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
         NSLog(@"----%@",result);
         
         if (error)
         {
             // Error
             
         }
         else if (result.isCancelled)
         {
             // Cancelled
         }
         else
         {
             if ([result.grantedPermissions containsObject:@"email"])
             {
                 [self getFBResult];
             }
         }
     }];

   }
-(void)getFBResult
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, picture.type(large), email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"fb user info : %@",result);
                 
                 NSMutableDictionary *pictureURL = [NSMutableDictionary new];
                 pictureURL = [result objectForKey:@"picture"];
                 FacebookImageString = [NSString stringWithFormat:@"%@",[[pictureURL valueForKey:@"data"] valueForKey:@"url"]];
                 FacebookNameString = [NSString stringWithFormat:@"%@",[result objectForKey:@"name"]];
                 FacebookIdString = [NSString stringWithFormat:@"%@",[result objectForKey:@"id"]];
                 FacebookEmailString = [NSString stringWithFormat:@"%@",[result objectForKey:@"email"]];
                 NSArray *NameArray= [FacebookNameString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                 FacebookFirstName = [NSString stringWithFormat:@"%@",[NameArray objectAtIndex:0]];
                 FacebookLastName=[NSString stringWithFormat:@"%@",[NameArray objectAtIndex:1]];
                 
                 
                 
                 [self webServiceFacebookLogin];
                 
                 [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FacebookLogin"];
                 
             }
             else
             {
                 NSLog(@"error : %@",error);
             }
         }];
    }
    
}

-(void)webServiceFacebookLogin
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"type" :@"sign_up",
                                         @"register_type" :@"facebook",
                                         @"facebook_id" :FacebookIdString,
                                         @"username" :FacebookNameString,
                                         @"email" :FacebookEmailString,
                                         @"profilepicture" :FacebookImageString,
                                         @"device_token" :[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"],
                                         @"device_type" :@"ios"
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    
    [[AppManager sharedManager] getDataForUrl:BASE_URL
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         // Get response from server
         
         NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             
             if ([[responseObject valueForKey:@"type"]isEqualToString:@"login_facebook"])
             {
                 
                 NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
                 
                 if(Status ==1)
                 {
                     
//                     alert(@"Alert", @"You are login successfully.");
                     
                   [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"user_id"] forKey:@"USERID"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     
                         AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
                         app_in_login.window.rootViewController=tabbar_controller;
                     
                     [[AppManager sharedManager]hideHUD];
                     
                     return;
                     
                 }
                 
                 else if (Status ==0)
                     
                 {
                     alert(@"Alert", @"Invalid Password.");
                     
                     [[AppManager sharedManager]hideHUD];
                     
                     return;
                 }
                 
             }
             
         }
     }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"Error: %@", @"No Internet connection");
         
         // [appdelRef hideProgress];
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Error", @"No internet connection.");
         
     }];
    
    
}


- (IBAction)TappedOnRegister:(id)sender
{
    [proxyService sharedProxy].delegate = self;
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        
    if (isStringEmpty([NSString stringWithFormat:@"%@",txt_firstName.text]))
    {
        txt_firstName.text=nil;
        alert(@"Message", @"Please Enter Your Name.");
        [txt_firstName becomeFirstResponder];
    }
    else if (isStringEmpty([NSString stringWithFormat:@"%@",txt_emailAdd.text]))
    {
        alert(@"Message", @"Please Enter Email Address.");
        [txt_emailAdd becomeFirstResponder];
    }
    else if ([emailTest evaluateWithObject:txt_emailAdd.text] == NO)
    {
        alert(@"Message", @"Please Enter Valid Email Address.");
        [txt_emailAdd becomeFirstResponder];
    }
    else if (txt_pass.text.length==0){
    
        alert(@"Message", @"Please Enter Password.");
        [txt_pass becomeFirstResponder];
        
    }
    else if (txt_confirmpassword.text.length==0){
        alert(@"Message", @"Please Enter Confirm Password.");
        [txt_confirmpassword becomeFirstResponder];
    }
    
    else if (![txt_pass.text isEqualToString:txt_confirmpassword.text])
    {
        alert(@"Oops!", @"Password don't match\nPlease try again.");
        [txt_confirmpassword becomeFirstResponder];
    }
    else
    {
        BOOL checkNet = [[proxyService sharedProxy] checkReachability];
        if(checkNet == TRUE)
        {
            [self webServiceSignUP];
        }
        else
        {
            alert(@"Message", @"No Internet connection");
        }
    }
    
    
}

-(void)webServiceSignUP
{
    //type=sign_up&username=ankur&email=ankur@gmail.com&password=123456
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"type" :@"sign_up",
                                         @"register_type" :@"manual",
                                         @"username" :txt_firstName.text,
                                         @"email" :txt_emailAdd.text,
                                         @"password" :txt_pass.text,
                                         @"device_token" :[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"],
                                         @"device_type" :@"ios"
                                         
                                         }];
   // http://quenelle.fansfoot.com/web/?type=sign_up&register_type=fascebook&facebook_id=1234&username=ankur&email=san@gmail.com&password=12&profilepicture=12.png
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    [[AppManager sharedManager] getDataForUrl:BASE_URL
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         NSLog(@"JSON: %@", responseObject);
         if ([responseObject count]>0)
         {
         if ([[responseObject valueForKey:@"type"]isEqualToString:@"sign_up"])
         {
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             if(Status ==1)
             {
    
                 alert(@"Alert", @"You are register successfully.");
                 LoginViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                 [self.navigationController pushViewController:vc1 animated:YES];
                 
                 txt_confirmpassword.text=nil;
                 txt_emailAdd.text=nil;
                 txt_firstName.text=nil;
                 txt_pass.text=nil;
                 
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
             
             }
             
             else if (Status==0)
             {
                 alert(@"Alert", @"Email already exist.");
                 
                 [txt_emailAdd becomeFirstResponder];
                 
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
                 
             }
         }
             
         }
         
         else
         {
             alert(@"Alert", @"Null Occur");
             [[AppManager sharedManager]hideHUD];
             
         }
         
     }
     
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"Error: %@", @"No internet connection.");
         
         // [appdelRef hideProgress];
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Error", @"No internet connection.");
         
     }];
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)termsofuseAction:(id)sender
{
    
    TermsofuseViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"terms"];
    
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (IBAction)PrivacyPolicyAction:(id)sender
{
    
    PrivacyPoliceViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"privacy"];
    
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
