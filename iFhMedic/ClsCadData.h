#import <Foundation/Foundation.h>

@interface ClsCadData : NSObject
@property (nonatomic, strong) NSString* ticketID;   // 1002
@property (nonatomic, strong) NSString* incidentDate;   // 1002
@property (nonatomic, strong) NSString* incidentNum;    //  1001
@property (nonatomic, strong) NSString* runNumber;      //
@property (nonatomic, strong) NSString* secondaryNumber;  // 1033
@property (nonatomic, strong) NSString* acccountCode;  // ticket Column TicketAccount
@property (nonatomic, strong) NSString* toIncidentCode;   // 1030
@property (nonatomic, strong) NSString* ToDestinationCode;  // 1031
@property (nonatomic, strong) NSString* TransportReason;  // 1032
@property (nonatomic, strong) NSString* PickupFacilityCode;  //9004 , 1011
@property (nonatomic, strong) NSString* IncidentAddress;  // strs(9)  - 1003
@property (nonatomic, strong) NSString* IncidentAddress2;  // strs(10) '11 Incident Adderss 2  - 1021
@property (nonatomic, strong) NSString* IncidentCity;  // strs(11) '12 Incident City   - 1004
@property (nonatomic, strong) NSString* IncidentState;  // strs(12) '13 Incident State   - 1005
@property (nonatomic, strong) NSString* IncidentZip;  // strs(13) '14 Incident Zip   - 1006
@property (nonatomic, strong) NSString* DestFacilityCode;  // strs(14) - 9003, 1701, 1402
@property (nonatomic, strong) NSString* DestAddress;  // strs(15)  1702
@property (nonatomic, strong) NSString* DestAddress2;  // strs(16)  1703
@property (nonatomic, strong) NSString* DestCity;  // strs(17)   1705
@property (nonatomic, strong) NSString* DestState;  // strs(18)  1706
@property (nonatomic, strong) NSString* DestZip;  // strs(19)   1704
@property (nonatomic, strong) NSString* CallReceivedDate;  // strs(20) - 1051
@property (nonatomic, strong) NSString* CallReceivedTime;  // strs(21) - 1048
@property (nonatomic, strong) NSString* DispatchDate;  // strs(22) - 1052
@property (nonatomic, strong) NSString* DispatchTime;  // strs(23) - 1040
@property (nonatomic, strong) NSString* EnrouteDate;  // strs(24) - 1053
@property (nonatomic, strong) NSString* EnrouteTime;  // strs(25) -  1041
@property (nonatomic, strong) NSString* AtSceneDate;  // strs(26) - 1054
@property (nonatomic, strong) NSString* AtSceneTime;  // strs(27) 1042
@property (nonatomic, strong) NSString* ToDestDate;  // strs(28) 1056
@property (nonatomic, strong) NSString* ToDestTime;  // strs(29) - 1043
@property (nonatomic, strong) NSString* AtDestDate;  // strs(30) 1057
@property (nonatomic, strong) NSString* AtDestTime;  // strs(31) 1044
@property (nonatomic, strong) NSString* ClearDate;  // strs(32)  1059
@property (nonatomic, strong) NSString* ClearTime;  // strs(33)  1046
@property (nonatomic, strong) NSString* AtPatientDate;  // strs(63) - 1055
@property (nonatomic, strong) NSString* AtPatientTime;  // strs(64) - 1047
@property (nonatomic, strong) NSString* TransferPatientDate;  // strs(65)  - 1058
@property (nonatomic, strong) NSString* TransferPatientTime;  // strs(66)  - 1045

@property (nonatomic, strong) NSString* PTFirstName;  // strs(34)  - 1102
@property (nonatomic, strong) NSString* PTMI;  // strs(35)  - 1118
@property (nonatomic, strong) NSString* PTLastName;  // strs(36)  1101
@property (nonatomic, strong) NSString* PTAddress;  // strs(37)   1107
@property (nonatomic, strong) NSString* PTAddress2;  // strs(38)   - 1108
@property (nonatomic, strong) NSString* PTCity;  // strs(39)  - 1109
@property (nonatomic, strong) NSString* PTState;  // strs(40)  - 1110
@property (nonatomic, strong) NSString* PTZip;  // strs(41)  1112
@property (nonatomic, strong) NSString* PTSSN;  // strs(42)   1133
@property (nonatomic, strong) NSString* PTAge;  // strs(43)   1119
@property (nonatomic, strong) NSString* PTSex;  // strs(44)  1105
@property (nonatomic, strong) NSString* PTWeight;  // strs(45)  1132
@property (nonatomic, strong) NSString* PTDOB;  // strs(46)   1103
@property (nonatomic, strong) NSString* DriverName;  // strs(47)
@property (nonatomic, strong) NSString* DriverCert;  // strs(48)
@property (nonatomic, strong) NSString* Attendant1Name;  // strs(49)
@property (nonatomic, strong) NSString* Attendant1Cert;  // strs(50)
@property (nonatomic, strong) NSString* Attendant2Name;  // strs(51)
@property (nonatomic, strong) NSString* Attnedant2Cert;  // strs(52)
@property (nonatomic, strong) NSString* ChiefComplaint;  // strs(53)   - 1008
@property (nonatomic, strong) NSString* Notes;  // strs(54)   - 1022
@property (nonatomic, strong) NSString* CallType;  // strs(55)   - 9017
@property (nonatomic, strong) NSString* BusinessName;  // strs(56)   - 9016
@property (nonatomic, strong) NSString* CrossStreet;  // strs(57)  - 1020
@property (nonatomic, strong) NSString* MapCode;  // strs(58)    1023
@property (nonatomic, strong) NSString* OdometerResponding;  // strs(59)  - 1067
@property (nonatomic, strong) NSString* OdometerAtScene;  // strs(60)   = 1060
@property (nonatomic, strong) NSString* OdometerPatientDestination;  // strs(61)   1061
@property (nonatomic, strong) NSString* OdometerClear;  // strs(62)   - 1066
@property (nonatomic, strong) NSString* PriorCalls;  // strs(67)  - 9015
@property (nonatomic, strong) NSString* LocationHazards;  // strs(68)   - 9013
@property (nonatomic, strong) NSString* Zone;  // strs(69)   - 9012
@property (nonatomic, strong) NSString* Latitude;  // strs(70)  - 9010
@property (nonatomic, strong) NSString* Longitude;  // strs(71) - 9011
@property (nonatomic, strong) NSString* Phone;  // strs(72)  - 9014
@property (nonatomic, strong) NSString* StreetNumber;  // strs(73)  - 1080
@property (nonatomic, strong) NSString* StreetPrefix;  // strs(74)  - 1081
@property (nonatomic, strong) NSString* StreetName;  // strs(75) - 1082
@property (nonatomic, strong) NSString* StreetType;  // strs(76)  - 1083
@property (nonatomic, strong) NSString* StreetSuffix;  // strs(77)  - 1084
@property (nonatomic, strong) NSString* xStreetPrefix;  // strs(78)  - 1085
@property (nonatomic, strong) NSString* xStreetName;  // strs(79)  - 1086
@property (nonatomic, strong) NSString* xStreetType;  // strs(80)  - 1087
@property (nonatomic, strong) NSString* xStreetSuffix;  // strs(81)   - 1088
@end
