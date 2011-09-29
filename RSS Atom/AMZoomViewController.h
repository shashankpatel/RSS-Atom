//
//  AMZoomViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/25/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMZoomViewController : UIViewController {
    NSMutableArray *viewControllers;
    UIViewController *currentViewController;
    int currentIndex;
}

@property(nonatomic,retain) NSMutableArray *viewControllers;
@property(nonatomic,retain) UIViewController *currentViewController;
@property int currentIndex;

-(id) initWithViewController:(UIViewController*) viewController;
-(id) initWithViewControllers:(NSArray*) controllers startIndex:(int) startIndex;

-(void) pushToIndex:(int) newIndex;
-(void) popToIndex:(int) newIndex;

@end