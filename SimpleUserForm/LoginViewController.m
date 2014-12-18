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
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) NSManagedObjectContext* _managedContext;
@property (weak, nonatomic) IBOutlet UITextField *_username;
@property (weak, nonatomic) IBOutlet UITextField *_password;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self._managedContext = appDelegate.managedObjectContext;
    
    UIImage *image = [ImageHelper blurImage:[UIImage imageNamed:@"image2.jpg"]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    self.signInButton.enabled = false;
    [self styleButton:self.signInButton];
    [self._username addTarget:self action:@selector(checkUsername:) forControlEvents:UIControlEventEditingChanged];
    [self._password addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
}
-(void)styleButton:(UIButton*) button{
    
    CALayer *layer = button.layer;
    UIColor *myColor = [UIColor colorWithRed:50.0 green:50.0 blue:50.0 alpha:0.5];
    layer.backgroundColor = [myColor CGColor];
    layer.borderColor = [[UIColor darkGrayColor] CGColor];
    layer.cornerRadius = 8.0f;
    layer.borderWidth = 1.0f;
}
-(void)checkUsername:(id)sender{
    UITextField *textField = (UITextField *)sender;
    BOOL isValid = [AccountValidator validateUsername:textField.text];
    NSLog(@"%d", isValid);
    if (isValid) {
        self.signInButton.enabled = true;
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
- (IBAction)signInTaped:(id)sender {
    if([[KeychainHelper secureValueForKey:self._username.text] isEqualToString:self._password.text]){
        HomeViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
        viewController.username = self._username.text;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    else{
        NSLog(@"FAIL");
    }
}

- (IBAction)signUpTaped:(id)sender {
}

- (IBAction)clearTaped:(id)sender {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [self._managedContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [self._managedContext deleteObject:object];
    }
    
    error = nil;
    [self._managedContext save:&error];
}

- (IBAction)saveTaped:(id)sender {
}

- (IBAction)fetchTaped:(id)sender {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Account"];
    
    NSError *error = nil;
    
    NSArray *results = [self._managedContext executeFetchRequest:request error:&error];
    
    if (error != nil) {
        
        NSLog(@"ERROR");
    }
    else {
        for (int i=0; i < results.count; i++) {
            Account* acc = (Account*)[results objectAtIndex:i];
            NSLog(@"%@", [acc valueForKey:@"username"]);
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
