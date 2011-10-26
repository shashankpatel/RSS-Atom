//
//  AMCatTile.m
//  Nouvelle
//
//  Created by Shashank Patel on 10/24/11.
//  Copyright (c) 2011 Not Applicable. All rights reserved.
//

#import "AMCatTile.h"

@implementation AMCatTile

@synthesize button,deleteButton;
@synthesize index;
@synthesize touchStartDate;

+(id) catTile{
    NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"AMCatTile" owner:nil options:nil];
    for (NSObject *obj in nib) {
        if ([obj isKindOfClass:[AMCatTile class]]) {
            [(AMCatTile*)obj loadCatTile];
            return obj;
        }
    }
    return nil;
}

-(void)loadCatTile{
    deleteButton.transform=CGAffineTransformMakeScale(0.1, 0.1);
    deleteButton.alpha=0;
}

-(IBAction) touchDown{
    self.touchStartDate=[[NSDate alloc] init];
    [touchStartDate release];
}

-(IBAction) touchUp{
    return;
    NSDate *touchEndDate=[NSDate date];
    float dt=[touchEndDate timeIntervalSinceDate:touchStartDate];
    if (dt<1) {
        [subTarget performSelector:subSelector withObject:self.button];
    }
    NSLog(@"dt:%f",dt);
}

-(void) addSubTarget:(NSObject*) _target selector:(SEL) _selector{
    subTarget=[_target retain];
    subSelector=_selector;
}

-(void) showDelete{
    deleteButton.transform=CGAffineTransformMakeScale(1,1);
    deleteButton.alpha=1;
    button.userInteractionEnabled=NO;
}

-(void) hideDelete{
    deleteButton.transform=CGAffineTransformMakeScale(0.1,0.1);
    deleteButton.alpha=0;
    button.userInteractionEnabled=YES;
}

-(void) dealloc{
    [subTarget release];
    [touchStartDate release];
    [button release];
    [super dealloc];
}


@end
