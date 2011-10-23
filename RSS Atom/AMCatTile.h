//
//  AMCatTile.h
//  Nouvelle
//
//  Created by Shashank Patel on 10/24/11.
//  Copyright (c) 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMCatTile : UIView{
    IBOutlet UIButton *button;
    int index;
}

@property(nonatomic,readonly) IBOutlet UIButton *button;
@property int index;

+(id) catTile;
-(void)loadCatTile;

@end
