//
//  WowLifeAppDelegate.m
//  WowLife
//
//  Created by Wowzolo on 10-10-27.
//  Copyright 2010 FantasyDay. All rights reserved.
//

#import "WowLifeAppDelegate.h"

@implementation WowLifeAppDelegate

@synthesize window;
@synthesize tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the tab bar controller's view to the window and display.
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
}


#pragma mark -
#pragma mark UITabBarControllerDelegate methods

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

#pragma mark -
#pragma mark CoreData
- (NSManagedObjectContext *) managedObjectContext {
	if (managedObjectContext != nil) {
		return managedObjectContext;
	}
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	}
	
	return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
	if (managedObjectModel != nil) {
		return managedObjectModel;
	}
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
	
	return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	
//	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Wowlife.sqlite"];
//	/*
//	 Set up the store.
//	 For the sake of illustration, provide a pre-populated default store.
//	 */
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	// If the expected store doesn't exist, copy the default store.
//	if (![fileManager fileExistsAtPath:storePath]) {
//		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"Wowlife" ofType:@"sqlite"];
//		if (defaultStorePath) {
//			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
//		}
//	}
//	
//	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
//	
//	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];	
//    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
//	
//	NSError *error;
//	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
//		// Update to handle the error appropriately.
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		exit(-1);  // Fail
//    }
    
//	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Wowlife.sqlite"];
	NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Wowlife.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error])
	{
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}

	
    return persistentStoreCoordinator;
}


- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Memory Control
- (void)dealloc {
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

