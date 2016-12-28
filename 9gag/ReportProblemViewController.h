//
//  FifthViewController.h
//  9gag
//
//  Created by Pankaj Sharma on 20/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@interface ReportProblemViewController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate>

{
    NSData *dataImage;
    NSString *encryptedString;
    UIImage *obj_imagePick;
    IBOutlet UIButton *btn_camera;
    IBOutlet UIImageView *imageViewCam;
    IBOutlet PlaceholderTextView *txtviewWhatHappen;
    IBOutlet PlaceholderTextView *txtViiewSuggetion;
    IBOutlet UITextField *lbl_title;
    NSArray *arr_category;
    NSString *str_categorid;
    IBOutlet UITextField *lbl_category;
    NSString *str_user_id;
    
    
    
    IBOutlet GADBannerView *bannerView;
    
}
- (IBAction)webserviceSendReport:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *Dropdown_TableVW;


@end
