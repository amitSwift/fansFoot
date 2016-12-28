//
//  PrivateChat.m
//  Havoc
//
//  Created by Preeti Malhotra on 7/26/14.
//  Copyright (c) 2014 Preeti Malhotra. All rights reserved.
//

#import "PrivateChat.h"
#define myfont @"Verdana"
#import "PrivateTWcell.h"
#import "AsyncImageView.h"
#import "AppManager.h"
#import "CategoryPostViewController.h"
#import <Social/Social.h>
#import "PlaceholderTextView.h"


#define kSEARCH_RESULT_LOCATION_KEY @"searchResultLocationKey"
#define kSEARCH_RESULT_CONTEXT_STRING_KEY @"searchResultContextStringKey"
#define kSEARCH_RESULT_CONTEXT_LOCATION_KEY @"searchResultContextLocationKey"
#define kSEARCH_RESULT_LOCATION_IN_CONTEXT_KEY @"searchResultLocationInContextKey"
#define CHAR_COUNT_PRECEDING_RESULT 0
#define CHAR_COUNT_FOLLOWING_RESULT 0

@interface PrivateChat ()

@end

@implementation PrivateChat

@synthesize str_post_id,Fromcategory,arr_detailComment;

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [_txtx_view resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bannerView.adUnitID = @"ca-app-pub-2063088545096347/2934377089";
    bannerView.rootViewController = self;
    [bannerView loadRequest:[GADRequest request]];
    
    activityIndicator = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:activityIndicator];
    activityIndicator.labelText = @"Please wait...";
    [activityIndicator show:YES];

    
    
    btn_send.layer.cornerRadius=5.0f;
    btn_send.clipsToBounds=YES;
    
    _txtx_view.placeholder = @"write a comment";
    _txtx_view.font=[UIFont fontWithName:@"System" size:18.0];
   _txtx_view.placeholderColor = [UIColor  blackColor];
    
    arr_comment=[[NSMutableArray alloc]init];

    _txtx_view.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtx_view.layer.cornerRadius=5;
    _txtx_view.clipsToBounds=YES;
    _txtx_view.delegate=self;

    
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    [self scrollToBottom];

    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
   [activityIndicator hide:YES];

    
}
//-(void)retrivechat
//{
//    //Add parameters to send server
//    
//    
//    //quenelle.fansfoot.com/web/?type=post_show&post_type=hot
//    
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
//                                       
//                                       @{
//                                         
//                                         @"type" :@"show_comments",
//                                         @"post_id" :str_post_id
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
//         if ([responseObject count]>0)
//         {
//             NSInteger Status=[[[[responseObject objectForKey:@"post"]valueForKey:@"status"]objectAtIndex:0] integerValue];
//             if(Status ==1)
//             {
//                 
//                 if ([[[[responseObject objectForKey:@"post"]valueForKey:@"type"]objectAtIndex:0] isEqualToString:@"show_comments"])
//                 {
//                     
//                     
//                     arr_comment=[responseObject objectForKey:@"post"];
//                     
//                     [chattable reloadData];
//                     [self scrollToBottom];
//                     chattable.hidden=NO;
//
//                     
//                     [[AppManager sharedManager]hideHUD];
//                     
//                     return;
//                     
//                 }
//                 
//             }
//             else if (Status==0)
//                 
//             {
//                 
////                 alert(@"Alert", @"No Comments.");
//
//                 
//                 [[AppManager sharedManager]hideHUD];
//                 
//                 return;
//             }
//             
//         }
//         
//         else
//         {
//             
//             alert(@"Alert", @"Null Data.");
//             [[AppManager sharedManager]hideHUD];
//             
//         }
//         
//     }
//     
//                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     
//     {
//         
//         NSLog(@"Error: %@", @"No internet connection.");
//         
//         // [appdelRef hideProgress];
//         [[AppManager sharedManager]hideHUD];
//         
//         alert(@"Error", @"No internet connection.");
//         
//     }];
//    
//    
//}
-(void)viewWillAppear:(BOOL)animated
{
    chattable.hidden=YES;
    self.tabBarController.tabBar.hidden=YES;
    [AppManager sharedManager].navCon = self.navigationController;
    [self scrollToBottom];
    
    NSString *str_comment=[arr_detailComment valueForKey:@"fbCommnetUrl"];
    [WebVW loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str_comment]]];
    [[proxyService sharedProxy] showActivityIndicatorInView:self.view withLabel:@"Loading.."];
}

-(void)viewDidAppear:(BOOL)animated
{
    
//    [self retrivechat];
    
    
   

}

-(void)dismissKeyboard
{
    [_txtx_view endEditing:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
  navigationType:(UIWebViewNavigationType)navigationType
{
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    if (conn == nil) {
        NSLog(@"cannot create connection");
    }
    [activityIndicator hide:YES];
    [[proxyService sharedProxy] hideActivityIndicatorInView];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arr_comment count];
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    static NSString *kSourceCellID = @"PrivateTWcell";
//    PrivateTWcell* cell = [tableView dequeueReusableCellWithIdentifier:kSourceCellID];
//    if(cell == nil)
//    {
//        cell = [[PrivateTWcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCellID];
//    }
    
//    static NSString *kSourceCellID = @"PrivateTWcell";
//    PrivateTWcell* cell = [tableView dequeueReusableCellWithIdentifier:kSourceCellID];
//    if(cell == nil)
//    {
//         cell = [[PrivateTWcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCellID];
//         cell.lbl_likes.frame=CGRectMake(274, cell.CellMessage_lbl.frame.size.height+3, 30, 20);
//         cell.Like_imageVW.frame=CGRectMake(251, cell.CellMessage_lbl.frame.size.height+3, 16, 14);
//    }
//
//    size = [[arr_comment valueForKey:@"comments"][indexPath.row] sizeWithFont:cell.CellMessage_lbl.font constrainedToSize:CGSizeMake(225, 99999)];
//    cell.CellMessage_lbl.frame = CGRectMake(5, 8, cell.CellMessage_lbl.frame.size.width, size.height);
//
//    cell.CellMessage_lbl.numberOfLines = size.height/cell.CellMessage_lbl.font.lineHeight;
//    cell.CellMessage_lbl.text =  [[arr_comment valueForKey:@"comments"] objectAtIndex:indexPath.row];
//    
//    
//    cell.lbl_likes.text=[NSString stringWithFormat:@"%@",[[arr_comment valueForKey:@"total_like "]objectAtIndex:indexPath.row]];
    
    
    
    
    
    
    
    //    static NSString *kSourceCellID = @"DetailPostTableCell";
    //
    //    DetailPostTableCell* cell = [tableView dequeueReusableCellWithIdentifier:kSourceCellID];
    //
    //    if(cell == nil)
    //    {
    //        cell = [[DetailPostTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCellID];
    //
    ////        cell.lbl_likes.frame=CGRectMake(274, cell.CellMessage_lbl.frame.size.height, 30, 20);
    ////        cell.Like_imageVW.frame=CGRectMake(251, cell.CellMessage_lbl.frame.size.height, 16, 14);
    ////        cell.lbl_person_name.frame=CGRectMake(5, cell.CellMessage_lbl.frame.origin.y-3, 200, 10);
    //
    //
    //    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setUserInteractionEnabled:NO];
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    for(UIView *cellView in [cell.contentView subviews])
    {
        if (![cellView isKindOfClass:[UIImageView class]] || ![cellView isKindOfClass:[UILabel class]] || ![cellView isKindOfClass:[UIButton class]])
        {
            [cellView removeFromSuperview];
        }
    }
    
    
    UILabel  * msg_lbl=[[UILabel alloc] init];
    msg_lbl.backgroundColor = [UIColor clearColor];
    msg_lbl.textColor = [UIColor blackColor];
    msg_lbl.font=[UIFont fontWithName:@"Helvetica" size:15.0];
    [cell.contentView addSubview:msg_lbl];
    
    UILabel  * lbl_likes=[[UILabel alloc] init];
    lbl_likes.backgroundColor = [UIColor clearColor];
    lbl_likes.textColor = [UIColor blackColor];
    lbl_likes.font=[UIFont fontWithName:@"Helvetica" size:15.0];
    [cell.contentView addSubview:lbl_likes];
    
    UIImageView *  personImgVw = [[UIImageView alloc]init];
    [personImgVw setImage:[UIImage imageNamed:@"like-icon"]];
    [cell.contentView addSubview:personImgVw];
    
    if (IS_IPHONE_5)
    {
        UILabel  * namelbl=[[UILabel alloc] init];
        namelbl.frame = CGRectMake(6 , 4, 298, 14);
        namelbl.backgroundColor = [UIColor clearColor];
        namelbl.textColor = [UIColor blackColor];
        namelbl.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:namelbl];
        
        
        size = [[arr_comment valueForKey:@"comments"][indexPath.row] sizeWithFont:msg_lbl.font constrainedToSize:CGSizeMake(225, 99999)];
        
        msg_lbl.numberOfLines = size.height/msg_lbl.font.lineHeight;
        
        msg_lbl.frame = CGRectMake(5, namelbl.frame.size.height+8, 300, size.height);
        
        msg_lbl.text =  [[arr_comment valueForKey:@"comments"] objectAtIndex:indexPath.row];
        
        namelbl.text=[[arr_comment valueForKey:@"username"] objectAtIndex:indexPath.row];
        
        lbl_likes.text=[NSString stringWithFormat:@"%@",[[arr_comment valueForKey:@"total_like "]objectAtIndex:indexPath.row]];
        
        personImgVw.frame=CGRectMake(251, msg_lbl.frame.size.height+11, 16, 14);
        lbl_likes.frame=CGRectMake(274, msg_lbl.frame.size.height+11, 30, 20);
        
    }
    else if (IS_IPHONE_6)
    {
        UILabel  * namelbl=[[UILabel alloc] init];
        namelbl.frame = CGRectMake(6 , 4, 298, 14);
        namelbl.backgroundColor = [UIColor clearColor];
        namelbl.textColor = [UIColor blackColor];
        namelbl.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:namelbl];
        
        
        size = [[arr_comment valueForKey:@"comments"][indexPath.row] sizeWithFont:msg_lbl.font constrainedToSize:CGSizeMake(225, 99999)];
        
        msg_lbl.numberOfLines = size.height/msg_lbl.font.lineHeight;
        
        msg_lbl.frame = CGRectMake(5, namelbl.frame.size.height+8, 350, size.height);
        
        msg_lbl.text =  [[arr_comment valueForKey:@"comments"] objectAtIndex:indexPath.row];
        
        namelbl.text=[[arr_comment valueForKey:@"username"] objectAtIndex:indexPath.row];
        
        lbl_likes.text=[NSString stringWithFormat:@"%@",[[arr_comment valueForKey:@"total_like "]objectAtIndex:indexPath.row]];
        
        personImgVw.frame=CGRectMake(291, msg_lbl.frame.size.height+11, 16, 14);
        lbl_likes.frame=CGRectMake(314, msg_lbl.frame.size.height+11, 30, 20);
    }
    else if (IS_IPHONE_6_PLUS)
    {
        UILabel  * namelbl=[[UILabel alloc] init];
        namelbl.frame = CGRectMake(6 , 4, 298, 14);
        namelbl.backgroundColor = [UIColor clearColor];
        namelbl.textColor = [UIColor blackColor];
        namelbl.font=[UIFont fontWithName:@"Helvetica" size:12.0];
        [cell.contentView addSubview:namelbl];
        
        
        size = [[arr_comment valueForKey:@"comments"][indexPath.row] sizeWithFont:msg_lbl.font constrainedToSize:CGSizeMake(225, 99999)];
        
        msg_lbl.numberOfLines = size.height/msg_lbl.font.lineHeight;
        
        msg_lbl.frame = CGRectMake(5, namelbl.frame.size.height+8, 394, size.height);
        
        msg_lbl.text =  [[arr_comment valueForKey:@"comments"] objectAtIndex:indexPath.row];
        
        namelbl.text=[[arr_comment valueForKey:@"username"] objectAtIndex:indexPath.row];
        
        lbl_likes.text=[NSString stringWithFormat:@"%@",[[arr_comment valueForKey:@"total_like "]objectAtIndex:indexPath.row]];
        
        personImgVw.frame=CGRectMake(331, msg_lbl.frame.size.height+11, 16, 14);
        lbl_likes.frame=CGRectMake(354, msg_lbl.frame.size.height+11, 30, 20);
        
    }
    
    
    return cell;
    
    
    
    
//    for(UIView *cellView in [cell.contentView subviews])
//    {
//        if (![cellView isKindOfClass:[UIImageView class]] || ![cellView isKindOfClass:[UILabel class]] || ![cellView isKindOfClass:[UIButton class]])
//        {
//            [cellView removeFromSuperview];
//        }
//    }

    //UIFont *proximaNova = [UIFont fontWithName:@"ProximaNova-Light" size:17];
    
    //NSString    *cellDescription = @"had to flush 3 times to get bloody tampon to go down";
    //  BlogData *blog = [mBlogs objectAtIndex:indexPath.row];
    
    //[cell.cellTitleLbl setText:[[arr_comment objectAtIndex:indexPath.row]valueForKey:@"comment"]];
    
    
//    cell.time_imVW.frame=CGRectMake(21, cell.cellTitleLbl.frame.size.height+15, 14, 14);
//    //cell.btn_like.frame=CGRectMake(289, cell.cellTitleLbl.frame.size.height+12, 14, 14);
//    cell.likeLbl.frame=CGRectMake(270, cell.cellTitleLbl.frame.size.height+8, 25, 21);
//    
//    cell.hourLbl.frame=CGRectMake(40, cell.cellTitleLbl.frame.size.height+12, 111, 21);
//    
//    [cell.likeLbl setText:[NSString stringWithFormat:@"%@",[[arr_comment objectAtIndex:indexPath.row]valueForKey:@"comment_like"]]
//     ];
//    
//    cell.likeImage.frame=CGRectMake(289, cell.cellTitleLbl.frame.size.height+15, 14, 14);
//    // cell.btn_like.frame=CGRectMake(289, cell.cellTitleLbl.frame.size.height+15, 39, 30);
//    
//    
//    cell.hourLbl.text=[NSString stringWithFormat:@"%@",[arr_comment valueForKey:@"created"][indexPath.row]];
//    cell.btn_like.tag=indexPath.row;
//    
//    [cell.btn_like addTarget:self action:@selector(TappeedOnCommentLike:) forControlEvents:UIControlEventTouchUpInside];
//    cell.btn_Dislike.tag=indexPath.row;
//    [cell.btn_Dislike addTarget:self action:@selector(TappeedOnCommentDisLike:) forControlEvents:UIControlEventTouchUpInside];
    
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    return cell;

}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath

{
//    NSString* msg = [[arr_comment valueForKey:@"comments"]objectAtIndex:indexPath.row];
//    CGRect rect = [msg boundingRectWithSize:CGSizeMake(225, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica neue" size:13]} context:nil];
//    CGSize size1 = rect.size;
//    height = size1.height+ size.height ;
  
    height = 35.0 + size.height;
    
    if(height < 50)
    {
        height = 50;
    }
    return height;

    
    
//    if(height < 87)
//    {
//        if (height<=31)
//        {
//            height=50;
//        }
//        else
//        {
//            height = 97;
//            
//        }
//        return height;
//    }
//    
//    else
//    {
//        return height-20;
//    }
    return height;
    
    
}


//- (IBAction)send_message:(id)sender
//{
//    
//    if (isStringEmpty([NSString stringWithFormat:@"%@",_txtx_view.text]))
//    {
//        alert(@"Message", @"Please Write a Comment");
//    }
//    
//    else
//    {
//        [self SendComment];
//        [_txtx_view resignFirstResponder];
//        
//    }
//    
//}

-(void)SendComment
{
    //Add parameters to send server
    
    
    //quenelle.fansfoot.com/web/?type=post_show&post_type=hot
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"type" :@"upload_comments",
                                         @"USERID" :str_userID,
                                         @"PID" :str_post_id,
                                         @"text" :_txtx_view.text
                                         
                                         }];
    
    
    [[AppManager sharedManager] showHUD:@"Loading..."];
    
    // [appdelRef showProgress:@"Please wait.."];
    
    [[AppManager sharedManager] getDataForUrl:BASE_URL
     
                                   parameters:parameters
     
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         // Get response from server
         
         NSLog(@"JSON: %@", responseObject);
         
         if ([responseObject count]>0)
         {
             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
             if(Status ==1)
             {
                 
                 if ([[responseObject valueForKey:@"type"] isEqualToString:@"upload_comments"])
                 {
                     
//                     [self retrivechat];
                     _txtx_view.text=nil;
                     [[AppManager sharedManager]hideHUD];
                     
                     
                     return;
                     
                 }
                 
             }
             
             else if (Status==0)
                 
             {
                 
//                 alert(@"Alert", @"No Comments.");
                 
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

-(void)scrollToBottom
{
    CGFloat yOffset = 0;
    if (chattable.contentSize.height > chattable.bounds.size.height)
    {
        yOffset = chattable.contentSize.height - chattable.bounds.size.height;
    }
    
    [chattable setContentOffset:CGPointMake(0, yOffset) animated:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [chattable endEditing:YES];
    [_txtx_view resignFirstResponder];
}


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
//static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 166;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.2;
double animatedDistance;



-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"begin");
    
    
    CGRect textFieldRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 3.0 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if(heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            animatedDistance = floor(215 * heightFraction);
        }
        else
        {
            animatedDistance = floor(215 * heightFraction);
        }
    }
    
    else
    {
        if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            animatedDistance = floor(225 * heightFraction);
        }
        else
        {
            animatedDistance = floor(225 * heightFraction);
        }
        
        
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}


@end
