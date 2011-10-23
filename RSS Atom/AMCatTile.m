//
//  AMCatTile.m
//  Nouvelle
//
//  Created by Shashank Patel on 10/24/11.
//  Copyright (c) 2011 Not Applicable. All rights reserved.
//

#import "AMCatTile.h"

@implementation AMCatTile

@synthesize button;
@synthesize index;

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
    
}



@end
