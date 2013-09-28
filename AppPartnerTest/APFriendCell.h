//
//  APFriendCell.h
//  AppPartnerTest
//
//  Created by Xiaonan Wang on 7/3/13.
//  Copyright (c) 2013 Xiaonan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface APFriendCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet FBProfilePictureView *picture;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UIImageView *cellSpinner;

@end
