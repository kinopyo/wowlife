//
//  Account.h
//  WowLife
//
//  Created by 朴　起煥 on 11/04/01.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kAccountValidationDomain           @"com.Fantasy.WowLife.AccountValidationDomain"
#define kAccountValidationNameCode    1000

@interface Account : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * alt_flg;
@property (nonatomic, retain) NSString * klass;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * race;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* tasks;

@end

@interface Account (CoreDataGeneratedAcessors)
- (void)addTasksObject:(NSManagedObject *)value;
- (void)removeTasksObject:(NSManagedObject *)value;
- (void)addTasks:(NSSet *)value;
- (void)removeTasks:(NSSet *)value;

@end