#import "NSDictionary+Functional.h"

@implementation NSDictionary (Functional)

- (void)forEach:(void (^)(id key, id obj, BOOL *stop))block
{
  [self enumerateKeysAndObjectsUsingBlock:block];
}

@end