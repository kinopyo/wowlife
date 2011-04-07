//
//  WowLifeAppDelegate.h
//  WowLife
//
//  Created by Wowzolo on 10-10-27.
//  Copyright 2010 FantasyDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountNavController;

@interface WowLifeAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	
	NSManagedObjectModel *managedObjectModel;
	NSManagedObjectContext *managedObjectContext;
	NSPersistentStoreCoordinator *persistentStoreCoordinator;
//	UINavigationController *accountNavController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//@property (nonatomic, retain) IBOutlet UINavigationController *accountNavController;

- (NSString *)applicationDocumentsDirectory;
@end
