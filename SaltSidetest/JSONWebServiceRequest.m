//
//  JSONWebServiceRequest.m
//  SaltSidetest
//
//  Created by Sajjeel Khilji on 10/16/15.
//  Copyright (c) 2015 Saltside. All rights reserved.
//

#import "JSONWebServiceRequest.h"
#import "AFNetworking.h"

#

static dispatch_queue_t json_request_operation_processing_queue() {
    static dispatch_queue_t it_json_request_operation_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        it_json_request_operation_processing_queue = dispatch_queue_create("com.qmic.networking.binary-request.processing", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return it_json_request_operation_processing_queue;
}


@interface JSONWebServiceRequest ()

@property (readwrite, nonatomic, strong) id responseJSON;
@property (readwrite, nonatomic, strong) NSError *error;
@property (readwrite, nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation JSONWebServiceRequest
@synthesize responseJSON = _responseJSON;
@synthesize error = _error;
@dynamic lock;

+ (instancetype)JSONWebServiceRequestWithRequest:(NSURLRequest *)urlRequest
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    JSONWebServiceRequest * requestOperation = [(JSONWebServiceRequest *)[self alloc] initWithRequest:urlRequest];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation  *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation  *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
    
    return requestOperation;
}


- (id)responseJSON {
    [self.lock lock];
    if (!_responseJSON && [self.responseData length] > 0 && [self isFinished] && !self.error) {
        NSError *error = nil;
        
        if (self.responseString && ![self.responseString isEqualToString:@" "]) {
            // Workaround for a bug in NSJSONSerialization when Unicode character escape codes are used instead of the actual character
            NSData *data = [self.responseString dataUsingEncoding:NSUTF8StringEncoding];

            if (data) {
                _responseJSON = [NSJSONSerialization JSONObjectWithData:data options:nil error:&error];
            } else {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setValue:@"Operation responseData failed decoding as a UTF-8 string" forKey:NSLocalizedDescriptionKey];
                [userInfo setValue:[NSString stringWithFormat:@"Could not decode string: %@", self.responseString] forKey:NSLocalizedFailureReasonErrorKey];
                error = [[NSError alloc] initWithDomain:@"AFNetworkingErrorDomain" code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            }
        }

        self.error = error;
    }
    [self.lock unlock];
    return _responseJSON;
}


- (NSError *)error {
    if (_error) {
        return _error;
    } else {
        return [super error];
    }
}

#pragma mark - AFHTTPRequestOperation


- (void)setCompletionBlockWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    
    self.completionBlock = ^ {
        if (self.error) {
            if (failure) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(self, self.error);
                });
            }
        } else {
            dispatch_async(json_request_operation_processing_queue(), ^{
                id response  = self.responseJSON;
                
                
                if(response == nil)
                {
                    NSError *  error = [[NSError alloc] initWithDomain:@"AFNetworkingErrorDomain" code:NSURLErrorBadServerResponse userInfo:nil];
                    self.error = error;

                }
                if (self.error) {
                    if (failure) {
                        dispatch_async( dispatch_get_main_queue(), ^{
                            failure(self, self.error);
                        });
                    }
                } else {
                    if (success) {
                        dispatch_async( dispatch_get_main_queue(), ^{
                            success(self, response);
                        });
                    }
                }
            });
        }
    };
#pragma clang diagnostic pop
}


@end
