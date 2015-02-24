#import <Foundation/Foundation.h>

@interface NSOrderedSet (Functional)

- (void)forEach:(void (^)(id obj))block;
- (void)forEachI:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (NSArray *)map:(id (^)(id obj))block;
- (NSArray *)mapI:(id (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (NSArray *)filter:(BOOL (^)(id obj))block;
- (NSArray *)filterI:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (id)filterFirst:(BOOL (^)(id obj))block;
- (id)filterFirstI:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block;

@end