#import "BEConfig.h"

@interface BEConfig ()
@property (strong, nonatomic, readwrite) NSString *currentConfiguration;
@property (strong, nonatomic) NSDictionary *dictionary;
@end


@implementation BEConfig
+ (instancetype)configuration {
	static dispatch_once_t onceToken;
	static BEConfig *config;
	dispatch_once(&onceToken, ^{
	    config = [[BEConfig alloc] init];
	    NSURL *configurationUrl = [[NSBundle mainBundle] URLForResource:@"BEConfiguration" withExtension:@"plist"];
	    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfURL:configurationUrl];
	    NSAssert(dictionary, @"BEConfiguration.plist not found. Create a BEConfiguration.plist file with your configuration data. Ensure it is added to your main target");

	    config.dictionary = dictionary;
        #ifdef BUILD_ENVIRONMENT
	    config.currentConfiguration = BUILD_ENVIRONMENT;
	    #else
        #error BUILD_ENVIRONMNET not set
	    #endif
	});
	return config;
}

- (id)objectForKeyedSubscript:(NSString *)key {
	if (self.dictionary[self.currentConfiguration][key]) {
		return self.dictionary[self.currentConfiguration][key];
	}
	return self.dictionary[key];
}

@end
