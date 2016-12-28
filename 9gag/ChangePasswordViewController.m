//
//  ChangePasswordViewController.m
//  9gag
//
//  Created by Pankaj Sharma on 28/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "AppManager.h"
#import "proxyService.h"

@interface ChangePasswordViewController ()
@property (strong, nonatomic) IBOutlet UITextView *AddTextView;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad

{
    bannerView.adUnitID = @"ca-app-pub-2063088545096347/2934377089";
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];
    UIView *paddingVw_fstName = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_email.leftView = paddingVw_fstName;
    txt_email.leftViewMode = UITextFieldViewModeAlways;
    
    
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



#pragma mark --showAdvertisingList--
- (IBAction)ForgotpasswordAction:(id)sender
{

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
   else
    {
    
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
        [self webServiceForgotpassword];
    }
    else
    {
        alert(@"Error", @"No Internet connection");
    }
}
}

-(void)webServiceForgotpassword
{
    [txt_email resignFirstResponder];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         @"type" :@"forget_password",
                                         @"email" :txt_email.text
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    [[AppManager sharedManager] getDataForUrl:BASE_URL
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         if ([responseObject count]>0)
         {
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             
             if(Status == 1)
             {

            if ([[responseObject valueForKey:@"type"] isEqualToString:@"forget_password"])
             {
                 alert(@"Alert", @"Reset password link sent to email id.");
                
                 txt_email.text=nil;

                 [[AppManager sharedManager]hideHUD];
                 
                 return;
                 
             }
             }
            else if (Status == 0)
             {
                 alert(@"Alert", @"No user found.");
                 
                 [[AppManager sharedManager]hideHUD];
                 
                 return;

             }
             
         }
         
         else
         {
             
             alert(@"Alert", @"Null Data.");
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

#pragma mark  Touch Delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txt_email resignFirstResponder];
    [self movedown];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
   
    [UIView commitAnimations];
    
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
            self.view.frame=CGRectMake(0, -100, 320, self.view.frame.size.height);
        }
        
        
    }
    
    else if (IS_IPHONE_6)
    {
        if(textField==txt_email)
        {
            self.view.frame=CGRectMake(0, -70, 375, self.view.frame.size.height);
        }
       
        
    }
    else if (IS_IPHONE_6_PLUS)
    {
        if(textField==txt_email)
        {
            self.view.frame=CGRectMake(0, -90, 414, self.view.frame.size.height);
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


@end
