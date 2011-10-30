//
//  AMFeedListViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMFeedListViewController.h"
#import "General.h"
#import "NSString+HTML.h"
#import "AMFeedManager.h"
#import "ElementParser.h"
#import "AMFeedCell.h"
#import <QuartzCore/QuartzCore.h>
#import "NouvelleAppDelegate.h"

@implementation AMFeedListViewController

@synthesize currentView;
@synthesize feedInfo;
@synthesize feedViewController;
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;
@synthesize feeds;

#define REFRESH_HEADER_HEIGHT 52.0f

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    feedTitle.font=[General regularLabelFont];
    [self addPullToRefreshHeader];
    [self initController];
    [self makeViewTranparent:table];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

static BOOL initialized=NO;

-(void) initController{
    cells=[[NSMutableArray alloc] init];
    feeds=[[NSMutableArray alloc] init];
    tempFeeds=[[NSMutableArray alloc] init];

    feedParser=[[MWFeedParser alloc] initWithFeedURL:feedInfo.urlString];
    feedParser.connectionType=ConnectionTypeAsynchronously;
    feedParser.delegate=self;
    initialized=YES;
}

-(void) viewWillDisappear:(BOOL)animated{
    stopIssued=YES;
    [feedParser stopParsing];
    [feedParser reset];
    if (self.zoomController.transitionType==kTransitionTypePop) {
        for (AMFeedCell *cell in cells) {
            cell.feedImage.shouldLoadImage=YES;
            [cell.feedImage stopLoading];
        }
        [feeds removeAllObjects];
        [table reloadData];
    }
    [super viewWillDisappear:animated];
}

-(IBAction) backgroundButtonPressed:(id)sender{
    if (viewMode==kViewModeShrunk) {
        [self.zoomController pushToIndex:3 expand:YES];
    }
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) shrink{
    //self.view.frame=CGRectMake(0, 0, 120, 460);
    table.frame=CGRectMake(0, 44, 110, 416);
    for (AMFeedCell *cell in cells) {
        [cell shrink];
    }
    viewMode=kViewModeShrunk;
}

-(void) expand{
    //self.view.frame=CGRectMake(0, 0, 320, 460);
    table.frame=CGRectMake(0, 44, 320, 416);
    viewMode=kViewModeNormal;
    for (AMFeedCell *cell in cells) {
        [cell expand];
    }
    
    feedViewController.titleBarView.alpha=1;
    feedViewController.view.transform=CGAffineTransformIdentity;
    feedViewController.view.alpha=0;
}

static BOOL skip=YES;

-(void) viewWillAppear:(BOOL)animated{
    if (skip) {
        skip=NO;
        return;
    }
    stopIssued=NO;
    if (self.zoomController.transitionType==kTransitionTypePush) {
        self.feeds=[AMFeedManager feedsForFeedID:feedInfo.feedID];
        NSLog(@"Loaded %d feeds for %d",[self.feeds count], feedInfo.feedID);
        [table reloadData];
        [self performSelector:@selector(reloadFeeds) withObject:nil afterDelay:0.5];
    }
    [super viewWillAppear:animated];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void) makeViewTranparent:(UIView *) view{
    for (UIView *subView in [view subviews]) {
        [self makeViewTranparent:subView];
    }
    view.backgroundColor=[UIColor clearColor];
}

-(IBAction)feedSelectorPressed:(id)sender{
    if (self.viewMode==kViewModeShrunk) {
        [UIView beginAnimations:@"PushView" context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:nil];
        [UIView setAnimationDidStopSelector:nil];
        [self expand];
        [self.zoomController.view bringSubviewToFront:self.view];
        [UIView commitAnimations];
    }else{
        [self.zoomController popToIndex:1];
    }
}

-(void) feedInfoSelected:(AMFeedInfo*) _feedInfo{
    //Some loading functionality for feed goes here
    self.feedInfo=_feedInfo;
    feedTitle.text=[feedInfo.title stringByConvertingHTMLToPlainText];
    [feedParser setUrl:feedInfo.urlString];
    [self.zoomController pushToIndex:2];
}

-(void) feedsReceived:(NSArray*) _feeds{
    [feeds addObjectsFromArray:_feeds];
    [table reloadData];
}

-(void) btnListPressed{
    return;
}

#pragma mark - UITableViewDataSource and UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FeedCell=@"AMFEEDCELL";
    AMFeedCell *cell=(AMFeedCell*) [tableView dequeueReusableCellWithIdentifier:FeedCell];
    if (!cell) {
        cell=[[AMFeedCell cell] autorelease];
        cell.titleLabel.font=[General regularLabelFont];
        cell.titleLabel.numberOfLines=1;
        cell.descriptionLabel.font=[General descriptionFont];
        cell.descriptionLabel.numberOfLines=3;
        cell.backgroundColor=[UIColor blackColor];
        if (self.viewMode==kViewModeShrunk) {
            [cell shrink];
        }
        [cells addObject:cell];
    }
    
    MWFeedItem *feed=[feeds objectAtIndex:indexPath.row];
    cell.titleLabel.text=[feed.title stringByConvertingHTMLToPlainText];
    NSString *content=[feed htmlStory];
    cell.descriptionLabel.text=[feed plainStory];
    
	if ([feed.iconLink length]==0 && [content length]!=0) {
		NSString *iconLink=nil;
		Element* root = [Element parseHTML:content];
		NSArray* imageElements = [root selectElements: @"img"];
		
		if (imageElements!=nil && [imageElements count]>0) {
			Element* imageElement =[imageElements objectAtIndex:0];
			iconLink=[imageElement attribute:@"src"];
		}
		if (iconLink==nil || [iconLink length]==0) {
			if (feed.content!=nil && [feed.content length]!=0) {
				content=[[NSString alloc] initWithString:feed.content];
				root = [Element parseHTML: content];
				[content release];
				imageElements = [root selectElements: @"img"];
				if([imageElements count]>0){
                    Element* imageElement =[imageElements objectAtIndex:0];
                    iconLink=[imageElement attribute:@"src"];
                }
			}
		}
		if (iconLink==nil) {
			iconLink=@"";
		}
		feed.iconLink=iconLink;
	}
    [cell loadImageFromURLString:feed.iconLink];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    feedViewController.feed=[feeds objectAtIndex:indexPath.row];
    [feedViewController performSelectorInBackground:@selector(loadDescription) withObject:nil];
    if (viewMode==kViewModeNormal) {
        [self.zoomController pushToIndex:3];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark -MWFeedParserDelegate methods

- (void)feedParserDidStart:(MWFeedParser *)parser{
    NSLog(@"Parsing started");
    //self.view.window.userInteractionEnabled=NO;
    [tempFeeds removeAllObjects];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info{
    
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item{
    item.feedID=feedInfo.feedID;
    [tempFeeds addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser{
    [self stopLoading];
    if (stopIssued) {
        stopIssued=NO;
        return;
    }
    [AMFeedManager addFeeds:tempFeeds forFeedID:feedInfo.feedID];
    self.feeds=[AMFeedManager feedsForFeedID:feedInfo.feedID];
    NSLog(@"Parsing finished");
    [table reloadData];
    [self stopLoading];
    //self.view.window.userInteractionEnabled=YES;
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    NSLog(@"Error:%@",[error description]);
    [self stopLoading];
}

#pragma UIScrollViewDelegate methods

- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 16) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 26) / 2),
                                    16, 26);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [table addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
    for (AMFeedCell *cell in cells) {
        cell.feedImage.shouldLoadImage=NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            table.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            table.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (AMFeedCell *cell in cells) {
        cell.feedImage.shouldLoadImage=YES;
        [cell.feedImage resetImage];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
    if (!decelerate) {
        for (AMFeedCell *cell in cells) {
            cell.feedImage.shouldLoadImage=YES;
            [cell.feedImage resetImage];
        }
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    table.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    table.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [feedParser parse];
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

- (void) reloadFeeds {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    stopIssued=YES;
    [feedParser stopParsing];
    [feedParser reset];
    [feedParser parse];
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

-(IBAction) wrenchPressed:(id)sender{
    NouvelleAppDelegate *appDelegate=(NouvelleAppDelegate*) [[UIApplication sharedApplication] delegate];
    [appDelegate logoutFromfacebook];
}

@end
