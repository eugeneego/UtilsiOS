#import "NSData+EEUtils.h"

@implementation NSData (EEUtils)

- (NSString *)hexString
{
  NSUInteger length = self.length;
  const unsigned char *bytes = self.bytes;

  if(!bytes)
    return @"";

  NSMutableString *hex = [NSMutableString stringWithCapacity:length * 2];
  for(NSUInteger i = 0; i < length; ++i)
    [hex appendString:[NSString stringWithFormat:@"%02x", bytes[i]]];

  return hex;
}

@end