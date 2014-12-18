//
//  LoginViewController.m
//  SimpleUserForm
//
//  Created by Gosho Goshev on 12/17/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Account.h"
#import "KeychainHelper.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (IBAction)saveTaped:(id)sender {
    [KeychainHelper setSecureValue:@"TESTVALUE" forKey:@"TESTKEY"];
}
- (IBAction)fetchTaped:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Account"];
    
    NSError *error = nil;
    
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (error != nil) {
        
        NSLog(@"ERROR");
    }
    else {
        for (int i=0; i < results.count; i++) {
            Account* acc = (Account*)[results objectAtIndex:i];
            NSLog(@"%@", [acc password]);
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
