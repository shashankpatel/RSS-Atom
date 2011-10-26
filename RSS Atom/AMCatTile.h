//
//  AMCatTile.h
//  Nouvelle
//
//  Created by Shashank Patel on 10/24/11.
//  Copyright (c) 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMCatTile : UIView{
    IBOutlet UIButton *button,*deleteButton;;
    int index;
    NSDate *touchStartDate;
    NSObject *subTarget;
    SEL subSelector;
    
}

@property(nonatomic,readonly) IBOutlet UIButton *button,*deleteButton;
@property int index;
@property(nonatomic,retain) NSDate *touchStartDate;

+(id) catTile;
-(void)loadCatTile;
-(IBAction) touchDown;
-(IBAction) touchUp;
-(void) showDelete;
-(void) hideDelete;
-(void) addSubTarget:(NSObject*) _target selector:(SEL) _selector;

@end
