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
-(void) testInvalidTreeNode;
-(void) testInitWithCommonTreeNode;

@end