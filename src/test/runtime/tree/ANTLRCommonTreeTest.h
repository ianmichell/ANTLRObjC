//
//  ANTLRCommonTreeTest.h
//  ANTLR
//
//  Created by Ian Michell on 26/05/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>


@interface ANTLRCommonTreeTest : SenTestCase 
{
}

-(void) testInitAndRelease;
-(void) testInitWithTree;
-(void) testWithToken;
-(void) testInvalidTreeNode;
-(void) testInitWithCommonTreeNode;
-(void) testCopyTree;
-(void) testDescription;
-(void) testText;
-(void) testAddChild;
-(void) testAddSelfAsChild;
-(void) testChildAtIndex;
-(void) testSetChildAtIndex;
-(void) testGetAncestor;
-(void) testFirstChildWithType;

@end
