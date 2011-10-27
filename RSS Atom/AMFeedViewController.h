//
//  FeedViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/23/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMViewController.h"
#import "MWFeedItem.h"
#import "AMImageView.h"

@protocol FeedViewDelegate <NSObject>

-(void) btnListPressed;

@end

@interface AMFeedViewController : AMViewController<UIGestureRecognizerDelegate,UIWebViewDelegate>{
    NSObject<FeedViewDelegate> *delegate;
    IBOutlet UIWebView *webView;
    MWFeedItem *feed;
    IBOutlet UIView *fbStatusView,*tweeterStatusView;
    IBOutlet UITextField *tfMessage;
    IBOutlet UILabel *lblTitle,*lblCaption,*lblDescription,*lblTweet;
    IBOutlet AMImageView *imageView;
    BOOL pageLoaded;
}

@property(nonatomic,retain) NSObject<FeedViewDelegate> *delegate;
@property(nonatomic,retain) MWFeedItem *feed;

-(void) processWebView;

-(IBAction) btnListPressed:(id)sender;
-(void) loadDescription;
-(IBAction)facebookClicked;
-(IBAction)twitterClicked;
-(IBAction)postTapped:(id)sender;
-(IBAction) cancelTapped:(id)sender;
-(IBAction) cancelTweetTapped:(id)sender;
-(IBAction) tweetTapped:(id)sender;

@end
