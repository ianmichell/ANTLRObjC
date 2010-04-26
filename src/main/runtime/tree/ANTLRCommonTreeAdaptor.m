//
//  ANTLRCommonTreeAdaptor.m
//  ANTLR
//
//  Created by Ian Michell on 26/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRCommonTreeAdaptor.h"
#import "ANTLRCommonTree.h"
#import "ANTLRCommonToken.h"

@implementation ANTLRCommonTreeAdaptor

-(id<ANTLRTree>) createTreeWithToken:(id<ANTLRToken>) payload
{
	return [[ANTLRCommonTree alloc] initWithToken:payload];
}

-(id<ANTLRToken>) tokenForNode:(id<ANTLRTree>) t
{
	if ([t isKindOfClass:[ANTLRCommonTree class]])
	{
		return ((ANTLRCommonTree *)t).token;
	}
	return nil; // we only care about common trees here...
}

-(id<ANTLRToken>) createTokenFromType:(NSInteger) tokenType withText:(NSString *) txt
{
	return [[ANTLRCommonToken alloc] initWithTokenType:tokenType andText:txt];
}

-(id<ANTLRToken>) createTokenFromToken:(id<ANTLRToken>) fromToken
{
	return [[ANTLRCommonToken alloc] initWithToken:fromToken];
}

@end
