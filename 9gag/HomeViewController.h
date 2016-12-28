//
//  ViewController.h
//  9gag
//
//  Created by Pankaj Sharma on 20/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"proxyService.h"

@import GoogleMobileAds;


@interface HomeViewController : UIViewController<WebServiceDelegate,UISearchBarDelegate,UIWebViewDelegate>
{
    NSMutableArray * arr_Images;
    NSMutableArray *arr_advertList;
    NSInteger index;
    BOOL headingSeleect;
    IBOutlet UIButton *btn_hot;
    IBOutlet UIButton *btn_tranding;
    IBOutlet UIButton *btn_frsh;
    BOOL btn_selected;
    IBOutlet UISegmentedControl *Home_segment;
    
    IBOutlet UILabel *NameofScreen;
    IBOutlet UITableView *tableVW_post;
    IBOutlet UIButton *back_btn;
    IBOutlet UIButton *btn_serach;
    NSString *str_segmentTitle;
    NSString *str_ChannelParameter;
    IBOutlet UISearchBar *SearchBar;
    BOOL IsSearchDataFound;
    NSMutableArray *filteredContentList;
    UIRefreshControl * RefreshControl;
    UIRefreshControl * RefreshControl_down;
    NSInteger page_count;
    
    NSMutableArray *arr_postsDATA;
    NSString *str_userID;
    
    NSString *str_PostID;
    BOOL isSearchBarApears;
    NSMutableArray *arr_NextpagePOst;
    
    int Frame_X;
    float Frame_percentage;
    BOOL imageNull;
    float imageHeight,imagewidth;
    NSMutableArray *arr_height,*arr_width;
    
    float cellheight,cellwidth;
    NSString *str_height;
    NSString *str_width;
    
    BOOL PushToNextView;
    
    NSMutableArray *arr_like,*arr_unlike;
    NSInteger indexPath1;
    
    BOOL isLIKE;

    NSMutableArray *arr_serchResult;
    
    IBOutlet UIWebView *WebVW_AddBanner;
    
    NSString *str_serachTXT;
    
    BOOL isFromLike;
    IBOutlet UIButton *btn_privious;
    IBOutlet UIButton *btn_next;
    
    IBOutlet GADBannerView *bannerView;
}
@property (nonatomic, retain) NSString* titlename;




@end

