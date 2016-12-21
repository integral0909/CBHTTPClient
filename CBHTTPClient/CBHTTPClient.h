//
//  CBHTTPClient.h
//  CBHTTPClient
//
//  Created by admin on 12/21/16.
//  Copyright © 2016 Vladimir. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CBHTTPClientDelegate;

@interface CBHTTPClient : NSObject

@property (nonatomic, strong) id<CBHTTPClientDelegate> delegate;

- (instancetype)initWithURL:(NSString *)url;
- (void) sendRequest:(NSDictionary *)params;

@end

@protocol CBHTTPClientDelegate <NSObject>

@optional
- (void) requestOK:(NSURLResponse *)response;
- (void) reuqestTryAgain:(NSURLResponse *)response;
- (void) requestTimeout:(NSURLResponse *)response;
- (void) requestFailed: (NSURLResponse *)response error: (NSError *)error;

@end
