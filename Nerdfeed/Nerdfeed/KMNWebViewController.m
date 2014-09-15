//
//  KMNWebViewController.m
//  Nerdfeed
//
//  Created by Michael Nwani on 9/13/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNWebViewController.h"

@implementation KMNWebViewController

//The view controller requests this method when its UIView *view object (its view property) is requested, but is currently nil.
-(void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

-(void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL)
    {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req]; //casting the UIView object to appear as a UIWebView object.
    }
}
@end
