//
//  ChatViewController.m
//  ChatClient
//
//  Created by Богдан Мельник on 29.09.15.
//  Copyright © 2015 Богдан Мельник. All rights reserved.
//

#import "ChatViewController.h"
#import "JoinData.h"

@interface ChatViewController ()

@property (strong, nonatomic) IBOutlet UITableView *chatHistoryTableView;
@property (strong, nonatomic) IBOutlet UITextField *messageTextTextField;

@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@property NSInputStream *inputStream;
@property NSOutputStream *outputStream;

@property NSMutableArray * messages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.messages = [[NSMutableArray alloc] init];
    
    self.chatHistoryTableView.delegate = self;
    self.chatHistoryTableView.dataSource = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.messageTextTextField.delegate = self;
    
    [self initNetworkCommunication];
    [self joinWithNickname:[[JoinData sharedInstance] currentNickname]];
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

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)[[JoinData sharedInstance] currentServerIP], [[[JoinData sharedInstance] currentServerPort] intValue], &readStream, &writeStream);
    _inputStream = (__bridge NSInputStream *)readStream;
    _outputStream = (__bridge NSOutputStream *)writeStream;
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream open];
    [_outputStream open];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ChatCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *s = (NSString *) [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = s;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (void)joinWithNickname:(NSString *)nickname {
    NSString *response  = [NSString stringWithFormat:@"iam:%@", nickname];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];
}

- (void)messageWithNSString:(NSString *)message {
    NSString *response  = [NSString stringWithFormat:@"msg:%@", message];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [_outputStream write:[data bytes] maxLength:[data length]];
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    NSLog(@"Stream event %lu.", (unsigned long)streamEvent);
    
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened!");
            break;
        case NSStreamEventHasBytesAvailable:
            
            if (theStream == self.inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            
                            NSLog(@"Server said: %@.", output);
                            [self messageReceived:output];
                            
                        }
                    }
                }
            }
            break;
            
            
        case NSStreamEventErrorOccurred:
            
            NSLog(@"Can not connect to the host!");
            break;
            
        case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            theStream = nil;
            
            break;
        default:
            NSLog(@"Unknown event!");
    }
    
}
- (void) messageReceived:(NSString *)message {
    
    [self.messages addObject:message];
    [self.chatHistoryTableView reloadData];
   
    NSIndexPath *topIndexPath =
    [NSIndexPath indexPathForRow:self.messages.count-1
                       inSection:0];
    [self.chatHistoryTableView scrollToRowAtIndexPath:topIndexPath
                      atScrollPosition:UITableViewScrollPositionMiddle
                              animated:YES];
}

-(void)dismissKeyboard {
    [self.messageTextTextField resignFirstResponder];
}

- (IBAction)sendButtonPressed:(id)sender {
    [self messageWithNSString: self.messageTextTextField.text];
    self.messageTextTextField.text = @"";
    [self dismissKeyboard];
}

- (IBAction)logoutButtonPressed:(id)sender {
    //Close conection!!!

    [[JoinData sharedInstance] resetJoinData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self.sendButton sendActionsForControlEvents: UIControlEventTouchUpInside];
    
    return YES;
}

@end
