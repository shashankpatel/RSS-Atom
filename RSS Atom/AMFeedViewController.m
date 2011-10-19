//
//  FeedViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/23/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMFeedViewController.h"
#import "AMWebViewController.h"

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
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(doubleTapReceived:)];
    singleFingerDTap.delegate=self;
    singleFingerDTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:singleFingerDTap];
    [singleFingerDTap release];
    
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
    [self performSelectorInBackground:@selector(loadDescription) withObject:nil];
    [super viewWillAppear:animated];
}

-(void) loadDescription{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    NSString *htmlDescription=[NSString stringWithFormat:htmlWrapper,feed.link,feed.title,feed.date,feed.author,feed.summary];
    [webView loadHTMLString:htmlDescription baseURL:nil];
    [pool release];
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
    if ([request.URL.path length]==0) {
        return YES;
    }
    
    AMWebViewController *wvc=(AMWebViewController*)[self.zoomController.viewControllers objectAtIndex:4];
    [wvc openURLString:request];
    [self.zoomController pushToIndex:4];
    
    return NO;
}

@end
