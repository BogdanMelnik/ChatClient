//
//  JoinData.m
//  ChatClient
//
//  Created by Богдан Мельник on 30.09.15.
//  Copyright © 2015 Богдан Мельник. All rights reserved.
//

#import "JoinData.h"

@implementation JoinData

+(instancetype) sharedInstance {
    static dispatch_once_t pred;
    static id shared = nil;
    dispatch_once(&pred, ^{
        shared = [[super alloc] initUniqueInstance];
    });
    return shared;
}

-(instancetype) initUniqueInstance {
    return [super init];
}

//defaultServerIP
@synthesize defaultServerIP = _defaultServerIP;
- (NSString*) defaultServerIP {
    return @"localhost";
}

//defaultServerPort
@synthesize defaultServerPort = _defaultServerPort;
- (NSString*) defaultServerPort {
    return @"80";
}

//defaultNickname
@synthesize defaultNickname = _defaultNickname;
- (NSString*) defaultNickname {
    return @"nickname";
}

//currentServerIP
@synthesize currentServerIP = _currentServerIP;
- (void) setCurrentServerIP:(NSString *)currentServerIP {
    _currentServerIP = currentServerIP;
}
- (NSString*) currentServerIP {
    return _currentServerIP;
}

//currentServerPort
@synthesize currentServerPort = _currentServerPort;
- (void) setCurrentServerPort:(NSString *)currentServerPort {
    _currentServerPort = currentServerPort;
}
- (NSString*) currentServerPort {
    return _currentServerPort;
}

//currentNickname
@synthesize currentNickname = _currentNickname;
- (void) setCurrentNickname:(NSString *)currentNickname {
    _currentNickname = currentNickname;
}
- (NSString*) currentNickname {
    return _currentNickname;
}

//isJoined
@synthesize isJoined = _isJoined;
- (void) setIsJoined:(BOOL)isJoined {
    _isJoined = isJoined;
}
- (BOOL) isJoined {
    return _isJoined;
}

-(void) resetJoinData {
    [self setCurrentServerIP:@""];
    [self setCurrentServerPort:@""];
    [self setCurrentNickname:@""];
    [self setIsJoined: NO];
}

@end