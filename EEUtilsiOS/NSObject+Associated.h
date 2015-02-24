#import <Foundation/Foundation.h>

@interface NSObject (Associated)

- (void)associateObjectAssign:(id)object forKey:(const void *)key;
- (void)associateObjectRetainNonatomic:(id)object forKey:(const void *)key;
- (void)associateObjectCopyNonatomic:(id)object forKey:(const void *)key;
- (void)associateObjectRetain:(id)object forKey:(const void *)key;
- (void)associateObjectCopy:(id)object forKey:(const void *)key;
- (id)associatedObjectForKey:(const void *)key;
- (void)removeAssociatedObjects;

@end