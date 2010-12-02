//
//  ClassCell.m
//  WowLife
//
//  Created by Wowzolo on 10-12-1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ClassCell.h"


@implementation ClassCell
@synthesize classId;
@synthesize raceId;
@synthesize classImageView;
@synthesize raceImageView;
@synthesize name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }	
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[classId release];
	[raceId release];
	[classImageView release];
	[raceImageView release];
	[name release];
    [super dealloc];
}


@end
