//
//  RegisterViewController.m
//  SimpleUserForm
//
//  Created by Gosho Goshev on 12/18/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "Account.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *_firstName;
@property (weak, nonatomic) IBOutlet UITextField *_lastName;
@property (weak, nonatomic) IBOutlet UITextField *_username;
@property (weak, nonatomic) IBOutlet UITextField *_password;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneTaped:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* context = appDelegate.managedObjectContext;
    Account *newAccount;
    newAccount = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
    newAccount.firstName = self._firstName.text;
    newAccount.lastName = self._lastName.text;
    newAccount.username = self._username.text;
    [newAccount setPassword:self._password.text];
    NSError *error;
    [context save:&error];

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
