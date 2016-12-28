//
//  PrivateTWcell.h
//  FAnsfoot
//
//  Created by Pankaj Sharma on 05/06/15.
//  Copyright (c) 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivateTWcell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *CellMessage_lbl;
@property (strong, nonatomic) IBOutlet UILabel *lbl_likes;
@property (strong, nonatomic) IBOutlet UIButton *Like_btn;
@property (strong, nonatomic) IBOutlet UIImageView *Like_imageVW;

@end
