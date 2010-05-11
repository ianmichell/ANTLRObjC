//
//  ANTLRRewriteRuleTokenStream.m
//  ANTLR
//
//  Created by Ian Michell on 10/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRRewriteRuleTokenStream.h"
#import "ANTLRError.h"

@implementation ANTLRRewriteRuleTokenStream

-(id) nextNode
{
	id<ANTLRToken> t = (id<ANTLRToken>)[self _next];
	return [treeAdaptor createTreeWithToken:t];
}

-(id<ANTLRToken>) nextToken
{
	return (id<ANTLRToken>)[self _next];
}

-(id) toTree:(id) el
{
	return el;
}

-(id) copy:(id) el
{
	@throw [NSException exceptionWithName:ANTLRUnsupportedOperationException reason:@"dup can't be called for a token stream" userInfo:nil];
}

@end
