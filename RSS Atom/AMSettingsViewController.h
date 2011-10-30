//
//  AMSettingsViewController.h
//  Nouvelle
//
//  Created by Shashank Patel on 10/30/11.
//  Copyright (c) 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NouvelleAppDelegate.h"
#import <MessageUI/MessageUI.h>

@class AMFeedListViewController;

@interface AMSettingsViewController : NSObject<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>{
    NouvelleAppDelegate *appDelegate;
    IBOutlet AMFeedListViewController *source;
}

@property(nonatomic,retain) AMFeedListViewController *source;

-(int) countForLoggedSocialNetworks;

@end
