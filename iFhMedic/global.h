//
//  global.h
//  iRescueMedic
//
//  Created by Nathan on 6/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#ifndef iRescueMedic_global_h
#define iRescueMedic_global_h

#define DRUG 2011
#define CLEAR_AIRWAY_DRUG   2001
#define kVERSION    @"VERSION"    // App version


//#define FAX_SERVICE             @"https://tww2.emergidata.net/RescueMedicReports/service.asmx"
#define FAX_SERVICE             @"https://ww2.managemyepcr.com/RescueMedicReports/service.asmx"

#define g_WEBSERVICE          @"https://tww6.emergidata.net/irescuemedic/service.asmx"
//#define   g_WEBSERVICE          @"https://mobile.managemyepcr.com/iFHMedic/service.asmx"


#define  g_DATADB       @"rm_data.sqlite"
#define  g_BLOBSDB      @"rm_blobs.sqlite"
#define  g_QUEUEDB      @"rm_queue.sqlite"
#define  g_LOOKUPDB     @"rm_lookup.sqlite"


extern NSMutableDictionary* g_SETTINGS;

extern NSTimer* g_QUEUETIMER;
extern NSTimer* g_BACKUPTIMER;
extern NSInteger g_CUSTOMERNO;

extern NSObject* g_SYNCDATADB;
extern NSObject* g_SYNCLOOKUPDB;
extern NSObject* g_SYNCBLOBSDB;
extern Boolean g_NEWTICKET;
extern NSMutableArray* g_CREWARRAY;
#endif
