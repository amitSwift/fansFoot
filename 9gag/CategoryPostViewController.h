//
//  CategoryPostViewController.h
//  FAnsfoot
//
//  Created by Pankaj Sharma on 04/06/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"proxyService.h"


@interface CategoryPostViewController : UIViewController<WebServiceDelegate,UISearchBarDelegate,UIWebViewDelegate>
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
    NSArray *  filteredContentList;
    NSInteger coount;
    UIRefreshControl * RefreshControl;
    NSInteger page_count;
    
    NSMutableArray *arr_postsDATA;
    
    NSString *str_PostID;
    NSString *str_userID;
    BOOL isSearchBarApears;
    NSMutableArray *arr_NextpagePOst;
    
    BOOL isLIKE;
    
    BOOL PushToNextView;
    
    NSMutableArray *arr_like,*arr_unlike;
    NSInteger indexPath1;
    
    
    NSMutableArray *arr_serchResult;
    
    IBOutlet UIWebView *WebVW_AddBanner;
    NSString *str_serachTXT;
    IBOutlet UIButton *btn_next;
    IBOutlet UIButton *btn_privious;

    IBOutlet GADBannerView *bannerView;
    
}
@property (nonatomic, retain) NSString* titlename;

@property(nonatomic,assign)BOOL isShow;
@end
