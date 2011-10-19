//
//  AMZoomViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/25/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMViewController;

#define kTransitionTypePush 0
#define kTransitionTypePop 1

@interface AMZoomViewController : UIViewController {
    NSMutableArray *viewControllers;
    AMViewController *currentViewController;
    int currentIndex;
    int transitionType;
}

@property(nonatomic,retain) NSMutableArray *viewControllers;
@property(nonatomic,retain) AMViewController *currentViewController;
@property int currentIndex;
@property int transitionType;

-(id) initWithViewController:(UIViewController*) viewController;
-(id) initWithViewControllers:(NSArray*) controllers startIndex:(int) startIndex;

-(void) pushToIndex:(int) newIndex;
-(void) popToIndex:(int) newIndex;
-(void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

-(void) popToIndex:(int) newIndex shrink:(BOOL) shrink;
-(void) pushToIndex:(int) newIndex expand:(BOOL) shrink;

@end
