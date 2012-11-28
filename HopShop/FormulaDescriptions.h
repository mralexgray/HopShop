//
//  FormulaDescription.h
//  HopShop
//
//  Created by Alex Gray on 11/27/12.
//  Copyright (c) 2012 Grailbox. All rights reserved.
//

#import <AtoZ/AtoZ.h>

@interface FormulaDescriptions : BaseModel

+ (NSS*) descriptionForName: (NSS*)name;
+ (NSS*) googleSearchFor:(NSS*)name;
+ (void) saveNewEntriesToDisk;

@end
