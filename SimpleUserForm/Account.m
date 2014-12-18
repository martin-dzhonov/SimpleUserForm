//
//  Account.m
//  SimpleUserForm
//
//  Created by Gosho Goshev on 12/18/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "Account.h"
#import "KeychainHelper.h"

@implementation Account

@dynamic firstName;
@dynamic gender;
@dynamic lastName;
@dynamic username;
- (NSString*)password
{
    if (self.username)
        return [KeychainHelper secureValueForKey:self.username];
    return nil;
}

- (void)setPassword:(NSString*)aPassword
{
    if (self.username)
        [KeychainHelper setSecureValue:aPassword forKey:self.username];
}
@end
