//
//  TaskDetailViewController.h
//  WowLife
//
//  Created by Wowzolo on 11-4-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TaskDetailViewController : UITableViewController {
  NSManagedObject *task;
	
 @private   
  NSArray         *sectionNames;
  NSArray         *rowLabels;
  NSArray         *rowKeys;
  NSArray         *rowControllers;
  NSArray         *rowArguments;
}
@property (nonatomic, retain) NSManagedObject *task;
@end
