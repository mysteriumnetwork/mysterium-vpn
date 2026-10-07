#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "key.h"
#import "WireGuardKitC.h"
#import "x25519.h"
#import "ringlogger.h"
#import "wireguard.h"
#import "WireGuardNetworkExtension-Bridging-Header.h"

FOUNDATION_EXPORT double WireGuardKitVersionNumber;
FOUNDATION_EXPORT const unsigned char WireGuardKitVersionString[];

