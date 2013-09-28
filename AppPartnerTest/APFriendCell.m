//
//  APFriendCell.m
//  AppPartnerTest
//
//  Created by Xiaonan Wang on 7/3/13.
//  Copyright (c) 2013 Xiaonan Wang. All rights reserved.
//

#import "APFriendCell.h"

@implementation APFriendCell
@synthesize nameLabel;
@synthesize picture;
@synthesize photo;
@synthesize cellSpinner;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
