#import <Foundation/Foundation.h>

@interface NSSet (Functional)

- (void)forEach:(void (^)(id obj))block;
- (void)forEachS:(void (^)(id obj, BOOL *stop))block;

- (NSArray *)map:(id (^)(id obj))block;
- (NSArray *)mapS:(id (^)(id obj, BOOL *stop))block;

- (NSArray *)filter:(BOOL (^)(id obj))block;
- (NSArray *)filterS:(BOOL (^)(id obj, BOOL *stop))block;
- (id)filterFirst:(BOOL (^)(id obj))block;

@end