//
//  AMFeedInfo.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/28/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMFeedInfo.h"

@implementation AMFeedInfo

@synthesize title,urlString,link,category;
@synthesize feedID,sortIndex;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) dealloc{
    [title release];
    [urlString release];
    [link release];
    [category release];
    [super dealloc];
}

@end
