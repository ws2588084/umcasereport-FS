//
//  EntityHelper.h
//  TableViewTest3
//
//  Created by EightLong on 14-9-17.
//
//

#import <Foundation/Foundation.h>

@interface EntityHelper : NSObject

+ (void) dictionaryToEntity:(NSDictionary *)dict entity:(NSObject*)entity;
+ (NSDictionary *) entityToDictionary:(id)entity;
+ (NSString *) modelToPara:(NSString *)key paraValue:(NSString *)value;
+ (NSString *) modelToParaUUID:(NSString *)key paraValue:(NSUUID *)value;
+ (NSString *) modelToParaNumber:(NSString *)key paraValue:(NSNumber *)value;

//通过对象返回一个NSDictionary，键是属性名称，值是属性值。
+ (NSDictionary*)getObjectData:(id)obj;

//将getObjectData方法返回的NSDictionary转化成JSON
+ (NSData*)getJSON:(id)obj options:(NSJSONWritingOptions)options error:(NSError**)error;

//直接通过NSLog输出getObjectData方法返回的NSDictionary
+ (void)print:(id)obj;



@end
