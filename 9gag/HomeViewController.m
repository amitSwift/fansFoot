//
//  ViewController.m
//  9gag
//
//  Created by Pankaj Sharma on 20/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "HomeVCTableViewCell.h"
#import "AppManager.h"
#import "PrivateChat.h"
#import "DetailPostViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "WebView.h"





@interface HomeViewController ()
{
    float sectionHeight;
    MBProgressHUD* HUD;
}
//@property (readonly) UIWebView* webView;
@property (readonly) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UITextView *AddTextView;
    
   
    
    

@end

@implementation HomeViewController

@synthesize titlename,webView;


- (UIWebView*) webView
{
    return [WebView shared];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bannerView.adUnitID = @"ca-app-pub-2063088545096347/2934377089";
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];
    
    
    [webView  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://quenelle.fansfoot.com/uploads/posts/t/8370.jpg"]]];
    
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    page_count=0;
    RefreshControl = [[UIRefreshControl alloc] init];
    RefreshControl.tintColor = [UIColor grayColor];
    [  RefreshControl addTarget:self action:@selector(handleRefreshComments:) forControlEvents:UIControlEventValueChanged];
    [tableVW_post addSubview:RefreshControl];
    [tableVW_post sendSubviewToBack:RefreshControl];


    SearchBar.hidden=YES;
    arr_advertList=[[NSMutableArray alloc]init];
    arr_Images =[[NSMutableArray alloc]init];
    
    NameofScreen.text=@"Home";
    btn_serach.hidden=NO;

        if (IS_IPHONE_5)
        {
            tableVW_post.frame=CGRectMake(0, 152, 320, 395);
        }
        else if (IS_IPHONE_6)
        {
            tableVW_post.frame=CGRectMake(0, 152, 375, 500);
            
        }
        else if (IS_IPHONE_6_PLUS)
        {
            tableVW_post.frame=CGRectMake(0, 152, 414, 500);
            
        }
    
    
    tableVW_post.backgroundColor=[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoading:) name:@"showLoading" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoading:) name:@"hideLoading" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hotUpdate:) name:@"loadHotItem" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWebServiceGetPost:) name:@"LoadHotservice" object:nil];
    
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

- (void)hotUpdate:(NSNotification *)notification
{
    
    
   
    
    NSLog(@"hot");
    
    page_count=0;
    
    [btn_hot setBackgroundImage:[UIImage imageNamed:@"left-inactive"] forState:UIControlStateNormal];
    [btn_hot setSelected:YES];
    [btn_tranding setBackgroundImage:[UIImage imageNamed:@"center-inactive"] forState:UIControlStateNormal];
    [btn_tranding setSelected:NO];
    [btn_frsh setBackgroundImage:[UIImage imageNamed:@"right_active"] forState:UIControlStateNormal];
    [btn_frsh setSelected:NO];
    
    str_segmentTitle=@"hot";
    str_ChannelParameter=@"post_show";
    
    [self webServiceHotItemLoad];
    
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)hideLoading:(NSNotification *)notification
{
    [[AppManager sharedManager] hideHUD];
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"]);
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"CategoryName"];
    
    arr_postsDATA=[[NSMutableArray alloc]init];
    Home_segment.layer.borderColor=[[UIColor clearColor]CGColor];
    arr_NextpagePOst=[[NSMutableArray alloc]init];
    arr_unlike=[[NSMutableArray alloc]init];
    arr_like=[[NSMutableArray alloc]init];
    arr_serchResult=[[NSMutableArray alloc]init];
    
    btn_privious.layer.cornerRadius=5.0f;
    btn_privious.clipsToBounds=YES;
    
    btn_next.layer.cornerRadius=5.0f;
    btn_next.clipsToBounds=YES;

    [AppManager sharedManager].navCon = self.navigationController;
    self.tabBarController.tabBar.hidden=NO;
    //[[AppManager sharedManager] hideHUDWitoutAnimation];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
   
    
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    isSearchBarApears=NO;
    
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Nextpage"]==YES)
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Nextpage"];
        if (!isStringEmpty(str_segmentTitle))
        {
            NSLog(@"%ld",(long)page_count);
            
            NSArray *tempArray = [arr_advertList subarrayWithRange:NSMakeRange(0, 5*(long)page_count)];
            arr_advertList=[NSMutableArray new];
            [arr_advertList addObjectsFromArray:tempArray];
            
            [self webServiceCategoryWiseDATA];
        }
        else
        {
             NSLog(@"%ld",(long)page_count);
            
            NSArray *tempArray = [arr_advertList subarrayWithRange:NSMakeRange(0, 5*(long)page_count)];
            arr_advertList=[NSMutableArray new];
            [arr_advertList addObjectsFromArray:tempArray];
            
            [self webServiceGetpost];
            
            [btn_hot setBackgroundImage:[UIImage imageNamed:@"left-active"] forState:UIControlStateNormal];
            [btn_tranding setBackgroundImage:[UIImage imageNamed:@"center-inactive"] forState:UIControlStateNormal];
            [btn_frsh setBackgroundImage:[UIImage imageNamed:@"right-inactive"] forState:UIControlStateNormal];
        }
    }
    else
    {
    if (!isStringEmpty(str_segmentTitle))
    {
        //page_count=0;
        NSArray *tempArray = [arr_advertList subarrayWithRange:NSMakeRange(0, 5*(long)page_count)];
        arr_advertList=[NSMutableArray new];
        [arr_advertList addObjectsFromArray:tempArray];
        [self webServiceCategoryWiseDATA];
    }
    else
    {
        //page_count=0;
        NSArray *tempArray = [arr_advertList subarrayWithRange:NSMakeRange(0, 5*(long)page_count)];
        arr_advertList=[NSMutableArray new];
        [arr_advertList addObjectsFromArray:tempArray];
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"]) {
             [self webServiceGetpost];
        }
       
        
        [btn_hot setBackgroundImage:[UIImage imageNamed:@"left-active"] forState:UIControlStateNormal];
        [btn_tranding setBackgroundImage:[UIImage imageNamed:@"center-inactive"] forState:UIControlStateNormal];
        [btn_frsh setBackgroundImage:[UIImage imageNamed:@"right-inactive"] forState:UIControlStateNormal];
        
        [[AppManager sharedManager] showHUD:@"Loading..."];
    }
    }
    
   [self getBANNER];
   
}
-(void)showLoading:(NSNotification *)notification
{
    [[AppManager sharedManager] showHUD:@"Loading..."];
  // [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getBANNER
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       @{
                                         }];
    
    
    [[AppManager sharedManager] getDataForUrl:@"http://dev414.trigma.us/windaily/UserOptions/getDid"
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, NSMutableDictionary * responseObject)
     {
         // Get response from server
         NSLog(@"JSON: %@", responseObject);
         if ([responseObject count]>0)
         {
             [WebVW_AddBanner loadHTMLString:[[responseObject objectForKey:@"Didyouknow"]valueForKey:@"under"] baseURL:nil];
            // [[AppManager sharedManager]hideHUD];
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
-(void)loadWebServiceGetPost:(NSNotification *)notification
{
     //[[NSNotificationCenter defaultCenter] removeObserver:self];
    [self webServiceGetpost];
}

-(void)webServiceGetpost
{
    NSLog(@"notification device type=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"]);
        NSString *str_count=[NSString stringWithFormat:@"%ld",(long)page_count];
        //quenelle.fansfoot.com/web/?type=post_show&post_type=hot
        NSMutableDictionary *parameters;
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
        {
            parameters = [NSMutableDictionary dictionaryWithDictionary:
                          @{
                            @"type" :@"post_show",
                            @"post_type" :@"hot",
                            @"page" :str_count,
                            @"device_token" :[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"],
                            @"device_type"  :@"ios",
                            @"USERID" :@""
                            }];
        }
        else{
            parameters = [NSMutableDictionary dictionaryWithDictionary:
                          @{
                            @"type" :@"post_show",
                            @"post_type" :@"hot",
                            @"page" :str_count,
                            @"device_token" :[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"],
                            @"device_type"  :@"ios",
                            @"USERID" :[[NSUserDefaults standardUserDefaults]valueForKey:@"USERID"]
                            }];
        }
        
        
        //[[AppManager sharedManager] showHUD:@"Loading..."];
        [[AppManager sharedManager] getDataForUrl:BASE_URL
                                       parameters:parameters
                                          success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject)
         
         {
             // Get response from server
             
             NSLog(@"JSON: %@", responseObject);
             arr_postsDATA=[responseObject objectForKey:@"post"];
             if ([responseObject count]>0)
             {
                 NSInteger Status=[[[arr_postsDATA valueForKey:@"status"]objectAtIndex:0] integerValue];
                 if(Status ==1)
                 {
                     
                     if ([[[arr_postsDATA valueForKey:@"type"]objectAtIndex:0] isEqualToString:@"post_show"])
                     {
                         
                         // arr_advertList=arr_postsDATA;
                         if (page_count==0)
                         {
                             arr_advertList=[NSMutableArray  new];
                         }
                         
                         
                         [arr_advertList addObjectsFromArray:arr_postsDATA];
                         [RefreshControl endRefreshing];
                         if([arr_advertList count]>0)
                         {
                             [tableVW_post reloadData];
                             NSLog(@"%f",sectionHeight);
                             if (isFromLike==YES)
                             {
                                 isFromLike=NO;
                             }
                             else
                             {
                                 //[tableVW_post setContentOffset:CGPointMake(0, 0) animated:NO];
                             }
                         }
                         [[AppManager sharedManager]hideHUD];
                         return;
                     }
                 }
                 
                 else if (Status==0)
                 {
                     [RefreshControl endRefreshing];
                     str_segmentTitle=nil;
                     alert(@"Alert", @"No Post.");
                     page_count=page_count-1;
                     
                     [[AppManager sharedManager]hideHUD];
                     
                     return;
                 }
             }
             
             else
             {
                 [RefreshControl endRefreshing];
                 str_segmentTitle=nil;
                 
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

#pragma mark --TableView Delegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isSearchBarApears==YES)
    {
        return [filteredContentList count];
    }
    else
    {
        return [arr_advertList count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (Image_null==YES)
    {
        Image_null=NO;
        return 290;
    }
    else
    {
    return Frame_Y+120;
    }
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    static NSString *cellIdentifier = @"HomeVCTableViewCell";
    // Similar to UITableViewCell, but
    HomeVCTableViewCell *tempcell = (HomeVCTableViewCell *)[tableVW_post dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (tempcell == nil)
    {
        tempcell = [[HomeVCTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        tempcell = (HomeVCTableViewCell *)[nib objectAtIndex:0];
        
        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
        tempcell.selectionStyle=UITableViewCellAccessoryNone;

        if (isSearchBarApears==YES)
        {
            [tempcell loaditemwithAdvertListArray:[filteredContentList objectAtIndex:indexPath.row]];

        }
        else
        {
            [tempcell loaditemwithAdvertListArray:[arr_advertList objectAtIndex:indexPath.row]];
  
        }
        
        tempcell.Btn_Comment.tag=indexPath.row;
        tempcell.Like_btn.tag=indexPath.row;
        tempcell.Unlike_btn.tag=indexPath.row;
        tempcell.fbLineBtn.tag=indexPath.row;
        
        
        
        [tempcell.fbLineBtn addTarget:self action:@selector(FbLikeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [tempcell.Btn_Comment addTarget:self action:@selector(CommentVCPUSH:) forControlEvents:UIControlEventTouchUpInside];
        [tempcell.Like_btn addTarget:self action:@selector(LikeAction:) forControlEvents:UIControlEventTouchUpInside];
        [tempcell.Unlike_btn addTarget:self action:@selector(UnlikeAction:) forControlEvents:UIControlEventTouchUpInside];
/*
        if (Image_null==YES)
        {
            FBSDKLikeControl *fbLikeControlView = [[FBSDKLikeControl alloc] initWithFrame:CGRectMake(10,290-40, 100, 30)];
            fbLikeControlView.likeControlStyle = FBSDKLikeControlStyleBoxCount;
            fbLikeControlView.objectID=[[arr_advertList objectAtIndex:indexPath.row]valueForKey:@"post_url"];
            NSLog(@"%@",[[arr_advertList objectAtIndex:indexPath.row]valueForKey:@"post_url"]);
            [tempcell.contentView addSubview:fbLikeControlView];

        }else{
            FBSDKLikeControl *fbLikeControlView = [[FBSDKLikeControl alloc] initWithFrame:CGRectMake(10,Frame_Y+120-50, 100, 30)];
            fbLikeControlView.likeControlStyle = FBSDKLikeControlStyleBoxCount;
            fbLikeControlView.objectID=[[arr_advertList objectAtIndex:indexPath.row]valueForKey:@"post_url"];
            NSLog(@"%@",[[arr_advertList objectAtIndex:indexPath.row]valueForKey:@"post_url"]);
            [tempcell.contentView addSubview:fbLikeControlView];
        }
       
    */
        
        
    }
    
    
    
    // Just want to test, so I hardcode the data
    return tempcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
//     {
//         [kAppDelegate goToLoginView];
//    }
//     else{
         SearchBar.hidden=YES;
         SearchBar.text=nil;
         [btn_serach setSelected:NO];
         [SearchBar resignFirstResponder];
         [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Nextpage"];
         
         DetailPostViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"detailpost"];
         
         if (isSearchBarApears==YES)
         {
             vc1.arr_detailpost=[filteredContentList objectAtIndex:indexPath.row];
         }
         else
         {
             isSearchBarApears=NO;
             vc1.arr_detailpost=[arr_advertList objectAtIndex:indexPath.row];
         }
         [self.navigationController pushViewController:vc1 animated:YES];
//     }
    
}
 - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  
    if ([scrollView.panGestureRecognizer translationInView:scrollView].y > 0)
    {
        NSLog(@"down");
        
    } else
    {
         NSLog(@"up");
        
            //[[AppManager sharedManager] showHUD:@"Loading..."];
        
            float bottomEdge = tableVW_post.contentOffset.y + tableVW_post.frame.size.height;
           // sectionHeight=tableVW_post.contentSize.height;
           sectionHeight=[self tableViewHeight];
           
            if (bottomEdge >= tableVW_post.contentSize.height)
            {
                [self NextPost:nil];
                
            }
    }
    
}





- (CGFloat)tableViewHeight
{
    [tableVW_post layoutIfNeeded];
    return [tableVW_post contentSize].height;
}

- (IBAction)NextPost:(id)sender
{
    if (isSearchBarApears==YES)
    {
        
    }
    else
    {
        page_count=page_count+1;
        if (!isStringEmpty(str_segmentTitle))
        {
            [self webServiceCategoryWiseDATA];
        }
        else
        {
            [self webServiceGetpost];
        }
    }
    
}
- (IBAction)PreviousPost:(id)sender
{
    if (page_count==0)
    {
        alert(@"Messgae", @"You are on First page");
    }
    else
    {
        
        if (isSearchBarApears==YES)
        {
            
        }
        else
        {
            page_count=page_count-1;
            
            if (!isStringEmpty(str_segmentTitle))
            {
                [self webServiceCategoryWiseDATA];
            }
            else
            {
                [self webServiceGetpost];
            }
        }
    }
}



-(void)FbLikeBtnAction:(id)sender
{
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
//    {
//        [kAppDelegate goToLoginView];
//    }
    
}

-(void)CommentVCPUSH:(id)sender
{
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
//    {
//        [kAppDelegate goToLoginView];
//    }
//    else
//    {
        SearchBar.hidden=YES;
        SearchBar.text=nil;
        [SearchBar resignFirstResponder];
        [btn_serach setSelected:NO];
        
        
        PrivateChat * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
        if (isSearchBarApears==YES)
        {
            vc1.arr_detailComment=[filteredContentList objectAtIndex:[sender tag]];
        }
        else
        {
            isSearchBarApears=NO;
            vc1.arr_detailComment=[arr_advertList objectAtIndex:[sender tag]];
        }
        [self.navigationController pushViewController:vc1 animated:YES];
//    }
    
}

-(void)LikeAction:(id)sender
{
    
//    indexPath1 = [NSIndexPath indexPathWithIndex:[sender tag]];
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
    {
        [kAppDelegate goToLoginView];
    }
    else
    {
        if (isSearchBarApears==YES)
        {
            str_PostID=[[filteredContentList objectAtIndex:[sender tag]]valueForKey:@"post_id"];
        }
        else
        {
            str_PostID=[[arr_advertList objectAtIndex:[sender tag]]valueForKey:@"post_id"];
        }
        
        //quenelle.fansfoot.com/mobile/web/?type=post_like&post_id=2&user_id=5204&status=1
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           @{
                                             @"type" :@"post_like",
                                             @"post_id" :str_PostID,
                                             @"user_id" :str_userID,
                                             @"status" :@"1"
                                             }];
        
        
        [[AppManager sharedManager] showHUD:@"Loading..."];
        
        // [appdelRef showProgress:@"Please wait.."];
        
        [[AppManager sharedManager] getDataForUrl:BASE_URL
                                       parameters:parameters
                                          success:^(AFHTTPRequestOperation *operation, id responseObject)
         
         {
             // Get response from server
             
             if (![[responseObject valueForKey:@"msg"] isEqualToString:@"Already like"])
             {
                 [[AppManager sharedManager]hideHUD];
                 NSMutableDictionary * dictTemp = [[arr_advertList objectAtIndex:[sender tag]] mutableCopy];
                 NSInteger likeCount = [[dictTemp valueForKey:@"total_like "] integerValue];
                 likeCount += 1;
                 [dictTemp setValue:[NSString stringWithFormat:@"%ld",(long)likeCount] forKey:@"total_like "];
                 [arr_advertList replaceObjectAtIndex:[sender tag] withObject:dictTemp];
                 
                 [tableVW_post reloadData];
             }
             else{
                 alert(@"Message", @"Already like");
                [[AppManager sharedManager]hideHUD];
                                      return;
             }
             
            




             
//             NSLog(@"JSON: %@", responseObject);
//             arr_like=responseObject;
//             
//             if ([responseObject count]>0)
//             {
//                 if ([[arr_like valueForKey:@"msg"] isEqualToString:@"like"])
//                 {
//                     
//
//                         for (int i=0; i<5; i++)
//                         {
//                             [arr_advertList removeLastObject];
//                         }
//
//                     
//                     [[AppManager sharedManager]hideHUD];
//                      isFromLike=YES;
//                     if (isLIKE==YES)
//                     {
//                         [self SearchWebservice];
//                     }
//                     else
//                     {
//                         [self getpostdataLIKE];
//                     }
//                     return;
//                     
//                 }
             
                 //else if ([[arr_like valueForKey:@"msg"] isEqualToString:@"Already like"])
//             if ([[arr_like valueForKey:@"msg"] isEqualToString:@"Already like"])
//                 {
//                     alert(@"Message", @"Already like");
//                     [[AppManager sharedManager]hideHUD];
//                     return;
//                 }
            // }
//             else
//             {
//                 str_segmentTitle=nil;
//                 alert(@"Alert", @"Null Data.");
//                 [[AppManager sharedManager]hideHUD];
//             }
             
         }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", @"No internet connection.");
             [[AppManager sharedManager]hideHUD];
             alert(@"Error", @"No internet connection.");
         }];
    }
}
-(void)UnlikeAction:(id)sender
{
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
    {
        [kAppDelegate goToLoginView];
    }
    else
    {
        if (isSearchBarApears==YES)
        {
            str_PostID=[[filteredContentList objectAtIndex:[sender tag]]valueForKey:@"post_id"];
        }
        else
        {
            str_PostID=[[arr_advertList objectAtIndex:[sender tag]]valueForKey:@"post_id"];
        }
        
        //quenelle.fansfoot.com/mobile/web/?type=post_like&post_id=2&user_id=5204&status=1
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           
                                           @{
                                             @"type" :@"post_like",
                                             @"post_id" :str_PostID,
                                             @"user_id" :str_userID,
                                             @"status" :@"0"
                                             }];
        
        [[AppManager sharedManager] showHUD:@"Loading..."];
        [[AppManager sharedManager] getDataForUrl:BASE_URL
                                       parameters:parameters
                                          success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             // Get response from server
             
             if (![[responseObject valueForKey:@"msg"] isEqualToString:@"Already unlike"])
             {
                 NSMutableDictionary * dictTemp = [[arr_advertList objectAtIndex:[sender tag]] mutableCopy];
                 NSInteger likeCount = [[dictTemp valueForKey:@"total_like "] integerValue];
                 likeCount -= 1;
                 [dictTemp setValue:[NSString stringWithFormat:@"%ld",(long)likeCount] forKey:@"total_like "];
                 [arr_advertList replaceObjectAtIndex:[sender tag] withObject:dictTemp];
                 
                 [tableVW_post reloadData];
                 [[AppManager sharedManager]hideHUD];
             }
             else{
                 alert(@"Message", @"Already unlike");
                [[AppManager sharedManager]hideHUD];
                return;
             }
             
             
//             NSLog(@"JSON: %@", responseObject);
//             arr_unlike=responseObject;
//             if ([responseObject count]>0)
//             {
//                 if ([[arr_unlike valueForKey:@"msg"] isEqualToString:@"unlike"])
//                 {
//                     [[AppManager sharedManager]hideHUD];
//                     isFromLike=YES;
//                     
//                     for (int i=0; i<5; i++)
//                     {
//                         [arr_advertList removeLastObject];
//                     }
//                     
//                     if (isLIKE==YES)
//                     {
//                         [self SearchWebservice];
//                     }
//                     else
//                     {
//                         [self getpostdataLIKE];
//                     }
//                     return;
//                     
//                 }
                // else if ([[arr_unlike valueForKey:@"msg"] isEqualToString:@"Already unlike"])
//              if ([[arr_unlike valueForKey:@"msg"] isEqualToString:@"Already unlike"])
//                 {
//                     alert(@"Message", @"Already unlike");
//                     [[AppManager sharedManager]hideHUD];
//                     return;
//                 }
            // }
             
//             else
//             {
//                 str_segmentTitle=nil;
//                 
//                 alert(@"Alert", @"Null Data.");
//                 [[AppManager sharedManager]hideHUD];
//                 
//             }
             
         }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             
             NSLog(@"Error: %@", @"No internet connection.");
             [[AppManager sharedManager]hideHUD];
             alert(@"Error", @"No internet connection.");
             
         }];
    }
    
    NSLog(@"%ld",(long)[sender tag]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webServiceCategoryWiseDATA
{
    //Add parameters to send server
    
     NSString *str_count=[NSString stringWithFormat:@"%ld",(long)page_count];
    //quenelle.fansfoot.com/web/?type=post_show&post_type=hot
    
    NSMutableDictionary *parameters;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
    {
       parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           @{
                                             @"type" :@"post_show",
                                             @"post_type" :str_segmentTitle,
                                             @"page" :str_count,
                                             @"device_token" :[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"],
                                             @"device_type"  :@"ios",
                                             @"USERID" :@""
                                             }];
    }else{
        parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           @{
                                             @"type" :@"post_show",
                                             @"post_type" :str_segmentTitle,
                                             @"page" :str_count,
                                             @"device_token" :[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"],
                                             @"device_type"  :@"ios",
                                             @"USERID" :[[NSUserDefaults standardUserDefaults]valueForKey:@"USERID"]
                                             }];
    }
    
   
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    [[AppManager sharedManager] getDataForUrl:BASE_URL
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, NSMutableDictionary * responseObject)
     
     {
         // Get response from server
         
         NSLog(@"JSON: %@", responseObject);
         arr_postsDATA=[responseObject objectForKey:@"post"];
         NSLog(@"---=Post==-=-data-=-=%@",arr_postsDATA);
         
         if ([responseObject count]>0)
         {
             NSInteger Status=[[[arr_postsDATA valueForKey:@"status"]objectAtIndex:0] integerValue];
             if(Status ==1)
             {
                 
             if ([[[arr_postsDATA valueForKey:@"type"]objectAtIndex:0] isEqualToString:str_ChannelParameter])
             {
                 //arr_advertList=arr_postsDATA;
                 [arr_advertList addObjectsFromArray:arr_postsDATA];
                 

                 [RefreshControl endRefreshing];
                 
                 if([arr_advertList count]>0)
                 {
                     [tableVW_post reloadData];
                     if (isFromLike==YES)
                     {
                         isFromLike=NO;
                     }
                     else
                     {
                         //[tableVW_post setContentOffset:CGPointMake(0, 0) animated:NO];
                     }
                 }
                 [[AppManager sharedManager]hideHUD];
                 return;
             }
                 
             }
             else if (Status==0)
             
             {
                 [RefreshControl endRefreshing];
                 str_segmentTitle=nil;
                 alert(@"Alert", @"No Post.");
                 page_count=page_count-1;
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
             }
             
         }
         
         else
         {
             [RefreshControl endRefreshing];
             str_segmentTitle=nil;
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
///////////////////new work on post notification////////////////

-(void)webServiceHotItemLoad
{
    //Add parameters to send server
    
    NSString *str_count=[NSString stringWithFormat:@"%ld",(long)page_count];
    //quenelle.fansfoot.com/web/?type=post_show&post_type=hot
    
    NSMutableDictionary *parameters;
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
    {
        parameters = [NSMutableDictionary dictionaryWithDictionary:
                      @{
                        @"type" :@"post_show",
                        @"post_type" :str_segmentTitle,
                        @"page" :str_count,
                        @"device_token" :[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"],
                        @"device_type"  :@"ios",
                        @"USERID" :@""

                        }];
    }else{
        parameters = [NSMutableDictionary dictionaryWithDictionary:
                      @{
                        @"type" :@"post_show",
                        @"post_type" :str_segmentTitle,
                        @"page" :str_count,
                        @"device_token" :[[NSUserDefaults standardUserDefaults]valueForKey:@"deviceToken"],
                        @"device_type"  :@"ios",
                        @"USERID" :[[NSUserDefaults standardUserDefaults]valueForKey:@"USERID"]
                        }];
    }
    
    
//    [[AppManager sharedManager] showHUD:@"Loading..."];
    [[AppManager sharedManager] getDataForUrl:BASE_URL
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, NSMutableDictionary * responseObject)
     
     {
         // Get response from server
         
         NSLog(@"JSON: %@", responseObject);
         arr_postsDATA=[responseObject objectForKey:@"post"];
         NSLog(@"---=Post==-=-data-=-=%@",arr_postsDATA);
         
         if ([responseObject count]>0)
         {
             NSInteger Status=[[[arr_postsDATA valueForKey:@"status"]objectAtIndex:0] integerValue];
             if(Status ==1)
             {
                 
                 if ([[[arr_postsDATA valueForKey:@"type"]objectAtIndex:0] isEqualToString:str_ChannelParameter])
                 {
                     //arr_advertList=arr_postsDATA;
                     [arr_advertList addObjectsFromArray:arr_postsDATA];
                     
                     
                     [RefreshControl endRefreshing];
                     
                     if([arr_advertList count]>0)
                     {
                         [tableVW_post reloadData];
                         if (isFromLike==YES)
                         {
                             isFromLike=NO;
                         }
                         else
                         {
                             //[tableVW_post setContentOffset:CGPointMake(0, 0) animated:NO];
                         }
                     }
                     [[AppManager sharedManager]hideHUD];
                     return;
                 }
                 
             }
             else if (Status==0)
                 
             {
                 [RefreshControl endRefreshing];
                 str_segmentTitle=nil;
                 alert(@"Alert", @"No Post.");
                 page_count=page_count-1;
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
             }
             
         }
         
         else
         {
             [RefreshControl endRefreshing];
             str_segmentTitle=nil;
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
///////////////////new work on post notification////////////////



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    UITextField *textField = [searchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeNever;
    
    if (searchText.length > 2)
    {
        isSearchBarApears=YES;
        
        filteredContentList=[[NSMutableArray alloc]init];
        
        //http://fansfoot.com/mobile/web/?type=search_post_show&key=pepsi
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                           
                                           @{
                                             
                                             @"type" :@"search_post_show",
                                             @"key" :searchText
                                             
                                             }];
        
        
        [[AppManager sharedManager] showHUD:@"Loading..."];
        
        // [appdelRef showProgress:@"Please wait.."];
        
        [[AppManager sharedManager] getDataForUrl:BASE_URL
         
                                       parameters:parameters
         
                                          success:^(AFHTTPRequestOperation *operation, id responseObject)
         
         {
             // Get response from server
             
             NSLog(@"JSON: %@", responseObject);
             
             filteredContentList=[responseObject objectForKey:@"post"];
             
             if ([responseObject count]>0)
             {
                 NSInteger Status=[[[filteredContentList valueForKey:@"status"]objectAtIndex:0] integerValue];
                 if(Status ==1)
                 {
                     [RefreshControl endRefreshing];
                     
                     if([filteredContentList count]>0)
                     {
                         isLIKE=YES;
                         
                         str_serachTXT=[NSString stringWithFormat:@"%@",searchText];
                         
                         [tableVW_post reloadData];
                     }
                     
                     [[AppManager sharedManager]hideHUD];
                     
                     return;
                 }
                 
                 else if (Status==0)
                     
                 {
                     str_segmentTitle=nil;
                     
                     alert(@"Alert", @"No Post.");
                     
                     [tableVW_post reloadData];


                     
                     [[AppManager sharedManager]hideHUD];
                     
                     return;
                 }
             }
             
             else
             {
                 str_segmentTitle=nil;
                 
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
        

//          NSPredicate *bPredicate =
//         //[NSPredicate predicateWithFormat:@"SELF contains[cd]%@", SearchBar.text];
//        [NSPredicate predicateWithFormat:@"tital CONTAINS[cd] %@",
//         SearchBar.text];
//         filteredContentList=[arr_advertList filteredArrayUsingPredicate:bPredicate];
//         [tableVW_post reloadData];
        
    }
    else
    {
        filteredContentList=[[NSMutableArray alloc]init];
//        filteredContentList=arr_advertList;
//        [tableVW_post reloadData];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [SearchBar setShowsCancelButton:YES animated:YES];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //  searchdata=NO;
    //[_tableview reloadData];
    isSearchBarApears=NO;
    isLIKE=NO;

//    arr_advertList=[[NSMutableArray alloc]init];
//    filteredContentList=arr_advertList;
    [tableVW_post reloadData];
    [btn_serach setSelected:NO];
    [SearchBar setText:@""];
    SearchBar.hidden=YES;
    [SearchBar setShowsCancelButton:NO animated:YES];
    [SearchBar resignFirstResponder];
    
}

- (IBAction)searchAction:(id)sender
{
    if ([btn_serach isSelected]==YES)
    {
        isSearchBarApears=NO;
        [tableVW_post reloadData];
        isLIKE=NO;
        SearchBar.hidden=YES;
//        [sender setSelected:NO];
        [btn_serach setSelected:NO];
        [SearchBar setText:@""];
        [SearchBar resignFirstResponder];
    }
    else
    {
       SearchBar.hidden=NO;
//       [sender setSelected:YES];
        [btn_serach setSelected:YES];
    }
}


-(void)getSearchPost
{

}


/*
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    tableVW_post = (UITableView*)scrollView;
    NSIndexPath *indexPathOfTopRowAfterScrolling = [tableVW_post indexPathForRowAtPoint:
                                                    *targetContentOffset
                                                    ];
    CGRect rectForTopRowAfterScrolling = [tableVW_post rectForRowAtIndexPath:
                                          indexPathOfTopRowAfterScrolling
                                          ];
    targetContentOffset->y=rectForTopRowAfterScrolling.origin.y;
   
    if(rectForTopRowAfterScrolling.origin.y < 0)
    {
            if ([arr_advertList count]==10)
            {
                
                //[self webServiceGetpost];
            }
        }
    
        else
    {
        // react to dragging down
        NSLog(@"no action");
    }

}*/


// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    // switch the indicator when more than 50% of the previous/next page is visible
//    if (scrollView==tableVW_post)
//    {
//        
//        //    CGFloat pageHeight = CGRectGetHeight(obj_scrollView.frame);
//        //    NSUInteger page = floor((obj_scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
//        
//        float bottomEdge = tableVW_post.contentOffset.y + tableVW_post.frame.size.height;
//        if (bottomEdge >= tableVW_post.contentSize.height)
//        {
//            [self loadScrollViewWithPage];
//            // we are at the end
//        }
//        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//        
//        
//    }
//    // a possible optimization would be to unload the views+controllers which are no longer visible
//}
//- (void)loadScrollViewWithPage
//{
//    if (isSearchBarApears==YES)
//    {
//        
//    }
//    else
//    {
//    page_count=page_count+1;
//    
//    if (!isStringEmpty(str_segmentTitle))
//    {
//        [self webServiceCategoryWiseDATA];
//    }
//    else
//    {
//        [self webServiceGetpost];
//    }
//    }
//}

#pragma mark --Refresh Action--
-(void)handleRefreshComments:(UIRefreshControl*)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating..."];
    //refresh your data here
    NSString *lastupdated=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"update"]];
    if ((lastupdated.length!=0)&&(![lastupdated isEqualToString:@"null"])&&(lastupdated!=[NSNull class])&&(![lastupdated isEqualToString:@"(null)"])&&(![lastupdated isEqualToString:@"<null>"])&&(![lastupdated isEqualToString:@""]))
    {
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastupdated];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *updated = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    [[NSUserDefaults standardUserDefaults]setValue:updated forKey:@"update"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if (isSearchBarApears==YES)
    {
        //[refreshControl endRefreshing];
    }
    else
    {

    if (!isStringEmpty(str_segmentTitle))
    {
        page_count=0;
        arr_advertList=[NSMutableArray new];
        [self webServiceCategoryWiseDATA];
    
    }
        
    else
    {
       [RefreshControl endRefreshing];
   // [self webServiceGetpost];
    
    }
        
    }
}

- (IBAction)RefreshPostList:(id)sender
{
    if (isSearchBarApears==YES)
    {
        
    }
    else
    {
    
    if (!isStringEmpty(str_segmentTitle))
    {

        [self webServiceCategoryWiseDATA];
    }
    else
    {

        [self webServiceGetpost];
    }
    }
}

-(void)getpostdataLIKE
{
    if (isSearchBarApears==YES)
    {
        
    }
    else
    {
        if (!isStringEmpty(str_segmentTitle))
        {
            [self webServiceCategoryWiseDATA];
        }
        else
        {
            [self webServiceGetpost];
        }
    }
}


- (IBAction)HotButtonAction:(id)sender
{
    [tableVW_post setContentOffset:CGPointMake(0, 0) animated:NO];
    arr_NextpagePOst=[NSMutableArray new];
    arr_advertList=[NSMutableArray new];
    [tableVW_post reloadData];
    
    if ([[sender currentTitle] isEqual:@"Hot"])
    {
        NSLog(@"hot");
        
        page_count=0;

        [btn_hot setBackgroundImage:[UIImage imageNamed:@"left-active"] forState:UIControlStateNormal];
        [sender setSelected:YES];
        
        [btn_tranding setBackgroundImage:[UIImage imageNamed:@"center-inactive"] forState:UIControlStateNormal];
        
        [btn_frsh setBackgroundImage:[UIImage imageNamed:@"right-inactive"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        
        str_segmentTitle=@"hot";
        str_ChannelParameter=@"post_show";

        [self webServiceCategoryWiseDATA];


    }
    
    else if ([[sender currentTitle] isEqual:@"Trending"])
    {
        NSLog(@"tranding");
        page_count=0;

        
        [btn_hot setBackgroundImage:[UIImage imageNamed:@"left-inactive"] forState:UIControlStateNormal];
        [sender setSelected:YES];
        [btn_tranding setBackgroundImage:[UIImage imageNamed:@"center-active"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        [btn_frsh setBackgroundImage:[UIImage imageNamed:@"right-inactive"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        
        str_segmentTitle=@"trendings";
        str_ChannelParameter=@"post_show";

        [self webServiceCategoryWiseDATA];


    }
    
    else if ([[sender currentTitle] isEqual:@"Fresh"])
    {
        NSLog(@"fresh");
        
        page_count=0;

        [btn_hot setBackgroundImage:[UIImage imageNamed:@"left-inactive"] forState:UIControlStateNormal];
        [sender setSelected:YES];
        [btn_tranding setBackgroundImage:[UIImage imageNamed:@"center-inactive"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        [btn_frsh setBackgroundImage:[UIImage imageNamed:@"right_active"] forState:UIControlStateNormal];
        [sender setSelected:NO];
        
        str_segmentTitle=@"fresh";
        str_ChannelParameter=@"post_show";

        [self webServiceCategoryWiseDATA];

    }
    
    
}

-(void)SearchWebservice
{
    isSearchBarApears=YES;
    filteredContentList=[[NSMutableArray alloc]init];
    
    //http://fansfoot.com/mobile/web/?type=search_post_show&key=pepsi
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       @{
                                         @"type" :@"search_post_show",
                                         @"key" :str_serachTXT
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    [[AppManager sharedManager] getDataForUrl:BASE_URL
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         NSLog(@"JSON: %@", responseObject);
         
         filteredContentList=[responseObject objectForKey:@"post"];
         
         if ([responseObject count]>0)
         {
             NSInteger Status=[[[filteredContentList valueForKey:@"status"]objectAtIndex:0] integerValue];
             if(Status ==1)
             {
                 [RefreshControl endRefreshing];
                 
                 if([filteredContentList count]>0)
                 {
                     isLIKE=YES;
                     [tableVW_post reloadData];
                 }
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
             }
             
             else if (Status==0)
                 
             {
                 str_segmentTitle=nil;
                 alert(@"Alert", @"No Post.");
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
             }
         }
         
         else
         {
             str_segmentTitle=nil;
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

//- (IBAction)segmentValueChanged:(id)sender
//{
//
//    if (Home_segment.selectedSegmentIndex==1)
//    {
//        str_segmentTitle=@"hot";
//    }
//    else if (Home_segment.selectedSegmentIndex==2)
//    {
//        str_segmentTitle=@"trendings";
//    }
//    else
//    {
//        str_segmentTitle=@"fresh";
//    }
//    str_ChannelParameter=@"post_show";
//    
//    [self webServiceCategoryWiseDATA];
//}


/*- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == tableVW_post)
    {
        CGFloat scrollPosition = tableVW_post.contentSize.height - tableVW_post.frame.size.height - tableVW_post.contentOffset.y;
        NSLog(@"%f",scrollPosition);
        if (scrollPosition < 30)// you can set your value
        {
                [self handleRefreshComments:RefreshControl];
            [tableVW_post setTableFooterView:RefreshControl];

            
        }
    }
}*/


//Add parameters to send server

//    NSLog(@"%@",filteredContentList);
//
//    NSString *str_count=[NSString stringWithFormat:@"%ld",(long)page_count];
//
//    //quenelle.fansfoot.com/web/?type=post_show&post_type=hot
//
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
//
//                                       @{
//
//                                         @"type" :@"post_show",
//                                         @"post_type" :@"",
//                                         @"page" :str_count
//
//                                         }];
//
//
//    [[AppManager sharedManager] showHUD:@"Loading..."];
//
//    // [appdelRef showProgress:@"Please wait.."];
//
//    [[AppManager sharedManager] getDataForUrl:BASE_URL
//
//                                   parameters:parameters
//
//                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
//
//     {
//         // Get response from server
//
//         NSLog(@"JSON: %@", responseObject);
//
//         arr_postsDATA=[responseObject objectForKey:@"post"];
//
//         if ([responseObject count]>0)
//         {
//             NSInteger Status=[[[arr_postsDATA valueForKey:@"status"]objectAtIndex:0] integerValue];
//
//             if(Status == 1)
//             {
//
//             if ([[[arr_postsDATA valueForKey:@"type"]objectAtIndex:0] isEqualToString:@"post_show"])
//             {
//                str_segmentTitle=nil;
//
//                arr_advertList=arr_postsDATA;
//
//                 filteredContentList=arr_advertList;
//
//                 [RefreshControl endRefreshing];
//
//                     if([arr_advertList count]>0)
//                     {
//                         [tableVW_post reloadData];
//                     }
//
//                     [[AppManager sharedManager]hideHUD];
//
//                     return;
//
//             }
//
//             }
//                 else if (Status == 0)
//                 {
//                     str_segmentTitle=nil;
//
//                     alert(@"Alert", @"No Post.");
//
//                     [[AppManager sharedManager]hideHUD];
//
//                     return;
//                 }
//
//             }
//
//         else
//         {
//             str_segmentTitle=nil;
//
//             alert(@"Alert", @"Null Data.");
//             [[AppManager sharedManager]hideHUD];
//
//         }
//
//         }
//
//        failure:^(AFHTTPRequestOperation *operation, NSError *error)
//
//     {
//
//         NSLog(@"Error: %@", @"No internet connection.");
//
//         // [appdelRef hideProgress];
//         [[AppManager sharedManager]hideHUD];
//
//         alert(@"Error", @"");
//
//     }];

@end
