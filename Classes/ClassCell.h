//
//  ClassCell.h
//  WowLife
//
//  Created by Wowzolo on 10-12-1.
//  Copyright 2010 FantasyDay. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ClassCell : UITableViewCell {
	NSNumber *classId;
	NSNumber *raceId;
	IBOutlet UIImageView *classImageView;
	IBOutlet UIImageView *raceImageView;
	IBOutlet UILabel *name;
}

@property (nonatomic, retain) NSNumber *classId;
@property (nonatomic, retain) NSNumber *raceId;
@property (nonatomic, retain) IBOutlet UIImageView *classImageView;
@property (nonatomic, retain) IBOutlet UIImageView *raceImageView;
@property (nonatomic, retain) IBOutlet UILabel *name;
@end
