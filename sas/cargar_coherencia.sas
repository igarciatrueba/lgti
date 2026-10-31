/*
  Carga de las tablas coherentes del dossier en CASUSER.
  Los CSV se leen desde SAS Content mediante el servicio FILESRVC.
  Las tablas se preparan en WORK antes de cargarlas en CASUSER.
*/
/* Si la sesión ya existe, CAS puede emitir un aviso inocuo. */
cas mysess;
caslib _all_ assign;

%let ruta=/ruta/a/tu/carpeta/coherencia;

filename f_cif filesrvc folderpath="&ruta" filename="cifras_dossier.csv";
filename f_esc filesrvc folderpath="&ruta" filename="escenarios_dossier.csv";
filename f_umb filesrvc folderpath="&ruta" filename="umbrales_dossier.csv";
filename f_trz filesrvc folderpath="&ruta" filename="Synthetic_Traceability.csv";

data work.LGTI_CIFRAS_DOSSIER;
  length id $64 cifra $200 valor $32 unidad $32 categoria $32 capa $10
         fuente $120 apartado_dossier $8 valor_num 8;
  infile f_cif dsd dlm=',' firstobs=2 encoding='utf-8'
         truncover lrecl=32767;
  input id :$64. cifra :$200. valor :$32. unidad :$32. categoria :$32.
        capa :$10. fuente :$120. apartado_dossier :$8.;
  valor_num = input(valor, ?? best32.);
  label id='Identificador de cifra'
        cifra='Cifra del dossier'
        valor='Valor con punto decimal'
        valor_num='Valor numérico'
        unidad='Unidad de medida'
        categoria='Categoría de evidencia'
        capa='Capa de información'
        fuente='Fuente o fórmula'
        apartado_dossier='Apartado del dossier';
run;

proc casutil;
  droptable casdata="LGTI_CIFRAS_DOSSIER" incaslib="casuser" quiet;
  load data=work.LGTI_CIFRAS_DOSSIER outcaslib="casuser"
       casout="LGTI_CIFRAS_DOSSIER" replace;
  promote casdata="LGTI_CIFRAS_DOSSIER" incaslib="casuser"
          outcaslib="casuser";
quit;

data work.LGTI_ESCENARIOS;
  length escenario $16 capa $10;
  infile f_esc dsd dlm=',' firstobs=2
         encoding='utf-8' truncover lrecl=32767;
  input escenario :$16.
        vehiculos_retirada_amplia
        coste_unitario_usd
        retirada_amplia_musd
        reduccion_poblacion_pct
        vehiculos_retirada_dirigida
        coste_dirigido_musd
        coste_evitado_musd
        probabilidad_evento_pct
        ahorro_operativo_musd
        valor_anual_creado_musd
        porcentaje_lgti_pct
        pago_lgti_musd
        beneficio_neto_cliente_musd
        coste_implantacion_musd
        recuperacion_inversion_anos
        capa :$10.;
  label escenario='Escenario'
        vehiculos_retirada_amplia='Vehículos retirada amplia'
        coste_unitario_usd='Coste unitario (USD)'
        retirada_amplia_musd='Retirada amplia (M USD)'
        reduccion_poblacion_pct='Reducción de población (%)'
        vehiculos_retirada_dirigida='Vehículos retirada dirigida'
        coste_dirigido_musd='Coste dirigido (M USD)'
        coste_evitado_musd='Coste evitado (M USD)'
        probabilidad_evento_pct='Probabilidad anual (%)'
        ahorro_operativo_musd='Ahorro operativo (M USD)'
        valor_anual_creado_musd='Valor anual creado (M USD)'
        porcentaje_lgti_pct='Participación de LGTI (%)'
        pago_lgti_musd='Pago a LGTI (M USD)'
        beneficio_neto_cliente_musd='Beneficio neto cliente (M USD)'
        coste_implantacion_musd='Coste implantación (M USD)'
        recuperacion_inversion_anos='Recuperación (años)'
        capa='Capa de información';
run;

proc casutil;
  droptable casdata="LGTI_ESCENARIOS" incaslib="casuser" quiet;
  load data=work.LGTI_ESCENARIOS outcaslib="casuser"
       casout="LGTI_ESCENARIOS" replace;
  promote casdata="LGTI_ESCENARIOS" incaslib="casuser"
          outcaslib="casuser";
quit;

data work.LGTI_UMBRALES;
  length capa $10;
  infile f_umb dsd dlm=',' firstobs=2
         encoding='utf-8' truncover lrecl=32767;
  input linea unidades_vigiladas pct_registros fallos_detectados
        fallos_totales sensibilidad_pct capa :$10.;
  label linea='Línea de vigilancia'
        unidades_vigiladas='Registros vigilados'
        pct_registros='Registros vigilados (%)'
        fallos_detectados='Fallos detectados'
        fallos_totales='Fallos totales'
        sensibilidad_pct='Sensibilidad (%)'
        capa='Capa de información';
run;

proc casutil;
  droptable casdata="LGTI_UMBRALES" incaslib="casuser" quiet;
  load data=work.LGTI_UMBRALES outcaslib="casuser"
       casout="LGTI_UMBRALES" replace;
  promote casdata="LGTI_UMBRALES" incaslib="casuser"
          outcaslib="casuser";
quit;

data work.LGTI_TRAZABILIDAD_SINT;
  length Record_ID $16 Production_Date 8 Production_Month $7 Supplier $40
         Supplier_Country $24 Cell_Plant $24 Plant_Country $24
         Production_Line $12 Shift $12 Material_Lot $20 Cell_Lot $20
         Cell_ID $20 Module_ID $20 Battery_Pack_ID $20 VIN $20
         Vehicle_Model $40 Market_Country $30 Market_Region $20
         State_Province $30 Regulation $30 Regulatory_Status $20
         Documentation_Status $20 Defect_Type $40 Severity $20
         Risk_Level $16 Alert_Status $20 Recall_Status $20 Capa $12
         Grupo_Genealogia $24 Linea_015 $12;
  format Production_Date yymmdd10.;
  infile f_trz dsd dlm=',' firstobs=2
         encoding='utf-8' truncover lrecl=32767;
  input Record_ID :$16.
        Production_Date :yymmdd10.
        Production_Month :$7.
        Supplier :$40.
        Supplier_Country :$24.
        Cell_Plant :$24.
        Plant_Country :$24.
        Production_Line :$12.
        Shift :$12.
        Material_Lot :$20.
        Cell_Lot :$20.
        Cell_ID :$20.
        Module_ID :$20.
        Battery_Pack_ID :$20.
        VIN :$20.
        Vehicle_Model :$40.
        Market_Country :$30.
        Market_Region :$20.
        State_Province :$30.
        Regulation :$30.
        Regulatory_Status :$20.
        Documentation_Status :$20.
        Compliance_Score
        Temperature_Max_C
        Voltage_V
        Internal_Resistance_mOhm
        Charge_Cycles
        Defect_Type :$40.
        Defect_Flag
        Severity :$20.
        Risk_Probability
        Risk_Level :$16.
        Alert_Status :$20.
        Recall_Status :$20.
        Traceability_Complete
        Investigation_Hours_Before
        Investigation_Hours_After
        Resolution_Days
        Units_Represented
        Replacement_Cost_USD
        Logistics_Cost_USD
        Potential_Fine_USD
        Broad_Recall_Cost_USD
        Targeted_Recall_Cost_USD
        Avoided_Recall_Cost_USD
        Expected_Fine_Avoided_USD
        Productivity_Savings_USD
        Implementation_Allocated_USD
        EBITDA_Impact_USD
        Failure_Predicted
        Failure_Actual
        Genealogy_Complete
        Capa :$12.;

  Genealogia_Completa_2ind =
    (Genealogy_Complete = 1 and Documentation_Status = 'Completa');
  if Genealogia_Completa_2ind = 1 then Grupo_Genealogia = 'Completa';
  else Grupo_Genealogia = 'Sin evidencia completa';

  if Risk_Probability >= 0.15 then Linea_015 = 'Vigilada';
  else Linea_015 = 'No vigilada';
  if Linea_015 = 'Vigilada' and Failure_Actual = 1 then
    Fallo_Detectado_015 = 1;
  else Fallo_Detectado_015 = 0;

  keep Record_ID Supplier Cell_Plant Production_Month Production_Line Shift
       Material_Lot Cell_Lot Cell_ID Module_ID Battery_Pack_ID VIN Vehicle_Model
       Documentation_Status Genealogy_Complete Risk_Probability Risk_Level
       Failure_Actual Defect_Type Defect_Flag Severity Units_Represented
       Compliance_Score Temperature_Max_C Voltage_V Internal_Resistance_mOhm
       Charge_Cycles Resolution_Days Investigation_Hours_Before
       Investigation_Hours_After Broad_Recall_Cost_USD Targeted_Recall_Cost_USD
       Avoided_Recall_Cost_USD Productivity_Savings_USD
       Implementation_Allocated_USD EBITDA_Impact_USD Alert_Status Recall_Status
       Capa Genealogia_Completa_2ind Grupo_Genealogia Linea_015
       Fallo_Detectado_015;

  label Record_ID='Identificador del registro'
        Supplier='Proveedor'
        Cell_Plant='Planta de celdas'
        Production_Month='Mes de producción'
        Production_Line='Línea de producción'
        Shift='Turno'
        Material_Lot='Lote de material'
        Cell_Lot='Lote de celdas'
        Cell_ID='Identificador de celda'
        Module_ID='Identificador de módulo'
        Battery_Pack_ID='Identificador de pack'
        VIN='Número de identificación vehículo'
        Vehicle_Model='Modelo de vehículo'
        Documentation_Status='Estado de documentación'
        Genealogy_Complete='Indicador de genealogía original'
        Risk_Probability='Probabilidad de riesgo'
        Risk_Level='Nivel de riesgo'
        Failure_Actual='Fallo real'
        Defect_Type='Tipo de defecto'
        Defect_Flag='Indicador de defecto'
        Severity='Severidad'
        Units_Represented='Unidades representadas'
        Compliance_Score='Puntuación de cumplimiento'
        Temperature_Max_C='Temperatura máxima (C)'
        Voltage_V='Voltaje (V)'
        Internal_Resistance_mOhm='Resistencia interna (mOhm)'
        Charge_Cycles='Ciclos de carga'
        Resolution_Days='Días de resolución'
        Investigation_Hours_Before='Horas investigación antes'
        Investigation_Hours_After='Horas investigación después'
        Broad_Recall_Cost_USD='Coste retirada amplia (USD)'
        Targeted_Recall_Cost_USD='Coste retirada dirigida (USD)'
        Avoided_Recall_Cost_USD='Coste evitado (USD)'
        Productivity_Savings_USD='Ahorro productividad (USD)'
        Implementation_Allocated_USD='Implantación asignada (USD)'
        EBITDA_Impact_USD='Impacto EBITDA (USD)'
        Alert_Status='Estado de alerta'
        Recall_Status='Estado de retirada'
        Capa='Capa de información'
        Genealogia_Completa_2ind='Genealogía completa por dos indicadores'
        Grupo_Genealogia='Grupo de genealogía'
        Linea_015='Línea vigilada con umbral 0,15'
        Fallo_Detectado_015='Fallo detectado con umbral 0,15';
run;

proc casutil;
  droptable casdata="LGTI_TRAZABILIDAD_SINT" incaslib="casuser" quiet;
  load data=work.LGTI_TRAZABILIDAD_SINT outcaslib="casuser"
       casout="LGTI_TRAZABILIDAD_SINT" replace;
  promote casdata="LGTI_TRAZABILIDAD_SINT" incaslib="casuser"
          outcaslib="casuser";
quit;

title "Comprobaciones de carga: valores esperados y obtenidos";
proc sql;
  create table work.COMPROBACIONES_CARGA as
  select 'Registros' as Comprobacion length=48,
         1800 as Esperado,
         count(*) as Obtenido
  from work.LGTI_TRAZABILIDAD_SINT
  union all
  select 'Suma de unidades', 605250, sum(Units_Represented)
  from work.LGTI_TRAZABILIDAD_SINT
  union all
  select 'Unidades con genealogía completa', 530200,
         sum(case when Genealogia_Completa_2ind = 1
                  then Units_Represented else 0 end)
  from work.LGTI_TRAZABILIDAD_SINT
  union all
  select 'Registros vigilados con línea 0,15', 545,
         sum(case when Linea_015 = 'Vigilada' then 1 else 0 end)
  from work.LGTI_TRAZABILIDAD_SINT
  union all
  select 'Fallos detectados con línea 0,15', 81,
         sum(Fallo_Detectado_015)
  from work.LGTI_TRAZABILIDAD_SINT;

  /* Tabla visible en resultados y valores detallados en el log de SAS Studio. */
  select Comprobacion, Esperado, Obtenido
  from work.COMPROBACIONES_CARGA;
quit;
title;
