//
//  RITestMacros.h
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#ifndef Exercise_RITestMacros_h
#define Exercise_RITestMacros_h

// Set the flag for a block completion handler
#define StartBlock() __block BOOL waitingForBlock = YES

// Set the flag to stop the loop
#define EndBlock() waitingForBlock = NO

// Wait and loop until flag is set
#define WaitUntilBlockCompletes() WaitWhile(waitingForBlock)

// Macro - Wait for condition to be NO/false in blocks and asynchronous calls
#define WaitWhile(condition) \
do { \
while(condition) { \
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; \
} \
} while(0)

#endif
