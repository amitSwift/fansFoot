//
//  CategoryPostViewController.m
//  FAnsfoot
//
//  Created by Pankaj Sharma on 04/06/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "CategoryPostViewController.h"
#import "AppDelegate.h"
#import "CategoryPostTableViewCell.h"
#import "AppManager.h"
#import "DetailPostViewController.h"
#import "PrivateChat.h"
#import "PlayYoutubeVideoVC.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>


@interface CategoryPostViewController ()
{
      float sectionHeight;
}
@property (strong, nonatomic) IBOutlet UITextView *AddTextView;

@end

@implementation CategoryPostViewController
@synthesize titlename,isShow;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bannerView.adUnitID = @"ca-app-pub-2063088545096347/2934377089";
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];
    
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];

    page_count=0;
    
    RefreshControl = [[UIRefreshControl alloc] init];
    RefreshControl.tintColor = [UIColor grayColor];
    [RefreshControl addTarget:self action:@selector(handleRefreshComments:) forControlEvents:UIControlEventValueChanged];
    [tableVW_post addSubview:RefreshControl];
    [tableVW_post sendSubviewToBack:RefreshControl];
    
    arr_advertList=[[NSMutableArray alloc]init];
    arr_Images =[[NSMutableArray alloc]init];
    
           NameofScreen.text=titlename;
        
        if (IS_IPHONE_5)
        {
            tableVW_post.frame=CGRectMake(0, 108, 320, 395);
        }
        else if (IS_IPHONE_6)
        {
            tableVW_post.frame=CGRectMake(0, 108, 375, 500);
            
        }
        else if (IS_IPHONE_6_PLUS)
        {
            tableVW_post.frame=CGRectMake(0, 108, 414, 500);
            
        }
    
    tableVW_post.backgroundColor=[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
    if (isShow==YES)
    {
        back_btn.hidden=NO;
    }else{
        back_btn.hidden=YES;
    }
    [self loadAddress];
    
    // Do any additional setup after loading the view, typically from a nib.
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

- (IBAction)NextPost:(id)sender
{
    if (isSearchBarApears==YES) {
        
    }
    else
    {
        //[tableVW_post setContentOffset:CGPointMake(0, 0) animated:NO];

        page_count=page_count+1;
        [self webServiceCategoryWiseDATA];
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
            //[tableVW_post setContentOffset:CGPointMake(0, 0) animated:NO];

            page_count=page_count-1;
            [self webServiceCategoryWiseDATA];
        }
        
        }
}

- (IBAction)backButtonAction:(id)sender
{
    str_segmentTitle=nil;
    
     [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    page_count=0;
    [tableVW_post setContentOffset:CGPointMake(0, 0) animated:NO];
    
    btn_privious.layer.cornerRadius=5.0f;
    btn_privious.clipsToBounds=YES;
    
    btn_next.layer.cornerRadius=5.0f;
    btn_next.clipsToBounds=YES;
    
    arr_unlike=[[NSMutableArray alloc]init];
    arr_like=[[NSMutableArray alloc]init];
    arr_serchResult=[[NSMutableArray alloc]init];
    
    self.tabBarController.tabBar.hidden=NO;

    arr_postsDATA=[[NSMutableArray alloc]init];
    
    arr_NextpagePOst=[[NSMutableArray alloc]init];

    [AppManager sharedManager].navCon = self.navigationController;
    
    [proxyService sharedProxy].delegate = self;

}
-(void)viewDidAppear:(BOOL)animated
{
    isSearchBarApears=NO;
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Nextpage"]==YES)
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Nextpage"];

        str_segmentTitle=[titlename lowercaseString];
        
        str_ChannelParameter=@"channels";
    
        [self webServiceCategoryWiseDATA];
    }
    else
    {
        str_segmentTitle=[titlename lowercaseString];
        
        str_ChannelParameter=@"channels";
        
        [self webServiceCategoryWiseDATA];

    }
    
    [self getBANNER];
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
             [[AppManager sharedManager]hideHUD];
             
         }
         else
         {
             alert(@"Alert", @"Null Data.");
             [[AppManager sharedManager]hideHUD];
             
         }
     }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", @"No internet connection.");
         [[AppManager sharedManager]hideHUD];
        // alert(@"Error", @"No internet connection.");
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
    static NSString *cellIdentifier = @"CategoryPostTableViewCell";
    // Similar to UITableViewCell, but
    CategoryPostTableViewCell *tempcell = (CategoryPostTableViewCell *)[tableVW_post dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (tempcell == nil)
    {
        
        tempcell = [[CategoryPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        tempcell = (CategoryPostTableViewCell *)[nib objectAtIndex:0];
        
        tempcell.selectionStyle = UITableViewCellSelectionStyleNone;
        tempcell.selectionStyle=UITableViewCellAccessoryNone;
        
        NSLog(@"%@",NameofScreen.text);
        if ([NameofScreen.text isEqualToString:@"Videos"])
        {
            tempcell.isYoutubeVideo=YES;
        }else{
            tempcell.isYoutubeVideo=NO;
        }

        if (isSearchBarApears==YES)
        {
            [tempcell loaditemwithCategoryListArray:[filteredContentList objectAtIndex:indexPath.row]];
            
        }
        else
        {
            [tempcell loaditemwithCategoryListArray:[arr_advertList objectAtIndex:indexPath.row]];
            
        }

        tempcell.btn_Like.tag=indexPath.row;
        tempcell.btn_Unlike.tag=indexPath.row;
        [tempcell.Btn_Comment addTarget:self action:@selector(CommentVCPUSH:) forControlEvents:UIControlEventTouchUpInside];
        [tempcell.btn_Like addTarget:self action:@selector(LikeAction:) forControlEvents:UIControlEventTouchUpInside];
        [tempcell.btn_Unlike addTarget:self action:@selector(UnlikeAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return tempcell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
    {
        [kAppDelegate goToLoginView];
    }
    else
    {
        if ([NameofScreen.text isEqualToString:@"Videos"])
        {
        }
        else
        {
            SearchBar.text=nil;
            [SearchBar resignFirstResponder];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Nextpage"];
            
            DetailPostViewController * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"detailpost"];
            //PlayYoutubeVideoVC * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayYoutubeVideoVC"];
            
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
        }

    }

    

    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)CommentVCPUSH:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==NO)
    {
        [kAppDelegate goToLoginView];
    }
    else
    {
        isSearchBarApears=NO;
        SearchBar.text=nil;
        [SearchBar resignFirstResponder];
        
        PrivateChat * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
        
        if (isSearchBarApears==YES)
        {
            vc1.arr_detailComment=[filteredContentList objectAtIndex:[sender tag]];
            vc1.Fromcategory=YES;
            [[NSUserDefaults standardUserDefaults]setObject:str_segmentTitle forKey:@"Previouscategory"];
        }
        
        else
        {
            vc1.arr_detailComment=[arr_advertList objectAtIndex:[sender tag]];
            vc1.Fromcategory=YES;
            [[NSUserDefaults standardUserDefaults]setObject:str_segmentTitle forKey:@"Previouscategory"];
            
        }
        [self.navigationController pushViewController:vc1 animated:YES];

    }
    
    
 }


-(void)LikeAction:(id)sender
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

             
             
            /*
             NSLog(@"JSON: %@", responseObject);
             
             arr_like=responseObject;
             
             if ([responseObject count]>0)
             {
                 
                 if ([[arr_like valueForKey:@"msg"] isEqualToString:@"like"])
                 {
                     
                     [[AppManager sharedManager]hideHUD];
                     
                     if (isLIKE==YES)
                     {
                         [self SearchWebservice];
                     }
                     else
                     {
                         [self getLikeData];
                     }
                     
                     return;
                 }
                 
                 
                 else if ([[arr_like valueForKey:@"msg"] isEqualToString:@"Already like"])
                 {
                     alert(@"Message", @"Already like");
                     [[AppManager sharedManager]hideHUD];
                     
                     return;
                 }
             }
             
             else
             {
                 str_segmentTitle=nil;
                 
                 alert(@"Alert", @"Null Data.");
                 [[AppManager sharedManager]hideHUD];
                 
             }*/
             
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
        
        // [appdelRef showProgress:@"Please wait.."];
        
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

             
             
           /*  NSLog(@"JSON: %@", responseObject);
             
             arr_unlike=responseObject;
             
             if ([responseObject count]>0)
             {
                 
                 if ([[arr_unlike valueForKey:@"msg"] isEqualToString:@"unlike"])
                 {
                     [[AppManager sharedManager]hideHUD];
                     
                     if (isLIKE==YES)
                     {
                         [self SearchWebservice];
                     }
                     else
                     {
                         [self getLikeData];
                     }
                     
                     return;
                     
                 }
                 else if ([[arr_unlike valueForKey:@"msg"] isEqualToString:@"Already unlike"])
                 {
                     alert(@"Message", @"Already unlike");
                     [[AppManager sharedManager]hideHUD];
                     
                     return;
                 }
             }
             
             else
             {
                 str_segmentTitle=nil;
                 alert(@"Alert", @"Null Data.");
                 [[AppManager sharedManager]hideHUD];
             }*/
             
         }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             NSLog(@"Error: %@", @"No internet connection.");
             [[AppManager sharedManager]hideHUD];
             alert(@"Error", @"No internet connection.");
             
         }];

    }
    
}



-(void)webServiceCategoryWiseDATA
{
    NSString *str_count=[NSString stringWithFormat:@"%ld",(long)page_count];
    
    if ([str_segmentTitle isEqualToString:@"animated gif"])
    {
        str_segmentTitle=@"animated-gif";
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       @{
                                         @"type" :@"channels",
                                         @"post_type" :str_segmentTitle,
                                         @"page" :str_count
                                         }];
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    [[AppManager sharedManager] getDataForUrl:BASE_URL
                                   parameters:parameters
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         
         NSLog(@"category data----->>>>>> %@", responseObject);
         arr_postsDATA=[responseObject objectForKey:@"post"];
         NSLog(@"%@",arr_postsDATA);
         
         if ([responseObject count]>0)
         {
             
            
             NSInteger Status=[[[arr_postsDATA valueForKey:@"status"]objectAtIndex:0] integerValue];
             //NSInteger Status=[[arr_postsDATA valueForKey:@"status"] integerValue];
             if(Status ==1)
             {
                 if ([[[arr_postsDATA valueForKey:@"type"]objectAtIndex:0] isEqualToString:str_ChannelParameter])
                 {
                     [[NSUserDefaults standardUserDefaults]setObject:str_segmentTitle forKey:@"CategoryName"];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     
                     //arr_advertList=arr_postsDATA;
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
                     }
                     
                     
                     [[AppManager sharedManager]hideHUD];
                     
                     return;
            }
        }
             else if (Status==0)
                 
             {
                 [RefreshControl endRefreshing];
                 page_count=page_count-1;
                 alert(@"Alert", @"No Post.");
                 [[AppManager sharedManager]hideHUD];
                 
                 return;
             }
             
         }
         
         else
         {
             [RefreshControl endRefreshing];

             alert(@"Alert", @"Null Data.");
             [[AppManager sharedManager]hideHUD];
             
         }
         
     }
     
                failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"Error: %@", @"No internet connection.");
         
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Error", @"No internet connection.");
         
     }];
    
}


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
                     isLIKE=YES;
                     [RefreshControl endRefreshing];
                     if([filteredContentList count]>0)
                     {
                         [tableVW_post reloadData];
                         str_serachTXT=[NSString stringWithFormat:@"%@",searchText];
                     }
                     [[AppManager sharedManager]hideHUD];
                     return;
                 }
                 
                 else if (Status==0)
                 {
                     alert(@"Alert", @"No Post.");
                     [tableVW_post reloadData];
                     [[AppManager sharedManager]hideHUD];
                     
                     return;
                 }
             }
             else
             {
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
    else
    {
        filteredContentList=[[NSMutableArray alloc]init];
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
    isSearchBarApears=NO;
    isLIKE=NO;
    [tableVW_post reloadData];
    
    [SearchBar setText:@""];
    [SearchBar setShowsCancelButton:NO animated:YES];
    [SearchBar resignFirstResponder];
}



/*- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
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
            coount=coount+1;
            [self webServiceCategoryWiseDATA];
        }
    }
    
    else
    {
        // react to dragging down
        NSLog(@"no action");
    }
    
}*/


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
        [refreshControl endRefreshing];
    }
    else
    {
    if (!isStringEmpty(str_ChannelParameter))
    {
        
        [self webServiceCategoryWiseDATA];
    }
    }
}
- (IBAction)RefreshCategoryPostList:(id)sender
{
    if (isSearchBarApears==YES)
    {
        
    }
    else
    {
        [self webServiceCategoryWiseDATA];
    }
}

-(void)getLikeData
{
    [self webServiceCategoryWiseDATA];

    
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
         [[AppManager sharedManager]hideHUD];
         
         alert(@"Error", @"No internet connection.");
         
     }];
    
}




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
//    if (isSearchBarApears==YES) {
//        
//    }
//    else
//    {
//    page_count=page_count+1;
//    [self webServiceCategoryWiseDATA];
//    }
//    
//}



@end
