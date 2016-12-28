//
//  CategoryPostTableViewCell.m
//  FAnsfoot
//
//  Created by Pankaj Sharma on 04/06/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import "CategoryPostTableViewCell.h"
#import "UIImageView+WebCache.h"
//#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "CategoryPostViewController.h"
//#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)



@implementation CategoryPostTableViewCell

@synthesize TitleLBL,PostimageVW,btn_Unlike,btn_Like;


- (void)awakeFromNib
{
    // Initialization code
   
    
}

-(void)loaditemwithCategoryListArray:(NSMutableArray *)arr_AdvertList
{
    ////working
    
    NSLog(@"%@",arr_AdvertList);
    
    NSString *str_height=[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"height"]];
    NSString *str_width=[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"width"]];
    NSLog(@"image_height-->>>>%@",str_height);
    
    imageHeight=[str_height floatValue];
    imagewidth=[str_width floatValue];
    
    NSLog(@"%f,%f",imageHeight,imagewidth);
   
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"CategoryName"] isEqual:@"animated-gif"])
    {
        if ([[arr_AdvertList valueForKey:@"type"]isEqualToString:@"search_post_show"])
        {
            
        }
        else
        {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"pic"]]];
        str_gifimage=[NSString stringWithFormat:@"%@",[url URLByDeletingPathExtension]];
     
//        dispatch_async(kBgQueue, ^{
        
//            imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str_gifimage]]];
        
//            dispatch_async(dispatch_get_main_queue(), ^{
//            });
//        });
        }
    }
    
// else
// {
////     dispatch_async(kBgQueue, ^{
//         imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"pic"]]]];
//         
////         dispatch_async(dispatch_get_main_queue(), ^{
////         });
////     });
//    
// }
    
    if (imageHeight==0)
    {
//        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://designs14.trigma.us//fansfoot/post-img-empty@2x.png"]];
//        UIImage *image=[UIImage imageNamed:@"post-img-empty"];
//        
//        imageData = UIImagePNGRepresentation(image);
//        
//        PostimageVW.frame=CGRectMake(7, 49, 304, 174);
//        PostimageVW.image=[UIImage imageNamed:@"post-img-empty"];
//        Frame_Y=174;
//        Frame_X=304;
        
        Image_null=YES;
    }
    else
    {
//        UIImage *image = [UIImage imageWithData:imageData];
        
        //    CGFloat compression = 0.9f;
        //    CGFloat maxCompression = 0.02f;
        //    int maxFileSize = 250*8;
        //
        //    NSData *imageData1 = UIImageJPEGRepresentation(image, compression);
        //
        //    while ([imageData length] > maxFileSize && compression > maxCompression)
        //    {
        //        compression -= 0.1;
        //        imageData1 = UIImageJPEGRepresentation(image, compression);
        //    }
        //     UIImage *compressedImage = [UIImage imageWithData:imageData1];
        //    NSLog(@"%@",compressedImage);
        
        
        //    NSLog(@"OLD image height: %f",image.size.height);
        //    NSLog(@"OLD image width: %f",image.size.width);
        
        //    if (image.size.width>PostimageVW.frame.size.width)
        //    {
//            NSLog(@"New Height for image %f",Frame_Y);
//            NSLog(@"New width for image %d",Frame_X);
        
        Frame_percentage=300/imagewidth*100;
        
        Frame_X=PostimageVW.frame.size.width-20;
        Frame_Y=imageHeight*Frame_percentage/100;
        
        PostimageVW.frame=CGRectMake(8, 40, 304, Frame_Y);
        TitleLBL.frame=CGRectMake(14, 0, Frame_X, 36);
        _lbl_points.frame=CGRectMake(12, Frame_Y+42, 90, 20);
        _lbl_comment.frame=CGRectMake(107, Frame_Y+42, 90, 20);
        _Buttons_BackgroundVW.frame=CGRectMake(8, Frame_Y+65, 304, 44);
        _cell_background_image.frame=CGRectMake(7, 8, 305, Frame_Y+60);

    }
    
    TitleLBL.adjustsFontSizeToFitWidth = YES;
    _lbl_comment.adjustsFontSizeToFitWidth = YES;
    _lbl_points.adjustsFontSizeToFitWidth = YES;

    
    TitleLBL.text=[arr_AdvertList valueForKey:@"tital"];
    _lbl_points.text=[NSString stringWithFormat:@"%@ Points",[arr_AdvertList valueForKey:@"total_like "]];
    _lbl_comment.text=[NSString stringWithFormat:@"%@ Comments",[arr_AdvertList valueForKey:@"comments"]];
    
    if (Image_null==YES)
    {
        if (self.isYoutubeVideo==YES)
        {
            NSString *s = [arr_AdvertList valueForKey:@"pic"];
            NSRange r1 = [s rangeOfString:@"http://www.youtube.com/embed/"];
            NSRange r2 = [s rangeOfString:@"?"];
            NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
            NSString *sub = [s substringWithRange:rSub];
            
            self.playerView.hidden=NO;
            [self.playerView loadWithVideoId:sub];
        }
        
        PostimageVW.image=[UIImage imageNamed:@"post-img-empty"];
        
        [PostimageVW setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"video_tumb"]]] placeholderImage:[UIImage imageNamed:@"PlaceHol-iPad.png"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            
        }

//        [PostimageVW setImageWithURL:[NSURL URLWithString:@"http://designs14.trigma.us//fansfoot/post-img-empty@2x.png"] placeholderImage:[UIImage imageNamed:@"PlaceHol-iPad.png"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//         {
//             
//         }
         
         usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    else
    
    {
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"CategoryName"] isEqual:@"animated-gif"])
        {
            if ([[arr_AdvertList valueForKey:@"type"]isEqualToString:@"search_post_show"])
            {
                [PostimageVW setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"pic"]]] placeholderImage:[UIImage imageNamed:@"PlaceHol-iPad.png"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                 {
                     
                 }
                 
                 usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }
            else
            {
                
                [PostimageVW setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"pic"]]] placeholderImage:[UIImage imageNamed:@"PlaceHol-iPad.png"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
                 {
                     
                 }
                 
                 usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }
            
//            [PostimageVW setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",str_gifimage]] placeholderImage:[UIImage imageNamed:@"PlaceHol-iPad.png"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//             {
//                 
//             }
//             usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//                
//            }
        }
            
        else
        {
        
      [PostimageVW setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"pic"]]] placeholderImage:[UIImage imageNamed:@"PlaceHol-iPad.png"] options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             
         }
         
         usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
    //    PostimageVW.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[arr_AdvertList valueForKey:@"image"]]];
    //    lbl_Discription.text=[arr_AdvertList valueForKey:@"description"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
