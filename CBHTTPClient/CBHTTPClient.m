//
//  CBHTTPClient.m
//  CBHTTPClient
//
//  Created by admin on 12/21/16.
//  Copyright © 2016 Vladimir. All rights reserved.
//


#import "CBHttpClient.h"

@interface CBHTTPClient() <NSURLConnectionDelegate> {
    
}

@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@end

@implementation CBHTTPClient

- (instancetype)initWithURL:(NSString *)url {
    self = [super init];
    if (self) {
        _request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [_request setHTTPMethod:@"GET"];
        [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return self;
}

- (void) sendRequest:(NSDictionary *)params {
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:_request.URL.absoluteString];
    NSMutableString *strParam = [[NSMutableString alloc] init];
    for (NSString *key in params.allKeys) {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            [strParam appendFormat:@"%@=%@", key, value];
            [strParam appendString:@"&"];
        }
    }
    
    if (params.allKeys.count > 0) {
        [strParam deleteCharactersInRange:NSMakeRange([strParam length] - 1, 1)];
    }
    [urlComponents setQuery:strParam];
    NSLog(@"%@", urlComponents.URL);
    [_request setURL:urlComponents.URL];
    
    _task = [[NSURLSession sharedSession] dataTaskWithRequest:_request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (self.delegate) {
            if (response) {
                
                NSInteger statuCode = [(NSHTTPURLResponse *)response statusCode];
                
                /// Internal server error
                if (statuCode == 500) {
                    [self.delegate reuqestTryAgain:response];
                }
                /// Time out
                else if (statuCode == 504 || statuCode == 408) {
                    [self.delegate requestTimeout:response];
                }
                /// Success
                else if (200 <= statuCode && statuCode < 300) {
                    [self.delegate requestOK:response];
                }
                /// Error
                else {
                    [self.delegate requestFailed:response error:nil];
                }
            } else {
                if (error) {
                    
                    [self.delegate requestFailed:nil error:error];
                }
            }
        }
    }];
    [_task resume];
}


@end
