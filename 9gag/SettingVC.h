//
//  ForthViewController.h
//  9gag
//
//  Created by Pankaj Sharma on 20/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "proxyService.h"

@interface SettingVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,WebServiceDelegate>
{
    
    IBOutlet UITableView *Setting_table;
    NSArray *arr_setting;
    NSString *str_nsfwStstus;
    UISwitch *  switchControl;
    NSString *str_userID;
    NSDictionary *jsonArray;
    
    IBOutlet GADBannerView *bannerView;
}

@end
