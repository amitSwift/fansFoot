//
//  DetailPostViewController.h
//  FAnsfoot
//
//  Created by Pankaj Sharma on 08/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DetailPostViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
    IBOutlet UIImageView *post_imageVW;
    IBOutlet UILabel *lbl_POstname;
    int Frame_X;
    float Frame_percentage;
    BOOL imageNull;
    IBOutlet UILabel *lbl_points;
    IBOutlet UILabel *lbl_comments;
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIButton *btn_send;
    float height;
    IBOutlet UITableView *chattable;
    NSData *dataImage;
    NSString *str_userID;
    CGSize size;
    NSMutableArray *arr_comment;
    NSString *str_post_id;
    NSMutableArray *arr_postsDATA;
    NSData *imageData;
    NSURL *url;
    NSString *str_gifimage;
    
    BOOL animatedpic;
    
    IBOutlet UIWebView *WebVW;
    
    IBOutlet GADBannerView *bannerView;
    
}
- (IBAction)likeAction:(id)sender;
- (IBAction)unlikeAction:(id)sender;

- (IBAction)send_message:(id)sender;

@property (strong, nonatomic) IBOutlet PlaceholderTextView *txtx_view;

- (IBAction)backaction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *LikeButton;
@property (strong, nonatomic) IBOutlet UIButton *UnlikeButton;
@property (strong, nonatomic) IBOutlet UIButton *commentyButoon;
@property (strong, nonatomic) IBOutlet UIButton *FacebookLikeButton;
@property(nonatomic,retain)NSMutableArray *arr_detailpost;
@property (strong, nonatomic) IBOutlet UIImageView *cell_background_image;

@property (strong, nonatomic) IBOutlet UIView *Buttons_BackgroundVW;
@property (strong, nonatomic) IBOutlet UIWebView *webView;


@end
