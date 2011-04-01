//
//  Task.m
//  WowLife
//
//  Created by 朴　起煥 on 11/04/01.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Task.h"
#import "Account.h"


@implementation Task
@dynamic name;
@dynamic due_date;
@dynamic type;
@dynamic category;
@dynamic completed;
@dynamic complete_date;
@dynamic accounts;

- (void)addAccountsObject:(Account *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"accounts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"accounts"] addObject:value];
    [self didChangeValueForKey:@"accounts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeAccountsObject:(Account *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"accounts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"accounts"] removeObject:value];
    [self didChangeValueForKey:@"accounts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addAccounts:(NSSet *)value {    
    [self willChangeValueForKey:@"accounts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"accounts"] unionSet:value];
    [self didChangeValueForKey:@"accounts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeAccounts:(NSSet *)value {
    [self willChangeValueForKey:@"accounts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"accounts"] minusSet:value];
    [self didChangeValueForKey:@"accounts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
