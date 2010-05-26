//
//  ANTLRCommonTreeTest.m
//  ANTLR
//
//  Created by Ian Michell on 26/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRCommonTreeTest.h"
#import "ANTLRStringStream.h"
#import "ANTLRCommonTree.h"
#import "ANTLRCommonToken.h"

@implementation ANTLRCommonTreeTest

-(void) testInitAndRelease
{
	ANTLRCommonTree *tree = [ANTLRCommonTree new];
	STAssertNotNil(tree, @"Tree was nil");
	STAssertEquals(tree.type, (NSInteger)ANTLRTokenTypeInvalid, @"Tree should have an invalid token type, because it has not token");
	[tree release];
}

-(void) testInitWithTree
{
	ANTLRCommonTree *tree = [[ANTLRCommonTree alloc] initWithTree:[ANTLRTree invalidNode]];
	STAssertNotNil(tree, @"Tree was nil");
	// FIXME: It doesn't do anything else, perhaps initWithTree should set something somewhere, java says no though...
	[tree release];
}

-(void) testInvalidTreeNode
{
	ANTLRCommonTree *tree = [ANTLRCommonTree invalidNode];
	STAssertNotNil(tree, @"Tree was nil");
	STAssertEquals(tree.type, (NSInteger)ANTLRTokenTypeInvalid, @"Tree Token type was not ANTLRTokenTypeInvalid");
	[tree release];
}

-(void) testInitWithCommonTreeNode
{
	ANTLRStringStream *stream = [[ANTLRStringStream alloc] initWithInput:@"this||is||a||double||piped||separated||csv"];
	ANTLRCommonToken *token = [[ANTLRCommonToken alloc] initWithCharStream:stream type:555 channel:ANTLRTokenChannelDefault start:4 stop:6];
	ANTLRCommonTree *tree = [[ANTLRCommonTree alloc] initWithToken:token];
	STAssertNotNil(tree, @"Tree was nil");
	ANTLRCommonTree *newTree = [[ANTLRCommonTree alloc] initWithCommonTreeNode:tree];
	STAssertNotNil(newTree, @"New tree was nil");
	STAssertEquals(newTree.token, tree.token, @"Tokens did not match");
	STAssertEquals(newTree.tokenStopIndex, tree.tokenStopIndex, @"Token stop index did not match");
	STAssertEquals(newTree.tokenStartIndex, tree.tokenStartIndex, @"Token start index did not match");
	[stream release];
	[tree release];
	[newTree release];
	[token release];
}
@end
