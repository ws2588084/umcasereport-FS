//
//  EntityHelper.m
//  TableViewTest3
//
//  Created by EightLong on 14-9-17.
//
//

#import "EntityHelper.h"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#import <objc/runtime.h>

@implementation EntityHelper

+ (void) dictionaryToEntity:(NSDictionary *)dict entity:(NSObject*)entity
{
    if (dict && entity) {
        
        for (NSString *keyName in [dict allKeys]) {
            //构建出属性的set方法
//            NSString *destMethodName = [NSString stringWithFormat:@"set%@:",[keyName capitalizedString]]; //capitalizedString返回每个单词首字母大写的字符串（每个单词的其余字母转换为小写）
            NSString *destMethodName = [NSString stringWithFormat:@"set%@:",keyName];
            SEL destMethodSelector = NSSelectorFromString(destMethodName);
            
            if ([entity respondsToSelector:destMethodSelector]) {
                NSObject *obj = [dict objectForKey:keyName];
                
//                [entity performSelector:destMethodSelector withObject:[dict objectForKey:keyName]];
                [entity performSelector:destMethodSelector withObject:obj];
            }
            
        }//end for
        
    }//end if
}

+ (NSDictionary *) entityToDictionary:(id)entity
{
    
    Class class = [entity class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(class, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        
        //        const char* attributeName = property_getAttributes(prop);
        //        NSLog(@"%@",[NSString stringWithUTF8String:propertyName]);
        //        NSLog(@"%@",[NSString stringWithUTF8String:attributeName]);
        
        id value =  [entity performSelector:NSSelectorFromString([NSString stringWithUTF8String:propertyName])];
        if(value ==nil)
            [valueArray addObject:[NSNull null]];
        else {
            [valueArray addObject:value];
        }
        //        NSLog(@"%@",value);
    }
    
    free(properties);
    
    NSDictionary* returnDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    NSLog(@"%@", returnDic);
    
    return returnDic;
}
+ (NSString *) modelToPara:(NSString *)key paraValue:(NSString *)value
{
    NSString *para = @"";
    if(value==nil)
        para = [NSString stringWithFormat:@"<%@></%@>",key,key];
    else
        para = [NSString stringWithFormat:@"<%@>%@</%@>",key,value,key];
    return para;
}
+ (NSString *) modelToParaUUID:(NSString *)key paraValue:(NSUUID *)value
{
    NSString *para = @"";
    if(value==nil)
        para = [NSString stringWithFormat:@"<%@>00000000-0000-0000-0000-000000000000</%@>",key,key];
    else
        para = [NSString stringWithFormat:@"<%@>%@</%@>",key,[value UUIDString],key];
    return para;
}
+ (NSString *) modelToParaNumber:(NSString *)key paraValue:(NSNumber *)value
{
    NSString *para = @"";
    if(value==nil)
        para = [NSString stringWithFormat:@"<%@>0</%@>",key,key];
    else
        para = [NSString stringWithFormat:@"<%@>%@</%@>",key,value,key];
    return para;
}

+ (NSDictionary*)getObjectData:(id)obj
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++)
    {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil)
        {
            value = [NSNull null];
        }
        else
        {
            value = [self getObjectInternal:value];
            [dic setObject:value forKey:propName];
        }
    }
    return dic;
}

+ (void)print:(id)obj
{
    NSLog(@"%@", [self getObjectData:obj]);
}


+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error
{
//    NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
//    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str);
    return [NSJSONSerialization dataWithJSONObject:[self getObjectData:obj] options:options error:error];
}

+ (id)getObjectInternal:(id)obj
{
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]])
    {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]])
    {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++)
        {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys)
        {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}
@end
