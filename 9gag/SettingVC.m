//
//  ForthViewController.m
//  9gag
//
//  Created by Pankaj Sharma on 20/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "SettingVC.h"
#import "SetingTableViewCell.h"
#import "ReportProblemViewController.h"
#import "ProfileViewController.h"
#import "AboutUSViewController.h"
#import "AppManager.h"
#import "HeaderFile.h"
#import "proxyService.h"
#include "constant.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface SettingVC ()
@property (strong, nonatomic) IBOutlet UITextView *AddTextView;
@end

@implementation SettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bannerView.adUnitID = @"ca-app-pub-2063088545096347/2934377089";
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];

    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];

    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"status"]isEqualToString:@"1"])
    {
        [switchControl setOn:YES animated:NO];
    }
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"status"]isEqualToString:@"0"])
    {
        [switchControl setOn:NO animated:NO];
    }
    
    self.tabBarController.tabBar.hidden=NO;

    arr_setting=[[NSArray alloc]initWithObjects:@"Profile",@"About us",@"Rating",@"Feedback",@"NSFW",@"Share this app",@"Report a problem",@"Like us on Facebook",@"Follow us on Twitter",nil];
    Setting_table.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1];
    
    Setting_table.scrollEnabled=NO;
    
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



-(void)viewWillAppear:(BOOL)animated
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"ONnsfw"]==YES)
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ONnsfw"];
        
        [switchControl setOn:YES animated:NO];
    }
    else
    {
        [switchControl setOn:NO animated:NO];
        
    }

    
    self.tabBarController.tabBar.hidden=NO;
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
    {
        switchControl.userInteractionEnabled=NO;
    }
//    [AppManager sharedManager].navCon = self.navigationController;


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_setting count];
    
    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Setting_table.hidden=NO;
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    SetingTableViewCell *temp=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (temp == nil)
    {
        temp = [[SetingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SetingTableViewCell" owner:temp options:nil];
        temp=[topLevelObjects objectAtIndex:0];
        temp.selectionStyle=UITableViewCellAccessoryNone;
        temp.selectionStyle = UITableViewCellSelectionStyleNone;
        temp.lbl_seting.text=[arr_setting objectAtIndex:indexPath.row];
        
       
        
//        [temp.btn_NsfwOnOff addTarget:self action:@selector(nsfwONOFF) forControlEvents:UIControlEventTouchUpInside];

        
        if (indexPath.row==4)
        {
            
            if (IS_IPHONE_5)
            {
                switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(254, 5, 43, 20)];
                temp.accessoryView = switchControl;
                switchControl.onTintColor=[UIColor colorWithRed:14.0/255.0 green:41.0/255.0 blue:84.0/255.0 alpha:1];
                [switchControl setOn:YES animated:NO];
                [switchControl addTarget:self action:@selector(nsfwONOFF) forControlEvents:UIControlEventValueChanged];
                temp.arrow_imagVW.hidden=YES;
                switchControl.hidden=NO;

            }
            else if (IS_IPHONE_6)
            {
                switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(309, 5, 43, 20)];
                temp.accessoryView = switchControl;
                switchControl.onTintColor=[UIColor colorWithRed:14.0/255.0 green:41.0/255.0 blue:84.0/255.0 alpha:1];
                [switchControl setOn:YES animated:NO];
                [switchControl addTarget:self action:@selector(nsfwONOFF) forControlEvents:UIControlEventValueChanged];
                temp.arrow_imagVW.hidden=YES;
                switchControl.hidden=NO;

            }
            else if (IS_IPHONE_6_PLUS)
            {
                switchControl = [[UISwitch alloc] initWithFrame:CGRectMake(348, 5, 43, 20)];
                temp.accessoryView = switchControl;
                switchControl.onTintColor=[UIColor colorWithRed:14.0/255.0 green:41.0/255.0 blue:84.0/255.0 alpha:1];
                [switchControl setOn:YES animated:NO];
                [switchControl addTarget:self action:@selector(nsfwONOFF) forControlEvents:UIControlEventValueChanged];
                temp.arrow_imagVW.hidden=YES;
                switchControl.hidden=NO;

            }
            
        }
        if (indexPath.row==7)
        {
            UIImageView *imagevW_button=[[UIImageView alloc]initWithFrame:CGRectMake(216, 10, 94, 25)];
            imagevW_button.image=[UIImage imageNamed:@"facebook-new"];
            
            [temp.contentView addSubview:imagevW_button];
            
            
            
        }
        if (indexPath.row==8)
        {
            UIImageView *imagevW_button=[[UIImageView alloc]initWithFrame:CGRectMake(216, 10, 94, 25)];
            imagevW_button.image=[UIImage imageNamed:@"twitter-new"];
            [temp.contentView addSubview:imagevW_button];
        }

        
    }
    
    return temp;
    
}

-(void)nsfwONOFF
{
    if ([switchControl isOn])
    {
        str_nsfwStstus=[NSString stringWithFormat:@"%d",0];
        
    }
    else
    {
        str_nsfwStstus=[NSString stringWithFormat:@"%d",1];
        
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:str_nsfwStstus forKey:@"status"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self WebServiceONOFFService];

    
}
-(void)WebServiceONOFFService
{
    //quenelle.fansfoot.com/web/?type=my_profile_setting&USERID=5204
    
//    NSURL *urli = [NSURL URLWithString:[NSString stringWithFormat:@"quenelle.fansfoot.com/mobile/web/?type=newsfunction&user_id=%@&status=%@",str_userID,str_nsfwStstus]];
    
//        [self ShowActivityIndicatorWithTitle:@"Please Wait"];
    

    
    NSURL *urli = [NSURL URLWithString:[NSString stringWithFormat:@"http://fansfoot.com/mobile/web/?"]];
    NSString * str = [NSString stringWithFormat:@"type=newsfunction&user_id=%@&status=%@",str_userID,str_nsfwStstus];
    NSLog(@"%@",str);
    NSData * postData = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urli];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSError * error = nil;
    NSURLResponse * response1 = nil;
    //    NSURLConnection * connec = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response1 error:&error];
    NSDictionary* json;
    if(data)
    {
        json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    }
    NSLog(@"%@",response1);
    NSLog(@"%@",json);
    
    if (json.count>0)
    {
        
        if ([[json valueForKey:@"message"]isEqualToString:@"off"])
        {
//            [self HideActivityIndicator];


            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Hide NSFW post"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        else if ([[json valueForKey:@"message"]isEqualToString:@"on"])
        {
//            [self HideActivityIndicator];

            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ONnsfw"];
            [[NSUserDefaults standardUserDefaults]synchronize];

            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Show NSFW post"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];


        }
        else
        {
//            [self HideActivityIndicator];
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Error"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];

        }
        
    }
  
}

//#pragma mark - WebService Delegates
//
//-(void)serviceResponse:(NSDictionary *)responseDic withServiceURL:(NSString *)str_service
//{
//    [[proxyService sharedProxy] hideActivityIndicatorInView];
//    
//    NSLog(@"%@",responseDic);
//    
//    if ([[responseDic valueForKey:@"status"] integerValue]==1)
//    {
//      
//    }
//    
//}
//
//-(void)failToGetResponseWithError:(NSError *)error
//{
//    [[proxyService sharedProxy] hideActivityIndicatorInView];
//    [[[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
//}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 45.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
//    {
//        [kAppDelegate goToLoginView];
//    }
//    else
//    {
        if (indexPath.row==0)
        {
            
            if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
            {
                [kAppDelegate goToLoginView];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"FromSettingScreen"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                ProfileViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
                [self.navigationController pushViewController:vc1 animated:YES];
            }
            
            
        }
        
        if (indexPath.row==1)
        {
            AboutUSViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutus"];
            
            [self.navigationController pushViewController:vc1 animated:YES];
            
        }
        
        
        if (indexPath.row==2)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.apple.com/itunes/"]];
            
        }
        
        
        if (indexPath.row==3)
        {
            
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                
                mailer.mailComposeDelegate = self;
                
                [mailer setSubject:@"Message Pro"];
                
                //Destination adress
                NSArray *toRecipients = [NSArray arrayWithObjects:@"contact@fansfoot.com", nil];
                [mailer setToRecipients:toRecipients];
                
                //Attachement Object
                UIImage *myImage = [UIImage imageNamed:@"image.jpeg"];
                NSData *imageData = UIImagePNGRepresentation(myImage);
                [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
                
                //Message Body
                NSString *emailBody = @"message body";
                [mailer setMessageBody:emailBody isHTML:NO];
                
                [self presentModalViewController:mailer animated:YES];
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                message:@"Your device doesn't support the composer sheet"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
            
        }
        
        if (indexPath.row==5)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.apple.com/itunes/"]];
            
            
        }
        
        if (indexPath.row==6)
        {
            ReportProblemViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"report"];
            
            [self.navigationController pushViewController:vc1 animated:YES];
            
            
        }
        if (indexPath.row==7)
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
                // Safe to launch the facebook app
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/162115273822511"]];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/Fansfoot/"]];
            }
           
            
        }
        if (indexPath.row==8)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/fansfoot"]];
            
        }
    //}
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    
    [self dismissModalViewControllerAnimated:YES];
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
