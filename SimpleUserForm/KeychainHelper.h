//
//  KeychainHelper.h
//  SimpleUserForm
//
//  Created by Gosho Goshev on 12/18/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainHelper : NSObject
+ (NSString *)serviceName;
+ (void)setServiceName:(NSString*)serviceName;

+ (BOOL)setSecureValue:(NSString *)string forKey:(NSString *)key;
+ (NSString *)secureValueForKey:(NSString *)key;
+ (BOOL)removeSecureValueForKey:(NSString *)aKey;

+ (OSStatus)valueStatusForKey:(NSString *)aKey;
+ (BOOL)hasValueForKey:(NSString *)aKey;
@end
