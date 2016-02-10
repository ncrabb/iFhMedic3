//
//  ScribbleView.m
//  Opthal
//
//  Created by Nasheena Yadav on 22/09/09.
//  Copyright 2009 VMFactor. All rights reserved.
//

#import "ScribbleView.h"


@implementation ScribbleView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self.backgroundColor = [UIColor clearColor];
	if (self = [super initWithCoder:aDecoder]) {		
		nIndex = 0;
	}
	return self;
}


- (void)drawRect:(CGRect)rect {
	
    CGContextRef ctx = UIGraphicsGetCurrentContext();   
    
	points[nIndex] = ptStartLocation;
	nIndex++;
	points[nIndex] = ptEndLocation;
	nIndex++;
	
    CGContextStrokeLineSegments(ctx, points, (nIndex-1));
	
	ptStartLocation = ptEndLocation;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if(nIndex == MAX_POINTS) return;
	
	ptEndLocation = [[touches anyObject] locationInView:self];
	[self setNeedsDisplay];	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {	
	ptStartLocation = [[touches anyObject] locationInView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {	
}

- (void) clearSignature:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextClearRect(ctx, self.bounds);
}



@end
