//
//  AMImageView.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/23/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMImageViewDelegate <NSObject>

-(void) imageSuccessfullyLoadedLive;
-(void) imageSuccessfullyLoadedLocally;
-(void) imageFailedToLoad;

@end

@interface AMImageView : UIImageView {
    NSURLConnection *connection;
    NSMutableData *receievedData;
    IBOutlet NSObject<AMImageViewDelegate> *delegate;
    NSString *urlString;
}

@property(nonatomic,retain) NSObject<AMImageViewDelegate> *delegate;

-(void) setImageWithContentsOfURLString:(NSString*) urlString;

@end
