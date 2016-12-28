//
//  postaddViewController.h
//  FAnsfoot
//
//  Created by Pankaj Sharma on 04/06/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface postaddViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate>

{
    
    NSData *dataImage;
    NSString *encryptedString;
    UIImage *obj_imagePick;
    IBOutlet UIButton *btn_camera;
    IBOutlet UIImageView *imageViewCam;
    IBOutlet UITextField *txt_PostTitle;
    IBOutlet UILabel *category_lbl;
    NSArray * arr_category;
    NSString *str_user_id;
    IBOutlet UITextField *txt_tags;
    NSString *str_categorid;
    
    IBOutlet UIButton *btn_checkbox;
    int Category_id;
    BOOL ischeckBoxSelected;
    BOOL imagePICK;
    
    
    IBOutlet GADBannerView *bannerView;
    
}
- (IBAction)ChooseCategoryAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *Dropdown_TableVW;
- (IBAction)checkboxaction:(id)sender;


@end
