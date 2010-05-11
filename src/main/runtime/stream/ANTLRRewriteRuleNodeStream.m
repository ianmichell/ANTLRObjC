//
//  ANTLRRewriteRuleNodeStream.m
//  ANTLR
//
//  Created by Ian Michell on 10/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRRewriteRuleNodeStream.h"
#import "ANTLRError.h"

@implementation ANTLRRewriteRuleNodeStream

-(id) nextNode
{
	return [self _next];
}

-(id) toTree:(id) el
{
	return [treeAdaptor copyNode:el];
}

-(id) copy:(id) el
{
	@throw [NSException exceptionWithName:ANTLRUnsupportedOperationException reason:@"dup can't be called for node stream" userInfo:nil];
}

@end
