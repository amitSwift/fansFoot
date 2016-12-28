//
//  LoginViewController.m
//  9gag
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "proxyService.h"
//#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppManager.h"
#import "ChangePasswordViewController.h"


@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextView *AddTextView;
@end

@implementation LoginViewController

- (void)viewDidLoad
{

    bannerView.adUnitID = @"ca-app-pub-2063088545096347/2934377089";
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];
    [AppManager sharedManager].navCon = self.navigationController;

    [super viewDidLoad];
    
    [self loadAddress];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [proxyService sharedProxy].delegate = self;
    
    UIView *paddingVw_fstName = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_email.leftView = paddingVw_fstName;
    txt_email.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingVw_fstName1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_password.leftView = paddingVw_fstName1;
    txt_password.leftViewMode = UITextFieldViewModeAlways;
    //UIColor *color = [UIColor whiteColor];
}

#pragma mark - TextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"MoveUP" context:Nil];
    [UIView setAnimationDuration:0.3];
    
    if(textField==txt_email)
    {
        [self moveUP:txt_email];
    }
    else if(textField==txt_password)
    {
        [self moveUP:txt_password];
    }
    [UIView commitAnimations];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == txt_email)
    {
        [txt_password  becomeFirstResponder];
    }
    else if (textField == txt_password)
    {
        [txt_password resignFirstResponder];
        
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
        if(textField==txt_email)
        {
            self.view.frame=CGRectMake(0, -90, 320, self.view.frame.size.height);
        }
        else if(textField==txt_password)
        {
            self.view.frame=CGRectMake(0, -110, 320, self.view.frame.size.height);
        }
       
    }
    
    else if (IS_IPHONE_6)
    {
        if(textField==txt_email)
        {
            self.view.frame=CGRectMake(0, -70, 375, self.view.frame.size.height);
        }
        else if(textField==txt_password)
        {
            self.view.frame=CGRectMake(0, -90, 375, self.view.frame.size.height);
        }
        
    }
    else if (IS_IPHONE_6_PLUS)
    {
        if(textField==txt_email)
        {
            self.view.frame=CGRectMake(0, -90, 414, self.view.frame.size.height);
        }
        else if(textField==txt_password)
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
    [txt_email resignFirstResponder];
    [txt_password resignFirstResponder];
    [self movedown];
}


- (IBAction)TappedOnForgotPswd:(id)sender
{
//    ChangePasswordViewController *forgotPswdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"changepassword"];
//    [self.navigationController pushViewController:forgotPswdVC animated:YES];
    
}
- (IBAction)TappedONFacebook:(id)sender
{
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
//    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
//     {
//         NSLog(@"----%@",result);
//         
//         if (error)
//         {
//             // Error
//             
//         }
//         else if (result.isCancelled)
//         {
//             // Cancelled
//         }
//         else
//         {
//             if ([result.grantedPermissions containsObject:@"email"])
//             {
//                 [self getFBResult];
//             }
//         }
//     }];

    [login logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error){
                if (error) {
                    NSLog(@"There was an error with FB:\n %@",error.description);
                } else if (result.isCancelled) {
        
                } else {
                    if ([result.grantedPermissions containsObject:@"email"]) {
                        NSLog(@"permissions granted! %@",[[FBSDKAccessToken currentAccessToken]permissions]);
                        // Do work
                        [self getFBResult];
                    }else{
                        NSLog(@"permissions NOT granted");
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
                 
                // FacebookLastName=[NSString stringWithFormat:@"%@",[NameArray objectAtIndex:1]];
                 
                 
                 
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
                     
                     [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"user_id"] forKey:@"USERID"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     
                    AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
                         app_in_login.window.rootViewController=tabbar_controller;
                     
                     [[AppManager sharedManager]hideHUD];
                     [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"alreadylogin"];
                     [self popToRootView];
                     [kAppDelegate hideTabBar];
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
         
         NSLog(@"Error: %@", @"No internet connection.");
         
         // [appdelRef hideProgress];
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Error", @"No internet connection.");
         
     }];
    
    
}

- (IBAction)TappedOnLogin:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromCategory"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
//    AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    app_in_login.window.rootViewController=tabbar_controller;

    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if (isStringEmpty([NSString stringWithFormat:@"%@",txt_email.text]))
    {
        alert(@"Message", @"Please enter email.");
        [txt_email becomeFirstResponder];
    }
    
    else if ([emailTest evaluateWithObject:txt_email.text] == NO)
    {
        alert(@"Message", @"Please Enter Valid Email Address.");
        [txt_email becomeFirstResponder];
    }

    else if (txt_password.text.length==0)
    {
        alert(@"Message", @"Please enter password.");
        [txt_password becomeFirstResponder];
    }
    
    else
    {
        BOOL checkNet = [[proxyService sharedProxy] checkReachability];
        
        if(checkNet == TRUE)
        {
           [self webServiceLogin];
        }
        else
        {
            alert(@"Error", @"No Internet connection");
        }
    }
}

-(void)webServiceLogin
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       @{
                                         @"type" :@"login",
                                         @"email" :txt_email.text,
                                         @"password" :txt_password.text,
                                         @"device_token" :[[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"],
                                         @"device_type" :@"ios"
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    [[AppManager sharedManager] getDataForUrl:BASE_URL
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         if ([responseObject count]>0)
         {
         if ([[responseObject valueForKey:@"type"]isEqualToString:@"Login"])
         {
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             if(Status ==1)
             {
                 [[NSUserDefaults standardUserDefaults]setObject:[responseObject valueForKey:@"user_id"] forKey:@"USERID"];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 //alert(@"Alert", @"You are login successfully.");
                 AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
                 app_in_login.window.rootViewController=tabbar_controller;
                 [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"alreadylogin"];
                 
                 
                 
                  [[AppManager sharedManager]hideHUD];
                  [self popToRootView];
                  [kAppDelegate hideTabBar];

                return;
         }
             
         else if (Status ==0)
         {
             alert(@"Alert", @"Invalid Email or Password.");
             [[AppManager sharedManager]hideHUD];
             
             return;
         }
        }
    }
         else
         {
             alert(@"Error", @"No Response.");
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
- (void)popToRootView
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
