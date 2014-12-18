//
//  AccountValidator.m
//  SimpleUserForm
//
//  Created by Gosho Goshev on 12/18/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "AccountValidator.h"

@implementation AccountValidator
+ (BOOL) validateUsername:(NSString *)username{
    //alphanumeric allowed(A-Z, 0-9), no special symbols, 3-32 characters long
    if(3 > username.length || username.length > 32){
        return false;
    }
    NSString *usernameRegex = @"^[a-zA-Z0-9]*$";
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", usernameRegex];
    
    return [usernameTest evaluateWithObject:username];
}
+ (BOOL) validatePassword:(NSString *)password{
    //at least one number, at least one special symbol, 8-32 characters long
   
    NSString *passwordRegex = @"^(?=.*\d)(?=.*[A-Za-z]).{8,32}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    
    return [passwordTest evaluateWithObject:password];
}
@end
