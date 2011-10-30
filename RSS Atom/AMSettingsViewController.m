//
//  AMSettingsViewController.m
//  Nouvelle
//
//  Created by Shashank Patel on 10/30/11.
//  Copyright (c) 2011 Not Applicable. All rights reserved.
//

#import "AMSettingsViewController.h"
#import "General.h"
#import "AMFeedListViewController.h"

@implementation AMSettingsViewController

@synthesize source;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (appDelegate==nil) {
        appDelegate=(NouvelleAppDelegate*) [[UIApplication sharedApplication] delegate];
    }
    
    if ([[NouvelleAppDelegate sharedFacebook] isSessionValid] || [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"]!=nil) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self countForLoggedSocialNetworks]>0 && section==0) {
        return [self countForLoggedSocialNetworks];
    }else{
        return 2;
    }
}

-(int) countForLoggedSocialNetworks{
    int count=0;
    
    if ([[NouvelleAppDelegate sharedFacebook] isSessionValid])count++;
    if([[NSUserDefaults standardUserDefaults] objectForKey: @"authData"]!=nil)count++;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.textLabel.font=[General selectedFontRegular];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor blackColor];
    }
    
    if ([self countForLoggedSocialNetworks]>0 && indexPath.section==0) {
        if ([self countForLoggedSocialNetworks]==2) {
            if (indexPath.row==0) {
                cell.textLabel.text=@"Logout from Facebook";
                cell.imageView.image=[UIImage imageNamed:@"facebookIconSmall.png"];
            }else{
                cell.textLabel.text=@"Logout from Twitter";
                cell.imageView.image=[UIImage imageNamed:@"twitterIconSmall.png"];
            }
        }else{
            if ([[NouvelleAppDelegate sharedFacebook] isSessionValid]) {
                cell.textLabel.text=@"Logout from Facebook";
                cell.imageView.image=[UIImage imageNamed:@"facebookIconSmall.png"];
            }else{
                cell.textLabel.text=@"Logout from Twitter";
                cell.imageView.image=[UIImage imageNamed:@"twitterIconSmall.png"];
            }
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
    
    if ([self countForLoggedSocialNetworks]>0 && section==0) {
        label.text=@"Manage social networks";
    }else{
        label.text=@"Help and support";
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self countForLoggedSocialNetworks]>0 && indexPath.section==0) {
        if ([self countForLoggedSocialNetworks]==2) {
            if (indexPath.row==0) {
                [appDelegate logoutFromfacebook];
            }else{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authData"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }else{
            if ([[NouvelleAppDelegate sharedFacebook] isSessionValid]) {
                [appDelegate logoutFromfacebook];
            }else{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authData"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }else{
        if (indexPath.row==0) {
            //Show tutorial
            [source tutorialSelected];
        }else{
            //Show feedback and support
            [source feedbackSelected];
        }
    }
    
    [tableView reloadData];
    tableView.superview.frame=CGRectMake(0, 0, 320, tableView.contentSize.height);
}


@end
