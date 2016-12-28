//
//  AppDelegate.h
//  9gag
//
//  Created by Pankaj Sharma on 20/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "HomeViewController.h"
#import <UserNotifications/UserNotifications.h>

UITabBarController *tabbar_controller;


@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,UIAlertViewDelegate,UNUserNotificationCenterDelegate>
{
    UIImageView *splashImageView;
    NSMutableArray *jsonArray;
    
    NSString *str_iphone4;
    NSString *str_iphone5;
    NSString *str_iphone6;
    NSString *str_iphone6Plus;
    
}

@property (strong, nonatomic) UIWindow *window;

-(void)tabbar;
-(void)hideTabBar;
-(void)goToLoginView;
-(void)makeRootView;

@end

