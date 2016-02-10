<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    
    <xsl:template match="/">
        
        
			
			<div style="width:100%; float:left; overflow: auto; text-align:left">
					<div style="padding-left=25; font:95%">

						On <xsl:value-of select ="PCR/ID1002"></xsl:value-of> EMS Unit <xsl:value-of select ="PCR/UNIT"></xsl:value-of>
						responded to a call with a chief complaint of <xsl:value-of select ="PCR/ID1008" />.
						
						<xsl:choose>
						<xsl:when test="PCR/ID1119 != ''">
							<xsl:choose>
								<xsl:when test="PCR/ID1105 != ''">
									Patient was a <xsl:value-of select ="PCR/ID1119"/>
									year old <xsl:value-of select ="PCR/ID1105" />. 
								</xsl:when>
								<xsl:otherwise>
									Patient was <xsl:value-of select ="PCR/ID1119"/> years old. 
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						</xsl:choose>
						<!--Medications: -->
						<xsl:choose>
							<xsl:when test="PCR/ID1227 = 'NKDA'">
								Patient has no known drug allergies (NKDA).
							</xsl:when>
							<xsl:when test="PCR/ID1227 != ''">
								Allergies to the following medications were noted:
								<xsl:value-of select ="PCR/ID1227"/>.
							</xsl:when>
							<xsl:otherwise> Patient has no known drug allergies.</xsl:otherwise>
						</xsl:choose>

						<xsl:variable name = "alg_cnt" select = "count(PCR/ID1224 | PCR/ID1225 | PCR/ID1226 | PCR/ID1228 )" />
						<xsl:if test="$alg_cnt > 0">

							<!--Environment: -->
							<xsl:choose>
								<xsl:when test="PCR/ID1224 != ''">
									Environmental allergies included 
									<xsl:value-of select ="PCR/ID1224"/>. 
								</xsl:when>
							</xsl:choose>
							<!--Food: -->
							<xsl:choose>
								<xsl:when test="PCR/ID1225 != ''">
									Food allergies included 
									<xsl:value-of select ="PCR/ID1225"/>. 
								</xsl:when>
							</xsl:choose>
							<!--Insects: -->
							<xsl:choose>
								<xsl:when test="PCR/ID1226 != ''">
									Insect allergies included 
									<xsl:value-of select ="PCR/ID1226"/>. 
								</xsl:when>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="PCR/ID1228 != ''">
									<!--Alerts: -->
									<xsl:value-of select ="PCR/ID1228"/>. 
								</xsl:when>
							</xsl:choose>
						</xsl:if>
						
						<p/>
						<!-- Medical History-->
						<xsl:variable name = "hist_cnt" select = "count(PCR/ID1433 | PCR/ID1601 | PCR/ID1602 | PCR/ID1603 | PCR/ID1604 | PCR/ID1605 | PCR/ID1606 | PCR/ID1607 | PCR/ID1608 | PCR/ID1609 | PCR/ID1610 )" />

						<xsl:if test="$hist_cnt > 0">
						The following medical history was obtained by EMT personnel.
						<xsl:choose>
							<!--Medications -->							
							<xsl:when test="PCR/ID1433 != ''">
								Current medications being taken include: 
								<xsl:value-of select ="PCR/ID1433"/>. 
							</xsl:when>
						</xsl:choose>

						<xsl:choose>
							<!--Cardiovascular -->
							<xsl:when test="PCR/ID1601 != ''">
								Cardiovascular history includes 
								<xsl:value-of select ="PCR/ID1601"/>. 
							</xsl:when>
						</xsl:choose>

						<xsl:choose>
							<!--Cancer -->
							<xsl:when test="PCR/ID1602 != ''">
								Patient has a history of cancer, including 
								<xsl:value-of select ="PCR/ID1602"/>. 
							</xsl:when>
						</xsl:choose>
						
						<xsl:choose>
							<!--Neurological -->
							<xsl:when test="PCR/ID1603 != ''">
								Neurological history includes 
								<xsl:value-of select ="PCR/ID1603"/>. 
							</xsl:when>
						</xsl:choose>

						<xsl:choose>
							<!--Gastrointestinal -->
							<xsl:when test="PCR/ID1604 != ''">
								Patient reports a gastrointestinal history of 
								<xsl:value-of select ="PCR/ID1604"/>. 
							</xsl:when>
						</xsl:choose>
						
						<xsl:choose>
							<!--Genitourinary -->
							<xsl:when test="PCR/ID1605 != ''">
								Genitourinary history includes 
								<xsl:value-of select ="PCR/ID1605"/>. 
							</xsl:when>
						</xsl:choose>

						<xsl:choose>
							<!--Infectious -->
							<xsl:when test="PCR/ID1606 != ''">
								Patient reports an infectious history of
								<xsl:value-of select ="PCR/ID1606"/>. 
							</xsl:when>
						</xsl:choose>
							
						<xsl:choose>
							<!--Metabolic / Endocrine-->
							<xsl:when test="PCR/ID1607 != ''">
								Metabolic - endocrine history includes 
								<xsl:value-of select ="PCR/ID1607"/>. 
							</xsl:when>
						</xsl:choose>

						<xsl:choose>
							<!--Respiratory -->
							<xsl:when test="PCR/ID1608 != ''">
								Patient reports a respiratory history of 
								<xsl:value-of select ="PCR/ID1608"/>. 
							</xsl:when>
						</xsl:choose>
							
						<xsl:choose>
							<!--Psychological-->
							<xsl:when test="PCR/ID1609 != ''">
								Psychological history includes 
								<xsl:value-of select ="PCR/ID1609"/>. 
							</xsl:when>
						</xsl:choose>

						<xsl:choose>
							<!--Womens Health-->
							<xsl:when test="PCR/ID1610	 != ''">
								Patient reports the following women's heath issues: 
								<xsl:value-of select ="PCR/ID1610	"/>. 
							</xsl:when>
						</xsl:choose>

						<p/>
						</xsl:if>
						Patient was assessed with the following responses noted.
						<xsl:choose>
							<xsl:when test="PCR/ID1235 != ''">
								Motor Response was <xsl:value-of select ="PCR/ID1235" />.
							</xsl:when>
						</xsl:choose>

						<!-- Verbal and Eye assessment -->
						<xsl:choose>
							<xsl:when test="PCR/ID1236 != ''">
								<xsl:choose>
									<xsl:when test="PCR/ID1237 != ''">
										Verbal Response was rated at a <xsl:value-of select ="PCR/ID1236" />, and 
										eye response was <xsl:value-of select ="PCR/ID1237" />.
									</xsl:when>
									<xsl:otherwise>
										Verbal Response was rated at a <xsl:value-of select ="PCR/ID1236" />.
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="PCR/ID1237 != ''">
										Eye Response was <xsl:value-of select ="PCR/ID1237" />.
									</xsl:when>
								</xsl:choose>								
							</xsl:otherwise>
						</xsl:choose>

						<!-- Airway and Breathing -->
						<xsl:choose>
							<xsl:when test="PCR/ID1239 != ''">
								<xsl:choose>
									<xsl:when test="PCR/ID1240 != ''">
										Airway was <xsl:value-of select ="PCR/ID1239" />, and
										breathing was <xsl:value-of select ="PCR/ID1240" />.
									</xsl:when>
									<xsl:otherwise>
										Airway was <xsl:value-of select ="PCR/ID1239" />.
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="PCR/ID1240 != ''">
										Breathing was <xsl:value-of select ="PCR/ID1240" />.
									</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>

						<!-- CRT and Skin -->
						<xsl:choose>
							<xsl:when test="PCR/ID1242 != ''">
								<xsl:choose>
									<xsl:when test="PCR/ID1243 != ''">
										CRT (Capillary Refill Time) was <xsl:value-of select ="PCR/ID1242" />, 
										and skin was <xsl:value-of select ="PCR/ID1243" />.
									</xsl:when>
									<xsl:otherwise>
										CRT (Capillary Refill Time) was <xsl:value-of select ="PCR/ID1242" />.
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="PCR/ID1243 != ''">
										Skin was <xsl:value-of select ="PCR/ID1243" />.
									</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>

						<!-- AVPU Orientation-->
						<xsl:choose>
							<xsl:when test="PCR/ID1244 != ''">
								AVPU was <xsl:value-of select ="PCR/ID1244" />.
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="PCR/ID1272 != ''">
								Orientation was <xsl:value-of select ="PCR/ID1272" />.
							</xsl:when>
						</xsl:choose>
						
						<!-- Head / Face -->
						<xsl:choose>
							<xsl:when test="PCR/ID1283 != ''">
								Head/Face was <xsl:value-of select ="PCR/ID1283" />.
							</xsl:when>
						</xsl:choose>
						<!-- Neck -->
						<xsl:choose>
							<xsl:when test="PCR/ID1284 != ''">
								Neck was <xsl:value-of select ="PCR/ID1284" />.
							</xsl:when>
						</xsl:choose>
						<!-- Lungs -->
						<xsl:choose>
							<xsl:when test="PCR/ID1285 != ''">
								Lungs were <xsl:value-of select ="PCR/ID1285" />.
							</xsl:when>
						</xsl:choose>
						<!-- Chest -->
						<xsl:choose>
							<xsl:when test="PCR/ID1286 != ''">
								Chest was <xsl:value-of select ="PCR/ID1286" />.
							</xsl:when>
						</xsl:choose>
						<!-- ABD -->
						<xsl:choose>
							<xsl:when test="PCR/ID1287 != ''">
								ABD was <xsl:value-of select ="PCR/ID1287" />.
							</xsl:when>
						</xsl:choose>
						<!-- Pevlis -->
						<xsl:choose>
							<xsl:when test="PCR/ID1288 != ''">
								Pelvis was <xsl:value-of select ="PCR/ID1288" />.
							</xsl:when>
						</xsl:choose>
						<!-- Pevlis -->
						<xsl:choose>
							<xsl:when test="PCR/ID1288 != ''">
								Pelvis was <xsl:value-of select ="PCR/ID1288" />.
							</xsl:when>
						</xsl:choose>
						<!-- EXT -->
						<xsl:choose>
							<xsl:when test="PCR/ID1270 != ''">
								Ext was <xsl:value-of select ="PCR/ID1270" />.
							</xsl:when>
						</xsl:choose>
						<!-- Back -->
						<xsl:choose>
							<xsl:when test="PCR/ID1271 != ''">
								Back was <xsl:value-of select ="PCR/ID1271" />.
							</xsl:when>
						</xsl:choose>
						<!-- Psychosocial -->
						<xsl:choose>
							<xsl:when test="PCR/ID1273 != ''">
								Psychosocial was <xsl:value-of select ="PCR/ID1273" />.
							</xsl:when>
						</xsl:choose>
						<!-- Stress -->
						<xsl:choose>
							<xsl:when test="PCR/ID1280 != ''">
								Stress level was <xsl:value-of select ="PCR/ID1280" />.
							</xsl:when>
						</xsl:choose>
						<!-- Anxiety -->
						<xsl:choose>
							<xsl:when test="PCR/ID1281 != ''">
								Anxiety level was <xsl:value-of select ="PCR/ID1281" />.
							</xsl:when>
						</xsl:choose>
						<!-- Cooperativeness-->
						<xsl:choose>
							<xsl:when test="PCR/ID1282 != ''">
								Cooperativeness	level was <xsl:value-of select ="PCR/ID1282" />.
							</xsl:when>
						</xsl:choose>
						

						<!-- Motor and Sensory-->
						<xsl:choose>
							<xsl:when test="PCR/ID1245 != ''">
								<xsl:choose>
									<xsl:when test="PCR/ID1246 != ''">
										Motor rated at <xsl:value-of select ="PCR/ID1245" />, and
										sensory was <xsl:value-of select ="PCR/ID1246" />.
									</xsl:when>
									<xsl:otherwise>
										Motor rated at <xsl:value-of select ="PCR/ID1245" />.
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="PCR/ID1246 != ''">
										Sensory was <xsl:value-of select ="PCR/ID1246" />.
									</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>

						<!-- Speech and Eyes-->
						<xsl:choose>
							<xsl:when test="PCR/ID1247 != ''">
								<xsl:choose>
									<xsl:when test="PCR/ID1249 != ''">
										Speech was <xsl:value-of select ="PCR/ID1247" />, and
										eyes were <xsl:value-of select ="PCR/ID1249" />.
									</xsl:when>
									<xsl:otherwise>
										Speech was <xsl:value-of select ="PCR/ID1247" />.
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="PCR/ID1249 != ''">
										Eyes were <xsl:value-of select ="PCR/ID1249" />.
									</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
						
						<xsl:choose>
							<xsl:when test="PCR/ID1240 != ''">
								Overall, general assessment: <xsl:value-of select ="PCR/ID1240" />.
							</xsl:when>
						</xsl:choose>
						<p></p>

						<xsl:variable name = "vit_cnt" select = "count(PCR/Vital )" />
						<xsl:if test="$vit_cnt > 1">
							<xsl:value-of select = "count(PCR/Vital)" /> sets of vitals were taken for this incident.
						</xsl:if>
						<xsl:if test="$vit_cnt = 1">
							<xsl:value-of select = "count(PCR/Vital)" /> set of vitals were taken for this incident.
						</xsl:if>						
						
						<xsl:for-each select="PCR/Vital">
							Vital number <xsl:value-of select="INST" /> was taken
							<xsl:value-of select="Position" /> at <xsl:value-of select ="Time" />
							by <xsl:value-of select="DoneBy" />.  Results were as follows. 
							
							<xsl:choose>
								<xsl:when test="HR != ''">
									Heart rate was <xsl:value-of select="HR" />. 
								</xsl:when>
							</xsl:choose>
							
							<xsl:choose>
								<xsl:when test="RR != ''">
									Respiratory rate was <xsl:value-of select="RR" />. 
								</xsl:when>
							</xsl:choose>
							
							<xsl:choose>
								<xsl:when test="SYSBP != ''">
									<xsl:choose>
										<xsl:when test="DIABP != ''">
											Sys BP was <xsl:value-of select="SYSBP" />, and
											Diast BP was <xsl:value-of select ="DIABP" />.
										</xsl:when>
										<xsl:otherwise>
											Sys BP was <xsl:value-of select="SYSBP" />.
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="DIABP != ''">
											Diast BP was <xsl:value-of select ="DIABP" />.
										</xsl:when>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:choose>
								<xsl:when test="SPO2 != ''">
									<xsl:choose>
										<xsl:when test="Glucose != ''">
											SPO2 showed levels of <xsl:value-of select="SPO2" />, and 
											glucose levels were at <xsl:value-of select ="Glucose" />.
										</xsl:when>
										<xsl:otherwise>
											SPO2 showed levels of <xsl:value-of select="SPO2" />.
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="Glucose != ''">
											Glucose levels were <xsl:value-of select="Glucose" />
										</xsl:when>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
							
							<xsl:choose>
								<xsl:when test="Temp != ''">
									Patient's temperature was taken and showed <xsl:value-of select="Temp" />.
								</xsl:when>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="EKG != ''">
									EKG showed <xsl:value-of select="EKG" />.
								</xsl:when>
							</xsl:choose>
						</xsl:for-each >

						<p></p>

						<xsl:variable name = "tr_cnt" select = "count(PCR/Treatment )" />
						<xsl:if test="$tr_cnt > 1">
							The following <xsl:value-of select = "count(PCR/Treatment)" />  treatments were performed on the patient.
						</xsl:if>
						<xsl:if test="$tr_cnt = 1">
							The following <xsl:value-of select = "count(PCR/Treatment)" />  treatment was performed on the patient.
						</xsl:if>
						
						<xsl:if test="count(PCR/Treatment) > 0">
						<xsl:for-each select="PCR/Treatment">
							<xsl:choose>
								<!-- 2001 Clear Airway -->
								<xsl:when test="ID = '2001'">Airway was cleared at </xsl:when>
								<!-- 2002 Suction -->
								<xsl:when test="ID = '2002'">Suction was administered at </xsl:when>
								<!-- 2003 Air Adjunct-->
								<xsl:when test="ID = '2003'">Air adjunct was administered at </xsl:when>
								<!-- 2004 O2-->								
								<xsl:when test="ID = '2004'">O2 was given at </xsl:when>
								<!-- 2005	Manual Vent -->
								<xsl:when test="ID = '2005'">Manual vent was administered at </xsl:when>
								<!-- 2006 Intubation-->
								<xsl:when test="ID = '2006'">Patient was intubated at </xsl:when>
								<!--2007	Extubation -->
								<xsl:when test="ID = '2007'">Patient was extubated at </xsl:when>
								<!-- 2008 Chrico -->
								<xsl:when test="ID = '2008'">Chirco was administered at </xsl:when>
								<!-- 2009	Chest Decompression -->								
								<xsl:when test="ID = '2009'">Chest decompression was performed at </xsl:when>
								<!-- 2010	IV -->
								<xsl:when test="ID = '2010'">IV was started at </xsl:when>
								<!-- 2011	Drug -->								
								<xsl:when test="ID = '2011'">EMT administered drug at </xsl:when>
								<!--2012	Defib / Pacing -->								
								<xsl:when test="ID = '2012'">Defib-Pacing was performed at </xsl:when>
								<!-- 2013	Vagal Maneuver -->
								<xsl:when test="ID = '2013'">Vagal maneuver was attempted at </xsl:when>
								<!-- 2014	Start CPR -->								
								<xsl:when test="ID = '2014'">CPR was started at </xsl:when>
								<!--2015	Stop CPR -->								
								<xsl:when test="ID = '2015'">CPR was stopped at </xsl:when>
								<!-- 2016	Position -->
								<xsl:when test="ID = '2016'">Position was changed at </xsl:when>
								<!-- Spinal Immobilization -->								
								<xsl:when test="ID = '2017'">Spinal immobilization was performed at </xsl:when>
								<!-- 2018	Splint -->								
								<xsl:when test="ID = '2018'">Splint was placed at </xsl:when>
								<!-- 2019	Restraints -->								
								<xsl:when test="ID = '2019'">Restraints were placed at </xsl:when>
								<!-- 2020 Bandage -->								
								<xsl:when test="ID = '2020'">Bandage was placed at </xsl:when>
								<!-- 2021	Eye Flush -->
								<xsl:when test="ID = '2021'">Eye flush was attempted at </xsl:when>
								<!-- 2022 Physical Exam-->								
								<xsl:when test="ID = '2022'">Physical exam was performed at </xsl:when>
								<!-- 2024	Delivery -->								
								<xsl:when test="ID = '2024'">Delivery was performed at </xsl:when>
								<xsl:otherwise><xsl:value-of select="Type"/> was administered at </xsl:otherwise>
							</xsl:choose>
							<xsl:value-of select="Time" />.
							The following details were noted for this treatment: <xsl:value-of select="Description" />.
						</xsl:for-each>
						<p></p>
						</xsl:if>

						<xsl:for-each select="PCR/Protocol">
							Protocol <xsl:value-of select="Type"></xsl:value-of> was viewed at
							<xsl:value-of select="Time"></xsl:value-of>.
						</xsl:for-each >
						<p></p>

						Outcome for this incident: <xsl:value-of select="PCR/ID1401"/>.
						<xsl:choose>
							<xsl:when test="PCR/ID1402 != ''">
								<xsl:choose>
									<xsl:when test="PCR/ID1422 != ''">
										Patient was transported to <xsl:value-of select="PCR/ID1402"/>
										(<xsl:value-of select="PCR/ID1403"/>), escorted by <xsl:value-of select="PCR/ID1422"/>.
									</xsl:when>
									<xsl:otherwise>
										Patient was transported to <xsl:value-of select="PCR/ID1402"/>(<xsl:value-of select="PCR/ID1403"/>).
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>

						<xsl:choose>
							<xsl:when test="PCR/ID1420 != ''">
								<xsl:choose>
									<xsl:when test="PCR/ID1421 != ''">
										Patients personal items included <xsl:value-of select="PCR/ID1420"/>,
										which were given to <xsl:value-of select="PCR/ID1421"/>.
									</xsl:when>
									<xsl:otherwise>
										Patients personal items included <xsl:value-of select="PCR/ID1420"/>.
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>

						<xsl:if test="PCR/ID1423">
							The condition of the patient upon arrival was <xsl:value-of select="PCR/ID1423"/>.
						</xsl:if>
						
						<xsl:choose>
							<xsl:when test="PCR/ID1045 != ''">
								<xsl:choose>
									<xsl:when test="PCR/ID1046 != ''">
										Patient care was transfered at <xsl:value-of select="PCR/ID1045"/>
										and the unit was clear at <xsl:value-of select="PCR/ID1046"/>.
									</xsl:when>
									<xsl:otherwise>
										Patient care was transfered at <xsl:value-of select="PCR/ID1045"/>.
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								The unit was clear at <xsl:value-of select="PCR/ID1046"/>.
							</xsl:otherwise>
						</xsl:choose>						

					</div>
				<br/>
			</div>
			<br clear="all"/>

    </xsl:template>

</xsl:stylesheet>
