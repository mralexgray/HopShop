

#import "Formula.h"
#import "FormulaDescriptions.h"



// Notifications
NSS * const NotificationClearOutput = @"notification_clear_output";
NSS * const NotificationInfoReceived = @"notification_info_received";
NSS * const NotificationFormulaeSelected = @"notification_formulae_selected";
NSS * const NotificationUpdateCompleted = @"notification_update_completed";
NSS * const NotificationOutputReceived = @"notification_output_received";


@interface Formula (private)
- (void)loadBrewInfo;
@end

@implementation Formula

static NSS *KeyName = @"name";
static NSS *KeyDesc = @"desc";
static NSS *KeyVersion = @"version";
static NSS *KeyInfo = @"info";
static NSS *KeyInstalled = @"installed";
static NSS *KeyOutdated = @"outdated";

- (id)initWithName:(NSS *)name_
{
	if (!(self = [super init])) return nil;
	self.name = name_;
//	[NSThread performBlockInBackground:^{
	self.desc = [FormulaDescriptions descriptionForName:_name];
//		 if (google) {
//		 	[[NSThread mainThread] performBlock:^{
//				self.desc = google.copy;
//			} waitUntilDone:YES];
//		}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder 
{
	if (!(self = [super init])) return nil;
	_desc = [decoder decodeObjectForKey:KeyDesc];
	_name = [decoder decodeObjectForKey:KeyName];
	_version = [decoder decodeObjectForKey:KeyVersion];
	_info = [decoder decodeObjectForKey:KeyInfo];
	_installed = [[decoder decodeObjectForKey:KeyInstalled] boolValue];
	_outdated = [[decoder decodeObjectForKey:KeyOutdated] boolValue];
	return self;
}	 

- (void)encodeWithCoder:(NSCoder *)encoder 
{
	[encoder encodeObject:_name forKey:KeyName];
	[encoder encodeObject:_desc forKey:KeyDesc];
	[encoder encodeObject:_version forKey:KeyVersion];
	[encoder encodeObject:_info forKey:KeyInfo];
	[encoder encodeObject:@(self.installed) forKey:KeyInstalled];
	[encoder encodeObject:@(self.outdated) forKey:KeyOutdated];
}

- (NSS *)info
{
	if (_info == nil)	[self loadBrewInfo];
	return _info;
}

- (void)loadBrewInfo
{
	Brew *brew = [[Brew alloc] initWithDelegate:self];
	[brew info:@[self.name]];
}

- (NSS *)description
{
	return [NSS stringWithFormat:@"%@ %@\n%@\n", self.name, (self.version == nil ? @"" : self.version), (self.info == nil ? @"" : self.info)];
}

- (NSAS *)fancyDescription
{
	NSMAS *fancy = [[NSMAS alloc] init]; 	// Add the name
	[fancy appendAttributedString:[[NSAS alloc] initWithString:self.name attributes:@{NSFontAttributeName: [AtoZ font:@"UbuntuMono-Bold" size:24], NSForegroundColorAttributeName: GREEN}]];
	!self.version ?: [fancy appendAttributedString:[[NSAS alloc] initWithString:$(@"\n%@", self.version) attributes:@{NSFontAttributeName: [NSFont systemFontOfSize:18.0], NSForegroundColorAttributeName:BLACK}]]; 	// Add the version
	return self.info    ? ^{	// Add the info
		NSMAS *fancyInfo = [[NSMAS alloc] initWithString:$(@"\n%@\n", self.info)];
		__block int index = 1;  // Detect the URLs  // Skip the leading newline
		NSLog(@"%@", [AtoZ controlFont]);
		[[self.info componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]each:^(NSS *word) {
			![word hasPrefix:@"http"] ?:
				[fancyInfo addAttributes:@{			   NSFontNameAttribute: [AtoZ font:@"UbuntuMono-Bold" size:24],
//													   NSFontSizeAttribute: @22,
											NSForegroundColorAttributeName: BLUE,
//										     NSUnderlineStyleAttributeName: @(NSSingleUnderlineStyle),
											  		   NSLinkAttributeName: word} range:NSMakeRange(index, [word length])];
			index += [word length] + 1;
		}];

		[fancy appendAttributedString:fancyInfo]; 		// Put in output
		return fancy;
	}() : fancy;

}

#pragma mark - BrewDelegate methods

- (void)infoDidComplete:(NSS *)output
{
	!output ?: ^{
		NSRange range = [output rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
		if (range.location > 0)	{
			self.info 		= [output substringFromIndex:(range.location + 1)];
			self.version 	= [[[output substringToIndex:range.location] componentsSeparatedByString:@" "] lastObject];
	}	}();
	[AZNOTCENTER postNotificationName:NotificationInfoReceived object:@[self]];
}

//- (void) descDidComplete:(NSString *)output
//{
//	NSLog(@"output: %@", output);
//	self.desc = output;
//}

@end
