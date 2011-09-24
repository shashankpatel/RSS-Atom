//
//  FeedViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/23/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedViewDelegate <NSObject>

-(void) btnListPressed;

@end

@interface FeedViewController : UIViewController<UIGestureRecognizerDelegate,UIWebViewDelegate>{
    NSObject<FeedViewDelegate> *delegate;
    IBOutlet UIWebView *webView;
}

@property(nonatomic,retain) NSObject<FeedViewDelegate> *delegate;

-(void) processWebView;

-(IBAction) btnListPressed:(id)sender;

@end
