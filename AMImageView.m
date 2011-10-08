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
@synthesize shouldLoadImage;
@synthesize connection;

- (void)initAMImageView
{
    shouldLoadImage=YES;
    receievedData=[[NSMutableData alloc] init];
    // Initialization code here.
}

-(void) setImageWithContentsOfURLString:(NSString*) _urlString{
    self.image=nil;
    self.urlString=_urlString;
    [self.connection cancel];
    self.connection=nil;
    if ((self.image=[AMSerializer imageForURLString:urlString])) {
        [delegate imageSuccessfullyLoadedLocally];
    }
    
    [self resetImage];
}

-(void) resetImage{
    if (self.image) {
        return;
    }
    
    if (!shouldLoadImage) {
        return;
    }
    
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.connection cancel];
    self.connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
    }
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
        NSLog(@"Loaded: %@",urlString);
        [AMSerializer serializeImage:downloadedImage forURLString:urlString];
            [delegate imageSuccessfullyLoadedLive];
    }
    
    [receievedData setLength:0];
    self.connection=nil;
}

-(UIImage*) thumbmnailFromImage:(UIImage*) image{
    float width,height;
    width=image.size.width;
    height=image.size.height;
    if (width<130 && height<130) {
        return  image;
    }
    
    float ratio=130.0/MAX(width, height);
    width*=ratio;
    height*=ratio;
    NSLog(@"%f,%f",width,height);
    return [image resizedImage:CGSizeMake(width, height) 
          interpolationQuality:1.0];
}

- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error{
    self.connection=nil;
    [delegate imageFailedToLoad];
}

-(void) dealloc{
    self.connection=nil;
    [receievedData release];
    [delegate release];
    [urlString release];
    [super dealloc];
}

@end
