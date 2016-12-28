//
//  FirstViewController.m
//  9gag
//
//  Created by Pankaj Sharma on 20/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "CategorysViewController.h"
#import "HomeViewController.h"
#import "CategoryPostViewController.h"

@interface CategorysViewController ()
@property (strong, nonatomic) IBOutlet UITextView *AddTextView;
@end

@implementation CategorysViewController

- (void)viewDidLoad {
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
- (IBAction)DetailCategoryPost:(id)sender
{
    CategoryPostViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"categorypost"];
    vc1.isShow=YES;
    if ([sender tag]==0)
    {
        vc1.titlename=@"Memes";
    }
    else if ([sender tag]==1)
    {
       vc1.titlename=@"Videos";
    }
    else if ([sender tag]==2)
    {
        vc1.titlename=@"NSFW";
    }
    else if ([sender tag]==3)
    {
        vc1.titlename=@"Animated GIF";
    }
    
    
    [self.navigationController pushViewController:vc1 animated:YES];

}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;

}


@end
