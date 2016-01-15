//
//  EOWebServiveInteraction.h
//  TopeveryEO
//
//  Created by WangShuai on 14/11/12.
//  Copyright (c) 2014年 Topevery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebServiveInteraction : NSObject<NSXMLParserDelegate,NSURLConnectionDelegate>
{
    NSMutableData *webData;
    NSXMLParser *xmlParser;
    NSMutableString *soapResults;
    NSMutableString *resultMutable;
    BOOL elementFound;
}
typedef void (^MethodInvokeSuccessBlock)(NSArray* output);
typedef void (^MethodInvokeFailedBlock)(NSString* errMsg);
@property (nonatomic,strong) NSURLConnection *conn;
@property (nonatomic,strong) NSString *methodName;
@property (nonatomic,strong) NSString *para;
@property (strong,nonatomic) NSString *result;
@property (nonatomic,strong) NSString *entityName;
@property (nonatomic) BOOL isBool;
@property (nonatomic,strong) NSString *errorMessage;
@property (nonatomic, assign) NSInteger statusCode;

@property (nonatomic, strong) MethodInvokeSuccessBlock invokeSuccess;
@property (nonatomic, strong) MethodInvokeFailedBlock invokeFailed;
-(void)invoke:(NSInteger)timeoutInterval successBlock:(MethodInvokeSuccessBlock)successBlock failedBlock:(MethodInvokeFailedBlock)failedBlock;


@end
