//
//  PlayYoutubeVideoVC.h
//  FAnsfoot
//
//  Created by amit varma on 26/11/15.
//  Copyright © 2015 Pankaj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YTPlayerView.h"

@interface PlayYoutubeVideoVC : UIViewController<YTPlayerViewDelegate>{
    
    IBOutlet GADBannerView *bannerView;
    
    
}
@property(nonatomic,retain)NSMutableArray *arr_detailpost;

@property (strong, nonatomic) IBOutlet YTPlayerView *playerView;

- (IBAction)playVideo:(id)sender;
- (IBAction)stopVideo:(id)sender;



@end
