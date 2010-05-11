//
//  ANTLRRewriteRuleSubtreeStream.m
//  ANTLR
//
//  Created by Ian Michell on 10/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRRewriteRuleSubtreeStream.h"


@implementation ANTLRRewriteRuleSubtreeStream

-(id) nextNode
{
	NSInteger n = [self size];
	if (dirty || (cursor >= n && n == 1))
	{
		id el = [self _next];
		return [treeAdaptor copyNode:el];
	}
	id el = [self _next];
	return el;
}

-(id) copy:(id) el
{
	return [treeAdaptor copyTree:el];
}

@end
