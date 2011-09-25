//
//  FeedSelectorViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "FeedSelectorViewController.h"
#import "General.h"
#import "AMImageView.h"
#import "HomeViewController.h"

@implementation FeedSelectorViewController

@synthesize delegate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    feedURLs=[[NSMutableArray alloc] initWithObjects:@"Gizmodo",@"Techcrunch",@"Mashable",@"Daring Fireball",@"Wired",@"Engadget",nil];
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [feedURLs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FeedCell=@"CELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:FeedCell];
    if (!cell) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeedCell] autorelease];
        cell.textLabel.font=[General selectedFontRegular];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
    }
    cell.textLabel.text=[feedURLs objectAtIndex:indexPath.row];
    NSString *urlString=[NSString stringWithFormat:@"http://www.google.com/s2/favicons?domain=www.%@.com",[[feedURLs objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@""]];

    AMImageView *amiv=[[AMImageView alloc] init];
    [cell addSubview:amiv];
    [amiv setImageWithContentsOfURLString:urlString];
    amiv.frame=CGRectMake(20, 15, 16, 16);
    [amiv release];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [delegate feedSelectedForURLString:nil];
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
    UILabel *label=[[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 30)] autorelease];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.font=[General selectedFontRegular];
    label.text=@"Technology";
    [headerView addSubview:label];
    return  headerView;
}

-(IBAction) addFeedPressed:(id)sender{
    [self.zoomController popToIndex:0];
}

-(void) dealloc{
    [feedURLs release];
    [delegate release];
    [super dealloc];
}


@end
