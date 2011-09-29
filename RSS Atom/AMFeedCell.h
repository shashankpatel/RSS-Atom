//
//  AMFeedCell.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/29/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMImageView.h"

@interface AMFeedCell : UITableViewCell<AMImageViewDelegate>{
    IBOutlet UILabel *titleLabel,*descriptionLabel;
    IBOutlet AMImageView *feedImage;
    CGRect titleFrame,descriptionFrame,feedImageFrame;
    CGRect descriptionFrameRet,feedImageFrameRet;
}

@property(nonatomic,retain) IBOutlet UILabel *titleLabel,*descriptionLabel;
@property(nonatomic,retain) IBOutlet AMImageView *feedImage;

+(id) cell;
-(void) loadFeedCell;
-(void) loadImageFromURLString:(NSString*) urlString;

@end
