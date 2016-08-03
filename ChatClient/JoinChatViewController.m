//
//  JoinChatViewController.m
//  ChatClient
//
//  Created by Богдан Мельник on 29.09.15.
//  Copyright © 2015 Богдан Мельник. All rights reserved.
//

#import "JoinChatViewController.h"
#import "JoinData.h"

@interface JoinChatViewController ()

@property (strong, nonatomic) IBOutlet UITextField *serverIPTextField;
@property (strong, nonatomic) IBOutlet UITextField *serverPortTextField;
@property (strong, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;

@end

@implementation JoinChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetJoinTextFields];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.serverIPTextField.delegate = self;
    self.serverPortTextField.delegate = self;
    self.nicknameTextField.delegate = self;
    
    // Do any additional setup after loading the view.
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

- (void) resetJoinTextFields {
    self.serverIPTextField.text = @"";
    self.serverPortTextField.text = @"";
    self.nicknameTextField.text = @"";
    
    self.serverIPTextField.placeholder = [[JoinData sharedInstance] defaultServerIP];
    self.serverPortTextField.placeholder = [[JoinData sharedInstance] defaultServerPort];
    self.nicknameTextField.placeholder = [[JoinData sharedInstance] defaultNickname];
}

- (IBAction)joinButtonPressed:(id)sender {
    
    NSString *IP = [[NSString alloc]init];
    NSString *port = [[NSString alloc]init];
    NSString *nickname = [[NSString alloc]init];
    
    if ([self.serverIPTextField.text isEqual: @""]) {
        IP = [[JoinData sharedInstance]defaultServerIP];
    }
    else {
        IP = self.serverIPTextField.text;
        //Check IP!!!
    }
    
    if ([self.serverPortTextField.text isEqual:@""]) {
        port = [[JoinData sharedInstance]defaultServerPort];
    }
    else {
        port = self.serverPortTextField.text;
        //Check port!!!
    }
    
    if ([self.nicknameTextField.text isEqual:@""]) {
        nickname = [[JoinData sharedInstance] defaultNickname];
    } else {
        nickname = self.nicknameTextField.text;
        //Check nickname!
    }
    
    [[JoinData sharedInstance] setCurrentServerIP: IP];
    [[JoinData sharedInstance] setCurrentServerPort:port];
    [[JoinData sharedInstance] setCurrentNickname:nickname];
    [[JoinData sharedInstance] setIsJoined:YES];
    
    [self resetJoinTextFields];
}

-(void)dismissKeyboard {
    [self.serverIPTextField resignFirstResponder];
    [self.serverPortTextField resignFirstResponder];
    [self.nicknameTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self.joinButton sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    return YES;
}

@end
