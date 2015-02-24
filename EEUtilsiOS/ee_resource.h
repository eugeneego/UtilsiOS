#ifndef EE_RESOURCE_H
#define EE_RESOURCE_H

#define IS_IPHONE ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
#define RESOURCE_FOR_DEVICE(x) [NSString stringWithFormat:@"%@_%@", x, IS_IPHONE ? @"iPhone" : @"iPad"]
#define LS(key) [[NSBundle mainBundle] localizedStringForKey:(key) value:(key) table:nil]

#endif
