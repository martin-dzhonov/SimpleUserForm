//
//  KeychainHelper.m
//  SimpleUserForm
//
//  Created by Gosho Goshev on 12/18/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "KeychainHelper.h"

@interface KeychainHelper ()

+ (NSString *)serviceName;

+ (NSMutableDictionary *)dictionaryBaseForKey:(NSString *)aKey;
+ (NSMutableDictionary *)dictionaryBaseForKey:(NSString *)aKey skipClass:(BOOL)aSkipClass;

@end
@implementation KeychainHelper
static NSString *keychainServiceName = nil;

+ (NSString *)serviceName {
    return (keychainServiceName == nil) ? @"service" : keychainServiceName;
}

+ (void)setServiceName:(NSString*)serviceName {
    keychainServiceName = serviceName;
}

+ (NSMutableDictionary *)dictionaryBaseForKey:(NSString *)aKey {
    return [KeychainHelper dictionaryBaseForKey:aKey skipClass:NO];
}

+ (NSMutableDictionary *)dictionaryBaseForKey:(NSString *)aKey skipClass:(BOOL)aSkipClass {
    
    NSMutableDictionary *searchDictionary = [NSMutableDictionary new];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchDictionary setObject:[KeychainHelper serviceName] forKey:(__bridge id)kSecAttrService];
    [searchDictionary setObject:aKey forKey:(__bridge id)kSecAttrAccount];
    
    return searchDictionary;
}


+ (OSStatus)valueStatusForKey:(NSString *)aKey {
    NSDictionary *searchDictionary = [KeychainHelper dictionaryBaseForKey:aKey];
    return SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, nil);
}

+ (BOOL)hasValueForKey:(NSString *)aKey {
    return ([KeychainHelper valueStatusForKey:aKey] == errSecSuccess);
}

/*
 * NOTE: aValue or any sub objects must conform to the NSCoding protocol
 */
+ (BOOL)setSecureValue:(id)aValue forKey:(NSString *)aKey {
    
    if (aValue == nil || aKey == nil) return NO;
    
    NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:aValue];
    
    // check the status of the value (exists / doesn't)
    OSStatus valStatus = [KeychainHelper valueStatusForKey:aKey];
    if (valStatus == errSecItemNotFound) {
        
        // doesn't exist .. create
        NSMutableDictionary *addQueryDict = [KeychainHelper dictionaryBaseForKey:aKey];
        [addQueryDict setObject:valueData forKey:(__bridge id)kSecValueData];
        
        valStatus = SecItemAdd ((__bridge CFDictionaryRef)addQueryDict, NULL);
        NSAssert1(valStatus == errSecSuccess, @"Value add returned status %d", (int)valStatus);
    }
    else if (valStatus == errSecSuccess) {
        
        // exists .. update
        NSMutableDictionary *updateQueryDict = [KeychainHelper dictionaryBaseForKey:aKey];
        NSDictionary *valueDict = [NSDictionary dictionaryWithObject:valueData forKey:(__bridge id)kSecValueData];
        
        valStatus = SecItemUpdate ((__bridge CFDictionaryRef)updateQueryDict, (__bridge CFDictionaryRef)valueDict);
        NSAssert1(valStatus == errSecSuccess, @"Value update returned status %d", (int)valStatus);
        
    }
    else {
        NSAssert2(NO, @"Received mismatched status (%d) while setting keychain value for key %@", (int)valStatus, aKey);
    }
    
    return YES;
}

+ (id)secureValueForKey:(NSString *)aKey {
    
    NSMutableDictionary *retrieveQueryDict = [KeychainHelper dictionaryBaseForKey:aKey];
    [retrieveQueryDict setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];		// make sure data comes back
    
    CFDataRef dataRef = nil;
    OSStatus queryResult = SecItemCopyMatching ((__bridge CFDictionaryRef)retrieveQueryDict, (CFTypeRef *)&dataRef);
    if (queryResult == errSecSuccess) {
        NSData *valueData = (__bridge_transfer NSData *)dataRef;
        id value = [NSKeyedUnarchiver unarchiveObjectWithData:valueData];
        return value;
    }
    else {
        NSAssert2(queryResult == errSecItemNotFound, @"Received mismatched status (%d) while retriveing keychain value for key %@", (int)queryResult, aKey);
    }
    
    return nil;
}

+ (BOOL)removeSecureValueForKey:(NSString *)aKey {
    
    NSDictionary *deleteQueryDict = [KeychainHelper dictionaryBaseForKey:aKey];
    OSStatus queryResult = SecItemDelete((__bridge CFDictionaryRef)deleteQueryDict);
    if (queryResult == errSecSuccess) {
        return YES;
    }
    else {
        NSAssert2(queryResult == errSecItemNotFound, @"Received mismatched status (%d) while deleting keychain value for key %@", (int)queryResult, aKey);
        return NO;
    }
}

@end
