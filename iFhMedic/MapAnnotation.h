//
//  MapAnnotation.h
//  MappingApp
//
//  Created by VMFactor on 5/22/13.
//  Copyright (c) 2013 SimPalm. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>



// types of annotations for which we will provide annotation views. 
typedef enum {
	MapAnnotationTypePin = 0,
	MapAnnotationTypeImage = 1
} MapAnnotationType;


@interface MapAnnotation : NSObject <MKAnnotation> {
	CLLocationCoordinate2D	_coordinate;
	MapAnnotationType		_annotationType;
	
	NSString*				_title;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property MapAnnotationType annotationType;
@property (nonatomic, copy) NSString* title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString*)sTitle annotationType:(MapAnnotationType)annotationType;

//- (id)initWithCoordinate:(CLLocationCoordinate2D) coordinate title:(NSString*) sTitle subtitle:(NSString*)ssubtitle annotationType:(MapAnnotationType) annotationType stationinfo:(GeoStations *)station;
@end
