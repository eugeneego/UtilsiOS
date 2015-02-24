#import <Foundation/Foundation.h>

@interface EEWeakTargetSelector : NSObject

- (instancetype)initWithTarget:(id)target selector:(SEL)selector;

- (void)fire:(id)object;

@end