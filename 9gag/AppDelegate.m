//
//  AppDelegate.m
//  9gag
//
//  Created by Pankaj Sharma on 20/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <UserNotifications/UserNotifications.h>


#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()

{
    NSMutableArray *tabbar_array;
    UINavigationController *navigation_app_delegate;
    UIImageView *splashimage;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
//    [[NSUserDefaults standardUserDefaults]setValue:@"64d0e0bf46af47621fb3a0d150a8a20aea8edd42c50824c9c3c4cb2101445ffb" forKey:@"deviceToken"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-2063088545096347/2934377089"];
    
    
     [self registerForRemoteNotifications];
    
    tabbar_array=[[NSMutableArray alloc]init];
    tabbar_controller=[[UITabBarController alloc]init];
    [self tabbar];
    

    [application setStatusBarHidden:NO];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self loadFirstScreen];
    //[self secondSplashScreen];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    
    
    
    
//        NSURL *urli = [NSURL URLWithString:[NSString stringWithFormat:@"http://fansfoot.com/mobile/web/?type=image_size"]];
//    
//        NSString *str = [NSString stringWithFormat:@""];
//    
//        NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
//        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:urli];
//        [request setHTTPMethod:@"POST"];
//        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPBody:postData];
//        NSError *error = nil;
//        NSURLResponse *response = nil;
//    
//        jsonArray = [[NSMutableArray alloc] init];
//    
//        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//        if(data)
//        {
//            jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//            //        json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//        }
//        NSLog(@"%@",response);
//        
//        NSLog(@"%@",jsonArray);
//    str_iphone4=[jsonArray valueForKey:@"iphone4"];
//    str_iphone5=[jsonArray valueForKey:@"iphone5"];
//    str_iphone6=[jsonArray valueForKey:@"iphone6"];
//    str_iphone6Plus=[jsonArray valueForKey:@"iphone6+"];
    

    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UINavigationController *navController =(UINavigationController *) self.window.rootViewController;
//    
//    
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==YES)
//    {
//        
//        HomeViewController *destCon = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//        
//        
//        [navController pushViewController:destCon animated:YES];
//    }
//    else
//    {
//        
//        LoginViewController *pop = [storyboard instantiateViewControllerWithIdentifier:@"login"];
//        
//        [navController pushViewController:pop animated:YES];
//    }
//
    
//    AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    app_in_login.window.rootViewController=tabbar_controller;
    
    // Override point for customization after application launch.
     return YES;
    
}


-(void)loadFirstScreen
{
    splashimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    splashimage.image=[UIImage imageNamed:@"Default"];
    [self.window.rootViewController.view addSubview:splashimage];
    [self performSelector:@selector(secondSplashScreen) withObject:nil afterDelay:3.0f];
    
}
-(void)secondSplashScreen
{
    [splashimage removeFromSuperview];
     UIImage *splashImage = [UIImage imageNamed:@"Splash"];
    splashImageView = [[UIImageView alloc] initWithImage:splashImage];
    splashImageView.frame=[[UIScreen mainScreen] bounds];
    [self.window.rootViewController.view addSubview:splashImageView];
    
    // [self.window.rootViewController.view bringSubviewToFront:splashImageView];
     [[AppManager sharedManager] hideHUDWitoutAnimation];
    [self performSelector:@selector(dissmissSecondScreen) withObject:nil afterDelay:3.0f];
}

-(void)dissmissSecondScreen
{
    [[AppManager sharedManager] hideHUDWitoutAnimation];
    [splashImageView removeFromSuperview];
    [self.window.rootViewController.view bringSubviewToFront:splashImageView];
    
  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"showLoading" object:self];
    [self performSelector:@selector(dissmissLoader) withObject:nil afterDelay:2.0f];
    
    
}
-(void)dissmissLoader
{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"hideLoading" object:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadHotservice" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark- Push notification methods-
-(void)registerForRemoteNotifications
{
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    
    }
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    //Called when a notification is delivered to a foreground app.
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionAlert);
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadHotservice" object:self];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    //Called to let your app know which action was selected by the user for a given notification.
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
    
    
    ///copy old notification code
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    
    
    NSDictionary* reciveDict=[response.notification.request.content.userInfo valueForKey:@"aps"];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message!" message:[reciveDict valueForKey:@"alert"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
    int notification_type =[[reciveDict valueForKey:@"notification_type"] intValue];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadHotservice" object:self];

    
    
}



-(void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *deviceTokens = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokens = [deviceTokens stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"registered device token %@", deviceTokens);
    [[NSUserDefaults standardUserDefaults]setValue:deviceTokens forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadHotservice" object:self];
     //[self tabbar];
    //[self loadFirstScreen];
    
    
    
    
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"String %@",str);
    
    [[NSUserDefaults standardUserDefaults]setValue:@"64d0e0bf46af47621fb3a0d150a8a20aea8edd42c50824c9c3c4cb2101445ffb" forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadHotservice" object:self];
    //[self tabbar];
    //[self loadFirstScreen];
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    
    
       NSDictionary* reciveDict=[userInfo valueForKey:@"aps"];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message!" message:[reciveDict valueForKey:@"alert"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
    
        int notification_type =[[reciveDict valueForKey:@"notification_type"] intValue];
        
    [[NSUserDefaults standardUserDefaults]synchronize];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"LoadHotservice" object:self];
    
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"loadHotItem" object:nil];
         [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadHotservice" object:self];
    }
}


#pragma tabbar work
-(void)tabbar
{
    
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ViewControllerObj = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    FirstViewControllerObj=[storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    //SecondViewControllerObj=[storyboard instantiateViewControllerWithIdentifier:@"postadd"];
     SecondViewControllerObj=[storyboard instantiateViewControllerWithIdentifier:@"categorypost"];
    ThirdViewControllerObj=[storyboard instantiateViewControllerWithIdentifier:@"profile"];
    ForthViewControllerObj=[storyboard instantiateViewControllerWithIdentifier:@"ForthViewController"];
    
    
    
    UINavigationController *Viewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:ViewControllerObj];
    [Viewcontroller_navigation.tabBarItem setImage: [ Viewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"home-inactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    Viewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"home-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Viewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [tabbar_array addObject:Viewcontroller_navigation];
    
    
    UINavigationController *FirstViewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:FirstViewControllerObj];
    [FirstViewcontroller_navigation.tabBarItem setImage: [ FirstViewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"list-inactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    FirstViewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"list-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    FirstViewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [tabbar_array addObject:FirstViewcontroller_navigation];
    
    
        UINavigationController *SecondViewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:SecondViewControllerObj];
        [SecondViewcontroller_navigation.tabBarItem setImage: [ SecondViewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"addIocn-inactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        SecondViewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"addIocn-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        SecondViewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        SecondViewControllerObj.titlename=@"Videos";
        SecondViewControllerObj.isShow=NO;
        [tabbar_array addObject:SecondViewcontroller_navigation];
    
    
    UINavigationController *ThirdViewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:ThirdViewControllerObj];
    [ThirdViewcontroller_navigation.tabBarItem setImage: [ ThirdViewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"profile-Inactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    ThirdViewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"profile-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ThirdViewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [tabbar_array addObject:ThirdViewcontroller_navigation];
    ThirdViewcontroller_navigation.navigationBarHidden=YES;
    
    
    
    UINavigationController *ForthViewcontroller_navigation=[[UINavigationController alloc]initWithRootViewController:ForthViewControllerObj];
    [ForthViewcontroller_navigation.tabBarItem setImage: [ ForthViewcontroller_navigation.tabBarItem.image=[UIImage imageNamed:@"setting-Inactive"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    ForthViewcontroller_navigation.tabBarItem.selectedImage = [[UIImage imageNamed:@"setting-active"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ForthViewcontroller_navigation.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    [tabbar_array addObject:ForthViewcontroller_navigation];
    
    
    
    Viewcontroller_navigation.navigationBarHidden=YES;
    FirstViewcontroller_navigation.navigationBarHidden=YES;
    SecondViewcontroller_navigation.navigationBarHidden=YES;
    ThirdViewcontroller_navigation.navigationBarHidden=YES;
    ForthViewcontroller_navigation.navigationBarHidden=YES;
    
    tabbar_controller.delegate=self;
    [tabbar_controller setViewControllers:tabbar_array animated:YES];
    self.window.rootViewController=tabbar_controller;
    
    ////***LoginPass**/////
    
    //    AppDelegate *app_in_login =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    //    app_in_login.window.rootViewController=tabbar_controller;
    
    /////****/////
    
    
    }

-(void)makeRootView
{
    self.window.rootViewController=tabbar_controller;
}



-(void)hideTabBar
{
    [tabbar_controller setSelectedIndex:0];
    
    tabbar_array=[[NSMutableArray alloc]init];
     tabbar_controller=[[UITabBarController alloc]init];
    [self tabbar];
}
-(void)goToLoginView
{
  [tabbar_controller setSelectedIndex:3];
}

@end
