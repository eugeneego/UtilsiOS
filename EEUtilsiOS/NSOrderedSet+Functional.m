#import "NSOrderedSet+Functional.h"

@implementation NSOrderedSet (Functional)

- (void)forEach:(void (^)(id obj))block
{
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    block(obj);
  }];
}

- (void)forEachI:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
  [self enumerateObjectsUsingBlock:block];
}

- (NSArray *)map:(id (^)(id obj))block
{
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    id mappedObj = block(obj);
    if(mappedObj) {
      [array addObject:mappedObj];
    }
  }];
  return [array copy];
}

- (NSArray *)mapI:(id (^)(id obj, NSUInteger idx, BOOL *stop))block
{
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    id mappedObj = block(obj, idx, stop);
    if(mappedObj) {
      [array addObject:mappedObj];
    }
  }];
  return [array copy];
}

- (NSArray *)filter:(BOOL (^)(id obj))block
{
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if(block(obj)) {
      [array addObject:obj];
    }
  }];
  return [array copy];
}

- (NSArray *)filterI:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block
{
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if(block(obj, idx, stop)) {
      [array addObject:obj];
    }
  }];
  return [array copy];
}

- (id)filterFirst:(BOOL (^)(id obj))block
{
  __block id result = nil;
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if(block(obj)) {
      result = obj;
      *stop = YES;
    }
  }];
  return result;
}

- (id)filterFirstI:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))block
{
  __block id result = nil;
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if(block(obj, idx, stop)) {
      result = obj;
      *stop = YES;
    }
  }];
  return result;
}

@end