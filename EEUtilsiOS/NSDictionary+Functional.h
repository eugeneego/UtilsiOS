#import <Foundation/Foundation.h>

@interface NSDictionary (Functional)

- (void)forEach:(void (^)(id key, id obj, BOOL *stop))block;

@end