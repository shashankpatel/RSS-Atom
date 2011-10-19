//
//  AMViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/25/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMZoomViewController.h"


#define kViewModeNormal 0
#define kViewModeShrunk 1

@interface AMViewController : UIViewController{
    AMZoomViewController *zoomController;
    int viewMode;
    IBOutlet UIView *titleBarView;
}

@property(nonatomic,retain) AMZoomViewController *zoomController;
@property int viewMode;
@property(nonatomic,readonly) IBOutlet UIView *titleBarView;


-(void) shrink;
-(void) expand;

@end
