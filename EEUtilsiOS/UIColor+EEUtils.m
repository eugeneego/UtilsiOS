#import "UIColor+EEUtils.h"

const CGFloat MaxColorValue = 255.0f;

@implementation UIColor (EEUtils)

- (UIColor *)inverseColor
{
  CGFloat red, green, blue, alpha;
  if([self getRed:&red green:&green blue:&blue alpha:&alpha])
    return [UIColor colorWithRed:1 - red green:1 - green blue:1 - blue alpha:alpha];
  else
    return self;
}

- (CGFloat)brightness
{
  CGFloat red, green, blue, alpha;
  if([self getRed:&red green:&green blue:&blue alpha:&alpha])
    return ((red * 299) + (green * 587) + (blue * 114)) / 1000.0f;
  else
    return 0;
}

- (BOOL)isDark
{
  return [self brightness] < 0.5f;
}

#pragma mark - Hex

- (NSString *)hexString
{
  CGFloat red, green, blue, alpha;
  if([self getRed:&red green:&green blue:&blue alpha:&alpha])
    return [NSString stringWithFormat:@"%02X%02X%02X", (int)(red * MaxColorValue), (int)(green * MaxColorValue), (int)(blue * MaxColorValue)];
  else
    return @"";
}

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
  NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
  CGFloat alpha, red, blue, green;
  switch(colorString.length) {
    case 3: // #RGB
      alpha = 1.0f;
      red = [self colorComponentFromString:colorString start:0 length:1];
      green = [self colorComponentFromString:colorString start:1 length:1];
      blue = [self colorComponentFromString:colorString start:2 length:1];
      break;
    case 4: // #ARGB
      alpha = [self colorComponentFromString:colorString start:0 length:1];
      red = [self colorComponentFromString:colorString start:1 length:1];
      green = [self colorComponentFromString:colorString start:2 length:1];
      blue = [self colorComponentFromString:colorString start:3 length:1];
      break;
    case 6: // #RRGGBB
      alpha = 1.0f;
      red = [self colorComponentFromString:colorString start:0 length:2];
      green = [self colorComponentFromString:colorString start:2 length:2];
      blue = [self colorComponentFromString:colorString start:4 length:2];
      break;
    case 8: // #AARRGGBB
      alpha = [self colorComponentFromString:colorString start:0 length:2];
      red = [self colorComponentFromString:colorString start:2 length:2];
      green = [self colorComponentFromString:colorString start:4 length:2];
      blue = [self colorComponentFromString:colorString start:6 length:2];
      break;
    default:
      return nil;
  }
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFromString:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
  NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
  NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
  unsigned hexComponent;
  [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
  return hexComponent / MaxColorValue;
}

#pragma mark - Integer components

+ (UIColor *)colorWithIntegerRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(NSInteger)alpha
{
  return [self colorWithRed:red / MaxColorValue green:green / MaxColorValue blue:blue / MaxColorValue alpha:alpha / MaxColorValue];
}

@end