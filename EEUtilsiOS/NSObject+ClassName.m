#import "NSObject+ClassName.h"

@implementation NSObject (ClassName)

+ (NSString *)className
{
  return NSStringFromClass([self class]);
}

- (NSString *)className
{
  return NSStringFromClass([self class]);
}

@end