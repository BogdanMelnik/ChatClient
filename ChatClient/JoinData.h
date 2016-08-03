//
//  JoinData.h
//  ChatClient
//
//  Created by Богдан Мельник on 30.09.15.
//  Copyright © 2015 Богдан Мельник. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JoinData : NSObject

@property (nonatomic) NSString *defaultServerIP;
@property (nonatomic) NSString *defaultServerPort;
@property (nonatomic) NSString *defaultNickname;
@property (nonatomic) NSString *currentServerIP;
@property (nonatomic) NSString *currentServerPort;
@property (nonatomic) NSString *currentNickname;

@property (nonatomic) BOOL isJoined;

+(instancetype) sharedInstance;

+(instancetype) alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
-(instancetype) init __attribute__((unavailable("init not available, call sharedInstance instead")));
+(instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));
-(instancetype) copy __attribute__((unavailable("copy not available, call sharedInstance instead")));

-(void) resetJoinData;

@end