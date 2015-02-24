#import "UINavigationController+EEUtils.h"

@implementation UINavigationController (EEUtils)

#define EE_NC_BEGIN_TRANSACTION if(animated && completion) { \
  [CATransaction begin]; \
  [CATransaction setCompletionBlock:completion]; \
}

#define EE_NC_COMMIT_TRANSACTION if(animated && completion) \
  [CATransaction commit]; \
else if(completion) \
  completion();

- (void)pushViewControllers:(NSArray *)viewControllers animated:(BOOL)animated completion:(void (^)())completion
{
  EE_NC_BEGIN_TRANSACTION
  [self setViewControllers:[self.viewControllers arrayByAddingObjectsFromArray:viewControllers] animated:animated];
  EE_NC_COMMIT_TRANSACTION
}

- (void)popPreviousViewController
{
  if(self.viewControllers.count < 3)
    return;

  NSMutableArray *viewControllers = [self.viewControllers mutableCopy];
  [viewControllers removeObjectAtIndex:viewControllers.count - 2];
  [self setViewControllers:viewControllers animated:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion
{
  EE_NC_BEGIN_TRANSACTION
  UIViewController *result = [self.navigationController popViewControllerAnimated:animated];
  EE_NC_COMMIT_TRANSACTION
  return result;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)())completion
{
  EE_NC_BEGIN_TRANSACTION
  NSArray *result = [self.navigationController popToViewController:viewController animated:animated];
  EE_NC_COMMIT_TRANSACTION
  return result;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)())completion
{
  EE_NC_BEGIN_TRANSACTION
  NSArray *result = [self.navigationController popToRootViewControllerAnimated:animated];
  EE_NC_COMMIT_TRANSACTION
  return result;
}

@end