//
//  JSONWebServiceRequest.h
//  SaltSidetest
//
//  Created by Sajjeel Khilji on 10/16/15.
//  Copyright (c) 2015 Saltside. All rights reserved.
//

#import "AFHTTPRequestOperation.h"

@interface JSONWebServiceRequest : AFHTTPRequestOperation

+ (instancetype)JSONWebServiceRequestWithRequest:(NSURLRequest *)urlRequest
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
