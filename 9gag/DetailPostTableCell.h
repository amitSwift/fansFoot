//
//  DetailPostTableCell.h
//  FAnsfoot
//
//  Created by Pankaj Sharma on 08/07/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPostTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *CellMessage_lbl;
@property (strong, nonatomic) IBOutlet UILabel *lbl_likes;
@property (strong, nonatomic) IBOutlet UIButton *Like_btn;
@property (strong, nonatomic) IBOutlet UIImageView *Like_imageVW;
@property (strong, nonatomic) IBOutlet UILabel *lbl_person_name;

@end
