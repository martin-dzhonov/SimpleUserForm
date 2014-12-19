//
//  RegisterViewController.m
//  SimpleUserForm
//
//  Created by Gosho Goshev on 12/18/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "Account.h"
#import "AccountValidator.h"
#import "AlertHelper.h"

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
    
    [self styleButton:self.doneButton];
    [self setBackgroundImage];
    [self setSegmentedControlStyle];
    
    [self._username addTarget:self action:@selector(checkData:) forControlEvents:UIControlEventEditingChanged];
    [self._password addTarget:self action:@selector(checkData:) forControlEvents:UIControlEventEditingChanged];
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
    }
    else {
        textField.textColor = [UIColor redColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)doneTaped:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [UIColor colorWithRed:0 green:250 blue:50 alpha:0.9];
    if(self._firstName.text.length == 0 || self._lastName.text.length == 0){
        [AlertHelper showAlert:@"Sorry" withMessage:@"Full name is required."];
    }
    else if(!_usernameValid){
        [AlertHelper showAlert:@"Sorry" withMessage:@"Minimum username lenght is 3."];
    }
    else if(!_passwordValid){
        [AlertHelper showAlert:@"Sorry" withMessage:@"Password minimum lenght is 8 and should contain number and a special symbol."];
    }
    else{
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
        
        [AlertHelper showAlert:@"Success" withMessage:@"Account registered."];
        
        LoginViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    [button performSelector:@selector(setBackgroundColor:) withObject:[UIColor colorWithRed:0 green:20 blue:190 alpha:0.5] afterDelay:0.2];

}

-(void)styleButton:(UIButton*) button{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:0 green:20 blue:190 alpha:0.5]];
    CALayer *layer = button.layer;
    layer.cornerRadius = 2.0f;
    layer.borderWidth = 1.0f;
}

-(void)setSegmentedControlStyle{
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    self._gender.tintColor = [UIColor colorWithRed:0 green:20 blue:200 alpha:0.5];
}

-(void) setBackgroundImage{
    UIImage *image = [UIImage imageNamed:@"image6.jpg"];
    //Uncomment to blur the image programatically
    //UIImage *image = [ImageHelper blurImage:[UIImage imageNamed:@"image6.jpg"]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
}

@end
