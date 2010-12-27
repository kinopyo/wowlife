//
//  Convertor.m
//  WowLife
//
//  Created by Wowzolo on 10-12-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Convertor.h"


@implementation Convertor

// return race value by string text
+ (NSNumber *)raceValue:(NSString *)raceText {

	NSNumber *raceValue = NULL;
	if ([raceText isEqualToString:@"Undead"]) {
		raceValue = [[NSNumber alloc] initWithInt:5];
	} else if ([raceText isEqualToString:@"Orc"]) {
		raceValue = [[NSNumber alloc] initWithInt:2];
	} else if ([raceText isEqualToString:@"Troll"]) {
		raceValue = [[NSNumber alloc] initWithInt:8];
	} else if ([raceText isEqualToString:@"Blood Elf"]) {
		raceValue = [[NSNumber alloc] initWithInt:10];
	} else if ([raceText isEqualToString:@"Tauren"]) {
		raceValue = [[NSNumber alloc] initWithInt:6];
	}	
	return raceValue;
}


+ (NSString *)raceText:(NSNumber *)raceValue {
	NSString *raceText = @"";
	switch ([raceValue intValue]) {
		case 1:
			raceText = @"Human";
			break;
		case 2:
			raceText = @"Orc";
			break;
		case 3:
			raceText = @"Drawf";
			break;
		case 4:
			raceText = @"Night Elf";
			break;
		case 5:
			raceText = @"Undead";
			break;
		case 6:
			raceText = @"Tauren";
			break;
		case 7:
			raceText = @"Gnome";
			break;
		case 8:
			raceText = @"Troll";
			break;
		case 9:
			raceText = @"Troll";
			break;
			
			

	}
			
	return raceText;
}

@end
