#import <UIKit/UIKit.h>
#define kNonEditableTextColor    [UIColor colorWithRed:.318 green:0.4 blue:.569 alpha:1.0]
#define kKeyForMap  @"map"  // key for xxxSelectionEditor, datasource of the list
#define kSaveImmediateFlag  @"saveImmediate"  

@interface ManagedObjectAttributeEditor : UITableViewController <UIAlertViewDelegate> {
  NSManagedObject         *managedObject;
  NSString                *keypath;
  NSString                *labelString;
  BOOL  saveImmediate;  // 選択直後に保存し、navigationからpopupするかのフラグ    
}
@property (nonatomic, retain) NSManagedObject *managedObject;
@property (nonatomic, retain) NSString *keypath;
@property (nonatomic, retain) NSString *labelString;
-(IBAction)cancel;
-(IBAction)save;
-(IBAction)validateAndPop;
@end
