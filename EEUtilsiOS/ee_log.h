#ifndef EE_LOG_H
#define EE_LOG_H

#if DEBUG || TEST
#define DbgLog(...) NSLog(__VA_ARGS__)
#define DbgLogv(fmt, args) NSLogv((fmt), (args))
#else
#define DbgLog(...)
#define DbgLogv(fmt, args)
#endif

#define EE_CLASS NSStringFromClass([self class])
#define EE_CMD NSStringFromSelector(_cmd)

#define ClassLog(a) DbgLog(@"%@ %@", (a), EE_CLASS)
#define MethodLog() DbgLog(@"[%@ %@]", EE_CLASS, EE_CMD)

#endif
