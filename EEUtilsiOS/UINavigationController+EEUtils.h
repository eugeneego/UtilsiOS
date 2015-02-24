#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UINavigationController (EEUtils)

- (void)pushViewControllers:(NSArray *)viewControllers animated:(BOOL)animated completion:(void (^)())completion;
- (void)popPreviousViewController;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)())completion;
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)())completion;
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)())completion;

@end