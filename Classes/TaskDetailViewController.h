//
//  TaskDetailViewController.h
//  WowLife
//
//  Created by Wowzolo on 11-4-3.
//  Copyright 2011年 FantasyDay. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTaskTypeList @"taskTypeList"
#define kTaskCategoryList @"taskCategoryList"

@interface TaskDetailViewController : UITableViewController {
  NSManagedObject *task;
	
 @private   
  NSArray         *sectionNames;
  NSArray         *rowLabels;
  NSArray         *rowKeys;
  NSArray         *rowValueMaps;
  NSArray         *rowControllers;
  NSArray         *rowArguments;
  NSDictionary    *taskTypeMap;
  NSDictionary    *taskCategoryMap;
}
@property (nonatomic, retain) NSManagedObject *task;
@end
