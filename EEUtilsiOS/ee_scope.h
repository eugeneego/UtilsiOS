#ifndef EE_SCOPE_H
#define EE_SCOPE_H

#define WEAK(var, name) __typeof (var) __weak name = var
#define STRONG(var, name) __typeof (var) __strong name = var

#endif
