#import <objc/runtime.h>
#import "NSObject+Associated.h"

@implementation NSObject (Associated)

- (void)associateObjectAssign:(id)object forKey:(const void *)key
{
  objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_ASSIGN);
}

- (void)associateObjectRetainNonatomic:(id)object forKey:(const void *)key
{
  objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)associateObjectCopyNonatomic:(id)object forKey:(const void *)key
{
  objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)associateObjectRetain:(id)object forKey:(const void *)key
{
  objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN);
}

- (void)associateObjectCopy:(id)object forKey:(const void *)key
{
  objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_COPY);
}

- (id)associatedObjectForKey:(const void *)key
{
  return objc_getAssociatedObject(self, key);
}

- (void)removeAssociatedObjects
{
  objc_removeAssociatedObjects(self);
}

@end