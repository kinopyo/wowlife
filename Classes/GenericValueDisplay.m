#import "GenericValueDisplay.h"

@implementation NSString (GenericValueDisplay)
- (NSString *)genericValueDisplay {
	return self;
}
@end

@implementation NSDate (GenericValueDisplay)
- (NSString *)genericValueDisplay {
    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	NSString *ret = [formatter stringFromDate:self];
	[formatter release];
	return ret;
}
@end

@implementation NSNumber (GenericValueDisplay) 
- (NSString *)genericValueDisplay {
    return [self descriptionWithLocale:[NSLocale currentLocale]];
}
@end

@implementation NSDecimalNumber (GenericValueDisplay) 
- (NSString *)genericValueDisplay {
    return [self descriptionWithLocale:[NSLocale currentLocale]];
}
@end
