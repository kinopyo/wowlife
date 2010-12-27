//
//  Convertor.h
//  WowLife
//
//  Created by Wowzolo on 10-12-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Convertor : NSObject {

}

+ (NSNumber *)raceValue:(NSString *)raceText;
+ (NSString *)raceText:(NSNumber *)raceValue;

@end
