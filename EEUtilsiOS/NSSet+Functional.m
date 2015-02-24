#import "NSSet+Functional.h"

@implementation NSSet (Functional)

- (void)forEach:(void (^)(id obj))block
{
  [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    block(obj);
  }];
}

- (void)forEachS:(void (^)(id obj, BOOL *stop))block
{
  [self enumerateObjectsUsingBlock:block];
}

- (NSArray *)map:(id (^)(id obj))block
{
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
  [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    id mappedObj = block(obj);
    if(mappedObj) {
      [array addObject:mappedObj];
    }
  }];
  return [array copy];
}

- (NSArray *)mapS:(id (^)(id obj, BOOL *stop))block
{
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
  [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    id mappedObj = block(obj, stop);
    if(mappedObj) {
      [array addObject:mappedObj];
    }
  }];
  return [array copy];
}

- (NSArray *)filter:(BOOL (^)(id obj))block
{
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
  [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    if(block(obj)) {
      [array addObject:obj];
    }
  }];
  return [array copy];
}

- (NSArray *)filterS:(BOOL (^)(id obj, BOOL *stop))block
{
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
  [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    if(block(obj, stop)) {
      [array addObject:obj];
    }
  }];
  return [array copy];
}

- (id)filterFirst:(BOOL (^)(id obj))block
{
  __block id result = nil;
  [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    if(block(obj)) {
      result = obj;
      *stop = YES;
    }
  }];
  return result;
}

@end