//
//  constant.h
//  Tchat
//
//  Created by ToXSL on 26/03/13.
//  Copyright (c) 2013 ToXSL. All rights reserved.
//

#ifndef Tchat_constant_h
#define Tchat_constant_h
#import "AppDelegate.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)



#define  KAppDelegate  ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define liveurl                @"http://fansfoot.com/mobile/web/?"
//#define liveurl                   @"http://dev414.trigma.us/onbeat"

#define kSignUpUser            @""

#define kLoginUser             @"type=login"
#define KLogOut                @"type=logout"

#define KONOFF                 @""
#define KAdverDetail           @"/webservices/adsDetails?"

#define KchangePsswrd          @"/users/changepass?"
#define KForgotPswd            @"/users/mobileuserforgot?"
#define KAderPost              @"/webservices/add?"

#define KShowPost              @"/webservices/userAds?"


#define Kshowprofile           @"type=my_profile"

#define Keditprofile           @"type=edit_profile"

#define Kreportproblem         @"type=report_problem"

#define Kaddpost               @"type=add_post"

#endif
