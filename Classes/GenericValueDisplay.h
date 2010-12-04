#import <Foundation/Foundation.h>

@protocol GenericValueDisplay
- (NSString *)genericValueDisplay;
@end

@interface NSString (GenericValueDisplay) <GenericValueDisplay>
- (NSString *)genericValueDisplay;
@end

@interface NSDate (GenericValueDisplay) <GenericValueDisplay>
- (NSString *)genericValueDisplay;
@end

@interface NSNumber (GenericValueDisplay) <GenericValueDisplay>
- (NSString *)genericValueDisplay;
@end

@interface NSDecimalNumber (GenericValueDisplay) <GenericValueDisplay>
- (NSString *)genericValueDisplay;
@end
