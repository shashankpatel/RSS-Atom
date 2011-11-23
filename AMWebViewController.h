//
//  AMWebViewController.h
//  Nouvelle
//
//  Created by Shashank Patel on 10/19/11.
//  Copyright (c) 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMViewController.h"

@interface AMWebViewController : AMViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *webView;
    IBOutlet UIView *loadingView;
    IBOutlet UIButton *stopButton;
    IBOutlet UIView *moreView;
    IBOutlet UITableView *moreTable;
    NSURL *URL;
}

@property(nonatomic,retain) NSURL *URL;

-(void) loadRequest:(NSURLRequest*) request;
-(void) showLoadingView;
-(void) hideLoadingView;

-(IBAction) stopPressed;
-(IBAction) forwardPressed;
-(IBAction) backwardPressed;
-(IBAction)backPressed;
-(IBAction) morePressed;

@end
