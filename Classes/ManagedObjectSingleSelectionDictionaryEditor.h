//
//  ManagedObjectSingleSelectionDictionaryEditor.h
//  WowLife
//
//  Created by 朴　起煥 on 11/03/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagedObjectAttributeEditor.h"

@interface ManagedObjectSingleSelectionDictionaryEditor : ManagedObjectAttributeEditor {
    NSDictionary            *map;
    
    //@private
    NSIndexPath        *lastIndexPath;
    NSArray            *list;
}
@property (nonatomic, retain) NSDictionary *map;
@property (nonatomic, retain) NSArray *list;
@end
