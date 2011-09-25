//
//  FeedViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/23/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "FeedViewController.h"

@implementation FeedViewController

@synthesize delegate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(doubleTapReceived:)];
    singleFingerDTap.delegate=self;
    singleFingerDTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:singleFingerDTap];
    [singleFingerDTap release];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com"]]];
    
    [self processWebView];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) processWebView{
    UIScrollView *webScroll=[[webView subviews] objectAtIndex:0];
    webScroll.backgroundColor=[UIColor clearColor];
    webView.backgroundColor=[UIColor clearColor];
    for (UIView *view in [[[webView subviews] objectAtIndex:0] subviews] ) {
        if ([[[view class] description] isEqualToString:@"UIImageView"]) {
            UIImageView *iv=(UIImageView*) view;
            iv.image=nil;
            iv.backgroundColor=[UIColor clearColor];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


-(void) doubleTapReceived:(id) sender{
    NSLog(@"Double tap");
}

-(void) singleTapReceived:(id) sender{
    NSLog(@"Single tap");
}

-(IBAction) btnListPressed:(id)sender{
    [self.zoomController popToIndex:2];
}

#pragma UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"should do");
    return YES;
}

@end
