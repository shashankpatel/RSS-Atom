//
//  AMImageView.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/23/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMImageView.h"
#import "AMSerializer.h"
#import "UIImage+Resize.h"

@implementation AMImageView

@synthesize delegate;
@synthesize urlString;
@synthesize shouldLoadImage,shouldLoadSmallImage;
@synthesize connection;

- (void)initAMImageView
{
    shouldLoadImage=YES;
    receievedData=[[NSMutableData alloc] init];
    // Initialization code here.
}

-(void) setImageWithContentsOfURLString:(NSString*) _urlString{
    self.image=nil;
    self.urlString=[_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self stopLoading];
    if ((self.image=[AMSerializer imageForURLString:urlString])) {
        [delegate imageSuccessfullyLoadedLocally];
    }
    
    [self resetImage];
}

-(void) stopLoading{
    [self.connection cancel];
    [connection release];
    connection=nil;
    
}

-(void) resetImage{
    [self stopLoading];
    
    if (self.image) {
        return;
    }
    
    if (!shouldLoadImage) {
        return;
    }
    
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    self.connection=[NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receievedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receievedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection{
    NSData *imageData=[NSData dataWithData:receievedData];
    if ([receievedData length]==0) {
        [delegate imageFailedToLoad];
    }else{
        UIImage *downloadedImage=[self thumbmnailFromImage:[UIImage imageWithData:imageData]];
        self.image=downloadedImage;
        if (downloadedImage.size.width>10 && downloadedImage.size.height>10) {
            [AMSerializer serializeImage:downloadedImage forURLString:urlString];
            [delegate imageSuccessfullyLoadedLive];
        }
    }
    
    [receievedData setLength:0];
    self.connection=nil;
}

-(UIImage*) thumbmnailFromImage:(UIImage*) image{
    float width,height;
    width=image.size.width;
    height=image.size.height;
    
    if (width<140 && height<140) {
        if ((width<30 || height<30)) {
            if (shouldLoadSmallImage) {
                return image;
            }else{
                return nil;
            }
        }
        return  image;
    }
    
    float ratio=140.0/MAX(width, height);
    width*=ratio;
    height*=ratio;
    return [image resizedImage:CGSizeMake(width, height) 
          interpolationQuality:1.0];
}

- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error{
    self.connection=nil;
    [delegate imageFailedToLoad];
}

-(void) dealloc{
    [self.connection cancel];
    self.connection=nil;
    [receievedData release];
    [delegate release];
    [urlString release];
    [super dealloc];
}

@end
