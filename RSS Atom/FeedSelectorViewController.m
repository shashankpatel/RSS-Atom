//
//  FeedSelectorViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "FeedSelectorViewController.h"

@implementation FeedSelectorViewController

@synthesize delegate;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    feedURLs=[[NSMutableArray alloc] initWithObjects:@"Gizmodo",@"Techcrunch",@"Meshable",@"Daring Fireball",nil];
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
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeedCell];
    }
    cell.textLabel.text=[feedURLs objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [delegate feedSelectedForURLString:nil];
}

-(void) dealloc{
    [feedURLs release];
    [delegate release];
    [super dealloc];
}


@end
