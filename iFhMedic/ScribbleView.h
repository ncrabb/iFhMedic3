//
//  ScribbleView.h
//  Opthal
//
//  Created by Nasheena Yadav on 22/09/09.
//  Copyright 2009 VMFactor. All rights reserved.
//


#import <UIKit/UIKit.h>
#define MAX_POINTS	1024

@interface ScribbleView : UIView {

	CGPoint ptStartLocation;
	CGPoint ptEndLocation;
	CGPoint points[MAX_POINTS];
	int nIndex;
}

- (void) clearSignature:(CGRect)rect;

@end
