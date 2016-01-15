//
//  EOWebServiveInteraction.m
//  TopeveryEO
//
//  Created by WangShuai on 14/11/12.
//  Copyright (c) 2014年 Topevery. All rights reserved.
//

#import "WebServiveInteraction.h"
#import "AppDelegate.h"

@implementation WebServiveInteraction


-(void)invoke:(NSInteger)timeoutInterval successBlock:(MethodInvokeSuccessBlock)successBlock failedBlock:(MethodInvokeFailedBlock)failedBlock
{
    self.invokeSuccess = successBlock;
    self.invokeFailed = failedBlock;
    
    resultMutable = [[NSMutableString alloc]init];
    // 创建SOAP消息，内容格式就是网站上提示的请求报文的实体主体部分
    NSString *soapMsg = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<%@ xmlns=\"http://www.topevery.com/\">"
                         "%@"
                         "</%@>"
                         "</soap12:Body>"
                         "</soap12:Envelope>", _methodName, _para, _methodName];
    //    NSLog(@"%@",soapMsg);
    //服务地址
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
//    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *IP = [PublicHelper GetSettingValue:@"HttpIP"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/ASMX/MobileWebService.asmx",IP]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msglength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMsg length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msglength forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    [req setTimeoutInterval:30];
    // 创建连接
    self.conn = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
    if (self.conn)
    {
        webData = [NSMutableData data];
    }
}

// 刚开始接受响应时调用
-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    self.statusCode = [httpResponse statusCode];
    //    [webData setLength: 0];
}
// 每接收到一部分数据就追加到webData中
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data
{
    [webData appendData:data];
}
// 出现错误时
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error
{
    self.conn = nil;
    webData = nil;
    NSString *errorString = [NSString stringWithFormat:@"网络错误: %@",
                             [error localizedDescription]];
    
    if(self.invokeFailed != nil) {
        self.invokeFailed(errorString);
    }
}

// 完成接收数据时调用
-(void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    //     打印出得到的XML
//        NSString *resultXML = [[NSString alloc] initWithBytes:[webData mutableBytes]
//                                                    length:[webData length]
//                                                  encoding:NSUTF8StringEncoding];
//    
//        NSLog(@"%@", resultXML);
    //     使用NSXMLParser解析出我们想要的结果
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    
    [NSJSONSerialization JSONObjectWithData:webData options:kNilOptions error:nil];
    
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}
// 开始解析一个元素名
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict
{
    //    if ([elementName isEqualToString:matchingElement])
    //    {
    if (!soapResults)
    {
        soapResults = [[NSMutableString alloc] init];
    }
    elementFound = YES;
    //    }
}
// 追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if(elementFound)
    {
        [soapResults appendString: string];
    }
}
// 结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //    if([elementName isEqualToString:@"IsSucess"])
    //    {
    //        self.isBool = [soapResults boolValue];
    //    }
    //    else if([elementName isEqualToString:@"ErrorMessage"])
    //    {
    //        self.errorMessage = soapResults;
    //    }
    //    else if([elementName isEqualToString:@"result"])
    //    {
    //        self.result = soapResults;
    //    }
    
    if([elementName isEqualToString:[NSString stringWithFormat:@"%@Response",_methodName]])
    {
        _result = [NSString stringWithFormat:@"[%@]",_result];
        
        if(self.statusCode == 200) {
            if(self.invokeSuccess != nil) {
                NSData *data= [_result dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *Entitys = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:nil];
                self.invokeSuccess(Entitys);
            }
        } else {
            if(self.invokeFailed != nil) {
                self.invokeFailed([NSString stringWithFormat:@"操作失败： statusCode=%ld", (long)self.statusCode]);
            }
        }
        elementFound = NO;
        [xmlParser abortParsing];
    }
    else if([elementName isEqualToString:_entityName])
    {
        if(resultMutable==nil || resultMutable.length<=0)
        {
            resultMutable = soapResults;
        }
        else
        {
            resultMutable = [[NSMutableString alloc]initWithFormat:@"{%@}",resultMutable];
        }
        if(_result.length>0)
        {
            _result = [NSString stringWithFormat:@"%@,%@",_result,resultMutable];
        }
        else
        {
            _result = resultMutable;
        }
        resultMutable = [[NSMutableString alloc]init];
    }
    else
    {
        
        if(resultMutable.length>0)
            [resultMutable appendFormat:@",\"%@\":\"%@\"",elementName,soapResults];
        else
            [resultMutable appendFormat:@"\"%@\":\"%@\"",elementName,soapResults];
    }
    
    
    soapResults = nil;
}
// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (soapResults) {
        soapResults = nil;
    }
}
// 出错时，例如强制结束解析
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (soapResults)
    {
        soapResults = nil;self.conn = nil;
        webData = nil;
        NSString *errorString = [NSString stringWithFormat:@"网络错误: %@",
                                 [parseError localizedDescription]];
        
        if(self.invokeFailed != nil) {
            self.invokeFailed(errorString);
        }
    }
    
    
}
@end
