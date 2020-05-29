//
//  NetWorkTools.h
//  RACDemo
//
//  Created by 刘李斌 on 2020/5/29.
//  Copyright © 2020 Brilliance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager.h>
#import <ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWorkTools : AFHTTPSessionManager

+ (instancetype)sharedTools;

- (RACSignal *)getRequestWithURL:(NSString *)url params:(id)params progress:(void(^)(NSProgress * downloadProgressvoid))progressBlock;

- (RACSignal *)postRequestWithURL:(NSString *)url params:(id)params progress:(void(^)(NSProgress * downloadProgressvoid))progressBlock;

@end

NS_ASSUME_NONNULL_END
