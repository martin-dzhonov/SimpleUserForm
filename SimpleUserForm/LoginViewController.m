//
//  LoginViewController.m
//  SimpleUserForm
//
//  Created by Gosho Goshev on 12/17/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "Account.h"
#import "AlertHelper.h"
#import "KeychainHelper.h"
#import "AccountValidator.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController (){
    BOOL _usernameValid;
    BOOL _passwordValid;
}
@property (strong, nonatomic) NSManagedObjectContext* _managedContext;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UITextField *_username;
@property (weak, nonatomic) IBOutlet UITextField *_password;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self._managedContext = appDelegate.managedObjectContext;
    
    [self setBackgroundImage];
    self.signInButton.enabled = false;
    [self styleButton:self.signInButton];
    [self styleButton:self.signUpButton];
    
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
        if(_usernameValid && _passwordValid){
            self.signInButton.enabled = true;
        }
        else{
            self.signInButton.enabled = false;
        }
    }
    else {
        textField.textColor = [UIColor redColor];
        self.signInButton.enabled= false;
    }
}

- (IBAction)signInTaped:(id)sender {
    if([[KeychainHelper secureValueForKey:self._username.text] isEqualToString:self._password.text]){
        HomeViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
        viewController.username = self._username.text;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else{
        [AlertHelper showAlert:@"Error" withMessage:@"Invalid username/password"];
    }
}

- (IBAction)signUpTaped:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = [UIColor colorWithRed:0 green:200 blue:50 alpha:0.9];
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

-(void)styleButton:(UIButton*) button{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:15 green:15 blue:15 alpha:0.3] forState:UIControlStateDisabled];
    [button setBackgroundColor:[UIColor colorWithRed:0 green:20 blue:190 alpha:0.5]];
    CALayer *layer = button.layer;
    layer.cornerRadius = 2.0f;
    layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
