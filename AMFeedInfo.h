//
//  AMFeedInfo.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/28/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMFeedInfo : NSObject{
    NSString *title,*urlString,*link,*category;
    int feedID,sortIndex;
}

@property(nonatomic,retain) NSString *title,*urlString,*link,*category;
@property int feedID,sortIndex;

@end
