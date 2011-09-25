//
//  AMViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/25/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMZoomViewController.h"

@interface AMViewController : UIViewController{
    AMZoomViewController *zoomController;
}

@property(nonatomic,retain) AMZoomViewController *zoomController;

@end
