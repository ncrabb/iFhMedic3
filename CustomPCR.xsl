<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    
    <xsl:template match="/">
        
        <body style="font:100% Tahoma,arial,sans-serif;color: #333">
            <div style="width:100%;margin: 0 auto;background-color: #ffffff;text-align:  center">
                
                
                <div style="width:49%; float:left; overflow: auto; text-align:left">
                    
                    <h2>Patient Care Report</h2>
                    
                    <div style="padding-left=25; font:95%">
                        
                        <b>
                            Incident Number: </b>
                        <xsl:value-of select ="PCR/ID1001"></xsl:value-of>
                        <br/>
                        <b>Date of Service: </b>
                        <xsl:value-of select ="PCR/ID1002"></xsl:value-of>
                        <br/>
                        <b>Impression: </b>
                        <xsl:value-of select ="PCR/ID1008"></xsl:value-of>
                        <xsl:if test="PCR/ID1013 != ''">
                            <br/>
                            <b> Chief Complaint: </b>
                            <xsl:value-of select ="PCR/ID1013"></xsl:value-of>
                        </xsl:if >
                        <br/>
                        <b>Unit/Crew: </b>
                        <xsl:value-of select ="PCR/CREW"></xsl:value-of>
                    </div>
                    
                </div>
                
                <div style="width:49%; float:right;  overflow:auto; text-align:right">
                    
                    <xsl:variable name ="logoimage" select ="PCR/LOGO"/>
                    <img src="{$logoimage}"></img>
                    <Br/>
                    
                </div>
                
                <br clear="all"/>
                <br/>
                
                <div style="border:ridge; font:90%">
                    <div style="width=100%; text-align:left;font-size: 120%;background: #ececec;color: black">
                        <b>Patient Information</b>
                    </div >
                    
                    <div style="text-align:left">
                        <table style="width=98%; font:85%">
                            
                            <tr>
                                <td style="font:120%">
                                    <b>
                                        Last Name:
                                        <xsl:value-of select ="PCR/ID1101"></xsl:value-of>
                                        
                                    </b>
                                </td>
                                <td style="font:120%">
                                    <b>
                                        First Name:
                                        <xsl:value-of select ="PCR/ID1102"></xsl:value-of>
                                    </b>
                                </td>
                                <td>
                                    <b>MI: </b>
                                    <xsl:value-of select ="PCR/ID1118"></xsl:value-of>
                                </td>
                                <td>
                                    <b>DOB: </b>
                                    <xsl:value-of select ="PCR/ID1103"></xsl:value-of>
                                </td>
                                <td>
                                    <b>Age: </b>
                                    <xsl:choose >
                                        
                                        <xsl:when test="PCR/ID1134 != 'Years'">
                                            <xsl:value-of select ="PCR/ID1119"></xsl:value-of>&#160;
                                            <xsl:value-of select ="PCR/ID1134"></xsl:value-of>
                                        </xsl:when >
                                        <xsl:when test="PCR/ID1134 = ''">
                                            <xsl:value-of select ="PCR/ID1119"></xsl:value-of>
                                        </xsl:when >
                                        <xsl:otherwise>
                                            <xsl:value-of select ="PCR/ID1119"></xsl:value-of>
                                        </xsl:otherwise>
                                        
                                    </xsl:choose >
                                    
                                </td>
                                
                                
                                
                            </tr>
                            
                            
                            
                            <tr>
                                
                                <td>
                                    Sex: <xsl:value-of select ="PCR/ID1105"></xsl:value-of>
                                </td>
                                <td>
                                    Race: <xsl:value-of select ="PCR/ID1104"></xsl:value-of>
                                </td>
                                <td>
                                    Phone: <xsl:value-of select ="PCR/ID1106"></xsl:value-of>
                                </td>
                                <td>
                                    SSN: <xsl:value-of select ="PCR/ID1133"></xsl:value-of>
                                </td>
                                <td>
                                    DL#: <xsl:value-of select ="PCR/ID1130"></xsl:value-of>
                                </td>
                                <td>
                                    Height: <xsl:value-of select ="PCR/ID1131"></xsl:value-of> <xsl:value-of select ="PCR/ID1950" />
                                </td>
                                
                            </tr>
                            <tr>
                                
                                <td>
                                    Address: <xsl:value-of select ="PCR/ID1107"></xsl:value-of>
                                </td>
                                <td>
                                    City: <xsl:value-of select ="PCR/ID1109 "></xsl:value-of>
                                </td>
                                <td>
                                    State: <xsl:value-of select ="PCR/ID1110"></xsl:value-of>
                                </td>
                                <td>
                                    Zip: <xsl:value-of select ="PCR/ID1112"></xsl:value-of>
                                    
                                </td>
                                <td>
                                    County: <xsl:value-of select ="PCR/ID1111"/>
                                    
                                </td>
                                <td>
                                    Weight: <xsl:value-of select ="PCR/ID1132"></xsl:value-of> <xsl:value-of select ="PCR/ID1951" />
                                </td>
                                
                            </tr>
                            
                        </table>
                        
                        <table style="width=98%; font:85%">
                            <tr>
                                <td>
                                    <b>Residency: </b>
                                    <xsl:value-of select ="PCR/ID1135"></xsl:value-of>
                                </td>
                                <td>
                                    <b>Insurance: </b>
                                    <xsl:if test="PCR/INSURANCE != ''">
                                        <xsl:value-of select ="PCR/INSURANCE"></xsl:value-of>
                                    </xsl:if>
                                    <!--
                                     <xsl:if test="PCR/ID1120 != ''">
                                     Medicare ID -
                                     <xsl:value-of select ="PCR/ID1120"></xsl:value-of>
                                     </xsl:if>
                                     <xsl:if test="PCR/ID1121 != ''">
                                     Medicaid ID -
                                     <xsl:value-of select ="PCR/ID1121"></xsl:value-of>
                                     </xsl:if>
                                     <xsl:if test="PCR/ID1122 != ''">
                                     <xsl:value-of select ="PCR/ID1122"></xsl:value-of>
                                     </xsl:if>
                                     <xsl:if test="PCR/ID1123 != ''">
                                     ID Number -
                                     <xsl:value-of select ="PCR/ID1123"></xsl:value-of>
                                     </xsl:if>
                                     <xsl:if test="PCR/ID1124 != ''">
                                     Group Number -
                                     <xsl:value-of select ="PCR/ID1124"></xsl:value-of>
                                     </xsl:if>
                                     <xsl:if test="PCR/ID1125 != ''">
                                     Insured Name -
                                     <xsl:value-of select ="PCR/ID1125"></xsl:value-of>
                                     </xsl:if>
                                     <xsl:if test="PCR/ID1126 != ''">
                                     Insured DOB -
                                     <xsl:value-of select ="PCR/ID1126"></xsl:value-of>
                                     </xsl:if>
                                     <xsl:if test="PCR/ID1127 != ''">
                                     Insured SSN -
                                     <xsl:value-of select ="PCR/ID1127"></xsl:value-of>
                                     </xsl:if>
                                     
                                     -->
                                </td>
                                
                                <xsl:if test="PCR/ID1113 != ''">
                                    <td>
                                        <b>Financial Guarantor: </b><xsl:value-of select ="PCR/ID1113"/>, <xsl:value-of select ="PCR/ID1114"/>&#160;
                                        <xsl:value-of select ="PCR/ID1116"/>&#160;<xsl:value-of select ="PCR/ID1117"/> <xsl:text> Relation: </xsl:text><xsl:value-of select ="PCR/ID1115"/>
                                    </td>
                                    
                                </xsl:if >
                            </tr>
                        </table>
                        
                        <br/>
                        
                        <b>&#x0020;Patient Medications: </b>
                        <xsl:value-of select ="PCR/ID1433"></xsl:value-of>
                        <br/>
                        
                        <b>&#x0020;Patient Allergies: </b>
                        
                        <xsl:if test="PCR/ID1224 != ''">
                            <b> Environmental - </b><xsl:value-of select ="PCR/ID1224"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1225 != ''">
                            <b> Food - </b>
                            <xsl:value-of select ="PCR/ID1225"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1226 != ''">
                            <b> Insects - </b>
                            <xsl:value-of select ="PCR/ID1226"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1227 != ''">
                            <b> Medications - </b>
                            <xsl:value-of select ="PCR/ID1227"></xsl:value-of>
                        </xsl:if>
                        
                        <xsl:if test="PCR/ID1228 != ''">
                            <br/>
                            <b>&#x0020;EMS Exposure: </b>
                            <xsl:value-of select ="PCR/ID1228"></xsl:value-of>
                            
                        </xsl:if>
                        <br/>
                        <b>&#x0020;Patient History: </b>
                        <xsl:if test="PCR/ID1601 != ''">
                            <b> Cardio - </b>
                            <xsl:value-of select ="PCR/ID1601"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1602 != ''">
                            <b> Cancer - </b>
                            <xsl:value-of select ="PCR/ID1602"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1603 != ''">
                            <b> Neuro - </b>
                            <xsl:value-of select ="PCR/ID1603"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1604 != ''">
                            <b> GI - </b>
                            <xsl:value-of select ="PCR/ID1604"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1605 != ''">
                            <b> Genitourinary - </b>
                            <xsl:value-of select ="PCR/ID1605"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1606 != ''">
                            <b> Infectious - </b>
                            <xsl:value-of select ="PCR/ID1606"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1607 != ''">
                            <b> Metabolic / Endocrine - </b>
                            <xsl:value-of select ="PCR/ID1607"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1608 != ''">
                            <b> Respiratory - </b>
                            <xsl:value-of select ="PCR/ID1608"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1609 != ''">
                            <b> Psych - </b>
                            <xsl:value-of select ="PCR/ID1609"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1610 != ''">
                            <b> Womens Health - </b>
                            <xsl:value-of select ="PCR/ID1610"></xsl:value-of>
                        </xsl:if>
                        
                        
                        <br/>
                        <b>&#x0020;Patient Symptoms: </b>
                        <xsl:if test="PCR/ID1501 != ''">
                            <b> General - </b>
                            <xsl:value-of select ="PCR/ID1501"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1502 != ''">
                            <b> Respiratory - </b>
                            <xsl:value-of select ="PCR/ID1502"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1503 != ''">
                            <b> Cardiovascular - </b>
                            <xsl:value-of select ="PCR/ID1503"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1504 != ''">
                            <b> Neurological - </b>
                            <xsl:value-of select ="PCR/ID1504"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1505 != ''">
                            <b> Head / Neck - </b>
                            <xsl:value-of select ="PCR/ID1505"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1506 != ''">
                            <b> GI - </b>
                            <xsl:value-of select ="PCR/ID1506"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1507 != ''">
                            <b> GU / GYN - </b>
                            <xsl:value-of select ="PCR/ID1507"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1508 != ''">
                            <b> Musculoskeletal - </b>
                            <xsl:value-of select ="PCR/ID1508"></xsl:value-of>
                        </xsl:if>
                        <xsl:if test="PCR/ID1509 != ''">
                            <b> Metabolic - </b>
                            <xsl:value-of select ="PCR/ID1509"></xsl:value-of>
                        </xsl:if>
                        
                        <xsl:if test="PCR/ID1010 != ''">
                            <br/>
                            <b>&#x0020;Secondary Complaint: </b>
                            <xsl:value-of select ="PCR/ID1010"></xsl:value-of>
                        </xsl:if>
                        
                        
                        
                    </div>
                    
                </div>
                <br clear="all"/>
                
                <div style="width:100%; float:left; text-align :left; border-width: 1; border: ridge; font:90%">
                    <div style="width:100%; float:left; text-align :left ; font-size: 120%;background: #ececec;color: black">
                        <b>Patient Assessment</b>
                    </div>
                    <br/>
                    
                    <xsl:choose >
                        
                        <xsl:when test="PCR/MultiAssessment = '1'">
                            <xsl:for-each select="PCR/Assessment">
                                <big>
                                    <b>Assessment: </b>
                                </big>
                                <xsl:if test="A1800 != ''">
                                    <b> Time - </b>
                                    <xsl:value-of select ="A1800"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1801 != ''">
                                    <b> Skin - </b>
                                    <xsl:value-of select ="A1801"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1802 != ''">
                                    <b> Head/Face - </b>
                                    <xsl:value-of select ="A1802"></xsl:value-of>
                                </xsl:if>
                                
                                <xsl:if test="A1803 != ''">
                                    <b> Neck - </b>
                                    <xsl:value-of select ="A1803"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1804 != ''">
                                    <b> Chest/Lungs - </b>
                                    <xsl:value-of select ="A1804"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1805 != ''">
                                    <b> Heart - </b>
                                    <xsl:value-of select ="A1805"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1806 != ''">
                                    <b> LU Abdomen - </b>
                                    <xsl:value-of select ="A1806"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1807 != ''">
                                    <b> LL Abdomen - </b>
                                    <xsl:value-of select ="A1807"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1808 != ''">
                                    <b> RU Abdomen - </b>
                                    <xsl:value-of select ="A1808"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1809 != ''">
                                    <b> RL Abdomen - </b>
                                    <xsl:value-of select ="A1809"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1810 != ''">
                                    <b> GU - </b>
                                    <xsl:value-of select ="A1810"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1811 != ''">
                                    <b> Back Cervical - </b>
                                    <xsl:value-of select ="A1811"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1812 != ''">
                                    <b> Back Thoracic - </b>
                                    <xsl:value-of select ="A1812"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1813 != ''">
                                    <b> Back Lumbar - </b>
                                    <xsl:value-of select ="A1813"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1814 != ''">
                                    <b> RU Extremities - </b>
                                    <xsl:value-of select ="A1814"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1815 != ''">
                                    <b> RL Extremities - </b>
                                    <xsl:value-of select ="A1815"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1816 != ''">
                                    <b> LU Extremities - </b>
                                    <xsl:value-of select ="A1816"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1817 != ''">
                                    <b> LL Extremities - </b>
                                    <xsl:value-of select ="A1817"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1818 != ''">
                                    <b> Left Eye - </b>
                                    <xsl:value-of select ="A1818"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1819 != ''">
                                    <b> Right Eye - </b>
                                    <xsl:value-of select ="A1819"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1820 != ''">
                                    <b> Mental Status - </b>
                                    <xsl:value-of select ="A1820"></xsl:value-of>
                                </xsl:if>
                                <xsl:if test="A1821 != ''">
                                    <b> Neuro - </b>
                                    <xsl:value-of select ="A1821"></xsl:value-of>
                                </xsl:if>
                                
                                
                                <br />
                                
                            </xsl:for-each>
                        </xsl:when>
                        
                        <xsl:otherwise >
                            
                            <big>
                                <b>Assessment: </b>
                            </big>
                            
                            <xsl:if test="PCR/ID1239 != ''">
                                <b> Airway - </b>
                                <xsl:value-of select ="PCR/ID1239"></xsl:value-of>
                            </xsl:if>
                            <xsl:if test="PCR/ID1240 != ''">
                                <b> Breathing - </b>
                                <xsl:value-of select ="PCR/ID1240"></xsl:value-of>
                            </xsl:if>
                            <xsl:if test="PCR/ID1241 != ''">
                                <b> Circulation - </b>
                                <xsl:value-of select ="PCR/ID1241"></xsl:value-of>
                            </xsl:if>
                            <xsl:if test="PCR/ID1242 != ''">
                                <b> CRT - </b>
                                <xsl:value-of select ="PCR/ID1242"></xsl:value-of>
                            </xsl:if>
                            <xsl:if test="PCR/ID1243 != ''">
                                <b> Skin - </b>
                                <xsl:value-of select ="PCR/ID1243"></xsl:value-of>
                            </xsl:if>
                            <xsl:if test="PCR/ID1244 != ''">
                                <b> Neuro AVPU - </b>
                                <xsl:value-of select ="PCR/ID1244"></xsl:value-of>
                            </xsl:if>
                            <xsl:if test="PCR/ID1245 != ''">
                                <b> Neuro Motor - </b>
                                <xsl:value-of select ="PCR/ID1245"></xsl:value-of>
                            </xsl:if>
                            <xsl:if test="PCR/ID1246 != ''">
                                <b> Neuro Sensory - </b>
                                <xsl:value-of select ="PCR/ID1246"></xsl:value-of>
                            </xsl:if>
                            <xsl:if test="PCR/ID1247 != ''">
                                <b> Neuro Speech - </b>
                                <xsl:value-of select ="PCR/ID1247"></xsl:value-of>
                            </xsl:if>
                            <xsl:if test="PCR/ID1249 != ''">
                                <b> Eyes - </b>
                                <xsl:value-of select ="PCR/ID1249"></xsl:value-of>
                            </xsl:if>
                            <br/>
                            
                        </xsl:otherwise>
                        
                    </xsl:choose>
                    
                    
                    
                    
                    <!--
                     
                     <big>
                     <b>GCS: </b>
                     </big>
                     <xsl:if test="PCR/ID1235 != ''">
                     <b> Motor - </b>
                     <xsl:value-of select ="PCR/ID1235"></xsl:value-of>
                     </xsl:if>
                     <xsl:if test="PCR/ID1236 != ''">
                     <b> Verbal - </b>
                     <xsl:value-of select ="PCR/ID1236"></xsl:value-of>
                     </xsl:if>
                     <xsl:if test="PCR/ID1237 != ''">
                     <b> Eye - </b>
                     <xsl:value-of select ="PCR/ID1237"></xsl:value-of>
                     </xsl:if>
                     <xsl:if test="PCR/GCSTotal != ''">
                     <b> Total - </b>
                     <xsl:value-of select ="PCR/GCSTotal"></xsl:value-of>
                     </xsl:if>
                     
                     <br/> -->
                    <big>
                        <b>OPQRST: </b>
                        
                    </big>
                    <b> Onset </b><xsl:value-of select ="PCR/ID1210"/>&#x0020;
                    <b> Provocation - </b>
                    <xsl:value-of select ="PCR/ID1211"/>&#x0020;
                    <b> Quality - </b>
                    <xsl:value-of select ="PCR/ID1212"/>&#x0020;
                    <b> Radiation - </b>
                    <xsl:value-of select ="PCR/ID1213"/>&#x0020;
                    <b> Time - </b>
                    <xsl:if test="PCR/ID1215 != ''">
                        <xsl:value-of select ="PCR/ID1215"></xsl:value-of>&#x0020;Days&#x0020;
                    </xsl:if>
                    <xsl:if test="PCR/ID1217 != ''">
                        <xsl:value-of select ="PCR/ID1217"></xsl:value-of>&#x0020;Hours&#x0020;
                    </xsl:if>
                    <xsl:if test="PCR/ID1218 != ''">
                        <xsl:value-of select ="PCR/ID1218"></xsl:value-of>&#x0020;Minutes&#x0020;
                    </xsl:if>
                    <xsl:if test="PCR/ID1262 != ''">
                        <b>Additional Info - </b><xsl:value-of select ="PCR/ID1262"></xsl:value-of>
                    </xsl:if>
                    
                    <br/>
                    <big>
                        <b>Injury: </b>
                        
                    </big>
                    <xsl:if test="PCR/ID1250 != ''">
                        <b> MOI - </b>
                        <xsl:value-of select ="PCR/ID1250"></xsl:value-of>
                    </xsl:if>
                    <xsl:if test="PCR/ID1219 != ''">
                        <b> Type of Activity - </b>
                        <xsl:value-of select ="PCR/ID1219"></xsl:value-of>
                    </xsl:if>
                    <xsl:if test="PCR/ID1220 != ''">
                        <b> Location - </b>
                        <xsl:value-of select ="PCR/ID1220"></xsl:value-of>
                    </xsl:if>
                    <xsl:if test="PCR/ID1221 != ''">
                        <b> Safety Equipment - </b>
                        <xsl:value-of select ="PCR/ID1221"></xsl:value-of>
                    </xsl:if>
                    <xsl:if test="PCR/ID1222 != ''">
                        <b> Incident Type - </b>
                        <xsl:value-of select ="PCR/ID1222"></xsl:value-of>
                    </xsl:if>
                    <xsl:if test="PCR/ID1223 != ''">
                        <b> Intent - </b>
                        <xsl:value-of select ="PCR/ID1223"></xsl:value-of>
                    </xsl:if>
                    
                    <xsl:if test="PCR/ID1251 != ''">
                        <b> Extrication - </b>
                        <xsl:value-of select ="PCR/ID1251"></xsl:value-of>
                    </xsl:if>
                    <xsl:if test="PCR/ID1252 != ''">
                        <b> Ejected - </b>
                        <xsl:value-of select ="PCR/ID1252"></xsl:value-of>
                    </xsl:if>
                    <xsl:if test="PCR/ID1253 != ''">
                        <b> Exposure - </b>
                        <xsl:value-of select ="PCR/ID1253"></xsl:value-of>
                    </xsl:if>
                    <xsl:if test="PCR/ID1254 != ''">
                        <b> MVC Patient Position - </b>
                        <xsl:value-of select ="PCR/ID1254"></xsl:value-of>
                    </xsl:if>
                    
                    <xsl:if test="PCR/ID8001 = '1'">
                        <br/>
                        <big>
                            <b>Cardiac Arrest: </b>
                        </big>
                        <b> Prior to EMS Arrival - </b>
                        <xsl:if test="PCR/ID8002 = '0'">No</xsl:if>
                        <xsl:if test="PCR/ID8002 = '1'">
                            Yes
                            <xsl:if test="PCR/ID8004 = '1'">
                                <b> Bystander CPR - </b>Yes
                            </xsl:if>
                            <xsl:if test="PCR/ID8004 = '0'">
                                <b> Bystander CPR - </b>No
                            </xsl:if>
                            <xsl:if test="PCR/ID8005 = '1'">
                                <b> Bystander AED - </b>Yes
                            </xsl:if>
                            <xsl:if test="PCR/ID8005 = '0'">
                                <b> Bystander AED - </b>No
                            </xsl:if>
                            <xsl:if test="PCR/ID8006 = '1'">
                                <b> Shock given by bystander - </b>Yes
                            </xsl:if>
                            <xsl:if test="PCR/ID8006 = '0'">
                                <b> Shock given by bystander - </b>No
                            </xsl:if>
                        </xsl:if>
                        <b> Return of Pulse - </b>
                        <xsl:if test="PCR/ID8007 = '0'">No</xsl:if>
                        <xsl:if test="PCR/ID8007 = '1'">Yes</xsl:if>
                        <xsl:if test="PCR/ID8008 != ''">
                            <b> Engine Number on Scene - </b>
                            <xsl:value-of select ="PCR/ID8008"/>
                        </xsl:if>
                        <b> Engine Crew Started CPR - </b>
                        <xsl:if test="PCR/ID8009 = '0'">No</xsl:if>
                        <xsl:if test="PCR/ID8009 = '1'">
                            Yes
                            <xsl:if test="PCR/ID8010 != ''">
                                <b> ALS medic CPR count - </b>
                                <xsl:value-of select ="PCR/ID8010"/>
                            </xsl:if>
                            <xsl:if test="PCR/ID8011 != ''">
                                <b> BLS medic CPR count - </b>
                                <xsl:value-of select ="PCR/ID8011"/>
                            </xsl:if>
                        </xsl:if>
                        <b> LP12 file attached - </b>
                        <xsl:if test="PCR/ID8016 = '1'">Yes</xsl:if>
                        <xsl:if test="PCR/ID8016 = '0'">
                            No
                            <xsl:if test="PCR/ID8017 != ''">
                                <b> Reason not attached - </b>
                                <xsl:value-of select ="PCR/ID8017"/>
                            </xsl:if>
                        </xsl:if>
                        
                        
                    </xsl:if>
                    
                    
                </div >
                <!--
                 <br/>
                 <br/>-->
                <div style="width:100%; border-width: 1; border: ridge; font:90%">
                    <div style="width:100%; float:left; text-align :left ; font-size: 120%;background: #ececec;color: black">
                        <b>Vitals</b>
                    </div>
                    <br/>
                    <table style="font:75%; width=100%">
                        <tr>
                            <td>Time</td>
                            <td>HR</td>
                            <td>RR</td>
                            <td>BPSys</td>
                            <td>BPDia</td>
                            <td>SPO2</td>
                            <td>ETCO2</td>
                            <td>Blood Glucose</td>
                            <td>Temp</td>
                            <td>Position</td>
                            <td>EKG</td>
                            <td>GCS</td>
                            <td>RTS</td>
                            <td>Pain</td>
                            <td>SPCO</td>
                            <td>SPMET</td>
                            <td>DoneBy</td>
                            
                        </tr>
                        
                        
                        <xsl:for-each select="PCR/Vital">
                            <xsl:sort select="
                            concat(
                            substring(Time,1,2),
                            substring(Time,4,2),
                            substring(Time,7,2)
                            )"
                            order="ascending" data-type="number"/>
                            
                            <tr>
                                <td>
                                    <xsl:value-of select="Time"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="HR"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="RR"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="SYSBP"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="DIABP"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="SPO2"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="ETCO2"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="Glucose"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="Temp"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="Position"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="EKG"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="GCS"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="RTS"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="Pain"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="SPCO"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="SPMET"></xsl:value-of>
                                </td>
                                <td>
                                    <xsl:value-of select="DoneBy"></xsl:value-of>
                                </td>
                                
                            </tr>
                            
                        </xsl:for-each >
                    </table>
                    
                </div>
                
                <div style="width:100%; overflow: auto; border-width: 1; border: ridge; font:90%">
                    <div style="width:100%; float:left; text-align :left ; font-size: 120%;background: #ececec;color: black">
                        <b>Treatments</b>
                        
                        
                    </div>
                    <br/>
                    
                    <div>
                        
                        <table style="font:75%; width=100%">
                            <tr>
                                <td width="10%">Time</td>
                                <td width="20%">Treatment</td>
                                <td width="70%">Details</td>
                                
                            </tr>
                            <xsl:for-each select="PCR/Treatment">
                                <xsl:sort select="
                                concat(
                                substring(Time,1,2),
                                substring(Time,4,2),
                                substring(Time,7,2)
                                )"
                                order="ascending" data-type="number"/>
                                
                                
                                
                                <tr>
                                    <td width="10%">
                                        <xsl:value-of select="Time"></xsl:value-of>
                                    </td>
                                    <td width="20%">
                                        <xsl:value-of select="Type"></xsl:value-of>
                                    </td>
                                    <td width="70%">
                                        <xsl:value-of select="Description"></xsl:value-of>
                                    </td>
                                    
                                </tr>
                            </xsl:for-each >
                            
                        </table >
                    </div>
                    
                </div>
                
                <div style="width:100%; overflow: auto; border-width: 1; border: ridge; font:90%">
                    <div style="width:100%; float:left; text-align :left ; font-size: 120%;background: #ececec;color: black">
                        <b>Protocols</b>
                    </div>
                    <br/>
                    <div style="font:75%">
                        <table style="font:85%; width=100%">
                            <tr>
                                <td>Time</td>
                                <td>Protocol</td>
                            </tr>
                            
                            <xsl:for-each select="PCR/Protocol">
                                <tr>
                                    <td>
                                        <xsl:value-of select="Time"></xsl:value-of>
                                    </td>
                                    <td>
                                        <xsl:value-of select="Type"></xsl:value-of>
                                    </td>
                                </tr>
                            </xsl:for-each >
                            
                        </table>
                    </div>
                    
                </div>
                
                
                <xsl:if test="PCR/SuppliesUsed = 'Yes'">
                    
                    <div style="width:100%; border-width: 1; border: ridge; font:90%" >
                        <div style="float:right; width=100%; text-align :left ; font-size: 120%;background: #ececec;color: black">
                            <b>Supplies Used</b>
                        </div>
                        <br/>
                        <div style="font:75%">
                            <table style="font:85%; width=100%">
                                <tr>
                                    <td>Supply Used</td>
                                    <td>Qty</td>
                                </tr>
                                
                                <xsl:for-each select="PCR/Supply">
                                    <tr>
                                        <td>
                                            <xsl:value-of select="Desc"></xsl:value-of>
                                        </td>
                                        <td>
                                            <xsl:value-of select="Qty"></xsl:value-of>
                                        </td>
                                    </tr>
                                </xsl:for-each >
                                
                            </table>
                        </div>
                        
                    </div>
                    
                </xsl:if>
                
                <!--         <br/>-->
                <div style="border:ridge; font:90%; text-align:left">
                    <div style="width=100%; text-align :left ; font-size: 120%;background: #ececec;color: black">
                        <b>Comments</b>
                    </div >
                    
                    <b>Narrative: </b >
                    <xsl:value-of select ="PCR/ID1430"></xsl:value-of>
                    <br/>
                    
                    <!--
                     <b>Assessment Comments: </b>
                     <xsl:value-of select ="PCR/ID1431"></xsl:value-of>
                     <br/> -->
                    
                </div >
                <!--
                 <br clear="all"/>
                 -->
                
                <div style="border:ridge; font:90%; text-align:left">
                    <div style="width=100%; text-align :left ; font-size: 120%;background: #ececec;color: black">
                        <b>Incident Information</b>
                    </div >
                    
                    <table style="width=98%; font:85%">
                        <tr>
                            <td>
                                <big>
                                    <b>Location: </b >
                                </big>
                                
                                <xsl:value-of select ="PCR/ID1003" />,&#160;
                                <xsl:value-of select ="PCR/ID1004" />&#160;
                                <xsl:value-of select ="PCR/ID1005" />&#160;
                                <xsl:value-of select ="PCR/ID1006" />&#160;
                                <xsl:if test="PCR/ID1023 != ''">
                                    Map page: <xsl:value-of select ="PCR/ID1023" />
                                </xsl:if >
                            </td>
                            <td>
                                <b>Type: </b>
                                <xsl:value-of select ="PCR/ID1007" />
                            </td>
                            <xsl:if test="PCR/ID1070 != ''">
                                <td>
                                    <b>Dispatch Complaint: </b>
                                    <xsl:value-of select ="PCR/ID1070" />
                                </td>
                            </xsl:if >
                        </tr>
                        
                        <xsl:if test="PCR/UnitsOnScene = '1'">
                            <tr>
                                <big>
                                    <b>Other Units On Scene: </b>
                                </big>
                                <xsl:for-each select="PCR/UnitOnScene">
                                    
                                    <b> Unit
                                        <xsl:value-of select ="A1750"></xsl:value-of>
                                    </b>
                                    <xsl:value-of select ="A1751"></xsl:value-of> &#160;
                                    <xsl:value-of select ="A1752"></xsl:value-of> &#160;
                                    <xsl:value-of select ="A1753"></xsl:value-of> &#160;
                                    
                                </xsl:for-each >
                            </tr>
                        </xsl:if >
                        <xsl:if test="PCR/ID1429 != ''">
                            <tr>
                                
                                <b>Diverted: </b>
                                
                                <b>From </b> <xsl:value-of select ="PCR/ID1427"></xsl:value-of> &#160;
                                <b>Time </b> <xsl:value-of select ="PCR/ID1428"></xsl:value-of> &#160;
                                <b>Reason </b> <xsl:value-of select ="PCR/ID1429"></xsl:value-of> &#160;
                                
                            </tr>
                        </xsl:if >
                        
                    </table>
                    <br/>
                    <xsl:choose>
                        
                        <xsl:when test="PCR/ID1401 = 'Patient Transported' or PCR/ID1401 = 'Non Emergency Transfer'">
                            <big>
                                <b>Outcome: <xsl:value-of select ="PCR/ID1401" /></b>
                            </big>
                            <xsl:if test="PCR/ID1009 != ''">
                                <big>
                                    &#160;&#160;<xsl:value-of select ="PCR/ID1009"></xsl:value-of>
                                </big>
                                
                                
                            </xsl:if>
                            <br/>
                            <b>Destination: </b>
                            <xsl:if test="PCR/ID1701 != ''">
                                <xsl:value-of select ="PCR/ID1701"></xsl:value-of>,&#160;
                            </xsl:if>
                            <xsl:if test="PCR/ID1702 != ''">
                                <xsl:value-of select ="PCR/ID1702"></xsl:value-of>,&#160;
                            </xsl:if>
                            <xsl:if test="PCR/ID1703 != ''">
                                <xsl:value-of select ="PCR/ID1703"></xsl:value-of>&#160;
                            </xsl:if>
                            <xsl:if test="PCR/ID1705 != ''">
                                <xsl:value-of select ="PCR/ID1705"></xsl:value-of>,&#160;
                            </xsl:if>
                            <xsl:if test="PCR/ID1706 != ''">
                                <xsl:value-of select ="PCR/ID1706"></xsl:value-of>,&#160;
                            </xsl:if>
                            <xsl:if test="PCR/ID1704 != ''">
                                <xsl:value-of select ="PCR/ID1704"></xsl:value-of>&#160;
                            </xsl:if>
                            <xsl:if test="PCR/ID1707 != ''">
                                , <xsl:value-of select ="PCR/ID1707"></xsl:value-of>
                            </xsl:if>
                            <br />
                            
                            <xsl:if test="PCR/ID1403 != ''">
                                <b>Location Choice - </b>
                                <xsl:value-of select ="PCR/ID1403"></xsl:value-of>&#160;
                            </xsl:if>
                            <xsl:if test="PCR/ID1029 != ''">
                                <b>Priority to Destination - </b>
                                <xsl:value-of select ="PCR/ID1029"></xsl:value-of>&#160;
                            </xsl:if>
                            <xsl:if test="PCR/ID1031 != ''">
                                <b>Code to Destination - </b>
                                <xsl:value-of select ="PCR/ID1031"></xsl:value-of>&#160;
                            </xsl:if>
                            <xsl:if test="PCR/ID1424 != ''">
                                <b>Air EMS Contacted - </b>
                                <xsl:value-of select ="PCR/ID1424"></xsl:value-of>&#160;
                            </xsl:if>
                            <xsl:if test="PCR/ID1425 != ''">
                                <b>Air EMS Arrival - </b>
                                <xsl:value-of select ="PCR/ID1425"></xsl:value-of>&#160;
                            </xsl:if>
                            <xsl:if test="PCR/ID1426 != ''">
                                <b>Air EMS Depart - </b>
                                <xsl:value-of select ="PCR/ID1426"></xsl:value-of>&#160;
                            </xsl:if>
                            <xsl:if test="PCR/ID1434 != ''">
                                <b>Air EMS Company - </b>
                                <xsl:value-of select ="PCR/ID1434"></xsl:value-of>&#160;
                            </xsl:if>
                            
                            <xsl:if test="PCR/ID1420 != ''">
                                <b>Personal Items - </b>
                                <xsl:value-of select ="PCR/ID1420"></xsl:value-of>
                            </xsl:if>
                            <xsl:if test="PCR/ID1421 != ''">
                                <b> Items Given To - </b>
                                <xsl:value-of select ="PCR/ID1421"></xsl:value-of>
                            </xsl:if>
                            <xsl:if test="PCR/ID1422 != ''">
                                <b> Escorted By - </b>
                                <xsl:value-of select ="PCR/ID1422"></xsl:value-of>
                            </xsl:if>
                            
                            <xsl:if test="PCR/Mileage != ''">
                                <br/>
                                <big>
                                    Mileage -
                                    <xsl:value-of select ="PCR/Mileage"></xsl:value-of>
                                </big>
                            </xsl:if>
                            
                            
                        </xsl:when>
                        <!--
                         <xsl:when test="PCR/ID1401 = 'Patient Transported'">
                         <big>
                         <b>Outcome: Patient Transported</b>
                         </big>
                         <br/>
                         <b>Destination: </b>
                         <xsl:value-of select ="PCR/ID1402" />
                         </xsl:when>
                         -->
                        <xsl:otherwise >
                            <big>
                                <b>
                                    Outcome: <xsl:value-of select ="PCR/ID1401" />
                                </b>
                            </big>
                            
                        </xsl:otherwise>
                        
                    </xsl:choose >
                    
                    
                    
                </div >
                
                
                
                
                <div style="border:ridge; font:90%; text-align:left">
                    
                    <div style="width=100%; text-align :left ; font-size: 120%;background: #ececec;color: black">
                        <b>Call Times</b>
                    </div>
                    <table style="width=98%; font:85%; text-align:center">
                        <tr>
                            <td>
                                <b>Dispatched</b>
                            </td>
                            <td>
                                <b>EnRoute</b>
                            </td>
                            <td>
                                <b>At Scene</b>
                            </td>
                            <td>
                                <b>At Patient</b>
                            </td>
                            <td>
                                <b>Depart Scene</b>
                            </td>
                            <td>
                                <b>Destination</b>
                            </td>
                            <td>
                                <b>Transfer Care</b>
                            </td>
                            <td>
                                <b>Unit Clear</b>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <xsl:value-of select ="PCR/ID1040" />
                            </td>
                            <td>
                                <xsl:value-of select ="PCR/ID1041" />
                            </td>
                            <td>
                                <xsl:value-of select ="PCR/ID1042" />
                            </td>
                            <td>
                                <xsl:value-of select ="PCR/ID1047" />
                            </td>
                            <td>
                                <xsl:value-of select ="PCR/ID1043" />
                            </td>
                            <td>
                                <xsl:value-of select ="PCR/ID1044" />
                            </td>
                            <td>
                                <xsl:value-of select ="PCR/ID1045" />
                            </td>
                            <td>
                                <xsl:value-of select ="PCR/ID1046" />
                            </td>
                        </tr>
                    </table>
                    
                </div>
                
                <!--<br clear="all"/>-->
                
                
                <div style="border:ridge; font:90%; text-align:left">
                    <div style="width=100%; text-align :left ; font-size: 120%;background: #ececec;color: black">
                        <b>Signatures</b>
                    </div >
                    <br />
                    
                    <div style="font:75%">
                        <table style="font:85%; width=95%">
                            
                            <xsl:for-each select="PCR/Signature">
                                
                                <xsl:variable name ="imagename">
                                    <xsl:value-of select="File"></xsl:value-of>
                                </xsl:variable >
                                
                                
                                <tr>
                                    
                                    <td>
                                        <xsl:value-of select="Name"></xsl:value-of>
                                        <xsl:if test="SigName != ''">
                                            - <xsl:value-of select ="SigName"></xsl:value-of>
                                        </xsl:if>
                                    </td>
                                    <td>
                                        <img  src="{$imagename}" height="60" width="250"></img>
                                    </td>
                                    <td>
                                        <xsl:value-of select="Disclaimer"></xsl:value-of>
                                    </td>
                                </tr>
                                
                            </xsl:for-each >
                            
                        </table>
                    </div>
                    
                    
                    
                    
                </div >
                
                
            </div >
            
            <br clear="all"/>
            
            
            <xsl:if test="PCR/Addendum != ''">
                <div style="width:100%; overflow: auto; border-width: 1; border: ridge; font:90%">
                    <div style="width:100%; float:left; text-align :left ; font-size: 120%;background: #ececec;color: black">
                        
                        <b>Amendments</b>
                    </div>	
                    <br/>
                    <div style="font:75%">
                        <table style="font:85%; width=100%">
                            <tr>
                                <td>Time</td>
                                <td>Change Made</td>
                                <td>Modified By</td>
                            </tr>
                            
                            <xsl:for-each select="PCR/TicketChange">
                                <tr>
                                    <td>
                                        <xsl:value-of select="ChangeTime"></xsl:value-of>
                                    </td>
                                    <td>
                                        <xsl:value-of select="ChangeMade"></xsl:value-of>
                                    </td>
                                    <td>
                                        <xsl:value-of select="ModifiedBy"></xsl:value-of>
                                    </td>
                                </tr>
                            </xsl:for-each >
                            
                        </table>
                    </div>
                    
                </div>
            </xsl:if>
            
            <br clear="all"/>    
            
            <div style="width=100%; text-align :left ; font-size: 90%;color: black">
                <div style="float:LEFT" >
                    Provider Info: <xsl:value-of select ="PCR/PROVIDERINFO" />
                </div>
            </div>
            
            
            <HR></HR>
            <div style="width=100%; text-align :left ; font-size: 80%;color: black">
                <div style="float:left" >FH Medic - All rights reserved 2013</div>
                <div style="float:right" >
                    PCR Status: <b>
                        <xsl:value-of select ="PCR/STATUS" />
                    </b>
                    Date/Time Created: <b>
                        <xsl:value-of select ="PCR/TIMECREATED" />
                    </b>
                </div>
            </div>
            
            
            
            
        </body>
    </xsl:template>
    
</xsl:stylesheet>

