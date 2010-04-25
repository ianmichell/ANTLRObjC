//
//  ANTLRUnwantedTokenException.m
//  ANTLR
//
//  Created by Ian Michell on 25/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRUnwantedTokenException.h"


@implementation ANTLRUnwantedTokenException

@dynamic unexpectedToken;
-(id<ANTLRToken>) unexpectedToken
{
	return self.token;
}

-(NSString *) description
{
	NSString *str = [NSString stringWithFormat:@", expected %d", self.expecting];
	if (self.expecting == ANTLRTokenTypeInvalid)
	{
		[str release];
		str = @"";
	}
	if (self.token == nil)
	{
		return [NSString stringWithFormat:@"ANTLRUnwantedTokenException(found=nil%d)", self.expecting];
	}
	return [NSString stringWithFormat:@"ANTLRUnwantedTokenException(found=%@%d)", self.token.text, self.expecting];
}

@end
