#import <Foundation/Foundation.h>

@interface BEConfig : NSObject
@property (readonly, nonatomic) NSString *currentConfiguration;

+ (instancetype)configuration;

- (id)objectForKeyedSubscript:(NSString *)key;
@end
