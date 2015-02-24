#import "EEWeakTargetSelector.h"

@implementation EEWeakTargetSelector
{
  id __weak _target;
  SEL _selector;
}

- (instancetype)initWithTarget:(id)target selector:(SEL)selector
{
  self = [super init];
  if(self) {
    _target = target;
    _selector = selector;
  }
  return self;
}

- (void)fire:(id)object
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  [_target performSelector:_selector withObject:object];
#pragma clang diagnostic pop
}

@end