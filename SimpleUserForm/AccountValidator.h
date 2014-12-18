//
//  AccountValidator.h
//  SimpleUserForm
//
//  Created by Gosho Goshev on 12/18/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountValidator : NSObject
+ (BOOL)validateUsername:(NSString *)username;
+ (BOOL)validatePassword:(NSString *)password;
@end
