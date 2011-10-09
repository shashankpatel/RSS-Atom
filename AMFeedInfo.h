//
//  AMFeedInfo.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/28/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMFeedInfo : NSObject{
    NSString *title,*urlString,*link;
    int feedID;
}

@property(nonatomic,retain) NSString *title,*urlString,*link;
@property int feedID;

@end
