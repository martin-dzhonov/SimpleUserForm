//
//  HomeViewController.m
//  SimpleUserForm
//
//  Created by Gosho Goshev on 12/18/14.
//  Copyright (c) 2014 Gosho Goshev. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Account.h"
#import "KeychainHelper.h"
@interface HomeViewController ()
@property (strong, nonatomic) NSManagedObjectContext* _managedContext;
@property (weak, nonatomic) IBOutlet UILabel *_welcomeLabel;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self._managedContext = appDelegate.managedObjectContext;
    
    [self setBackgroundImage];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"SELF.username == %@", self.username];
    NSArray *results = [self._managedContext executeFetchRequest:fetchRequest error:nil];
    Account* acc = (Account*)[results objectAtIndex:0];
    NSString *title = [acc.gender isEqualToString:@"male"] ? @"Mr." : @"Mrs.";
    NSString *welcomeString = [NSString stringWithFormat:@"Hello %@ %@ %@", title, acc.firstName, acc.lastName];
    self._welcomeLabel.text = welcomeString;
}

-(void) setBackgroundImage{
    UIImage *image = [UIImage imageNamed:@"image6.jpg"];
    //Uncomment to blur the image programatically
    //UIImage *image = [ImageHelper blurImage:[UIImage imageNamed:@"image5.jpg"]];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:image];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
