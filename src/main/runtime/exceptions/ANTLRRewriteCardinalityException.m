//
//  ANTLRRewriteCardinalityException.m
//  ANTLR
//
//  Created by Ian Michell on 29/04/2010.
//  Copyright 2010 Ian Michell. All rights reserved.
//

#import "ANTLRRewriteCardinalityException.h"


@implementation ANTLRRewriteCardinalityException

+(ANTLRRewriteCardinalityException *) exceptionWithElementDescription:(NSString *) description
{
	return [[ANTLRRewriteCardinalityException alloc] initWithName:[NSString stringWithFormat: @"%s", class_getName([ANTLRRewriteCardinalityException class])] reason:description userInfo:nil];
}

@end
