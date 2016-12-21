//
//  AppDelegate.m
//  CBHTTPClient
//
//  Created by admin on 12/21/16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

#import "AppDelegate.h"
#import "CBHTTPClient.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>

@interface AppDelegate () <CBHTTPClientDelegate>

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [OHHTTPStubs setEnabled:true];
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest * _Nonnull request) {
        return true;
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        NSString* fixture = OHPathForFile(@"response.json", self.class);
        return [[OHHTTPStubsResponse responseWithFileAtPath:fixture
                                                 statusCode:504 headers:@{@"Content-Type":@"application/json"}]
                requestTime: 2.0f
                responseTime:OHHTTPStubsDownloadSpeedSLOW];
        
    }];
    
    
    [self testRequest];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void) testRequest {
    CBHTTPClient *client = [[CBHTTPClient alloc] initWithURL:@"http://104.238.94.136:8080/prefs"];
    [client setDelegate:self];
    [client sendRequest:@{
                          @"deviceId" : @"Simulator",
                          @"token" : @"abc123123123123123",
                          }];
    
}


/// CBHttpClient delegate
#pragma mark - CBHttpClient delegate

- (void)requestFailed:(NSURLResponse *)response error:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    
}

- (void)requestTimeout:(NSURLResponse *)response {
    NSLog(@"%s", __FUNCTION__);
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
}

- (void)requestOK:(NSURLResponse *)response {
    NSLog(@"%s", __FUNCTION__);
    
}

- (void)reuqestTryAgain:(NSURLResponse *)response {
    NSLog(@"%s", __FUNCTION__);
    
}

@end
