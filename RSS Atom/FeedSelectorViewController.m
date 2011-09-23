//
//  FeedSelectorViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "FeedSelectorViewController.h"
#import "General.h"
@implementation FeedSelectorViewController

@synthesize delegate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //[UIFont fontWithName: @"SegoeUI" size: 17];
    feedURLs=[[NSMutableArray alloc] initWithObjects:@"Gizmodo",@"Techcrunch",@"Mashable",@"Daring Fireball",nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[feedURLs objectAtIndex:indexPath.row]]];
    return cell;
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
    return 50;
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

-(void) dealloc{
    [feedURLs release];
    [delegate release];
    [super dealloc];
}


@end
