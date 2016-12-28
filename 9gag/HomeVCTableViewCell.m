//
//  ViewControllerTableViewCell.m
//  9gag
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "HomeVCTableViewCell.h"
#import "AsyncImageView.h"
#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
//#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "PrivateChat.h"
#import <ImageIO/ImageIO.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@implementation HomeVCTableViewCell

@synthesize TitleLBL,PostimageVW,facebookShareBTN,twittershareBTN,Btn_Comment,fbLineBtn,lbllikes;

- (void)awakeFromNib {
    // Initialization code
}
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_AdvertList
{
    NSLog(@"in cell data -=-=-=-%@",arr_AdvertList);
    ///working
    
    NSString *str_height=[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"height"]];
    NSString *str_width=[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"width"]];
    NSLog(@"image_height-->>>>%@",str_height);
    
    imageHeight=[str_height floatValue];
    imagewidth=[str_width floatValue];
    
    NSLog(@"%f,%f",imageHeight,imagewidth);

    if (imageHeight==0)
    {
               Image_null=YES;
    }
    else
    {

        Frame_percentage=300/imagewidth*100;
        
      
        
        Frame_X=PostimageVW.frame.size.width-20;
        Frame_Y=imageHeight*Frame_percentage/100;
        
        
        PostimageVW.frame=CGRectMake(8, 40, 304, Frame_Y);
        TitleLBL.frame=CGRectMake(14, 0, Frame_X, 36);
        
        _lbl_points.frame=CGRectMake(12, Frame_Y+42, 90, 20);
        _lbl_comment.frame=CGRectMake(107, Frame_Y+42, 90, 20);
         lbllikes.frame=CGRectMake(200, Frame_Y+42, 90, 20);
        
        _Buttons_BackgroundVW.frame=CGRectMake(8, Frame_Y+65, 304, 44);
        _cell_background_image.frame=CGRectMake(7, 8, 305, Frame_Y+60);
        
    }
    

    
    TitleLBL.adjustsFontSizeToFitWidth = YES;
    _lbl_comment.adjustsFontSizeToFitWidth = YES;
    _lbl_points.adjustsFontSizeToFitWidth = YES;
    
    
    TitleLBL.text=[arr_AdvertList valueForKey:@"tital"];
    _lbl_points.text=[NSString stringWithFormat:@"%@ Points",[arr_AdvertList valueForKey:@"total_like "]];
    _lbl_comment.text=[NSString stringWithFormat:@"%@ Comments",[arr_AdvertList valueForKey:@"comments"]];
    
    
    [PostimageVW setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"pic"]]] placeholderImage:[UIImage imageNamed:@"post-img-empty"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         
     }
     
     usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (IBAction)commentAction:(id)sender
{
    
}
@end
