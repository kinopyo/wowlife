//
//  Account.h
//  WowLife
//
//  Created by 朴　起煥 on 11/03/22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * klass;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * main;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSNumber * race;
@property (nonatomic, retain) NSString * name;

@end
