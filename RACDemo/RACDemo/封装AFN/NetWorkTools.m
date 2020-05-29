//
//  NetWorkTools.m
//  RACDemo
//
//  Created by 刘李斌 on 2020/5/29.
//  Copyright © 2020 Brilliance. All rights reserved.
//

#import "NetWorkTools.h"



@implementation NetWorkTools

+ (instancetype)sharedTools {
    static NetWorkTools *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:nil];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];
    });
    return instance;
}

- (RACSignal *)getRequestWithURL:(NSString *)url params:(id)params progress:(void(^)(NSProgress * downloadProgressvoid))progressBlock {
    
    RACSignal *signel = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [self GET:url parameters:params progress:progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //用subscriber将请求的响应作为信号发送
            [subscriber sendNext:responseObject];
            
            //停止subscriber  确保responseObject信号只发送一次
            [subscriber sendCompleted];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //用subscriber将请求的响应error作为信号发送
            [subscriber sendError:error];
            
            //停止subscriber  确保responseObject信号只发送一次
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
    
    
    return signel;
    
}


- (RACSignal *)postRequestWithURL:(NSString *)url params:(id)params progress:(void(^)(NSProgress * downloadProgressvoid))progressBlock {
    
    RACSignal *signel = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self POST:url parameters:params progress:progressBlock success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //用subscriber将请求的响应作为信号发送
            [subscriber sendNext:responseObject];
                       
            //停止subscriber  确保responseObject信号只发送一次
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //用subscriber将请求的响应error作为信号发送
            [subscriber sendError:error];
            
            //停止subscriber  确保responseObject信号只发送一次
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
    
    
    return signel;
    
}

@end
