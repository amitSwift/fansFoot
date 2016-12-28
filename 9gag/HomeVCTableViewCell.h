//
//  ViewControllerTableViewCell.h
//  9gag
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface HomeVCTableViewCell : UITableViewCell
{
    int Frame_X;
    float Frame_percentage;
    BOOL imageNull;
    NSData *imageData;
    UIImageView *dummy_imageVW;
    NSMutableArray *arr_dummy;
    float imageHeight,imagewidth;
    UIImage *image;
}
@property (strong, nonatomic) IBOutlet UIImageView *PostimageVW;
@property (strong, nonatomic) IBOutlet UIButton *twittershareBTN;
@property (strong, nonatomic) IBOutlet UIButton *facebookShareBTN;
@property (strong, nonatomic) IBOutlet UILabel *TitleLBL;
-(void)loaditemwithAdvertListArray:(NSMutableArray *)arr_AdvertList;
@property (strong, nonatomic) IBOutlet UIView *Buttons_BackgroundVW;
@property (strong, nonatomic) IBOutlet UILabel *lbl_points;
@property (strong, nonatomic) IBOutlet UILabel *lbl_comment;
@property (strong, nonatomic) IBOutlet UIImageView *cell_background_image;

@property (strong, nonatomic) IBOutlet UIButton *Btn_Comment;
@property (strong, nonatomic) IBOutlet UIButton *Like_btn;

@property (strong, nonatomic) IBOutlet UIButton *Unlike_btn;

@property (strong, nonatomic) IBOutlet UIButton *fbLineBtn;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *lbllikes;




@end
