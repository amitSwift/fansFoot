//
//  ThirdViewController.m
//  9gag
//
//  Created by Pankaj Sharma on 20/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UITextView *AddTextView;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    
    bannerView.adUnitID = @"ca-app-pub-2063088545096347/2934377089";
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];
    profile = YES;
    date_picker_view.hidden = YES;

    NSDate *currentDate = [NSDate date];
    imageViewCam.image =[UIImage imageNamed:@"profilepicture.jpg"];

    date_picker.maximumDate = currentDate;
    self.tabBarController.tabBar.hidden=NO;
    
    txt_name.delegate = self;
    txt_city.delegate = self;
    txt_country.delegate = self;
    txt_birthday.delegate = self;
    txt_name.userInteractionEnabled = NO;
    txt_city.userInteractionEnabled = NO;
    txt_country.userInteractionEnabled = NO;
    txt_birthday.userInteractionEnabled = NO;
    btn_picker.userInteractionEnabled= NO;
    btn_camera.userInteractionEnabled= NO;

    
    //btn_back.hidden=YES;
    
   

    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FromSettingScreen"]==YES)
    {
        
        btn_back.hidden=NO;
    }
    else
    {
        //btn_back.hidden=YES;
        
    }

    
    imageViewCam.layer.cornerRadius=imageViewCam.frame.size.height/2;
    imageViewCam.clipsToBounds = YES;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
    {
        LoginViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self.navigationController pushViewController:vc1 animated:NO];

    }
    
    
    UIView *paddingVw_fstName = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_birthday.leftView = paddingVw_fstName;
    txt_birthday.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingVw_fstName1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_city.leftView = paddingVw_fstName1;
    txt_city.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingVw_fstName2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_country.leftView = paddingVw_fstName2;
    txt_country.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingVw_fstName3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    txt_name.leftView = paddingVw_fstName3;
    txt_name.leftViewMode = UITextFieldViewModeAlways;

    
    [proxyService sharedProxy].delegate = self;

    self.tabBarController.tabBar.hidden=NO;
    
     str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
[self loadAddress];
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


-(void)viewDidAppear:(BOOL)animated
{

    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
    {
        [kAppDelegate goToLoginView];
    }
    else
    {
        [self webservice_call_method];
    }

}


#pragma mark Webservice Methods :-

-(void)webservice_call_method
{

    
    
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
        
        NSString *postData= [NSString stringWithFormat:@"USERID=%@",str_userID];
        
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Loading.."];
        [[proxyService sharedProxy] postDataonServer:Kshowprofile withPostString:postData];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
}

-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
{
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    NSLog(@"%@",responseDic);
    
    if ( [str_service isEqualToString:KLogOut])
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"alreadylogin"];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [kAppDelegate hideTabBar];
        
        
    }
    else if([str_service isEqualToString:Kshowprofile])
    {
        if ([[responseDic valueForKey:@"status"]integerValue]==1)
        {
            txt_name.text = [responseDic valueForKey:@"name"];
            points_lbl.text =[NSString stringWithFormat:@"%@", [responseDic valueForKey:@"like"]];
            comments_lbl.text = [NSString stringWithFormat:@"%@", [responseDic valueForKey:@"comments"]];
            post_lbl.text = [NSString stringWithFormat:@"%@", [responseDic valueForKey:@"post"]];

        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }
    else if (editprofile==YES){
        
        editprofile= NO;
        [[[UIAlertView alloc] initWithTitle:@"Message" message:@"Your profile successfully updated." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        imageViewCam.layer.cornerRadius = imageViewCam.frame.size.height/2;
        imageViewCam.clipsToBounds = YES;
    }
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 150;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.2;
double animatedDistance;

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"begin");
    
    CGRect textFieldRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 3.0 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if(heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textViewDoneEditing");
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        [txt_name resignFirstResponder];
        [txt_city resignFirstResponder];
    [txt_country resignFirstResponder];
    [txt_birthday resignFirstResponder];
    
    return YES;
}


- (IBAction)TappedOnCamera:(id)sender
{
 //   [UIView commitAnimations];
//    UIActionSheet *obj_ActionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", nil),NSLocalizedString(@"Photo album", nil), nil];
//    [obj_ActionSheet showInView:self.view];
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
                obj_ImagePicker.editing=YES;
                // obj_ImagePicker.videoQuality=UIImagePickerControllerQualityTypeHigh;
                [self.navigationController presentViewController:obj_ImagePicker animated:YES completion:nil];
            }
            else
            {
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK"                                                          otherButtonTitles: nil];
                [myAlertView show];
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
            
        case 2:
        {
            //            [scrollView_Advers setContentOffset:CGPointMake(0, 0) animated:YES];
            
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
    encryptedString = [dataImage base64EncodedStringWithOptions:0];
    obj_imagePick=[info valueForKey:UIImagePickerControllerOriginalImage];
    
       imageViewCam.image=obj_imagePick;
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backaction:(id)sender
{
    
    //btn_back.hidden=YES;
    editprofile=NO;
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromSettingScreen"];
    [[NSUserDefaults standardUserDefaults]synchronize];
//
//    [self.navigationController popViewControllerAnimated:NO];
    [self WebServiceLogOut];

}

-(IBAction)Cancel_button:(id)sender
{
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^
     {
         if (IS_IPHONE_6)
         {
             CGRect frame = date_picker_view.frame;
             frame.origin.y = 660;
             frame.origin.x = 0;
             date_picker_view.frame = frame;
         }else{
             CGRect frame = date_picker_view.frame;
             frame.origin.y = 568;
             frame.origin.x = 0;
             date_picker_view.frame = frame;
         }
         
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];

}
-(IBAction)Done_button:(id)sender
{
    txt_birthday.text = [self formatDate:date_picker.date];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         if (IS_IPHONE_6)
         {
             CGRect frame = date_picker_view.frame;
             frame.origin.y = 660;
             frame.origin.x = 0;
             date_picker_view.frame = frame;
         }else{
             CGRect frame = date_picker_view.frame;
             frame.origin.y = 568;
             frame.origin.x = 0;
             date_picker_view.frame = frame;
         }
         
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];

}
-(IBAction)btn_datepicker:(id)sender
{
    
    [txt_name resignFirstResponder];
    [txt_city resignFirstResponder];
    [txt_country resignFirstResponder];

    date_picker_view.hidden = NO;
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         if (IS_IPHONE_6)
         {
             CGRect frame = date_picker_view.frame;
             frame.origin.y = 350;
             frame.origin.x = 0;
             date_picker_view.frame = frame;
         }else{
             CGRect frame = date_picker_view.frame;
             frame.origin.y = 300;
             frame.origin.x = 0;
             date_picker_view.frame = frame;
         }
         
         
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
    
}

- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd"];
    // NSCalendar *calendar = [[NSCalendar alloc]
    //  initWithCalendarIdentifier:NSGregorianCalendar] ;
   
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}


- (IBAction)EditProfileAction:(id)sender
{
    
    if (profile==YES)
    {
        txt_name.userInteractionEnabled = YES;
        txt_city.userInteractionEnabled = YES;
        txt_country.userInteractionEnabled = YES;
        txt_birthday.userInteractionEnabled = YES;
        btn_picker.userInteractionEnabled= YES;
        btn_camera.userInteractionEnabled= YES;

        [editbtn setTitle:@"Save" forState:UIControlStateNormal];

        profile = NO;
    }
    else if(profile==NO)
    {
        [self WebServiceEditProfile];
        profile = YES;
        txt_name.userInteractionEnabled = NO;
        txt_city.userInteractionEnabled = NO;
        txt_country.userInteractionEnabled = NO;
        txt_birthday.userInteractionEnabled = NO;
        btn_picker.userInteractionEnabled= NO;
        btn_camera.userInteractionEnabled= NO;


        [editbtn setTitle:@"Edit" forState:UIControlStateNormal];

    }
}

-(void)WebServiceEditProfile
{
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
        editprofile = YES;
        NSString *urlEncoded = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                     NULL,
                                                                                                     (CFStringRef)txt_name.text,
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                                     kCFStringEncodingUTF8));
        
        NSString *postData= [NSString stringWithFormat:@"USERID=%@&username=%@&profilepicture=%@",str_userID,urlEncoded,encryptedString];
        
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Loading.."];
        [[proxyService sharedProxy] postDataonServer:Keditprofile withPostString:postData];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

}

-(void)WebServiceLogOut
{
    BOOL checkNet = [[proxyService sharedProxy] checkReachability];
    if(checkNet == TRUE)
    {
        editprofile = YES;
        NSString *urlEncoded = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                     NULL,
                                                                                                     (CFStringRef)txt_name.text,
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                                     kCFStringEncodingUTF8));
        
        NSString *postData= [NSString stringWithFormat:@"USERID=%@",str_userID];
        
        [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Loading.."];
        [[proxyService sharedProxy] postDataonServer:KLogOut withPostString:postData];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"FromSettingScreen"]==YES)
    {
        //btn_back.hidden=YES;
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FromSettingScreen"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


@end
