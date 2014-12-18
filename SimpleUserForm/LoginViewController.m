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
#import "HomeViewController.h"
#import "AccountValidator.h"
#import "ImageHelper.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController (){
    BOOL _usernameValid;
    BOOL _passwordValid;
}
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) NSManagedObjectContext* _managedContext;
@property (weak, nonatomic) IBOutlet UITextField *_username;
@property (weak, nonatomic) IBOutlet UITextField *_password;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self._managedContext = appDelegate.managedObjectContext;
    
    [self initBackgroundImage];
    
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
-(void) initBackgroundImage{
    UIImage *image = [UIImage imageNamed:@"image3.jpg"];//[ImageHelper blurImage:[UIImage imageNamed:@"image2.jpg"]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
}

-(void)styleButton:(UIButton*) button{
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"LuzSans-Book" size:16];
    CALayer *layer = button.layer;
    UIColor *myColor = [UIColor colorWithRed:20.0 green:125.0 blue:75.0 alpha:0.4];
    layer.backgroundColor = [myColor CGColor];
    layer.borderColor = [[UIColor darkGrayColor] CGColor];
    layer.cornerRadius = 2.0f;
    layer.borderWidth = 1.0f;

}

- (IBAction)signInTaped:(id)sender {
    if([[KeychainHelper secureValueForKey:self._username.text] isEqualToString:self._password.text]){
        HomeViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
        viewController.username = self._username.text;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error."
                                                        message:@"Invalid username/password."                                                  delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)signUpTaped:(id)sender {
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
