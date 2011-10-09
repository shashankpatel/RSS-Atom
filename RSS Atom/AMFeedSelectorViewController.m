//
//  FeedSelectorViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMFeedSelectorViewController.h"
#import "General.h"
#import "AMImageView.h"
#import "HomeViewController.h"
#import "AMFeedManager.h"
#import "NSString+HTML.h"

@implementation AMFeedSelectorViewController

@synthesize delegate;
@synthesize feedInfos;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void) viewWillAppear:(BOOL)animated{
    self.feedInfos=[AMFeedManager allFeedInfos];
    if ([feedInfos count]==0) {
        removeButton.hidden=YES;
    }else{
        removeButton.hidden=NO;
    }
    [table reloadData];
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [feedInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FeedCell=@"CELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:FeedCell];
    if (!cell) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeedCell] autorelease];
        cell.textLabel.font=[General selectedFontRegular];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        
        AMImageView *amiv=[[AMImageView alloc] init];
        amiv.tag=2222;
        [cell.contentView addSubview:amiv];
        amiv.frame=CGRectMake(20, 15, 16, 16);
        [amiv release];
    }
    
    AMFeedInfo *feedInfo=[feedInfos objectAtIndex:indexPath.row];
    cell.textLabel.text=[feedInfo.title stringByConvertingHTMLToPlainText];
    NSRange startRange,endRange;
    NSString *domain=feedInfo.link;
    startRange=[domain rangeOfString:@"//"];
    if (startRange.location==NSNotFound) {
        domain=@"helloworld/";
    }
    startRange.location=startRange.location+2;
    domain=[domain substringFromIndex:startRange.location];
    endRange=[domain rangeOfString:@"/"];
    domain=[domain substringToIndex:endRange.location];
    domain=[domain stringByReplacingOccurrencesOfString:@"www." withString:@""];
    NSString *urlString=[[NSString stringWithFormat:@"http://www.google.com/s2/favicons?domain=%@",domain] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    AMImageView *amiv=(AMImageView*) [cell viewWithTag:2222];
    [amiv setImageWithContentsOfURLString:urlString];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [delegate feedInfoSelected:[feedInfos objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    headerView.backgroundColor=[UIColor clearColor];
    UILabel *label=[[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 240, 30)] autorelease];
    label.center=CGPointMake(160, 20);
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=UITextAlignmentCenter;
    label.font=[General selectedFontRegular];
    label.text=@"Technology";
    [headerView addSubview:label];
    
    UIButton *rButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setImage:[UIImage imageNamed:@"removeIconSmall.png"] forState:UIControlStateNormal];
    rButton.frame=CGRectMake(0, 0, 40, 40);
    [headerView addSubview:rButton];
    
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"addIconSmall.png"] forState:UIControlStateNormal];
    addButton.frame=CGRectMake(280, 0, 40, 40);
    [headerView addSubview:addButton];
    
    return  headerView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    AMFeedInfo *feedInfo=[feedInfos objectAtIndex:indexPath.row];
    [AMFeedManager removeFeedInfo:feedInfo];
    [feedInfos removeObject:feedInfo];
    [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    if ([feedInfos count]==0) {
        removeButton.hidden=YES;
        [self removeFeedPressed:removeButton];
    }
}

-(IBAction) addFeedPressed:(id)sender{
    [self.zoomController popToIndex:0];
}

-(IBAction) removeFeedPressed:(id)sender{
    [table setEditing:!table.editing animated:YES];
    if(table.editing){
        [removeButton setImage:[UIImage imageNamed:@"checkMarkIconSmall.png"] forState:UIControlStateNormal];
    }else{
        [removeButton setImage:[UIImage imageNamed:@"removeIconSmall.png"] forState:UIControlStateNormal];
    }
}

-(void) dealloc{
    [feedInfos release];
    [delegate release];
    [super dealloc];
}


@end
