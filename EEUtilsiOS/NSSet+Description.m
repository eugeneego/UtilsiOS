#import "NSSet+Description.h"

@implementation NSSet (Description)

- (NSString *)descriptionWithPadding:(NSUInteger)padding
{
  NSString *const SinglePadString = @"  ";
  NSMutableString *pad = [NSMutableString stringWithCapacity:padding];
  for(NSUInteger i = 0; i < padding; i++)
    [pad appendString:SinglePadString];

  NSMutableString *result = [NSMutableString string];
  [result appendString:@"[\n"];

  for(id object in self) {
    NSString *description = nil;
    if([object respondsToSelector:@selector(descriptionWithPadding:)])
      description = [object descriptionWithPadding:padding + 1];
    else if([object isKindOfClass:[NSString class]])
      description = [NSString stringWithFormat:@"\"%@\"", object];
    else
      description = [object description];
    [result appendFormat:@"%@%@%@\n", pad, SinglePadString, description];
  }

  [result appendFormat:@"%@]", pad];
  return result;
}

@end