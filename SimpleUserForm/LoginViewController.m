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
@property (weak, nonatomic) IBOutlet UITextField *_username;
@property (weak, nonatomic) IBOutlet UITextField *_password;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (IBAction)signInTaped:(id)sender {
    if([[KeychainHelper secureValueForKey:self._username.text] isEqualToString:self._password.text]){
        NSLog(@"LOGIN SUCESS");
    }
    else{
        NSLog(@"FAIL");
    }
}
- (IBAction)signUpTaped:(id)sender {
}
- (IBAction)clearTaped:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [context deleteObject:object];
    }
    
    error = nil;
    [context save:&error];
}
- (IBAction)saveTaped:(id)sender {
    
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
            NSLog(@"%@", [acc valueForKey:@"gender"]);
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
