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

NS_ASSUME_NONNULL_BEGIN

NSString * const kSRSecurityPolicy = @"SRSecurityPolicy";

@implementation NSURLRequest (SRWebSocket)

- (nullable id<SRSecurityPolicy>)SR_securityPolicy;
{
    return [NSURLProtocol propertyForKey:kSRSecurityPolicy inRequest:self];
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
    [NSURLProtocol setProperty:securityPolicy forKey:kSRSecurityPolicy inRequest:self];
}

@end

NS_ASSUME_NONNULL_END
