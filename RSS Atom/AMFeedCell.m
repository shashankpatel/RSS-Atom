//
//  AMFeedCell.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/29/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMFeedCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation AMFeedCell

@synthesize titleLabel,descriptionLabel;
@synthesize feedImage;

+(id) cell{
    NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"AMFeedCell" owner:@"HomeViewController" options:nil];
    for (NSObject *obj in nib) {
        if ([obj isKindOfClass:[AMFeedCell class]]) {
            [(AMFeedCell*)obj loadFeedCell];
            return obj;
        }
    }
    return nil;
}

-(void) loadFeedCell{
    titleFrame=titleLabel.frame;
    descriptionFrameRet=descriptionLabel.frame;
    feedImageFrame=feedImage.frame;
    
    descriptionFrame=CGRectMake(0, 30, 280, 50);
    feedImageFrameRet=CGRectMake(0, 30, 0, 50);
    [feedImage initAMImageView];
}

-(void) loadImageFromURLString:(NSString*) urlString{
    feedImage.frame=feedImageFrameRet;
    descriptionLabel.frame=descriptionFrame;
    if (urlString) {
        [feedImage setImageWithContentsOfURLString:urlString];
    }
}



-(void) imageSuccessfullyLoadedLive{
    [UIView beginAnimations:@"Image Load Animation" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    feedImage.frame=feedImageFrame;
    descriptionLabel.frame=descriptionFrameRet;
    [UIView commitAnimations];
}

-(void) imageSuccessfullyLoadedLocally{
    feedImage.frame=feedImageFrame;
    descriptionLabel.frame=descriptionFrameRet;
}

-(void) imageFailedToLoad{
    NSLog(@"Image failed to load at: %@",feedImage.urlString);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) dealloc{
    [titleLabel release];
    [descriptionLabel release];
    [feedImage release];
    [super dealloc];
}

@end
