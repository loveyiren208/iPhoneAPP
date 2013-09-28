//
//  APFacebookViewController.m
//  AppPartnerTest
//
//  Created by Xiaonan Wang on 7/2/13.
//  Copyright (c) 2013 Xiaonan Wang. All rights reserved.
//

#import "APFacebookViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "APAppDelegate.h"
#import "APFriendInfo.h"
#import "APFriendCell.h"
@interface APFacebookViewController (){
    NSMutableArray *myFriends;
    NSArray *cachedFriends;
}

@property (strong, nonatomic) IBOutlet UITableView *friendsTable;
- (IBAction)reload:(id)sender;
@end

@implementation APFacebookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    myFriends = [[NSMutableArray alloc] init];
    cachedFriends = [[NSArray alloc] init];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_apppartner.png"]];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(logoutButtonWasPressed:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionStateChanged:)
                                                 name:AppPartnerSessionStateChangedNotification object:nil];
    
    if(FBSession.activeSession.isOpen){
        [self populateFriendsDetails];
    }
    
    cachedFriends = nil;
    [self populateFriendsDetails];
}


-(void)sessionStateChanged:(NSNotification*)notification{
    [self populateFriendsDetails];
}

//log out is pressed
-(void)logoutButtonWasPressed:(id)sender{
    [FBSession.activeSession closeAndClearTokenInformation];
}

// get friends info: full name and profile picture
-(void)populateFriendsDetails{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMyFriends] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if( cachedFriends != nil){
                return;
            }
            if (!error) {
                NSArray *friends = [user objectForKey:@"data"];
                myFriends = [[NSMutableArray alloc] init];
                NSLog(@"%@",[friends objectAtIndex:2]);
                
                for(NSDictionary<FBGraphUser>* friend in friends){
                    APFriendInfo *f = [[APFriendInfo alloc] init];
                    f.userID = friend.id;
                    f.fullName = friend.name;
                    //[f.pictureView alloc];
                    
                    //f.pictureView.profileID = friend.id;
                    [myFriends addObject:f];
                    
                    // NSLog(@"%d",[cachedFriends count]);
                    
                }
                cachedFriends = [myFriends copy];
               // NSLog(@"%d",[cachedFriends count]);
                
            }
            [[self friendsTable] reloadData];
            
        }];
    }
    
    [[self friendsTable] reloadData];
}


- (IBAction)reload:(id)sender {
    cachedFriends = nil;
    [self populateFriendsDetails];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%d",[cachedFriends count]);
    return [cachedFriends count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    APFriendCell *cell =(APFriendCell*) [tableView
                                         dequeueReusableCellWithIdentifier:@"FriendCell"];
    //delete old picture
    if(cell){
        cell.picture.profileID = nil;
    }
	APFriendInfo *friend = [cachedFriends objectAtIndex:indexPath.row];
    cell.nameLabel.text = friend.fullName;
    cell.picture.profileID = friend.userID;

    //set up cell background
    UIImage *rowBackground;
    NSInteger row = [indexPath row];
    NSInteger max = [tableView numberOfRowsInSection:[indexPath section]];
    if(row == 0 && row == max -1){
        rowBackground = [UIImage imageNamed:@"cell_single.png"];
    }else if(row ==0){
        rowBackground = [UIImage imageNamed:@"cell_top.png"];
        
    }else if(row ==max - 1){
        rowBackground = [UIImage imageNamed:@"cell_bottom.png"];
        
    }else {
        rowBackground = [UIImage imageNamed:@"cell_middle.png"];
    }
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:rowBackground];
    cellBackgroundView.image = rowBackground;
    cell.backgroundView = cellBackgroundView;
    
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
