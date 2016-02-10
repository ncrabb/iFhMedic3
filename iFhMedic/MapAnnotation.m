//
//  MapAnnotation.m
//  MappingApp
//
//  Created by VMFactor on 5/22/13.
//  Copyright (c) 2013 SimPalm. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation

@synthesize coordinate = _coordinate;
@synthesize annotationType = _annotationType;
@synthesize title = _title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)sTitle annotationType:(MapAnnotationType)annotationType;
{
	
	_coordinate = coordinate;
	_annotationType = annotationType;
	_title = sTitle;
	
	return self;
}

/*- (id)initWithCoordinate:(CLLocationCoordinate2D) coordinate title:(NSString*) sTitle subtitle:(NSString*)ssubtitle annotationType:(MapAnnotationType) annotationType stationinfo:(GeoStations *)station
{
	
	_coordinate = coordinate;
	_annotationType = annotationType;
	
	_title = sTitle;
	m_stationInfo = station;
	
	return self;
}*/

- (NSString *)subtitle
{
    
    return nil;
}

- (void)dealloc
{
}


@end
