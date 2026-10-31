/* Ajuste root a la ruta del directorio sas/ visible para el servidor SAS y CAS. */
%let root=/ruta/al/directorio/sas;
OPTIONS VALIDVARNAME=V7;
LIBNAME lgti "&root/lib";

/* LRECL se calcula con margen sobre la línea UTF-8 más larga de cada CSV. */

DATA lgti.Campaigns;
    INFILE "&root/csv/Campaigns.csv" DSD TRUNCOVER FIRSTOBS=2 ENCODING='utf-8' LRECL=32767;
    LENGTH
        Campno $9
        Campno_Normalizado $7
        Makes $30
        Models $245
        Years $49
        Mfgname $38
        Mfgcampno $19
        Compname $165
        Rcltypecd $1
        Potaff 8
        Odate 8
        Rcdate 8
        Datea 8
        Bgman 8
        Endman 8
        Influenced_By $3
        Desc_Defect $501
        Conequence_Defect $350
        Corrective_Action $1330
        Do_Not_Drive $3
        Park_Outside $3
        N_Filas_Origen 8
        Es_EQ22001 8
        Es_Perimetro_Principal 8
        Capa $4
        ;
    INFORMAT
        Campno $CHAR9.
        Campno_Normalizado $CHAR7.
        Makes $CHAR30.
        Models $CHAR245.
        Years $CHAR49.
        Mfgname $CHAR38.
        Mfgcampno $CHAR19.
        Compname $CHAR165.
        Rcltypecd $CHAR1.
        Potaff BEST32.
        Odate YYMMDD10.
        Rcdate YYMMDD10.
        Datea YYMMDD10.
        Bgman YYMMDD10.
        Endman YYMMDD10.
        Influenced_By $CHAR3.
        Desc_Defect $CHAR501.
        Conequence_Defect $CHAR350.
        Corrective_Action $CHAR1330.
        Do_Not_Drive $CHAR3.
        Park_Outside $CHAR3.
        N_Filas_Origen BEST32.
        Es_EQ22001 BEST32.
        Es_Perimetro_Principal BEST32.
        Capa $CHAR4.
        ;
    FORMAT
        Campno $CHAR9.
        Campno_Normalizado $CHAR7.
        Makes $CHAR30.
        Models $CHAR245.
        Years $CHAR49.
        Mfgname $CHAR38.
        Mfgcampno $CHAR19.
        Compname $CHAR165.
        Rcltypecd $CHAR1.
        Potaff BEST32.
        Odate YYMMDD10.
        Rcdate YYMMDD10.
        Datea YYMMDD10.
        Bgman YYMMDD10.
        Endman YYMMDD10.
        Influenced_By $CHAR3.
        Desc_Defect $CHAR501.
        Conequence_Defect $CHAR350.
        Corrective_Action $CHAR1330.
        Do_Not_Drive $CHAR3.
        Park_Outside $CHAR3.
        N_Filas_Origen BEST32.
        Es_EQ22001 BEST32.
        Es_Perimetro_Principal BEST32.
        Capa $CHAR4.
        ;
    LABEL
        Campno='Campno de Campaigns.'
        Campno_Normalizado='Campno Normalizado de Campaigns.'
        Makes='Makes de Campaigns.'
        Models='Models de Campaigns.'
        Years='Years de Campaigns.'
        Mfgname='Mfgname de Campaigns.'
        Mfgcampno='Mfgcampno de Campaigns.'
        Compname='Compname de Campaigns.'
        Rcltypecd='Rcltypecd de Campaigns.'
        Potaff='Potaff de Campaigns.'
        Odate='Odate de Campaigns.'
        Rcdate='Rcdate de Campaigns.'
        Datea='Datea de Campaigns.'
        Bgman='Bgman de Campaigns.'
        Endman='Endman de Campaigns.'
        Influenced_By='Influenced By de Campaigns.'
        Desc_Defect='Desc Defect de Campaigns.'
        Conequence_Defect='Conequence Defect de Campaigns.'
        Corrective_Action='Corrective Action de Campaigns.'
        Do_Not_Drive='Do Not Drive de Campaigns.'
        Park_Outside='Park Outside de Campaigns.'
        N_Filas_Origen='N Filas Origen de Campaigns.'
        Es_EQ22001='Es EQ22001 de Campaigns.'
        Es_Perimetro_Principal='Es Perimetro Principal de Campaigns.'
        Capa='Capa de Campaigns.'
        ;
    INPUT Campno Campno_Normalizado Makes Models Years Mfgname Mfgcampno Compname Rcltypecd Potaff Odate Rcdate Datea Bgman Endman Influenced_By Desc_Defect Conequence_Defect Corrective_Action Do_Not_Drive Park_Outside N_Filas_Origen Es_EQ22001 Es_Perimetro_Principal Capa;
RUN;

DATA lgti.Complaints;
    INFILE "&root/csv/Complaints.csv" DSD TRUNCOVER FIRSTOBS=2 ENCODING='utf-8' LRECL=32767;
    LENGTH
        Cmplid $7
        Odino $8
        Mfr_Name $21
        Maketxt $9
        Modeltxt $13
        Yeartxt $4
        Crash 8
        Faildate 8
        Fire 8
        Injured 8
        Deaths 8
        Compdesc $65
        City $24
        State $2
        Vin $11
        Datea 8
        Ldate 8
        Miles 8
        Occurences 8
        Cdescr $2076
        Cmpl_Type $4
        Police_Rpt_Yn 8
        Purch_Dt 8
        Orig_Owner_Yn 8
        Anti_Brakes_Yn 8
        Cruise_Cont_Yn 8
        Num_Cyls 8
        Drive_Train $3
        Fuel_Sys $1
        Fuel_Type $2
        Trans_Type $4
        Veh_Speed 8
        Dot $1
        Tire_Size $1
        Loc_Of_Tire $1
        Tire_Fail_Type $1
        Orig_Equip_Yn $1
        Manuf_Dt 8
        Seat_Type $1
        Restraint_Type $1
        Dealer_Name $39
        Dealer_Tel $10
        Dealer_City $15
        Dealer_State $2
        Dealer_Zip $8
        Prod_Type $1
        Repaired_Yn $1
        Medical_Attn 8
        Vehicles_Towed_Yn 8
        State_Of_Incident $2
        Vehicle_Operator $1
        Es_Componente_Bateria 8
        Capa $4
        ;
    INFORMAT
        Cmplid $CHAR7.
        Odino $CHAR8.
        Mfr_Name $CHAR21.
        Maketxt $CHAR9.
        Modeltxt $CHAR13.
        Yeartxt $CHAR4.
        Crash BEST32.
        Faildate YYMMDD10.
        Fire BEST32.
        Injured BEST32.
        Deaths BEST32.
        Compdesc $CHAR65.
        City $CHAR24.
        State $CHAR2.
        Vin $CHAR11.
        Datea YYMMDD10.
        Ldate YYMMDD10.
        Miles BEST32.
        Occurences BEST32.
        Cdescr $CHAR2076.
        Cmpl_Type $CHAR4.
        Police_Rpt_Yn BEST32.
        Purch_Dt YYMMDD10.
        Orig_Owner_Yn BEST32.
        Anti_Brakes_Yn BEST32.
        Cruise_Cont_Yn BEST32.
        Num_Cyls BEST32.
        Drive_Train $CHAR3.
        Fuel_Sys $CHAR1.
        Fuel_Type $CHAR2.
        Trans_Type $CHAR4.
        Veh_Speed BEST32.
        Dot $CHAR1.
        Tire_Size $CHAR1.
        Loc_Of_Tire $CHAR1.
        Tire_Fail_Type $CHAR1.
        Orig_Equip_Yn $CHAR1.
        Manuf_Dt YYMMDD10.
        Seat_Type $CHAR1.
        Restraint_Type $CHAR1.
        Dealer_Name $CHAR39.
        Dealer_Tel $CHAR10.
        Dealer_City $CHAR15.
        Dealer_State $CHAR2.
        Dealer_Zip $CHAR8.
        Prod_Type $CHAR1.
        Repaired_Yn $CHAR1.
        Medical_Attn BEST32.
        Vehicles_Towed_Yn BEST32.
        State_Of_Incident $CHAR2.
        Vehicle_Operator $CHAR1.
        Es_Componente_Bateria BEST32.
        Capa $CHAR4.
        ;
    FORMAT
        Cmplid $CHAR7.
        Odino $CHAR8.
        Mfr_Name $CHAR21.
        Maketxt $CHAR9.
        Modeltxt $CHAR13.
        Yeartxt $CHAR4.
        Crash BEST32.
        Faildate YYMMDD10.
        Fire BEST32.
        Injured BEST32.
        Deaths BEST32.
        Compdesc $CHAR65.
        City $CHAR24.
        State $CHAR2.
        Vin $CHAR11.
        Datea YYMMDD10.
        Ldate YYMMDD10.
        Miles BEST32.
        Occurences BEST32.
        Cdescr $CHAR2076.
        Cmpl_Type $CHAR4.
        Police_Rpt_Yn BEST32.
        Purch_Dt YYMMDD10.
        Orig_Owner_Yn BEST32.
        Anti_Brakes_Yn BEST32.
        Cruise_Cont_Yn BEST32.
        Num_Cyls BEST32.
        Drive_Train $CHAR3.
        Fuel_Sys $CHAR1.
        Fuel_Type $CHAR2.
        Trans_Type $CHAR4.
        Veh_Speed BEST32.
        Dot $CHAR1.
        Tire_Size $CHAR1.
        Loc_Of_Tire $CHAR1.
        Tire_Fail_Type $CHAR1.
        Orig_Equip_Yn $CHAR1.
        Manuf_Dt YYMMDD10.
        Seat_Type $CHAR1.
        Restraint_Type $CHAR1.
        Dealer_Name $CHAR39.
        Dealer_Tel $CHAR10.
        Dealer_City $CHAR15.
        Dealer_State $CHAR2.
        Dealer_Zip $CHAR8.
        Prod_Type $CHAR1.
        Repaired_Yn $CHAR1.
        Medical_Attn BEST32.
        Vehicles_Towed_Yn BEST32.
        State_Of_Incident $CHAR2.
        Vehicle_Operator $CHAR1.
        Es_Componente_Bateria BEST32.
        Capa $CHAR4.
        ;
    LABEL
        Cmplid='Cmplid de Complaints.'
        Odino='Odino de Complaints.'
        Mfr_Name='Mfr Name de Complaints.'
        Maketxt='Maketxt de Complaints.'
        Modeltxt='Modeltxt de Complaints.'
        Yeartxt='Yeartxt de Complaints.'
        Crash='Crash de Complaints.'
        Faildate='Faildate de Complaints.'
        Fire='Fire de Complaints.'
        Injured='Injured de Complaints.'
        Deaths='Deaths de Complaints.'
        Compdesc='Compdesc de Complaints.'
        City='City de Complaints.'
        State='State de Complaints.'
        Vin='Vin de Complaints.'
        Datea='Datea de Complaints.'
        Ldate='Ldate de Complaints.'
        Miles='Miles de Complaints.'
        Occurences='Occurences de Complaints.'
        Cdescr='Cdescr de Complaints.'
        Cmpl_Type='Cmpl Type de Complaints.'
        Police_Rpt_Yn='Police Rpt Yn de Complaints.'
        Purch_Dt='Purch Dt de Complaints.'
        Orig_Owner_Yn='Orig Owner Yn de Complaints.'
        Anti_Brakes_Yn='Anti Brakes Yn de Complaints.'
        Cruise_Cont_Yn='Cruise Cont Yn de Complaints.'
        Num_Cyls='Num Cyls de Complaints.'
        Drive_Train='Drive Train de Complaints.'
        Fuel_Sys='Fuel Sys de Complaints.'
        Fuel_Type='Fuel Type de Complaints.'
        Trans_Type='Trans Type de Complaints.'
        Veh_Speed='Veh Speed de Complaints.'
        Dot='Dot de Complaints.'
        Tire_Size='Tire Size de Complaints.'
        Loc_Of_Tire='Loc Of Tire de Complaints.'
        Tire_Fail_Type='Tire Fail Type de Complaints.'
        Orig_Equip_Yn='Orig Equip Yn de Complaints.'
        Manuf_Dt='Manuf Dt de Complaints.'
        Seat_Type='Seat Type de Complaints.'
        Restraint_Type='Restraint Type de Complaints.'
        Dealer_Name='Dealer Name de Complaints.'
        Dealer_Tel='Dealer Tel de Complaints.'
        Dealer_City='Dealer City de Complaints.'
        Dealer_State='Dealer State de Complaints.'
        Dealer_Zip='Dealer Zip de Complaints.'
        Prod_Type='Prod Type de Complaints.'
        Repaired_Yn='Repaired Yn de Complaints.'
        Medical_Attn='Medical Attn de Complaints.'
        Vehicles_Towed_Yn='Vehicles Towed Yn de Complaints.'
        State_Of_Incident='State Of Incident de Complaints.'
        Vehicle_Operator='Vehicle Operator de Complaints.'
        Es_Componente_Bateria='Es Componente Bateria de Complaints.'
        Capa='Capa de Complaints.'
        ;
    INPUT Cmplid Odino Mfr_Name Maketxt Modeltxt Yeartxt Crash Faildate Fire Injured Deaths Compdesc City State Vin Datea Ldate Miles Occurences Cdescr Cmpl_Type Police_Rpt_Yn Purch_Dt Orig_Owner_Yn Anti_Brakes_Yn Cruise_Cont_Yn Num_Cyls Drive_Train Fuel_Sys Fuel_Type Trans_Type Veh_Speed Dot Tire_Size Loc_Of_Tire Tire_Fail_Type Orig_Equip_Yn Manuf_Dt Seat_Type Restraint_Type Dealer_Name Dealer_Tel Dealer_City Dealer_State Dealer_Zip Prod_Type Repaired_Yn Medical_Attn Vehicles_Towed_Yn State_Of_Incident Vehicle_Operator Es_Componente_Bateria Capa;
RUN;

DATA lgti.Quarterly_Tracking;
    INFILE "&root/csv/Quarterly_Tracking.csv" DSD TRUNCOVER FIRSTOBS=2 ENCODING='utf-8' LRECL=32767;
    LENGTH
        Mfgtxt $38
        Campno $9
        Mfgcampno $19
        Rclsubj $70
        Odate 8
        Odateend 8
        Rptno 8
        Rptqtr $6
        Involved 8
        Ttlremedied 8
        Ttlunreach 8
        Ttlremoved 8
        Submdate 8
        Capa $4
        ;
    INFORMAT
        Mfgtxt $CHAR38.
        Campno $CHAR9.
        Mfgcampno $CHAR19.
        Rclsubj $CHAR70.
        Odate YYMMDD10.
        Odateend YYMMDD10.
        Rptno BEST32.
        Rptqtr $CHAR6.
        Involved BEST32.
        Ttlremedied BEST32.
        Ttlunreach BEST32.
        Ttlremoved BEST32.
        Submdate YYMMDD10.
        Capa $CHAR4.
        ;
    FORMAT
        Mfgtxt $CHAR38.
        Campno $CHAR9.
        Mfgcampno $CHAR19.
        Rclsubj $CHAR70.
        Odate YYMMDD10.
        Odateend YYMMDD10.
        Rptno BEST32.
        Rptqtr $CHAR6.
        Involved BEST32.
        Ttlremedied BEST32.
        Ttlunreach BEST32.
        Ttlremoved BEST32.
        Submdate YYMMDD10.
        Capa $CHAR4.
        ;
    LABEL
        Mfgtxt='Mfgtxt de Quarterly_Tracking.'
        Campno='Campno de Quarterly_Tracking.'
        Mfgcampno='Mfgcampno de Quarterly_Tracking.'
        Rclsubj='Rclsubj de Quarterly_Tracking.'
        Odate='Odate de Quarterly_Tracking.'
        Odateend='Odateend de Quarterly_Tracking.'
        Rptno='Rptno de Quarterly_Tracking.'
        Rptqtr='Rptqtr de Quarterly_Tracking.'
        Involved='Involved de Quarterly_Tracking.'
        Ttlremedied='Ttlremedied de Quarterly_Tracking.'
        Ttlunreach='Ttlunreach de Quarterly_Tracking.'
        Ttlremoved='Ttlremoved de Quarterly_Tracking.'
        Submdate='Submdate de Quarterly_Tracking.'
        Capa='Capa de Quarterly_Tracking.'
        ;
    INPUT Mfgtxt Campno Mfgcampno Rclsubj Odate Odateend Rptno Rptqtr Involved Ttlremedied Ttlunreach Ttlremoved Submdate Capa;
RUN;

DATA lgti.Costs;
    INFILE "&root/csv/Costs.csv" DSD TRUNCOVER FIRSTOBS=2 ENCODING='utf-8' LRECL=32767;
    LENGTH
        Id $3
        Evento $49
        Concepto $30
        Valor 8
        Unidad $17
        Categoria $23
        Formula_O_Origen $43
        Fuente $93
        Url $84
        Estado_Verificacion $52
        ;
    INFORMAT
        Id $CHAR3.
        Evento $CHAR49.
        Concepto $CHAR30.
        Valor BEST32.
        Unidad $CHAR17.
        Categoria $CHAR23.
        Formula_O_Origen $CHAR43.
        Fuente $CHAR93.
        Url $CHAR84.
        Estado_Verificacion $CHAR52.
        ;
    FORMAT
        Id $CHAR3.
        Evento $CHAR49.
        Concepto $CHAR30.
        Valor BEST32.
        Unidad $CHAR17.
        Categoria $CHAR23.
        Formula_O_Origen $CHAR43.
        Fuente $CHAR93.
        Url $CHAR84.
        Estado_Verificacion $CHAR52.
        ;
    LABEL
        Id='Id de Costs.'
        Evento='Evento de Costs.'
        Concepto='Concepto de Costs.'
        Valor='Valor de Costs.'
        Unidad='Unidad de Costs.'
        Categoria='Categoria de Costs.'
        Formula_O_Origen='Formula O Origen de Costs.'
        Fuente='Fuente de Costs.'
        Url='Url de Costs.'
        Estado_Verificacion='Estado Verificacion de Costs.'
        ;
    INPUT Id Evento Concepto Valor Unidad Categoria Formula_O_Origen Fuente Url Estado_Verificacion;
RUN;

DATA lgti.Price_References;
    INFILE "&root/csv/Price_References.csv" DSD TRUNCOVER FIRSTOBS=2 ENCODING='utf-8' LRECL=32767;
    LENGTH
        Id $3
        Solucion_Referencia $18
        Tipo $21
        Concepto $29
        Minimo 8
        Maximo 8
        Unidad $15
        Categoria $43
        Fuente $57
        Url $1
        Estado_Verificacion $26
        ;
    INFORMAT
        Id $CHAR3.
        Solucion_Referencia $CHAR18.
        Tipo $CHAR21.
        Concepto $CHAR29.
        Minimo BEST32.
        Maximo BEST32.
        Unidad $CHAR15.
        Categoria $CHAR43.
        Fuente $CHAR57.
        Url $CHAR1.
        Estado_Verificacion $CHAR26.
        ;
    FORMAT
        Id $CHAR3.
        Solucion_Referencia $CHAR18.
        Tipo $CHAR21.
        Concepto $CHAR29.
        Minimo BEST32.
        Maximo BEST32.
        Unidad $CHAR15.
        Categoria $CHAR43.
        Fuente $CHAR57.
        Url $CHAR1.
        Estado_Verificacion $CHAR26.
        ;
    LABEL
        Id='Id de Price_References.'
        Solucion_Referencia='Solucion Referencia de Price_References.'
        Tipo='Tipo de Price_References.'
        Concepto='Concepto de Price_References.'
        Minimo='Minimo de Price_References.'
        Maximo='Maximo de Price_References.'
        Unidad='Unidad de Price_References.'
        Categoria='Categoria de Price_References.'
        Fuente='Fuente de Price_References.'
        Url='Url de Price_References.'
        Estado_Verificacion='Estado Verificacion de Price_References.'
        ;
    INPUT Id Solucion_Referencia Tipo Concepto Minimo Maximo Unidad Categoria Fuente Url Estado_Verificacion;
RUN;

DATA lgti.Synthetic_Traceability;
    INFILE "&root/csv/Synthetic_Traceability.csv" DSD TRUNCOVER FIRSTOBS=2 ENCODING='utf-8' LRECL=32767;
    LENGTH
        Record_ID $10
        Production_Date 8
        Production_Month $7
        Supplier $24
        Supplier_Country $14
        Cell_Plant $8
        Plant_Country $14
        Production_Line $5
        Shift $7
        Material_Lot $12
        Cell_Lot $13
        Cell_ID $12
        Module_ID $10
        Battery_Pack_ID $11
        VIN $17
        Vehicle_Model $18
        Market_Country $14
        Market_Region $14
        State_Province $19
        Regulation $22
        Regulatory_Status $12
        Documentation_Status $10
        Compliance_Score 8
        Temperature_Max_C 8
        Voltage_V 8
        Internal_Resistance_mOhm 8
        Charge_Cycles 8
        Defect_Type $22
        Defect_Flag 8
        Severity $14
        Risk_Probability 8
        Risk_Level $5
        Alert_Status $17
        Recall_Status $12
        Traceability_Complete 8
        Investigation_Hours_Before 8
        Investigation_Hours_After 8
        Resolution_Days 8
        Units_Represented 8
        Replacement_Cost_USD 8
        Logistics_Cost_USD 8
        Potential_Fine_USD 8
        Broad_Recall_Cost_USD 8
        Targeted_Recall_Cost_USD 8
        Avoided_Recall_Cost_USD 8
        Expected_Fine_Avoided_USD 8
        Productivity_Savings_USD 8
        Implementation_Allocated_USD 8
        EBITDA_Impact_USD 8
        Failure_Predicted 8
        Failure_Actual 8
        Genealogy_Complete 8
        Capa $9
        ;
    INFORMAT
        Record_ID $CHAR10.
        Production_Date YYMMDD10.
        Production_Month $CHAR7.
        Supplier $CHAR24.
        Supplier_Country $CHAR14.
        Cell_Plant $CHAR8.
        Plant_Country $CHAR14.
        Production_Line $CHAR5.
        Shift $CHAR7.
        Material_Lot $CHAR12.
        Cell_Lot $CHAR13.
        Cell_ID $CHAR12.
        Module_ID $CHAR10.
        Battery_Pack_ID $CHAR11.
        VIN $CHAR17.
        Vehicle_Model $CHAR18.
        Market_Country $CHAR14.
        Market_Region $CHAR14.
        State_Province $CHAR19.
        Regulation $CHAR22.
        Regulatory_Status $CHAR12.
        Documentation_Status $CHAR10.
        Compliance_Score BEST32.
        Temperature_Max_C BEST32.
        Voltage_V BEST32.
        Internal_Resistance_mOhm BEST32.
        Charge_Cycles BEST32.
        Defect_Type $CHAR22.
        Defect_Flag BEST32.
        Severity $CHAR14.
        Risk_Probability BEST32.
        Risk_Level $CHAR5.
        Alert_Status $CHAR17.
        Recall_Status $CHAR12.
        Traceability_Complete BEST32.
        Investigation_Hours_Before BEST32.
        Investigation_Hours_After BEST32.
        Resolution_Days BEST32.
        Units_Represented BEST32.
        Replacement_Cost_USD BEST32.
        Logistics_Cost_USD BEST32.
        Potential_Fine_USD BEST32.
        Broad_Recall_Cost_USD BEST32.
        Targeted_Recall_Cost_USD BEST32.
        Avoided_Recall_Cost_USD BEST32.
        Expected_Fine_Avoided_USD BEST32.
        Productivity_Savings_USD BEST32.
        Implementation_Allocated_USD BEST32.
        EBITDA_Impact_USD BEST32.
        Failure_Predicted BEST32.
        Failure_Actual BEST32.
        Genealogy_Complete BEST32.
        Capa $CHAR9.
        ;
    FORMAT
        Record_ID $CHAR10.
        Production_Date YYMMDD10.
        Production_Month $CHAR7.
        Supplier $CHAR24.
        Supplier_Country $CHAR14.
        Cell_Plant $CHAR8.
        Plant_Country $CHAR14.
        Production_Line $CHAR5.
        Shift $CHAR7.
        Material_Lot $CHAR12.
        Cell_Lot $CHAR13.
        Cell_ID $CHAR12.
        Module_ID $CHAR10.
        Battery_Pack_ID $CHAR11.
        VIN $CHAR17.
        Vehicle_Model $CHAR18.
        Market_Country $CHAR14.
        Market_Region $CHAR14.
        State_Province $CHAR19.
        Regulation $CHAR22.
        Regulatory_Status $CHAR12.
        Documentation_Status $CHAR10.
        Compliance_Score BEST32.
        Temperature_Max_C BEST32.
        Voltage_V BEST32.
        Internal_Resistance_mOhm BEST32.
        Charge_Cycles BEST32.
        Defect_Type $CHAR22.
        Defect_Flag BEST32.
        Severity $CHAR14.
        Risk_Probability BEST32.
        Risk_Level $CHAR5.
        Alert_Status $CHAR17.
        Recall_Status $CHAR12.
        Traceability_Complete BEST32.
        Investigation_Hours_Before BEST32.
        Investigation_Hours_After BEST32.
        Resolution_Days BEST32.
        Units_Represented BEST32.
        Replacement_Cost_USD BEST32.
        Logistics_Cost_USD BEST32.
        Potential_Fine_USD BEST32.
        Broad_Recall_Cost_USD BEST32.
        Targeted_Recall_Cost_USD BEST32.
        Avoided_Recall_Cost_USD BEST32.
        Expected_Fine_Avoided_USD BEST32.
        Productivity_Savings_USD BEST32.
        Implementation_Allocated_USD BEST32.
        EBITDA_Impact_USD BEST32.
        Failure_Predicted BEST32.
        Failure_Actual BEST32.
        Genealogy_Complete BEST32.
        Capa $CHAR9.
        ;
    LABEL
        Record_ID='Record ID de Synthetic_Traceability.'
        Production_Date='Production Date de Synthetic_Traceability.'
        Production_Month='Production Month de Synthetic_Traceability.'
        Supplier='Supplier de Synthetic_Traceability.'
        Supplier_Country='Supplier Country de Synthetic_Traceability.'
        Cell_Plant='Cell Plant de Synthetic_Traceability.'
        Plant_Country='Plant Country de Synthetic_Traceability.'
        Production_Line='Production Line de Synthetic_Traceability.'
        Shift='Shift de Synthetic_Traceability.'
        Material_Lot='Material Lot de Synthetic_Traceability.'
        Cell_Lot='Cell Lot de Synthetic_Traceability.'
        Cell_ID='Cell ID de Synthetic_Traceability.'
        Module_ID='Module ID de Synthetic_Traceability.'
        Battery_Pack_ID='Battery Pack ID de Synthetic_Traceability.'
        VIN='VIN de Synthetic_Traceability.'
        Vehicle_Model='Vehicle Model de Synthetic_Traceability.'
        Market_Country='Market Country de Synthetic_Traceability.'
        Market_Region='Market Region de Synthetic_Traceability.'
        State_Province='State Province de Synthetic_Traceability.'
        Regulation='Regulation de Synthetic_Traceability.'
        Regulatory_Status='Regulatory Status de Synthetic_Traceability.'
        Documentation_Status='Documentation Status de Synthetic_Traceability.'
        Compliance_Score='Compliance Score de Synthetic_Traceability.'
        Temperature_Max_C='Temperature Max C de Synthetic_Traceability.'
        Voltage_V='Voltage V de Synthetic_Traceability.'
        Internal_Resistance_mOhm='Internal Resistance mOhm de Synthetic_Traceability.'
        Charge_Cycles='Charge Cycles de Synthetic_Traceability.'
        Defect_Type='Defect Type de Synthetic_Traceability.'
        Defect_Flag='Defect Flag de Synthetic_Traceability.'
        Severity='Severity de Synthetic_Traceability.'
        Risk_Probability='Risk Probability de Synthetic_Traceability.'
        Risk_Level='Risk Level de Synthetic_Traceability.'
        Alert_Status='Alert Status de Synthetic_Traceability.'
        Recall_Status='Recall Status de Synthetic_Traceability.'
        Traceability_Complete='Traceability Complete de Synthetic_Traceability.'
        Investigation_Hours_Before='Investigation Hours Before de Synthetic_Traceability.'
        Investigation_Hours_After='Investigation Hours After de Synthetic_Traceability.'
        Resolution_Days='Resolution Days de Synthetic_Traceability.'
        Units_Represented='Units Represented de Synthetic_Traceability.'
        Replacement_Cost_USD='Replacement Cost USD de Synthetic_Traceability.'
        Logistics_Cost_USD='Logistics Cost USD de Synthetic_Traceability.'
        Potential_Fine_USD='Potential Fine USD de Synthetic_Traceability.'
        Broad_Recall_Cost_USD='Broad Recall Cost USD de Synthetic_Traceability.'
        Targeted_Recall_Cost_USD='Targeted Recall Cost USD de Synthetic_Traceability.'
        Avoided_Recall_Cost_USD='Avoided Recall Cost USD de Synthetic_Traceability.'
        Expected_Fine_Avoided_USD='Expected Fine Avoided USD de Synthetic_Traceability.'
        Productivity_Savings_USD='Productivity Savings USD de Synthetic_Traceability.'
        Implementation_Allocated_USD='Implementation Allocated USD de Synthetic_Traceability.'
        EBITDA_Impact_USD='EBITDA Impact USD de Synthetic_Traceability.'
        Failure_Predicted='Failure Predicted de Synthetic_Traceability.'
        Failure_Actual='Failure Actual de Synthetic_Traceability.'
        Genealogy_Complete='Genealogy Complete de Synthetic_Traceability.'
        Capa='Capa de Synthetic_Traceability.'
        ;
    INPUT Record_ID Production_Date Production_Month Supplier Supplier_Country Cell_Plant Plant_Country Production_Line Shift Material_Lot Cell_Lot Cell_ID Module_ID Battery_Pack_ID VIN Vehicle_Model Market_Country Market_Region State_Province Regulation Regulatory_Status Documentation_Status Compliance_Score Temperature_Max_C Voltage_V Internal_Resistance_mOhm Charge_Cycles Defect_Type Defect_Flag Severity Risk_Probability Risk_Level Alert_Status Recall_Status Traceability_Complete Investigation_Hours_Before Investigation_Hours_After Resolution_Days Units_Represented Replacement_Cost_USD Logistics_Cost_USD Potential_Fine_USD Broad_Recall_Cost_USD Targeted_Recall_Cost_USD Avoided_Recall_Cost_USD Expected_Fine_Avoided_USD Productivity_Savings_USD Implementation_Allocated_USD EBITDA_Impact_USD Failure_Predicted Failure_Actual Genealogy_Complete Capa;
RUN;

DATA lgti.Synthetic_Network_Edges;
    INFILE "&root/csv/Synthetic_Network_Edges.csv" DSD TRUNCOVER FIRSTOBS=2 ENCODING='utf-8' LRECL=32767;
    LENGTH
        Source_Node $24
        Target_Node $8
        Units_Represented 8
        Link_Type $18
        Capa $9
        ;
    INFORMAT
        Source_Node $CHAR24.
        Target_Node $CHAR8.
        Units_Represented BEST32.
        Link_Type $CHAR18.
        Capa $CHAR9.
        ;
    FORMAT
        Source_Node $CHAR24.
        Target_Node $CHAR8.
        Units_Represented BEST32.
        Link_Type $CHAR18.
        Capa $CHAR9.
        ;
    LABEL
        Source_Node='Source Node de Synthetic_Network_Edges.'
        Target_Node='Target Node de Synthetic_Network_Edges.'
        Units_Represented='Units Represented de Synthetic_Network_Edges.'
        Link_Type='Link Type de Synthetic_Network_Edges.'
        Capa='Capa de Synthetic_Network_Edges.'
        ;
    INPUT Source_Node Target_Node Units_Represented Link_Type Capa;
RUN;

DATA lgti.Campaign_Analytic;
    INFILE "&root/csv/Campaign_Analytic.csv" DSD TRUNCOVER FIRSTOBS=2 ENCODING='utf-8' LRECL=32767;
    LENGTH
        Campno $9
        Campno_Normalizado $7
        Makes $9
        Models $28
        Years $14
        Es_EQ22001 8
        Potaff 8
        Remediados 8
        Rptqtr_Ultimo $6
        F2_Tasa_Reparacion 8
        N_Reclamaciones 8
        N_Reclamaciones_Fuego 8
        F3_Plazo_Deteccion_Dias 8
        Fecha_Primer_Fuego 8
        Coste_Observado_Usd $1
        Capa $4
        ;
    INFORMAT
        Campno $CHAR9.
        Campno_Normalizado $CHAR7.
        Makes $CHAR9.
        Models $CHAR28.
        Years $CHAR14.
        Es_EQ22001 BEST32.
        Potaff BEST32.
        Remediados BEST32.
        Rptqtr_Ultimo $CHAR6.
        F2_Tasa_Reparacion BEST32.
        N_Reclamaciones BEST32.
        N_Reclamaciones_Fuego BEST32.
        F3_Plazo_Deteccion_Dias BEST32.
        Fecha_Primer_Fuego YYMMDD10.
        Coste_Observado_Usd $CHAR1.
        Capa $CHAR4.
        ;
    FORMAT
        Campno $CHAR9.
        Campno_Normalizado $CHAR7.
        Makes $CHAR9.
        Models $CHAR28.
        Years $CHAR14.
        Es_EQ22001 BEST32.
        Potaff BEST32.
        Remediados BEST32.
        Rptqtr_Ultimo $CHAR6.
        F2_Tasa_Reparacion BEST32.
        N_Reclamaciones BEST32.
        N_Reclamaciones_Fuego BEST32.
        F3_Plazo_Deteccion_Dias BEST32.
        Fecha_Primer_Fuego YYMMDD10.
        Coste_Observado_Usd $CHAR1.
        Capa $CHAR4.
        ;
    LABEL
        Campno='Campno de Campaign_Analytic.'
        Campno_Normalizado='Campno Normalizado de Campaign_Analytic.'
        Makes='Makes de Campaign_Analytic.'
        Models='Models de Campaign_Analytic.'
        Years='Years de Campaign_Analytic.'
        Es_EQ22001='Es EQ22001 de Campaign_Analytic.'
        Potaff='Potaff de Campaign_Analytic.'
        Remediados='Remediados de Campaign_Analytic.'
        Rptqtr_Ultimo='Rptqtr Ultimo de Campaign_Analytic.'
        F2_Tasa_Reparacion='F2 Tasa Reparacion de Campaign_Analytic.'
        N_Reclamaciones='N Reclamaciones de Campaign_Analytic.'
        N_Reclamaciones_Fuego='N Reclamaciones Fuego de Campaign_Analytic.'
        F3_Plazo_Deteccion_Dias='F3 Plazo Deteccion Dias de Campaign_Analytic.'
        Fecha_Primer_Fuego='Fecha Primer Fuego de Campaign_Analytic.'
        Coste_Observado_Usd='Coste Observado Usd de Campaign_Analytic.'
        Capa='Capa de Campaign_Analytic.'
        ;
    INPUT Campno Campno_Normalizado Makes Models Years Es_EQ22001 Potaff Remediados Rptqtr_Ultimo F2_Tasa_Reparacion N_Reclamaciones N_Reclamaciones_Fuego F3_Plazo_Deteccion_Dias Fecha_Primer_Fuego Coste_Observado_Usd Capa;
RUN;

/* La ruta root debe ser accesible desde el servidor CAS. */
CAS lgti_session;

PROC CASUTIL SESSREF=lgti_session;
    load data=lgti.Campaigns casout="Campaigns" outcaslib="casuser" replace;
QUIT;

PROC CASUTIL SESSREF=lgti_session;
    load data=lgti.Complaints casout="Complaints" outcaslib="casuser" replace;
QUIT;

PROC CASUTIL SESSREF=lgti_session;
    load data=lgti.Quarterly_Tracking casout="Quarterly_Tracking" outcaslib="casuser" replace;
QUIT;

PROC CASUTIL SESSREF=lgti_session;
    load data=lgti.Costs casout="Costs" outcaslib="casuser" replace;
QUIT;

PROC CASUTIL SESSREF=lgti_session;
    load data=lgti.Price_References casout="Price_References" outcaslib="casuser" replace;
QUIT;

PROC CASUTIL SESSREF=lgti_session;
    load data=lgti.Synthetic_Traceability casout="Synthetic_Traceability" outcaslib="casuser" replace;
QUIT;

PROC CASUTIL SESSREF=lgti_session;
    load data=lgti.Synthetic_Network_Edges casout="Synthetic_Network_Edges" outcaslib="casuser" replace;
QUIT;

PROC CASUTIL SESSREF=lgti_session;
    load data=lgti.Campaign_Analytic casout="Campaign_Analytic" outcaslib="casuser" replace;
QUIT;

PROC SQL;
    /* Comprobación del número de filas de cada tabla. */
    SELECT "Campaigns" AS Tabla LENGTH=32, COUNT(*) AS N_Filas FROM lgti.Campaigns;
    SELECT "Complaints" AS Tabla LENGTH=32, COUNT(*) AS N_Filas FROM lgti.Complaints;
    SELECT "Quarterly_Tracking" AS Tabla LENGTH=32, COUNT(*) AS N_Filas FROM lgti.Quarterly_Tracking;
    SELECT "Costs" AS Tabla LENGTH=32, COUNT(*) AS N_Filas FROM lgti.Costs;
    SELECT "Price_References" AS Tabla LENGTH=32, COUNT(*) AS N_Filas FROM lgti.Price_References;
    SELECT "Synthetic_Traceability" AS Tabla LENGTH=32, COUNT(*) AS N_Filas FROM lgti.Synthetic_Traceability;
    SELECT "Synthetic_Network_Edges" AS Tabla LENGTH=32, COUNT(*) AS N_Filas FROM lgti.Synthetic_Network_Edges;
    SELECT "Campaign_Analytic" AS Tabla LENGTH=32, COUNT(*) AS N_Filas FROM lgti.Campaign_Analytic;
QUIT;

PROC MEANS DATA=lgti.Synthetic_Traceability SUM;
    VAR Units_Represented;
    /* La suma esperada es 605250. */
RUN;

PROC MEANS DATA=lgti.Campaign_Analytic N MEAN;
    VAR F2_Tasa_Reparacion;
RUN;

/* Ejemplos F1, F2 y F3; bloques comentados para consulta.            */
/* F1: PROC SQL; SELECT MAX(CASE WHEN Id='C01' THEN Valor*1000000 END)/
       MAX(CASE WHEN Id='C03' THEN Valor END) AS F1_Coste_Medio FROM lgti.Costs; QUIT; */
/* F2: PROC SQL; SELECT Campno, Remediados/Potaff AS F2_Tasa_Reparacion FROM lgti.Campaign_Analytic; QUIT; */
/* F3: PROC SQL; SELECT a.Campno, a.Rcdate-MIN(b.Ldate) AS F3_Plazo_Deteccion_Dias
       FROM lgti.Campaigns a INNER JOIN lgti.Complaints b
       ON FINDW(a.Makes, STRIP(b.Maketxt), '|', 'it') > 0
       AND FINDW(a.Models, STRIP(b.Modeltxt), '|', 'it') > 0
       AND FINDW(a.Years, STRIP(b.Yeartxt), '|', 'it') > 0
       WHERE b.Fire=1
       GROUP BY a.Campno, a.Rcdate; QUIT; */
