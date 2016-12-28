//
//  PrivateChat.h
//  Havoc
//
//  Created by Preeti Malhotra on 7/26/14.
//  Copyright (c) 2014 Preeti Malhotra. All rights reserved.
//

#import "PrivateChat.h"
#import "PlaceholderTextView.h"
#import "MBProgressHUD.h"

BOOL CHANNEL,PRIVATE;
@interface PrivateChat : UIViewController<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
 
    float height;
    IBOutlet UITableView *chattable;
    NSData *dataImage;
    NSString *str_userID;
    
    IBOutlet UIButton *btn_send;
    
    CGSize size;

    NSMutableArray *arr_comment;
    MBProgressHUD *activityIndicator;

    IBOutlet GADBannerView *bannerView;
    
  IBOutlet  UIWebView *WebVW;
}
- (IBAction)send_message:(id)sender;

@property (strong, nonatomic) IBOutlet PlaceholderTextView *txtx_view;
@property(strong,nonatomic)NSString *str_post_id;

@property(nonatomic,assign)BOOL Fromcategory;
@property (nonatomic,strong)NSMutableArray *arr_detailComment;



@end
