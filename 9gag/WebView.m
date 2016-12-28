//
//  WebView.m
//  FAnsfoot
//
//  Created by Amit Verma  on 3/14/16.
//  Copyright © 2016 Pankaj. All rights reserved.
//

#import "WebView.h"


WebView* g_sharedWebView;
@implementation WebView


+ (WebView*) shared
{
    if ( g_sharedWebView == nil )
    {
        g_sharedWebView = [[WebView alloc] init];
        
        // ... any other intialization you want to do
    }
    
    return g_sharedWebView;
}

@end
