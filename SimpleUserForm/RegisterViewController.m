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
#import "ImageHelper.h"
#import "LoginViewController.h"
@interface RegisterViewController ()
{
    BOOL _usernameValid;
    BOOL _passwordValid;
}
@property (strong, nonatomic) NSManagedObjectContext * _managedContext;
@property (weak, nonatomic) IBOutlet UITextField *_firstName;
@property (weak, nonatomic) IBOutlet UITextField *_lastName;
@property (weak, nonatomic) IBOutlet UITextField *_username;
@property (weak, nonatomic) IBOutlet UITextField *_password;
@property (weak, nonatomic) IBOutlet UISegmentedControl *_gender;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self._managedContext = appDelegate.managedObjectContext;
    
    self.doneButton.enabled = false;
    [self styleButton:self.doneButton];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    self._gender.tintColor = [UIColor greenColor];

    [self._username addTarget:self action:@selector(checkData:) forControlEvents:UIControlEventEditingChanged];
    [self._password addTarget:self action:@selector(checkData:) forControlEvents:UIControlEventEditingChanged];
}

-(void) viewWillAppear:(BOOL)animated{
    UIImage *image = [UIImage imageNamed:@"image6.jpg"];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
}

-(void) checkData:(id)sender{
    UITextField *textField = (UITextField *)sender;
    BOOL isValid;
    if(textField.tag == 0){
        isValid =[AccountValidator validateUsername:textField.text];
        _usernameValid = isValid;
    }
    else if(textField.tag == 1) {
        isValid = [AccountValidator validatePassword:textField.text];
        _passwordValid = isValid;
    }
    if (isValid) {
        textField.textColor = [UIColor blackColor];
        if(_usernameValid && _passwordValid){
            self.doneButton.enabled = true;
        }
        else{
            self.doneButton.enabled = false;
        }
    }
    else {
        textField.textColor = [UIColor redColor];
        self.doneButton.enabled= false;
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success."
                                                    message:@"Account registered."                                                  delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    LoginViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void)styleButton:(UIButton*) button{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button setBackgroundColor:[UIColor colorWithRed:0 green:255 blue:0 alpha:0.4]];
    CALayer *layer = button.layer;
    layer.borderColor = [[UIColor blackColor] CGColor];
    layer.cornerRadius = 2.0f;
    layer.borderWidth = 1.0f;
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
