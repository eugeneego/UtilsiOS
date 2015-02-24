#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (EEUtils)

- (UIImage *)screenshot;
- (UIImage *)screenshot7;

- (void)addFadeTransition;

- (void)addConstraintsToFillSuperView;

+ (UIView *)viewFromNibNamed:(NSString *)name owner:(id)owner;
+ (instancetype)viewFromNibNamed:(NSString *)nibName;

@end