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
#import "AccountValidator.h"
@interface RegisterViewController ()

@property (strong, nonatomic) NSManagedObjectContext * _managedContext;
@property (weak, nonatomic) IBOutlet UITextField *_firstName;
@property (weak, nonatomic) IBOutlet UITextField *_lastName;
@property (weak, nonatomic) IBOutlet UITextField *_username;
@property (weak, nonatomic) IBOutlet UITextField *_password;
@property (weak, nonatomic) IBOutlet UISegmentedControl *_gender;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self._managedContext = appDelegate.managedObjectContext;
    [self._username addTarget:self action:@selector(checkUsername:) forControlEvents:UIControlEventEditingChanged];
    [self._password addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
}
-(void)checkUsername:(id)sender{
    UITextField *textField = (UITextField *)sender;
    BOOL isValid = [AccountValidator validateUsername:textField.text];
    NSLog(@"%d", isValid);
    if (isValid) {
        textField.textColor = [UIColor greenColor];
    } else {
        textField.textColor = [UIColor redColor];
    }
}
- (void)checkTextField:(id)sender{
    UITextField *textField = (UITextField *)sender;
    BOOL isValid = [AccountValidator validatePassword:textField.text];
    NSLog(@"%d", isValid);
    if (isValid) {
        textField.textColor = [UIColor greenColor];
    } else {
        textField.textColor = [UIColor redColor];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)doneTaped:(id)sender {
    Account *newAccount;
    newAccount = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:self._managedContext];
    newAccount.firstName = self._firstName.text;
    newAccount.lastName = self._lastName.text;
    newAccount.username = self._username.text;
    [newAccount setPassword:self._password.text];
    if(self._gender.selectedSegmentIndex == 0){
        newAccount.gender = @"male";
    }
    else if(self._gender.selectedSegmentIndex == 1){
        newAccount.gender = @"female";
    }
    NSError *error;
    [self._managedContext save:&error];
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
