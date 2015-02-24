#import <Foundation/Foundation.h>

@interface NSArray (Functional)

- (void)forEach:(void (^)(id obj))block;
- (void)forEachI:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (NSArray *)map:(id (^)(id obj))block;
- (NSArray *)mapI:(id (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (NSArray *)filter:(BOOL (^)(id obj))block;
- (NSArray *)filterI:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (id)filterFirst:(BOOL (^)(id obj))block;
- (id)filterFirstI:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block;

- (id)reduce:(id (^)(id prevValue, id obj))block initialValue:(id)initialValue;
- (id)reduceI:(id (^)(id prevValue, id obj, NSUInteger idx, BOOL *stop))block initialValue:(id)initialValue;

@end