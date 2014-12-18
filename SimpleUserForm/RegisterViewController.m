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
@property (weak, nonatomic) IBOutlet UISegmentedControl *_gender;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self._firstName addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view.
}
- (void)checkTextField:(id)sender{
    UITextField *textField = (UITextField *)sender;
    if ([textField.text length] == 8) {
        textField.textColor = [UIColor greenColor]; // No cargo-culting please, this color is very ugly...
    } else {
        textField.textColor = [UIColor redColor];
        /* Must be done in case the user deletes a key after adding 8 digits,
         or adds a ninth digit */
    }
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
    if(self._gender.selectedSegmentIndex == 0){
        newAccount.gender = @"male";
    }
    else if(self._gender.selectedSegmentIndex == 1){
        newAccount.gender = @"female";
    }
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
