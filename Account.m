//
//  Account.m
//  WowLife
//
//  Created by 朴　起煥 on 11/03/23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Account.h"


@implementation Account
@dynamic klass;
@dynamic level;
@dynamic created;
@dynamic sex;
@dynamic race;
@dynamic name;
@dynamic alt_flg;

/*
- (void) awakeFromInsert
{
 //TODO set alt_flg default value, based on the count of the Account record
 
 // if is the first record, make false as it may not be alt.
 
 // else it may be an alt.
 
 
 
}
*/


-(BOOL)validateName:(id *)ioValue error:(NSError **)outError{
	
	NSString *value = *ioValue;
	
	BOOL isError = NO;
	NSString *msg = NULL;
	if (value == nil || [value length] == 0) {
		isError = YES;
		msg = @"Name can't be null";
	} else if ([value length] > 15) {
		isError = YES;
		msg = @"Name is too long";
	}

    if (isError) {
		
        if (outError != NULL) {
            NSString *errorStr = NSLocalizedString(msg, msg);
            NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:errorStr
                                                                     forKey:NSLocalizedDescriptionKey];
            NSError *error = [[[NSError alloc] initWithDomain:kAccountValidationDomain
                                                         code:kAccountValidationNameCode
                                                     userInfo:userInfoDict] autorelease];
            *outError = error;
        }
		
		return NO;
    }
    
    
    return YES;
}


@end
