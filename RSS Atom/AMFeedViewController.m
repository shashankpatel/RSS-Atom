//
//  FeedViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/23/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMFeedViewController.h"
#import "AMWebViewController.h"
#import "AMFeedListViewController.h"
#import "NouvelleAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "AMFeedManager.h"
#import "NSString+HTML.h"

@implementation AMFeedViewController

@synthesize delegate;
@synthesize feed;

static NSString *htmlWrapper;

#pragma mark - View lifecycle

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *htmlFilePath=[[NSBundle mainBundle] pathForResource:@"HTMLWrapper" 
                                                               ofType:@"html"];
        htmlWrapper=[[NSString stringWithContentsOfFile:htmlFilePath 
                                               encoding:NSUTF8StringEncoding 
                                                  error:nil] retain];
    }
    return self;
}

- (void)viewDidLoad
{
    fbStatusView.center=CGPointMake(160, -75);
    fbStatusView.alpha=0;
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(doubleTapReceived:)];
    singleFingerDTap.delegate=self;
    singleFingerDTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:singleFingerDTap];
    [singleFingerDTap release];
    
    UITapGestureRecognizer *singleFingerSTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(singleTapReceived:)];
    singleFingerSTap.delegate=self;
    singleFingerSTap.numberOfTapsRequired = 2;
    //[self.view addGestureRecognizer:singleFingerSTap];
    [singleFingerSTap release];
    
    [self processWebView];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void) processWebView{
    UIScrollView *webScroll=[[webView subviews] objectAtIndex:0];
    webScroll.opaque = NO;
    webScroll.backgroundColor=[UIColor clearColor];
    webView.backgroundColor=[UIColor clearColor];
    for (UIView *view in [[[webView subviews] objectAtIndex:0] subviews] ) {
        if ([[[view class] description] isEqualToString:@"UIImageView"]) {
            UIImageView *iv=(UIImageView*) view;
            iv.image=nil;
            iv.backgroundColor=[UIColor clearColor];
        }
        view.opaque = NO;
        view.backgroundColor=[UIColor clearColor];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void) viewWillAppear:(BOOL)animated{
    [tfMessage resignFirstResponder];
    pageLoaded=NO;
    webView.userInteractionEnabled=YES;
    [super viewWillAppear:animated];
}

-(void) loadDescription{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    NSString *htmlDescription=[NSString stringWithFormat:htmlWrapper,feed.link,feed.title,feed.date,feed.author,[feed htmlStory]];
    [webView loadHTMLString:htmlDescription baseURL:[NSURL URLWithString:@"www.appmaggot.com\test"]];
    [pool release];
}

-(void) doubleTapReceived:(id) sender{
    NSLog(@"Double tap");
    if (fbStatusView.alpha==1.0) {
        return;
    }
    [self.zoomController popToIndex:2 shrink:YES];
}

-(void) singleTapReceived:(id) sender{
    NSLog(@"Single tap");
    [self.zoomController pushToIndex:3 expand:YES];
}

-(IBAction) btnListPressed:(id)sender{
    AMFeedListViewController *flvc=(AMFeedListViewController*)[self.zoomController.viewControllers objectAtIndex:2];
    [flvc expand];
    [self.zoomController popToIndex:2];
}

#pragma UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"Domain:%@",[request.URL description]);
    if ([request.URL.path length]==0) {
        return YES;
    }
    
    if (!pageLoaded) {
        return YES;
    }
    
    AMWebViewController *wvc=(AMWebViewController*)[self.zoomController.viewControllers objectAtIndex:4];
    [wvc openURLString:request];
    [self.zoomController pushToIndex:4];
    
    return NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    pageLoaded=YES;
}

-(IBAction)facebookClicked{
    
    NSString *caption=[[AMFeedManager titleForFeedID:feed.feedID] stringByConvertingHTMLToPlainText];
    
    lblTitle.text=feed.title;
    lblCaption.text=caption;
    NSString *description=[feed plainStory];
    if ([description length]>120) {
        description=[description substringToIndex:119];
        description=[description stringByAppendingString:@"... Read on Nouvelle"];
    }
    if ([description length]<5) {
        description=@"Read on Nouvelle";
    }
    
    lblDescription.text=description;
    if (feed.iconLink) {
        [imageView setImageWithContentsOfURLString:feed.iconLink];
    }
    
    [UIView beginAnimations:@"Show facebook view" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    fbStatusView.center=CGPointMake(160, 75);
    fbStatusView.alpha=1;
    [UIView commitAnimations];
    webView.userInteractionEnabled=NO;
}

-(IBAction)postTapped:(id)sender{
    [tfMessage resignFirstResponder];
    NouvelleAppDelegate *appDelegate=(NouvelleAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate publishContent:feed];
    [UIView beginAnimations:@"Hide facebook view" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    fbStatusView.center=CGPointMake(160, -75);
    fbStatusView.alpha=0;
    [UIView commitAnimations];
    webView.userInteractionEnabled=YES;
}

-(IBAction) cancelTapped:(id)sender{
    [tfMessage resignFirstResponder];
    [UIView beginAnimations:@"Hide facebook view" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    fbStatusView.center=CGPointMake(160, -75);
    fbStatusView.alpha=0;
    [UIView commitAnimations];
    webView.userInteractionEnabled=YES;
}

@end
