# Guía manual SAS Visual Analytics — "LGES Traceability Intelligence - Torre de Control"

Versión corregida con los nombres reales del informe, que se inventariaron abriéndolo con la sesión de Iker (31-10-2026). El informe tiene **8 páginas y ninguna "00 Prototipo histórico"**. Orden de pestañas: 02, 03, 04, 05, 06, 07, **01 Resumen ejecutivo final**, 08.

## Estado de la parte SAS (honesto)
| Hecho | Estado |
|---|---|
| Inventario de las 8 páginas con captura | hecho (capturas de la sesión de Chrome) |
| Carpeta `My Folder/coherencia` con los 5 ficheros (subidos por Iker) | hecho |
| Programa de carga ejecutado en SAS Studio | **hecho**: sin errores en la parte 1 (3 tablas); controles de la tabla sintética: 1.800 / 605.250 / 530.200 / 545 / 81 = esperados |
| Tablas promovidas en CASUSER (`LGTI_CIFRAS_DOSSIER`, `LGTI_ESCENARIOS`, `LGTI_UMBRALES`, `LGTI_TRAZABILIDAD_SINT`) | hecho (log sin errores; no se abrió aún el panel de datos de VA para verlas listadas) |
| Respaldo del informe | hecho: "LGES Traceability Intelligence - respaldo" (Mi carpeta) |
| Edición de páginas del informe | **hecha (31-10-2026, con autorización de Iker)**: eliminados KPI de EBITDA 347 M, Failure_Predicted 40, cobertura 96 % y 722 M; añadidos textos con cifras del dossier y rótulos de categoría y capa en las páginas 01 a 08 (excepto 00, oculta); la "71" de la 08 sustituida por 231. Las cifras son texto estático, no están enlazadas a las tablas `LGTI_*`. Ver `informe_coherencia_final.md`, sección 4, para los pendientes (p. 05 y 03 sin datos en lectura) |

## Cómo reejecutar la carga
SAS Studio → abrir `My Folder/coherencia/cargar_coherencia.sas` → Ejecutar. **Nota:** el servidor está en modo restringido; el INFILE a ruta no funciona, hay que usar `FILENAME ... FILESRVC` y `cas mysess; caslib _all_ assign;` (ya incluido en el .sas del repo). El editor de SAS Studio no aceptó la versión subida (la pestaña `cargar_coherencia.sas` conserva el programa antiguo con error): usa el contenido actual del fichero del repo.

## Inventario real y cambios necesarios por página
Regla común: cada cifra con su categoría (dato público observado / cálculo derivado / supuesto académico / objetivo de diseño); las sintéticas con "Capa sintética (demostración del método) · elaboración propia, datos sintéticos".

| Página | Objetos reales | Valor actual | Cambio propuesto |
|---|---|---|---|
| 01 Resumen ejecutivo final | 4 KPI: `EBITDA_Impact_USD`, `Units_Represented`, `Compliance_Score`, `Failure_Predicted` | 347 M · 605 mil · 91 · 40 | **Sustituir/quitar** EBITDA 347 M y "Failure_Predicted 40" (sección 3.6). Poner KPI desde `LGTI_ESCENARIOS`: beneficio neto base 68,43 M USD; desde `LGTI_TRAZABILIDAD_SINT`: genealogía completa 87,6 %; desde `LGTI_UMBRALES` (0,15): sensibilidad 62 %. Rotular 605 mil y 91 como capa sintética |
| 02 Calidad y Proveedores | selector Proveedor; "Riesgo medio por proveedor" (Risk_Probability); "Distribución térmica por proveedor" (Temperature_Max_C) | datos sintéticos | solo rótulo "capa sintética"; sin contradicciones |
| 03 Trazabilidad de extremo a extremo | tabla "Pasaporte digital y linaje de batería"; KPI **"Cobertura de trazabilidad" 96 %**; "Red de suministro: proveedores → plantas" | 96 % | KPI → "Genealogía completa (dos indicadores)": 87,6 % (530.200 / 605.250) con `Genealogia_Completa_2ind`; añadir grupo C = 75.050 (12,4 %) con `Grupo_Genealogia`. Rótulo de capa sintética |
| 04 Cumplimiento regulatorio | selector Market_Country; "Exposición potencial a multas por mercado"; treemap `Potential_Fine_USD` | sintético | solo rótulo de capa; `Potential_Fine_USD` está fuera de la tabla nueva (usa la tabla antigua `LGES_TRACEABILITY_ES`) |
| 05 Predicción de fallos | "Señales de fallo y probabilidad de riesgo" (objeto sin contenido visible al cargar); 3 KPI "Resistencia interna media (mΩ)" por nivel de riesgo (3,5 / 2,3 / 2,1) | sin línea 0,15 ni AUC | añadir texto: "La nota ordena con AUC 0,76; sirve para priorizar vigilancia; la exclusión se decide con la genealogía"; tabla de `LGTI_UMBRALES` (0,15 → 545 vigiladas, 30,3 %, 81 de 130, 62 %); no usar `Defect_Flag`. Comprobar por qué el primer objeto sale vacío |
| 06 Impacto económico | "Recall amplio vs dirigido e impacto EBITDA" (barras por Production_Month); KPI "Coste potencial de recall amplio" 722 M | 722 M | **Quitar/rotular** 722 M (sección 3.6). Añadir tabla `LGTI_ESCENARIOS` (Tabla 7, 3 escenarios) y la sensibilidad: prob. 35,3–123,7; reducción 47,2–81,2; ahorro 61,2–83,3; π 72,5–64,4. Texto: 5,7 USD por cada USD pagado a LGTI |
| 07 Operaciones y productividad | "Horas de investigación y resolución por línea"; KPI "Horas de investigación tras la mejora" 13 mil | sintético | solo rótulo de capa; no comparar con escenarios |
| 08 Fuentes y calidad de datos | texto "FUENTES Y PREPARACIÓN | PROTOTIPO ACADÉMICO": tabla `LGES_TRACEABILITY_ES`, "71 registros figuran con trazabilidad incompleta" | 71 registros | Sustituir por: fuentes = tablas `LGTI_*`; 228 de 1.800 registros discrepan entre los dos indicadores; 87,6 % de genealogía completa. Mantener "datos sintéticos, no son registros internos de LG" |

## Pasos concretos en VA (por objeto)
1. Abrir el informe → lápiz (Editar). Datos → Agregar datos → CASUSER → añadir las 4 tablas `LGTI_*`.
2. En cada KPI a sustituir: Cambiar rol de datos al campo nuevo, o crear Medida calculada `Genealogía completa (%)` = `Sum(If Genealogia_Completa_2ind = 1 Then Units_Represented) / Sum(Units_Represented)`.
3. Añadir objetos "Texto" con el rótulo de categoría/capa.
4. Guardar como versión nueva y comparar con las capturas.
