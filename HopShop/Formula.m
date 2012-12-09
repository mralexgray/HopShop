
#import "Formula.h"
#import "FormulaDescriptions.h"

NSS * const NotificationClearOutput 	 = @"notification_clear_output";
NSS * const NotificationInfoReceived 	 = @"notification_info_received";
NSS * const NotificationFormulaeSelected = @"notification_formulae_selected";
NSS * const NotificationUpdateCompleted  = @"notification_update_completed";
NSS * const NotificationOutputReceived   = @"notification_output_received";

@interface Formula (private)
- (void)loadBrewInfo;
@end

@implementation Formula

static NSS *KeyName = @"name";
static NSS *KeyDesc = @"desc";
static NSS *KeyVersion = @"version";
static NSS *KeyInfo = @"info";
static NSS *KeyInstallStatus = @"install";
static NSS *KeyOutdated = @"outdated";

- (id)initWithName:(NSS *)name
{
	if (self != super.init ) return nil;
	_name 			 	= name;
	_installStatus 		= AZNotInstalled;
	self.desc	 			= [FormulaDescriptions descriptionForFormula:self];
	return self;
}

//- (id)initWithCoder:(NSCoder *)decoder
//{
//	if (!(self = [super init])) return nil;
//	_desc = [decoder decodeObjectForKey:KeyDesc];
//	_name = [decoder decodeObjectForKey:KeyName];
//	_version = [decoder decodeObjectForKey:KeyVersion];
//	_info = [decoder decodeObjectForKey:KeyInfo];
////	_installStatus = [decoder decodeObjectForKey:KeyInstallStatus];
////	_installed = [[decoder decodeObjectForKey:KeyInstalled] boolValue];
////	_outdated = [[decoder decodeObjectForKey:KeyOutdated] boolValue];
//	return self;
//}

//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//	[encoder encodeObject:_name forKey:KeyName];
//	[encoder encodeObject:_desc forKey:KeyDesc];
//	[encoder encodeObject:_version forKey:KeyVersion];
//	[encoder encodeObject:_info forKey:KeyInfo];
////	[encoder encodeObject:AZVinstall(self.installStatus) forKey:KeyInstallStatus];
////	[encoder encodeObject:@(self.outdated) forKey:KeyOutdated];
//}

- (NSS *)info	{ return _info ?: ^{ [self loadBrewInfo]; return _info; }(); }


- (void)loadBrewInfo
{
	CWTask *y = [CWTask.alloc initWithExecutable:@"/bin/ls" andArguments:@"/Users/localadmin"
									 atDirectory:nil];

	[y launchTaskOnQueue:AZSharedSingleOperationQueue() withCompletionBlock:^(NSString *output, NSError *error) {

	}
	launchTaskOnQueue:AZSharedSingleOperationQueue()
	 withCompletionBlock:(void)(^)(NSS *output, NSError *error){
		 NSLog(@"%@", output)
	 }];
	

	[AZSharedSingleOperationQueue() addOperation:
	 [Brew.alloc initWithFormula:self operation:BrewOperationInfo]];
//		[brew info:@[self.name]];
//	}];
}

- (void)setDescFromGoogle:(NSString *)desc {
	self.googleGenerated = YES;
	[self setDesc:desc];
}

- (NSS *)description
{
	return [NSS stringWithFormat:@"%@ %@\n%@\n", self.name, (_version == nil ? @"" : self.version), (_info == nil ? @"" : self.info)];
}

- (NSAS *)fancyDesc
{
	static BOOL hadDesc, hadVersion;  hadDesc = hadVersion = NO;
	return _fancyDesc =  hadVersion == (self.version != nil)  && hadDesc == (self.desc != nil) ? _fancyDesc : ^{
		__block NSMAS *fancy = [NSMAS.alloc initWithAttributedString:[NSAS.alloc initWithString:self.name attributes:@{NSFontAttributeName: [AtoZ font:@"UbuntuMono-Bold" size:24], NSForegroundColorAttributeName: GREEN}]]; 	// Add the name

		!self.version ?: [fancy appendAttributedString:[NSAS.alloc initWithString:$(@"\tversion: %@", self.version) attributes:@{NSFontAttributeName: [AtoZ font:@"UbuntuMono-Bold" size:18], NSForegroundColorAttributeName:GRAY8}]]; 	// Add the version
		!self.desc    ?: [fancy appendAttributedString:[NSAS.alloc initWithString:$(@"\nDescription: %@", self.desc) attributes:@{NSFontAttributeName: [AtoZ font:@"UbuntuMono-Bold" size:18], NSForegroundColorAttributeName:BLACK}]]; 	// Add the version
		hadVersion    =  self.version != nil;
		hadDesc       =  self.desc    != nil;
		!self.info    ?: ^{																// Add the info
			NSMAS *fancyInfo = [NSMAS.alloc initWithString:$(@"\n%@\n", self.info)];
//			__block int index = 1;  // Detect the URLs  // Skip the leading newline
			[[self.info componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet] reduce:^id  (id memo, NSS*word) {
//			// each:^(NSS *word) {
				![word hasPrefix:@"http"] ?:
					[fancyInfo addAttributes:@{			   NSFontNameAttribute: [AtoZ font:@"UbuntuMono-Bold" size:24], // NSFontSizeAttribute: @22,
												NSForegroundColorAttributeName: GRAY9,									// NSUnderlineStyleAttributeName: @(NSSingleUnderlineStyle),
														   NSLinkAttributeName: word} range:NSMakeRange([memo intValue], word.length)];
				return @( [memo intValue] + word.length + 1 );
			} withInitialMemo:@1];
			[fancy appendAttributedString:fancyInfo]; 		// Put in output
		}();
		return fancy;
		}();
}

+ (NSSet*) keyPathsForValuesAffectingUrl {return NSSET(@"info"); }

- (NSS*) url
{
	return _url = _url ?: [[_info componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet]filterOne:^BOOL(id object) {  return [(NSS*)object hasPrefix:@"http"];	}];
}

#pragma mark - BrewDelegate methods
- (void)infoDidComplete:(NSS *)output
{
	!output ?: ^{
		NSRange range = [output rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
		if (range.location > 0)	{
			self.info 		= [output substringFromIndex:(range.location + 1)];
			self.version 	= [[output substringToIndex:range.location] componentsSeparatedByString:@" "].lastObject;
	}	}();
	[AZNOTCENTER postNotificationName:NotificationInfoReceived object:@[self]];
}

@end
