#import <Foundation/Foundation.h>

@interface NSTimer (WeakUI)

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval weakTarget:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval weakTarget:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;
- (id)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)interval weakTarget:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;

- (void)scheduleOnUI;
+ (NSTimer *)scheduledUITimerWithTimeInterval:(NSTimeInterval)interval invocation:(NSInvocation *)invocation repeats:(BOOL)repeats;
+ (NSTimer *)scheduledUITimerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;
+ (NSTimer *)scheduledUITimerWithTimeInterval:(NSTimeInterval)interval weakTarget:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;

@end