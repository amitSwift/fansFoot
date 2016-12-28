//
//  PlayYoutubeVideoVC.m
//  FAnsfoot
//
//  Created by amit varma on 26/11/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import "PlayYoutubeVideoVC.h"
#import "YTPlayerView.h"

@interface PlayYoutubeVideoVC ()
@property (strong, nonatomic) IBOutlet UITextView *AddTextView;
@end

@implementation PlayYoutubeVideoVC
@synthesize arr_detailpost;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bannerView.adUnitID = @"ca-app-pub-2063088545096347/2934377089";
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];
    
    self.playerView.delegate = self;
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 };
    //[self.playerView loadWithVideoId:@"nMg-rE3VvEs" playerVars:playerVars];
    
    [self.playerView loadWithVideoId:@"nMg-rE3VvEs"];
    
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)playVideo:(id)sender
{
    [self.playerView playVideo];
}

- (IBAction)stopVideo:(id)sender
{
    [self.playerView stopVideo];
}
@end
