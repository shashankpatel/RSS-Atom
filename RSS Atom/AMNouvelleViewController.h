//
//  RSS_AtomViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFeedListViewController.h"
#import "AMZoomViewController.h"

@interface AMNouvelleViewController : UIViewController{
    AMFeedListViewController *AMFeedListViewController;
    AMZoomViewController *zvc;
}

@end
