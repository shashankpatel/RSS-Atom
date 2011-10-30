//
//  AMSettingsViewController.m
//  Nouvelle
//
//  Created by Shashank Patel on 10/30/11.
//  Copyright (c) 2011 Not Applicable. All rights reserved.
//

#import "AMSettingsViewController.h"
#import "General.h"

@implementation AMSettingsViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font=[General selectedFontRegular];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor blackColor];
    }
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"Logout from Facebook";
            cell.imageView.image=[UIImage imageNamed:@"facebookIconSmall.png"];
        }else{
            cell.textLabel.text=@"Logout from Twitter";
            cell.imageView.image=[UIImage imageNamed:@"twitterIconSmall.png"];
        }
    }else{
        if (indexPath.row==0) {
            cell.textLabel.text=@"Show tutorial";
            cell.imageView.image=[UIImage imageNamed:@"helpIconSmall"];
        }else{
            cell.textLabel.text=@"Feedback & support";
            cell.imageView.image=[UIImage imageNamed:@"emailIconSmall.png"];
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label=[[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 44)] autorelease];
    label.font=[General regularLabelFont];
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    
    UIView *headerView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    [headerView addSubview:label];
    
    if (section==0) {
        label.text=@"Manage social networks";
    }else{
        label.text=@"Help and support";
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

@end
