#import "NSArray+Description.h"
#import "UIColor+EEUtils.h"

@implementation NSArray (Description)

- (NSString *)descriptionWithPadding:(NSUInteger)padding
{
  NSString *const SinglePadString = @"  ";
  NSMutableString *pad = [NSMutableString stringWithCapacity:padding];
  for(NSUInteger i = 0; i < padding; i++) {
    [pad appendString:SinglePadString];
  }

  NSMutableString *result = [NSMutableString string];
  [result appendString:@"[\n"];

  [self enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
    NSString *description = nil;
    if([object respondsToSelector:@selector(descriptionWithPadding:)]) {
      description = [object descriptionWithPadding:padding + 1];
    } else if([object isKindOfClass:[NSString class]]) {
      description = [NSString stringWithFormat:@"\"%@\"", object];
    } else if([object isKindOfClass:[UIColor class]]) {
      description = [NSString stringWithFormat:@"\"%@\"", [(UIColor *)object hexString]];
    } else {
      description = [object description];
    }
    [result appendFormat:@"%@%@%@\n", pad, SinglePadString, description];
  }];

  [result appendFormat:@"%@]", pad];
  return result;
}

@end