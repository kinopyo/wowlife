//
//  Task.h
//  WowLife
//
//  Created by 朴　起煥 on 11/04/01.
//  Copyright (c) 2011 FantasyDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface Task : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * due_date;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * complete_date;
@property (nonatomic, retain) NSSet* accounts;

@end
