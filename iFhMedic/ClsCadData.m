//
//  ClsCadData.m
//  iRescueMedic
//
//  Created by admin on 1/27/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import "ClsCadData.h"

@implementation ClsCadData
@synthesize ticketID;
@synthesize incidentDate;
@synthesize incidentNum;
@synthesize runNumber;
@synthesize secondaryNumber;
@synthesize acccountCode;
@synthesize toIncidentCode;
@synthesize ToDestinationCode;
@synthesize TransportReason;
@synthesize PickupFacilityCode;  //
@synthesize IncidentAddress;  // strs(9) '10 Incident Address
@synthesize IncidentAddress2;  // strs(10) '11 Incident Adderss 2
@synthesize IncidentCity;  // strs(11) '12 Incident City
@synthesize IncidentState;  // strs(12) '13 Incident State
@synthesize IncidentZip;  // strs(13) '14 Incident Zip
@synthesize DestFacilityCode;  // strs(14) '15 Dest Facility code
@synthesize DestAddress;  // strs(15) '16 Dest Addr1
@synthesize DestAddress2;  // strs(16) '17 Dest Addr2
@synthesize DestCity;  // strs(17) '18 Dest city
@synthesize DestState;  // strs(18) '19 Dest State
@synthesize DestZip;  // strs(19) '20 Dest Zip
@synthesize CallReceivedDate;  // strs(20) '21 Call Date
@synthesize CallReceivedTime;  // strs(21) '22 Call Recieved Time
@synthesize DispatchDate;  // strs(22) '23 Dispatch Date
@synthesize DispatchTime;  // strs(23) '24 Dispatched Time
@synthesize EnrouteDate;  // strs(24) '25 Enroute Date
@synthesize EnrouteTime;  // strs(25) '26 Enroute Time
@synthesize AtSceneDate;  // strs(26) '27 At Scene Date
@synthesize AtSceneTime;  // strs(27) '28 At Scene Time
@synthesize ToDestDate;  // strs(28) '29 To Dest Date
@synthesize ToDestTime;  // strs(29) '30 To Dest Time
@synthesize AtDestDate;  // strs(30) '31 At Dest Date
@synthesize AtDestTime;  // strs(31) '32 At Dest Time
@synthesize ClearDate;  // strs(32) '33 Clear Date
@synthesize ClearTime;  // strs(33) '34 Clear Time
@synthesize PTFirstName;  // strs(34) '35 PT First Name
@synthesize PTMI;  // strs(35) '36 PT Middle IN
@synthesize PTLastName;  // strs(36) '37 PT Last Name
@synthesize PTAddress;  // strs(37) '38 PT Address
@synthesize PTAddress2;  // strs(38) '39 PT Adderss 2
@synthesize PTCity;  // strs(39) '40 PT City
@synthesize PTState;  // strs(40) '41 PT State
@synthesize PTZip;  // strs(41) '42 PT Zip
@synthesize PTSSN;  // strs(42) '43 PT SSN
@synthesize PTAge;  // strs(43) '44 PT Age
@synthesize PTSex;  // strs(44) '45 PT Sex
@synthesize PTWeight;  // strs(45) '46 PT Weight
@synthesize PTDOB;  // strs(46) '47 PT DOB
@synthesize DriverName;  // strs(47) '48 Driver name
@synthesize DriverCert;  // strs(48) '49 Driver Cert
@synthesize Attendant1Name;  // strs(49) '50 Attendant 1 Name
@synthesize Attendant1Cert;  // strs(50) '51 Attendant 1 Cert
@synthesize Attendant2Name;  // strs(51) '52 Attendant 2 Name
@synthesize Attnedant2Cert;  // strs(52) '53 Attendant 2 Cert
@synthesize ChiefComplaint;  // strs(53) '54 Chief Complaint
@synthesize Notes;  // strs(54)
@synthesize CallType;  // strs(55)
@synthesize BusinessName;  // strs(56)
@synthesize CrossStreet;  // strs(57)
@synthesize MapCode;  // strs(58)
@synthesize OdometerResponding;  // strs(59)
@synthesize OdometerAtScene;  // strs(60)
@synthesize OdometerPatientDestination;  // strs(61)
@synthesize OdometerClear;  // strs(62)
@synthesize AtPatientDate;  // strs(63)
@synthesize AtPatientTime;  // strs(64)
@synthesize TransferPatientDate;  // strs(65)
@synthesize TransferPatientTime;  // strs(66)
@synthesize PriorCalls;  // strs(67)
@synthesize LocationHazards;  // strs(68)
@synthesize Zone;  // strs(69)
@synthesize Latitude;  // strs(70)
@synthesize Longitude;  // strs(71)
@synthesize Phone;  // strs(72)


@synthesize StreetNumber;  // strs(73)
@synthesize StreetPrefix;  // strs(74)
@synthesize StreetName;  // strs(75)
@synthesize StreetType;  // strs(76)
@synthesize StreetSuffix;  // strs(77)

@synthesize xStreetPrefix;  // strs(78)
@synthesize xStreetName;  // strs(79)
@synthesize xStreetType;  // strs(80)
@synthesize xStreetSuffix;  // strs(81)

@end
