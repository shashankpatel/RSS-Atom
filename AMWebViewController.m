//
//  AMWebViewController.m
//  Nouvelle
//
//  Created by Shashank Patel on 10/19/11.
//  Copyright (c) 2011 Not Applicable. All rights reserved.
//

#import "AMWebViewController.h"
#import "General.h"

@implementation AMWebViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    moreView.frame=CGRectMake(0, -moreTable.contentSize.height, 320, moreTable.contentSize.height);
    moreView.alpha=0;
    [self.view addSubview:moreView];
    loadingView.alpha=0;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) loadRequest:(NSURLRequest*) request{
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
    [moreTable reloadData];
    [UIView beginAnimations:@"Show settings view" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    moreView.frame=CGRectMake(0, 0, 320, moreTable.contentSize.height);
    moreView.alpha=1;
    webView.alpha=0.5;
    [UIView commitAnimations];
    webView.userInteractionEnabled=NO;
}

-(IBAction) cancelPressed{
    [UIView beginAnimations:@"Hide settings view" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    moreView.frame=CGRectMake(0, -moreTable.contentSize.height, 320, moreTable.contentSize.height);
    moreView.alpha=0;
    webView.alpha=1;
    [UIView commitAnimations];
    webView.userInteractionEnabled=YES;
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


#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.textLabel.font=[General regularLabelFont];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor blackColor];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"Open in Safari";
            break;
        default:
            break;
    }
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [[UIApplication sharedApplication] openURL:webView.request.URL];
            [self cancelPressed];
            break;
        default:
            break;
    }
}

@end
