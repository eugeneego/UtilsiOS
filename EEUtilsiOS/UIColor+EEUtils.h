#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (EEUtils)

- (UIColor *)inverseColor;
- (CGFloat)brightness;
- (BOOL)isDark;

- (NSString *)hexString;
+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (UIColor *)colorWithIntegerRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha;

@end