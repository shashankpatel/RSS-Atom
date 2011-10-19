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
    NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"AMFeedCell" owner:@"AMFeedListViewController" options:nil];
    for (NSObject *obj in nib) {
        if ([obj isKindOfClass:[AMFeedCell class]]) {
            [(AMFeedCell*)obj loadFeedCell];
            return obj;
        }
    }
    return nil;
}

-(void) shrink{
    shrunk=YES;
    [self setFrames];
}

-(void) expand{
    shrunk=NO;
    [self setFrames];
}

-(void) setFrames{
    if (shrunk) {
        titleLabel.frame=titleFrameShrunk;
        titleLabel.numberOfLines=3;
        descriptionLabel.frame=descriptionFrameRet;
        descriptionLabel.hidden=YES;
        if (feedImage.image) {
            feedImage.frame=feedImageFrame;
        }else{
            feedImage.frame=feedImageFrameRet;
        }
    }else{
        titleLabel.frame=titleFrame;
        titleLabel.numberOfLines=1;
        descriptionLabel.hidden=NO;
        if (feedImage.image) {
            descriptionLabel.frame=descriptionFrameRet;
        }else{
            descriptionLabel.frame=descriptionFrame;
        }
        feedImage.frame=feedImageFrame;
    }
}

-(void) loadFeedCell{
    titleFrame=titleLabel.frame;
    descriptionFrameRet=descriptionLabel.frame;
    feedImageFrame=feedImage.frame;
    
    titleFrameShrunk=CGRectMake(0,5,70,80);
    descriptionFrameShrunk=descriptionLabel.frame;
    
    descriptionFrame=CGRectMake(0, 30, 280, 50);
    feedImageFrameRet=CGRectMake(0,10, 0, 70);
    
    [feedImage initAMImageView];
}

-(void) loadImageFromURLString:(NSString*) urlString{
    feedImage.frame=feedImageFrameRet;
    descriptionLabel.frame=shrunk?descriptionFrameRet:descriptionFrame;
    if (urlString) {
        [feedImage setImageWithContentsOfURLString:urlString];
    }
}



-(void) imageSuccessfullyLoadedLive{
    [UIView beginAnimations:@"Image Load Animation" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [self setFrames];
    [UIView commitAnimations];
}

-(void) imageSuccessfullyLoadedLocally{
    [self setFrames];
}

-(void) imageFailedToLoad{
    [self setFrames];
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
