//
// Copyright 2012 Square Inc.
// Portions Copyright (c) 2016-present, Facebook, Inc.
//
// All rights reserved.
//
// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree. An additional grant
// of patent rights can be found in the PATENTS file in the same directory.
//

#import "NSURLRequest+SRWebSocket.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@implementation NSURLRequest (SRWebSocket)

static id certificateVerifier;

- (nullable id<SRSecurityPolicy>)SR_securityPolicy;
{
    return objc_getAssociatedObject(self, &certificateVerifier);
}

@end

@implementation NSMutableURLRequest (SRWebSocket)

- (void)setSR_securityPolicy:(nullable id<SRSecurityPolicy>)securityPolicy
{
    if (![securityPolicy respondsToSelector:@selector(evaluateServerTrust:forDomain:)]) {
        @throw [NSException exceptionWithName:@"Assigning security policy failed."
                                       reason:@"Trying to assign a security policy that doesn't respond to required selector"
                                     userInfo:nil];
    }

    objc_setAssociatedObject(self, &certificateVerifier, securityPolicy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

NS_ASSUME_NONNULL_END
