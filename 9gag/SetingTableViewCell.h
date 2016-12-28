//
//  SetingTableViewCell.h
//  CameraApp
//
//  Created by Pankaj Sharma on 28/05/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetingTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_seting;
@property (strong, nonatomic) IBOutlet UIImageView *arrow_imagVW;
@property (strong, nonatomic) IBOutlet UISwitch *Switch_btn;
@property (strong, nonatomic) IBOutlet UISwitch *btn_NsfwOnOff;

@end
