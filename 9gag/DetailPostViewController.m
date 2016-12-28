//
//  DetailPostViewController.m
//  FAnsfoot
//
//  Created by Pankaj Sharma on 08/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "DetailPostViewController.h"
#import "PrivateTWcell.h"
#import "DetailPostTableCell.h"
#import <Social/Social.h>
#import "HeaderFile.h"

#import "PrivateChat.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#define kSEARCH_RESULT_LOCATION_KEY @"searchResultLocationKey"
#define kSEARCH_RESULT_CONTEXT_STRING_KEY @"searchResultContextStringKey"
#define kSEARCH_RESULT_CONTEXT_LOCATION_KEY @"searchResultContextLocationKey"
#define kSEARCH_RESULT_LOCATION_IN_CONTEXT_KEY @"searchResultLocationInContextKey"
#define CHAR_COUNT_PRECEDING_RESULT 0
#define CHAR_COUNT_FOLLOWING_RESULT 0

@interface DetailPostViewController ()

@property (strong, nonatomic) IBOutlet UITextView *AddTextView;

@end

@implementation DetailPostViewController

@synthesize arr_detailpost,webView;


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
    
    NSLog(@"%@",arr_detailpost);
    
    btn_send.layer.cornerRadius=5.0f;
    btn_send.clipsToBounds=YES;
    animatedpic=NO;
    
    _txtx_view.placeholder = @"Write a comment...";
    _txtx_view.font=[UIFont fontWithName:@"System" size:18.0];
    _txtx_view.placeholderColor = [UIColor  blackColor];

    str_post_id=[arr_detailpost valueForKey:@"post_id"];
    
    arr_comment=[[NSMutableArray alloc]init];
    
    _txtx_view.autocorrectionType = UITextAutocorrectionTypeNo;
    
    _txtx_view.layer.cornerRadius=5;
    _txtx_view.clipsToBounds=YES;
    _txtx_view.delegate=self;
    
    [self getdata];
    
    str_userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"];
    
    [self scrollToBottom];
    
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    
    
    scrollView.backgroundColor=[UIColor lightGrayColor];
    
    if (IS_IPHONE_5)
    {
        [scrollView setContentSize:(CGSizeMake(320, Frame_Y+300+44))];
        
        chattable.frame=CGRectMake(7, Frame_Y+120, 304, 174);
    }
    else if (IS_IPHONE_6)
    {
        [scrollView setContentSize:(CGSizeMake(375, Frame_Y+300+44))];
        
        chattable.frame=CGRectMake(7, Frame_Y+120, 359, 174);
    }
    else if (IS_IPHONE_6_PLUS)
    {
        
        [scrollView setContentSize:(CGSizeMake(320, Frame_Y+300+44))];
        
        chattable.frame=CGRectMake(7, Frame_Y+120, 398, 174);
    }
    
    [scrollView addSubview:lbl_POstname];
    NSString *str_comment=[arr_detailpost valueForKey:@"fbCommnetUrl"];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str_comment]]];
    
//    FBSDKLikeControl *fbLikeControlView = [[FBSDKLikeControl alloc] initWithFrame:CGRectMake(10,Frame_Y+120-40, 100, 30)];
//    fbLikeControlView.likeControlStyle = FBSDKLikeControlStyleBoxCount;
//    fbLikeControlView.objectID=[arr_detailpost valueForKey:@"post_url"];
//    [scrollView addSubview:fbLikeControlView];
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    chattable.hidden=YES;
    self.tabBarController.tabBar.hidden=YES;
    [AppManager sharedManager].navCon = self.navigationController;
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


-(void)getdata
{
    
   // NSLog(@"---IN GET Data----%@",arr_detailpost);
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"CategoryName"]);
    
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"CategoryName"] isEqual:@"animated-gif"])
    {
        
        if ([[arr_detailpost valueForKey:@"type"]isEqualToString:@"search_post_show"] || animatedpic==YES)
        {
            animatedpic=YES;
           imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_detailpost valueForKey:@"pic"]]]];
        }
        else
        {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_detailpost valueForKey:@"pic"]]];
        
        NSLog(@"%@", [url URLByDeletingPathExtension]);
        
        str_gifimage=[NSString stringWithFormat:@"%@",[url URLByDeletingPathExtension]];
        
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str_gifimage]]];
            
        }
    }
    else
    {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_detailpost valueForKey:@"pic"]]]];
        
        
    }
    
    uint8_t * bytePtr = (uint8_t  * )[imageData bytes];
    
     NSInteger totalData = [imageData length] / sizeof(uint8_t);
    
    if (totalData == 0)
    {
        
    }
    
      else  if((imageData==[NSNull class])||([imageData isEqual:@"null"])||([imageData isEqual:@"(null)"])||([imageData isEqual:@"<null>"])||([imageData isEqual:@"nil"])||([imageData isEqual:@""])||([imageData isEqual:@"<nil>"])||([imageData isEqual:@"<>"])||([imageData isEqual:@"0"]))
    {
        
        if (IS_IPHONE_5)
        {
            post_imageVW.frame=CGRectMake(7, 49, 304, 174);
            post_imageVW.image=[UIImage imageNamed:@"post-img-empty"];
            Frame_Y=174;
            Frame_X=304;
        }
        
        else if (IS_IPHONE_6)
        {
            post_imageVW.frame=CGRectMake(7, 49, 359, 273);
            post_imageVW.image=[UIImage imageNamed:@"post-img-empty"];
            Frame_Y=273;
            Frame_X=359;
        }
        
        else if (IS_IPHONE_6_PLUS)
        {
            post_imageVW.frame=CGRectMake(7, 49, 398, 342);
            post_imageVW.image=[UIImage imageNamed:@"post-img-empty"];
            Frame_Y=174;
            Frame_X=304;
        }
        
        imageNull=YES;
    }
    
    else
    {
        
        UIImage *image = [UIImage imageWithData:imageData];

        Frame_percentage=300/image.size.width*100;
        
        Frame_X=post_imageVW.frame.size.width-20;
        Frame_Y=image.size.height*Frame_percentage/100;
        
            NSLog(@"New Height for image %f",Frame_Y);
            NSLog(@"New width for image %d",Frame_X);
    }
    
    if (IS_IPHONE_5)
    {
        post_imageVW.frame=CGRectMake(7, 50, 304, Frame_Y);
        lbl_POstname.frame=CGRectMake(14, 10, Frame_X, 36);
        lbl_points.frame=CGRectMake(12, Frame_Y+52, 90, 20);
        lbl_comments.frame=CGRectMake(107, Frame_Y+52, 90, 20);
        _Buttons_BackgroundVW.frame=CGRectMake(7, Frame_Y+75, 304, 44);
        _cell_background_image.frame=CGRectMake(7, 18, 305, Frame_Y+60);
        webView.frame=CGRectMake(7,  Frame_Y+80+44, 305, 200);
        
        
        
        
    }
    else if (IS_IPHONE_6)
    {
        lbl_POstname.frame=CGRectMake(14, 10, Frame_X, 36);
        post_imageVW.frame=CGRectMake(7, 50, 359, Frame_Y);
        lbl_points.frame=CGRectMake(12, Frame_Y+52, 90, 20);
        lbl_comments.frame=CGRectMake(107, Frame_Y+52, 90, 20);
        _Buttons_BackgroundVW.frame=CGRectMake(7, Frame_Y+75, 359, 44);
        _cell_background_image.frame=CGRectMake(7, 18, 359, Frame_Y+60);
        webView.frame=CGRectMake(7,  Frame_Y+80+44, 359, 200);
        
    }
    else if (IS_IPHONE_6_PLUS)
    {
        post_imageVW.frame=CGRectMake(7, 50, 398, Frame_Y);
        lbl_POstname.frame=CGRectMake(14, 10, Frame_X, 36);
        lbl_points.frame=CGRectMake(12, Frame_Y+52, 90, 20);
        lbl_comments.frame=CGRectMake(107, Frame_Y+52, 90, 20);
        _Buttons_BackgroundVW.frame=CGRectMake(7, Frame_Y+75, 398, 44);
        _cell_background_image.frame=CGRectMake(7, 18, 398, Frame_Y+60);
        webView.frame=CGRectMake(7,  Frame_Y+80+44, 398, 200);
        
    }
    
    
//    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"alreadylogin"]==YES)
//    {
//        FBSDKLikeControl *likeButton = [[FBSDKLikeControl alloc]
//                                        initWithFrame:CGRectMake(12, Frame_Y+70+15, 100, 15)];
//        likeButton.objectID = [arr_detailpost valueForKey:@"fbCommnetUrl"];
//        likeButton.likeControlStyle = FBSDKLikeControlStyleBoxCount;
//        [scrollView addSubview:likeButton];
//    }

    
    
    //    [PostimageVW setImage:compressedImage];
    
    //    [PostimageVW setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"pic"]]] placeholderImage:[UIImage imageNamed:@"PlaceHol-iPad.png"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    
    lbl_POstname.adjustsFontSizeToFitWidth = YES;
    lbl_comments.adjustsFontSizeToFitWidth = YES;
    lbl_points.adjustsFontSizeToFitWidth = YES;
    
    
    lbl_POstname.text=[arr_detailpost valueForKey:@"tital"];
    
    lbl_points.text=[NSString stringWithFormat:@"%@ Points",[arr_detailpost valueForKey:@"total_like "]];
    lbl_comments.text=[NSString stringWithFormat:@"%@ Comments",[arr_detailpost valueForKey:@"comments"]];
    
    
    if (imageNull==YES)
    {
        post_imageVW.image=[UIImage imageNamed:@"post-img-empty"];
    }
    
    else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"CategoryName"] isEqual:@"animated-gif"])
    {
        
        if ([[arr_detailpost valueForKey:@"type"]isEqualToString:@"search_post_show"] || animatedpic==YES)
        {
            [post_imageVW setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_detailpost valueForKey:@"pic"]]] placeholderImage:[UIImage imageNamed:@"PlaceHol-iPad.png"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 
             }
             
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        else
        {
            
            [post_imageVW setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_detailpost valueForKey:@"pic"]]] placeholderImage:[UIImage imageNamed:@"PlaceHol-iPad.png"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 
             }
             
              usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
        
//        [post_imageVW setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str_gifimage]] placeholderImage:[UIImage imageNamed:@"PlaceHol-iPad.png"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//         {
//             
//         }
//         
//         usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        }
    }

    
    else
        
    {
        
        [post_imageVW setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_detailpost valueForKey:@"pic"]]] placeholderImage:[UIImage imageNamed:@"PlaceHol-iPad.png"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             
         }
         
          usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    

}

- (IBAction)commentPush:(id)sender
{
    PrivateChat * vc1 = [self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
    vc1.arr_detailComment=arr_detailpost;
    [self.navigationController pushViewController:vc1 animated:YES];

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
//                     arr_comment=[responseObject objectForKey:@"post"];
//                     
//                     [chattable reloadData];
//                     
//                     chattable.hidden=NO;
//
//                     [self scrollToBottom];
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
//                 chattable.hidden=YES;
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


-(void)viewDidAppear:(BOOL)animated
{
    
//    [self retrivechat];
    
    [self scrollToBottom];
    
   

}

-(void)dismissKeyboard
{
    [_txtx_view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arr_comment count];
    
    //count number of row from counting array hear cataGorry is An Array
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
   
    
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
    
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath

{
//    NSString* msg = [[arr_comment valueForKey:@"comments"]objectAtIndex:indexPath.row];
    
//    CGRect rect = [msg boundingRectWithSize:CGSizeMake(225, 99999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica neue" size:13]} context:nil];
//    CGSize size1 = rect.size;
//    //    height = size1.height+ size.height ;

    height = 35.0 + size.height;
    
    if(height < 50)
    
    {
        height = 50;
    }
    return height;
    
    
}


- (IBAction)likeAction:(id)sender
{
    
    //Add parameters to send server
    
    
    //quenelle.fansfoot.com/mobile/web/?type=post_like&post_id=2&user_id=5204&status=1
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"type" :@"post_like",
                                         @"post_id" :str_post_id,
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
         
         NSLog(@"JSON: %@", responseObject);
         
         arr_postsDATA=responseObject;
         
         if ([responseObject count]>0)
         {
//             NSInteger Status=[[arr_postsDATA valueForKey:@"status"] integerValue];
             
             //             if(Status == 1)
             //             {
             
             
             if ([[arr_postsDATA valueForKey:@"msg"] isEqualToString:@"like"])
             {
                 
                 [[AppManager sharedManager]hideHUD];
                 
                 
                 arr_detailpost=[[NSMutableArray alloc]init];
                 arr_detailpost=arr_postsDATA;
                 [self getdata];
                 
                 return;
                 
             }
             
             //             }
             
             else if ([[arr_postsDATA valueForKey:@"msg"] isEqualToString:@"Already like"])
             {
                 
                 alert(@"Message", @"Already like");
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

- (IBAction)unlikeAction:(id)sender
{
    
    //Add parameters to send server
    
    
    //quenelle.fansfoot.com/mobile/web/?type=post_like&post_id=2&user_id=5204&status=1
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:
                                       
                                       @{
                                         
                                         @"type" :@"post_like",
                                         @"post_id" :str_post_id,
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
         
         NSLog(@"JSON: %@", responseObject);
         
         arr_postsDATA=responseObject;
         
         if ([responseObject count]>0)
         {
//             NSInteger Status=[[arr_postsDATA valueForKey:@"status"] integerValue];
             
             //             if(Status == 1)
             //             {
             
             
             if ([[arr_postsDATA valueForKey:@"msg"] isEqualToString:@"unlike"])
             {
                 
                 arr_detailpost=[[NSMutableArray alloc]init];
                 arr_detailpost=arr_postsDATA;
                 [self getdata];
                 
                 [[AppManager sharedManager]hideHUD];
                 
                 
                 return;
                 
             }
             
             //             }
             
             else if ([[arr_postsDATA valueForKey:@"msg"] isEqualToString:@"Already unlike"])
             {
                 
                 alert(@"Message", @"Already unlike");
 
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
//        
//        [_txtx_view resignFirstResponder];
//        
//    }
//    
//}

//-(void)SendComment
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
//                                         @"type" :@"upload_comments",
//                                         @"USERID" :str_userID,
//                                         @"PID" :str_post_id,
//                                         @"text" :_txtx_view.text
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
//             NSInteger Status=[[responseObject valueForKey:@"status"] integerValue];
//             if(Status ==1)
//             {
//                 
//                 if ([[responseObject valueForKey:@"type"] isEqualToString:@"upload_comments"])
//                 {
//                     
//                     [self retrivechat];
//                     
//                     chattable.hidden=NO;
//                     _txtx_view.text=nil;
//                
////            // http://fansfoot.com/gag/8411/ugly-football-wins-premier-league-title.html
//
//                     
//                     
//NSMutableDictionary *res = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is Mr khana Comment",@"message",@"CAAFk4A8Go3MBAMjyxoNF8pkbK4eOzCvUCZAa9asCOTwbrqqxAEZADxfCAIUCRikWDsDeZAkpRQNKB3UfGo8l9HQ6MvPNhS6kzXk1Uzxxw88ZBrXDXs30eMDq0r8nDZBdXLySC7Cx31wcBijEg2LYh9ZAOeky6m87Iay4rnNcIZBYbHVQB4uPi0o",@"access_token",nil];
// [FBRequestConnection startWithGraphPath:@"f3287e32dc77436/comments" parameters:res HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//     if (error)
//     {
//         NSLog(@"error: %@", error.localizedDescription);
//     }
//     else
//     {
//         NSLog(@"ok!!");
//     } 
// }];
// 
//                     
//                     
////                     XXXXXXXXXX = Id where you want to comment.
//                     
//                     
////                     [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
////                                                        defaultAudience:FBSessionDefaultAudienceFriends
////                                                           allowLoginUI:YES
////                                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
////                        if (FBSession.activeSession.isOpen && !error)
////                        {
////                        // Publish the comment (your code inside) if permission was granted
////                        [self publishComment];
////                        }
////                        }];
//                     
//
//  
////                     NSDictionary *params = @{
////                                              @"message": @"This is a test comment",
////                                              };
////                     /* make the API call */
////                     FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
////                                                   initWithGraphPath:@"/http://quenelle.fansfoot.com/gag/8411/ugly-football-wins-premier-league-title.html/comments"
////                                                   parameters:params
////                                                   HTTPMethod:@"POST"];
////                     [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
////                                                           id result,
////                                                           NSError *error)
////                      {
////                          NSLog(@"%@",result);
////                          
////                          // Handle the result
////                      }];
//                     
//                     
////                     NSDictionary* dict = @{
////                                            @"link" : @"http://quenelle.fansfoot.com/uploads/posts/t/8407.jpg",
////                                            @"picture" : @"http://quenelle.fansfoot.com/uploads/posts/t/8407.jpg",
////                                            @"message":@"Your temp message here",
////                                            @"name" : @"Fansfoot",
////                                            @"caption" : @"TestPost",
////                                            @"description" : @"Integrating Facebook in ios"
////                                            };
////                     [FBRequestConnection startWithGraphPath:@"me/feed" parameters:dict HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
////                         NSString *alertText;
////                         if (error)
////                         {
////                             NSLog(@"%@",[NSString stringWithFormat: @"error: domain = %@, code = %ld", error.domain, (long)error.code]);
////                             alertText = @"Failed to post to Facebook, try again";
////                         } else
////                         {
////                             alertText = @"Posted successfully to Facebook";
////                         }
////                         
////                         [[[UIAlertView alloc] initWithTitle:@"Facebook Result" message:alertText delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil] show];
////                     }];
//
//                     
//                     
////  https://graph.facebook.com/124186682456_10151302011177457?access_token=ACCESS_TOKEN
//        
////  NSMutableDictionary *res = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"This is my comment",@"message",@"CAAFk4A8Go3MBAMjyxoNF8pkbK4eOzCvUCZAa9asCOTwbrqqxAEZADxfCAIUCRikWDsDeZAkpRQNKB3UfGo8l9HQ6MvPNhS6kzXk1Uzxxw88ZBrXDXs30eMDq0r8nDZBdXLySC7Cx31wcBijEg2LYh9ZAOeky6m87Iay4rnNcIZBYbHVQB4uPi0o",@"access_token",nil];
////    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"%@/comments",[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_detailpost valueForKey:@"pic"]]]] parameters:res HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
////                     {
////                                                              if (error)
////                                                              {
////                                                                  NSLog(@"error: %@", error.localizedDescription);
////                                                              }
////                                                              else
////                                                              {
////                                                                  NSLog(@"ok!! %@",result);
////                                                              }
////                                                              }];
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
//  failure:^(AFHTTPRequestOperation *operation, NSError *error)
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
//}

//-(void)publishComment
//{
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"asasasasa",@"message", nil];
//    NSString *strPicId = @"http://quenelle.fansfoot.com/uploads/posts/t/8407.jpg";
//    NSString *strPath =[NSString stringWithFormat:@"%@/comments",strPicId];
//    [FBRequestConnection startWithGraphPath:strPath parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result1, NSError *error)
//     {
//         if(!error)
//         {
//             NSLog(@"%@",result1);
//         }
//         else
//         {
//             NSLog(@"ERROR:%@",error);
//         }
//     }];
//}

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
    
    
//    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//    
//    [controller setInitialText:[NSString stringWithFormat:@"commented"]];
//    
//    NSURL *imageUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_detailpost valueForKey:@"pic"]]]]];
//    NSData* data = [[NSData alloc] initWithContentsOfURL:imageUrl];
//    
//    UIImage *photoImage = [UIImage imageWithData:data];
//    
//    [controller addImage:photoImage];
//    
//    [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
//        switch (result)
//        {
//            case SLComposeViewControllerResultCancelled:
//                break;
//            case SLComposeViewControllerResultDone:
//                
//            {
//                NSLog(@"%d",result);
//                NSLog(@"DONE");
//                
//            }
//                break;
//            default:
//                break;
//        }
//    }];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self presentViewController:controller animated:YES completion:Nil];

    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backaction:(id)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"CategoryName"];
    [self.navigationController popViewControllerAnimated:YES];
    animatedpic=NO;
}
@end
