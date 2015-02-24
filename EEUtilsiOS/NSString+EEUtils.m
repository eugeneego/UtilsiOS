#import "NSString+EEUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (EEUtils)

#pragma mark - Identity

- (BOOL)isAlphaNumericAndSpace
{
  static dispatch_once_t once;
  static NSCharacterSet *set = nil;
  dispatch_once(&once, ^{
    NSMutableCharacterSet *mutableSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [mutableSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    set = [mutableSet invertedSet];
  });
  return [self rangeOfCharacterFromSet:set].location == NSNotFound;
}

- (BOOL)isNumeric
{
  static dispatch_once_t once;
  static NSCharacterSet *set = nil;
  dispatch_once(&once, ^{
    set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  });
  return [self rangeOfCharacterFromSet:set].location == NSNotFound;
}

#pragma mark - Crypto hash

- (NSString *)md5
{
  if(self.length == 0)
    return nil;
  const char *utf8String = self.UTF8String;
  unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
  CC_MD5(utf8String, (CC_LONG)strlen(utf8String), outputBuffer);
  NSMutableString *hashString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for(int count = 0; count < CC_MD5_DIGEST_LENGTH; count++)
    [hashString appendFormat:@"%02x", outputBuffer[count]];
  return hashString;
}

- (NSString *)sha1
{
  if(self.length == 0)
    return nil;
  const char *utf8String = self.UTF8String;
  unsigned char outputBuffer[CC_SHA1_DIGEST_LENGTH];
  CC_SHA1(utf8String, (CC_LONG)strlen(utf8String), outputBuffer);
  NSMutableString *hashString = [[NSMutableString alloc] initWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  for(int count = 0; count < CC_SHA1_DIGEST_LENGTH; count++)
    [hashString appendFormat:@"%02x", outputBuffer[count]];
  return hashString;
}

#pragma mark - Abbreviation

- (NSString *)abbreviationWithMaximumLength:(NSUInteger)maximumLength
{
  NSMutableString *result = [NSMutableString stringWithCapacity:maximumLength];
  [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByWords
    usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
      [result appendString:[substring substringToIndex:1].uppercaseString];
      *stop = (result.length >= maximumLength);
    }];
  return result.uppercaseString;
}

+ (NSString *)abbreviationWithFirstName:(NSString *)firstName lastName:(NSString *)lastName fullName:(NSString *)fullName
{
  NSString *first = firstName ? [firstName abbreviationWithMaximumLength:1] : @"";
  NSString *last = lastName ? [lastName abbreviationWithMaximumLength:1] : @"";
  NSString *result = [first stringByAppendingString:last];
  if(result.length < 2) {
    if(!fullName) {
      fullName = [[NSString stringWithFormat:@"%@ %@", firstName ? firstName : @"", lastName ? lastName : @""]
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    result = [fullName abbreviationWithMaximumLength:2];
  }
  return result;
}

#pragma mark - Hashtags

+ (NSString *)stringWithHashtags:(NSArray *)hashtags
{
  NSMutableString *string = [NSMutableString string];
  [hashtags enumerateObjectsUsingBlock:^(NSString *hashtag, NSUInteger idx, BOOL *stop) {
    if(string.length > 0)
      [string appendString:@" "];
    [string appendString:@"#"];
    [string appendString:hashtag];
  }];
  return [string copy];
}

- (BOOL)isHashtag
{
  static dispatch_once_t once;
  static NSCharacterSet *set = nil;
  dispatch_once(&once, ^{
    NSMutableCharacterSet *mutableSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [mutableSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    [mutableSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"#_"]];
    set = [mutableSet invertedSet];
  });
  return [self rangeOfCharacterFromSet:set].location == NSNotFound;
}

- (NSArray *)hashtags
{
  NSArray *components = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" #"]];
  NSMutableArray *hashtags = [NSMutableArray arrayWithCapacity:components.count];
  [components enumerateObjectsUsingBlock:^(NSString *hashtag, NSUInteger idx, BOOL *stop) {
    if(hashtag.length >= 2)
      [hashtags addObject:hashtag.lowercaseString];
  }];
  return hashtags;
}

#pragma mark - File size

+ (NSString *)stringFromFileSize:(int32_t)fileSize
{
  float size = fileSize;
  NSString *units = @"B";
  if(size >= 1024) {
    units = @"KB";
    size /= 1024;
  }
  if(size >= 1024) {
    units = @"MB";
    size /= 1024;
  }
  if(size >= 1024) {
    units = @"GB";
    size /= 1024;
  }
  return [NSString stringWithFormat:@"%0.0f %@", size, units];
}

@end