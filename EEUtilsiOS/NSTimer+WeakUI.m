#import "NSTimer+WeakUI.h"
#import "EEWeakTargetSelector.h"

@implementation NSTimer (WeakUI)

#pragma mark - Weak target

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval weakTarget:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats
{
  EEWeakTargetSelector *wts = [[EEWeakTargetSelector alloc] initWithTarget:target selector:selector];
  return [self timerWithTimeInterval:interval target:wts selector:@selector(fire:) userInfo:userInfo repeats:repeats];
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval weakTarget:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats
{
  EEWeakTargetSelector *wts = [[EEWeakTargetSelector alloc] initWithTarget:target selector:selector];
  return [self scheduledTimerWithTimeInterval:interval target:wts selector:@selector(fire:) userInfo:userInfo repeats:repeats];
}

- (id)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)interval weakTarget:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats
{
  EEWeakTargetSelector *wts = [[EEWeakTargetSelector alloc] initWithTarget:target selector:selector];
  return [self initWithFireDate:date interval:interval target:wts selector:@selector(fire:) userInfo:userInfo repeats:repeats];
}

#pragma mark - UI timer

- (void)scheduleOnUI
{
  [[NSRunLoop mainRunLoop] addTimer:self forMode:NSDefaultRunLoopMode];
  [[NSRunLoop mainRunLoop] addTimer:self forMode:UITrackingRunLoopMode];
}

+ (NSTimer *)scheduledUITimerWithTimeInterval:(NSTimeInterval)interval invocation:(NSInvocation *)invocation repeats:(BOOL)repeats
{
  NSTimer *timer = [NSTimer timerWithTimeInterval:interval invocation:invocation repeats:repeats];
  [timer scheduleOnUI];
  return timer;
}

+ (NSTimer *)scheduledUITimerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats
{
  NSTimer *timer = [NSTimer timerWithTimeInterval:interval target:target selector:selector userInfo:userInfo repeats:repeats];
  [timer scheduleOnUI];
  return timer;
}

+ (NSTimer *)scheduledUITimerWithTimeInterval:(NSTimeInterval)interval weakTarget:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats
{
  NSTimer *timer = [NSTimer timerWithTimeInterval:interval weakTarget:target selector:selector userInfo:userInfo repeats:repeats];
  [timer scheduleOnUI];
  return timer;
}

@end