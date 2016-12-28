//
//  TermsofuseViewController.m
//  9gag
//
//  Created by Pankaj Sharma on 28/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "TermsofuseViewController.h"
#import "AppManager.h"

@interface TermsofuseViewController ()
@property (strong, nonatomic) IBOutlet UITextView *AddTextView;
@end

@implementation TermsofuseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    
//    [self CallwebServiceTerms];
    
}

-(void)CallwebServiceTerms
{
    
    
    //Add parameters to send server
    
    
    //quenelle.fansfoot.com/web/?type=post_show&post_type=hot
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"type" :@"aboutus",
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    
    [[AppManager sharedManager] getDataForUrl:BASE_URL
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
         NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             
             if ([[[[responseObject objectForKey:@"post"]valueForKey:@"type"]objectAtIndex:0] isEqualToString:@"post_show"])
             {
                 
                 [Obj_WebVW loadHTMLString:[[responseObject objectForKey:@"Termsandcondition"]valueForKey:@"terms_conditions"] baseURL:nil];
                 
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
                 
             }
             
             else
                 
             {
                 alert(@"Alert", @"Invalid Data.");
                 
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backAction:(id)sender
{

//    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
