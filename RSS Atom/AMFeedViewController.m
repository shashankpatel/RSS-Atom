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
#import "General.h"

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

-(void) makeViewTranparent:(UIView *) view{
    for (UIView *subView in [view subviews]) {
        [self makeViewTranparent:subView];
    }
    view.backgroundColor=[UIColor clearColor];
}

- (void)viewDidLoad
{
    fbStatusView.center=CGPointMake(160, -75);
    fbStatusView.alpha=0;
    tweeterStatusView.center=CGPointMake(160, -60);
    tweeterStatusView.alpha=0;
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
    
    [self makeViewTranparent:table];
    
    for (UIView *view in [webView subviews]) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            webScrollView=(UIScrollView*) view;
            [webScrollView addSubview:table];
        }
    }
    
    [self processWebView];
    
    [self.view addSubview:boastView];
    boastView.frame=CGRectMake(0, -297, 320, 297);
    boastView.alpha=0;
    [self makeViewTranparent:boastTable];
    
    [super viewDidLoad];
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

-(void) viewWillDisappear:(BOOL)animated{
    [self hideBoastTable];
    [super viewWillDisappear:animated];
}

-(void) reloadTable{
    [table reloadData];
    table.frame=CGRectMake(0, -table.contentSize.height, 320, table.contentSize.height);
    webScrollView.contentInset=UIEdgeInsetsMake(table.contentSize.height, 0, 0, 0);
}

-(void) loadDescription{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
    NSString *htmlDescription=[NSString stringWithFormat:htmlWrapper,[feed htmlStory]];
    [webView loadHTMLString:htmlDescription baseURL:[NSURL URLWithString:@"www.appmaggot.com\test"]];
    [pool release];
}

-(void) doubleTapReceived:(id) sender{
    NSLog(@"Double tap");
    if (fbStatusView.alpha==1.0 || tweeterStatusView.alpha==1.0 || boastView.alpha>0) {
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
    [wvc loadRequest:request];
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
    [appDelegate publishContent:feed withPostMessage:tfMessage.text];
    tfMessage.text=nil;
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

-(IBAction) cancelTweetTapped:(id)sender{
    [UIView beginAnimations:@"Hide facebook view" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    tweeterStatusView.center=CGPointMake(160, -60);
    tweeterStatusView.alpha=0;
    [UIView commitAnimations];
    webView.userInteractionEnabled=YES;
}

-(IBAction) tweetTapped:(id)sender{
    NouvelleAppDelegate *appDelegate=(NouvelleAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *post=[NSString stringWithFormat:@"%@ - %@",feed.title,[feed.link stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [appDelegate postOnTwitter:post];
    
    [UIView beginAnimations:@"Show Twitter view" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    tweeterStatusView.center=CGPointMake(160, -60);
    tweeterStatusView.alpha=0;
    [UIView commitAnimations];
    webView.userInteractionEnabled=YES;
    lblTweet.text=nil;
}

-(IBAction)twitterClicked{
    lblTweet.text=[NSString stringWithFormat:@"%@ - %@",feed.title,feed.link];
    [UIView beginAnimations:@"Show facebook view" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    tweeterStatusView.center=CGPointMake(160, 60);
    tweeterStatusView.alpha=1;
    [UIView commitAnimations];
    webView.userInteractionEnabled=NO;
}

-(IBAction)emailClicked:(id)sender{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposer=[[MFMailComposeViewController alloc] init];
        NSString *title=[NSString stringWithFormat:@"<a href='%@'><b>%@</b></a><hr><b>Published on</b> %@ <br><b>On</b> %@<br><hr><br>",feed.link,feed.title,[AMFeedManager titleForFeedID:feed.feedID],feed.date];
        NSString *htmlDescription=[NSString stringWithFormat:@"%@%@ <br><div style='background-color:white;link:orange;text-align:center'> <hr> <a href='http://www.appmaggot.com/nouvelle/itunes.php'> I want Nouvelle for iOS</a><hr></div>",title, [feed htmlStory]];
        NSString *mailTitle=[NSString stringWithFormat:@"%@ - Sent by Nouvelle for iOS",feed.title];
        mailComposer.mailComposeDelegate = self;
        
        [mailComposer setSubject:mailTitle];
        [mailComposer setMessageBody:htmlDescription isHTML:YES];
        [self presentModalViewController:mailComposer animated:YES];
        [mailComposer release];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (table==tableView) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==table) {
        return 3;
    }else{
        if (section==0) {
            return 2;
        }else{
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==table) {
        static NSString *cellIdentifier=@"Cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.textLabel.font=indexPath.row==0?[General regularLabelFont]:[General descriptionFont];
            cell.textLabel.textColor=[UIColor whiteColor];
            cell.backgroundColor=[UIColor blackColor];
            if (indexPath.row!=0) {
                cell.textLabel.textAlignment=UITextAlignmentRight;
            }else{
                cell.textLabel.numberOfLines=10;
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=feed.title;
                break;
            case 1:
                cell.textLabel.text=[feed.date description];
                break;
            case 2:
                cell.textLabel.text=feed.author;
                break;
            default:
                break;
        }
        return cell;
    }else{
        static NSString *cellIdentifier=@"ShareCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell==nil) {
            cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.textLabel.font=[General regularLabelFont];
            cell.textLabel.textColor=[UIColor whiteColor];
            cell.backgroundColor=[UIColor blackColor];
        }
        
        if (indexPath.section==0) {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=@"On Facebook";
                    break;
                case 1:
                    cell.textLabel.text=@"On Twitter";
                    break;
            }
        }else{
            cell.textLabel.text=@"Leave us review on iTunes";
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==table) {
        if (indexPath.row==0) {
            CGSize maximumLabelSize = CGSizeMake(280,9999);
            CGSize expectedLabelSize = [feed.title sizeWithFont:[General regularLabelFont]
                                              constrainedToSize:maximumLabelSize 
                                                  lineBreakMode:UILineBreakModeTailTruncation]; 
            
            return expectedLabelSize.height+18;
        }
        return 30;
    }else{
        return 44;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==table) {
        AMWebViewController *wvc=(AMWebViewController*)[self.zoomController.viewControllers objectAtIndex:4];
        [wvc loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:feed.link]]];
        [self.zoomController pushToIndex:4];
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (table==tableView) {
        return;
    }
    
    
    NouvelleAppDelegate *appDelegate=(NouvelleAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            [appDelegate boastOnFacebook];
        }else{
            [appDelegate boastOnTwitter];
        }
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.appmaggot.com/nouvelle/itunes.php"]];
    }
    [self hideBoastTable];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView==table) {
        return nil;
    }
    UILabel *label=[[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)] autorelease];
    label.font=[General regularLabelFont];
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    
    UIView *headerView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    [headerView addSubview:label];
    
    if (section==0) {
        label.text=@"Share your love for us on";
    }else{
        label.text=@"Or alternatively";
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (table==tableView) {
        return 0;
    }
    return 44;
}

-(IBAction) heartTapped:(id)sender{
    [self showBoastTable];
}

-(void) showBoastTable{
    [UIView beginAnimations:@"Show boast view" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    boastView.frame=CGRectMake(0, 0, 320, 297);
    boastView.alpha=1;
    [UIView commitAnimations];
    webView.userInteractionEnabled=NO;
}

-(IBAction) hideBoastTable{
    [UIView beginAnimations:@"Hide boast view" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.2];
    boastView.frame=CGRectMake(0, -297, 320, 297);
    boastView.alpha=0;
    [UIView commitAnimations];
    webView.userInteractionEnabled=YES;
}

@end
