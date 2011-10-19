//
//  AMWebViewController.m
//  Nouvelle
//
//  Created by Shashank Patel on 10/19/11.
//  Copyright (c) 2011 Not Applicable. All rights reserved.
//

#import "AMWebViewController.h"

@implementation AMWebViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    loadingView.alpha=0;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) openURLString:(NSURLRequest*) request{
    [self showLoadingView];
    [webView loadRequest:request];
}

-(void) showLoadingView{
    loadingView.alpha=1;
}

-(void) hideLoadingView{
    loadingView.alpha=0;
}

-(IBAction) stopPressed{
    [webView stopLoading];
    [self hideLoadingView];
}

-(IBAction) forwardPressed{
    [webView goForward];
}

-(IBAction) backwardPressed{
    [webView goBack];
}

-(IBAction)backPressed{
    [self.zoomController popToIndex:3];
}

-(IBAction) morePressed{
    
}


#pragma mark -UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self hideLoadingView];
}

-(void) dealloc{
    [super dealloc];
}

@end
