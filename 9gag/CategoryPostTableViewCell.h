//
//  CategoryPostTableViewCell.h
//  FAnsfoot
//
//  Created by Pankaj Sharma on 04/06/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface CategoryPostTableViewCell : UITableViewCell<YTPlayerViewDelegate>

{
    int Frame_X;
    float Frame_percentage;
    BOOL imageNull;
    NSString* theFileName1;
    NSData *imageData;
    NSURL *url;
    NSString *str_gifimage;
    NSString* theFileName2;
    NSString* theFileName;
    
    float imageHeight,imagewidth;
}
@property (strong, nonatomic) IBOutlet UIImageView *PostimageVW;
@property (strong, nonatomic) IBOutlet UIButton *btn_Like;
@property (strong, nonatomic) IBOutlet UIButton *btn_Unlike;

@property (strong, nonatomic) IBOutlet UILabel *TitleLBL;
-(void)loaditemwithCategoryListArray:(NSMutableArray *)arr_AdvertList;
@property (strong, nonatomic) IBOutlet UIView *Buttons_BackgroundVW;
@property (strong, nonatomic) IBOutlet UILabel *lbl_points;
@property (strong, nonatomic) IBOutlet UILabel *lbl_comment;
@property (strong, nonatomic) IBOutlet UIImageView *cell_background_image;
@property (strong, nonatomic) IBOutlet UIButton *Btn_Comment;
@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
@property(nonatomic,assign)BOOL isYoutubeVideo;
@end
