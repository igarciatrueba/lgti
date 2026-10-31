# Informe de coherencia final — dossier ↔ front HTML ↔ SAS Visual Analytics

Fecha: 2026-10-31 (ronda 3). "Verificado" = visto o ejecutado por Claude. El dossier (Google Docs) no se ha podido leer: la columna "Dossier" es la sección 3 del contexto. SAS verificado en modo lectura (capturas), tras recargar el informe guardado.

## 1. Cifras y conclusiones
| Cifra / conclusión | Dossier (sección 3) | Front HTML | SAS VA | ¿Coincide? |
|---|---|---|---|---|
| Vehículos Bolt | 142.000 | 142.000 (Impacto) | 142.000 (texto p. 01 y 06) | sí / sí |
| Cargo de la retirada | 2.000 M USD | 2.000,0 M USD | 2.000 M USD (texto p. 01 y 06); **KPI 722 M eliminado** | sí / sí |
| Coste por vehículo | 14.085 USD | 14.085 USD | 14.085 USD (texto p. 01 y 06) | sí / sí |
| Genealogía completa (G) | 87,6 % (530.200 / 605.250) | 87,6 % | 87,6 % (texto p. 01 y 03); **KPI 96 % eliminado**; cálculo en servidor SAS = 530.200 | sí / sí |
| Grupo C | 75.050 (12,4 %) | 75.050 (12,4 %) | 75.050 (12,4 %) (texto p. 01, 03, 08) | sí / sí |
| Registros con genealogía incompleta | (dos indicadores) | no aparece | 231 de 1.800 (p. 08, antes "71") | **sí (cifra de Iker: 1.800 − 1.569; recalculada: 231)** |
| AUC | 0,76 | 0,76 | 0,76 (texto p. 01 y 05) | sí / sí |
| Línea 0,15 | 545 · 30,3 % · 81/130 · 62 % | idem | idem (texto p. 01 y 05); servidor SAS: 545 y 81 | sí / sí |
| Otras líneas 0,50/0,20/0,10 | 39-21-16 % / 332-66-51 % / 903-104-80 % | idem | idem (texto p. 05) | sí / sí |
| Tabla 7 | ver contexto | idem + nota de redondeo | idem como texto (p. 06), con nota de redondeo | sí / sí |
| Sensibilidad de B base | 35,3–123,7; 47,2–81,2; 61,2–83,3; 72,5–64,4 | idem (tornado; fila «Porcentaje de pago a LGTI (π)») | idem (texto p. 06) | sí / sí |
| 5,7 USD por USD pagado | 5,7 | texto en Impacto | texto p. 06 | sí / sí |
| EBITDA 346,60 M | no principal | retirado | **KPI 347 M eliminado**; el gráfico de p. 06 sigue mostrando `EBITDA_Impact_USD` rotulado capa sintética | sí / parcial (rotulado) |
| "40 fallos predichos" | no principal | retirado | **KPI eliminado** | sí / sí |
| Horas 110.046 → 12.812 | no principal | retirado | KPI "13 mil" conservado y rotulado capa sintética (p. 07) | sí / rotulado |
| Valor protegido 2.000 USD / 2,4 h | no son del dossier | rotulado "Simulación ilustrativa · no es una cifra del proyecto" | no aparece | sí |
| π = 15 % | hipótesis de precio pendiente | rotulado "hipótesis de precio (rango 10–20 %)" | rotulado en p. 06 | sí / sí |
| Implantación 24 M USD | supuesto académico adoptado | rotulado supuesto académico | rotulado en p. 06 | sí / sí |

## 2. Las seis conclusiones (3.7): dónde se leen
| # | Conclusión | Front HTML | SAS VA |
|---|---|---|---|
| 1 | El problema es el grupo C; LGTI lo reduce | Inicio (regla conservadora + leyenda A/B/C), Seguimiento | p. 01 (texto), p. 03 (texto con leyenda A/B/C) |
| 2 | Deduplicar población por campaña | Impacto, "Referencia pública" | **no se lee en SAS** (pendiente) |
| 3 | Dos indicadores; 87,6 % | Inicio, Seguimiento | p. 01, 03, 08 |
| 4 | AUC 0,76, línea 0,15, 62 %; excluir lo decide la genealogía | Calidad | p. 01, 05 |
| 5 | Coste evitado sobre Bolt 2.000 M USD; pesa la probabilidad | Impacto (tornado, lectura ejecutiva) | p. 06 |
| 6 | Sintéticos demuestran el método; capas no comparables | Calidad, Impacto, Seguimiento, pie | p. 02, 04, 05, 06, 07, 08 (rótulos de capa) |

## 3. Vocabulario
- Escenarios Conservador / Base / Alto: coinciden en HTML y SAS (p. 06).
- Grupos A, B y C: leyenda añadida en HTML (Inicio) y en SAS (p. 03, texto). Verificado en navegador.
- Fórmulas F1–F10, P, G, S: **no se muestran** (decisión de Iker); verificado en HTML (sin F1–F10 visibles).
- Categorías de cifra y rótulo de capa: HTML con control "i"; SAS con texto en cada página. "Objetivo de diseño" no se usa en ninguno.
- Pendiente: nombres de campo de los gráficos de SAS siguen en inglés (p. ej. `Risk_Probability`, `Supplier`); las tablas nuevas sí tienen etiquetas en español.

## 4. Limitaciones y pendientes en SAS (honestidad)
- Las cifras del dossier en SAS son **texto estático** en objetos "Texto": no están enlazadas a las tablas `LGTI_*`, aunque las tablas están cargadas en CASUSER y añadidas al informe. Un intento de tabla de lista con `LGTI_UMBRALES` falló (las medidas se agregan en una fila; no hay opción "sin agregar" y no se pudo reclasificar la línea como categoría) y se retiró.
- ~~Página 05 sin datos / página 03 vacía~~ → **resueltas en la ronda 4** (ver sección 7).
- KPI 605 mil y 91 (p. 01) conservados, rotulados como capa sintética en el texto de la página.
- Página "00 Prototipo histórico - no presentar": oculta, **no se tocó**.
- Copias de seguridad: "LGES Traceability Intelligence - respaldo" (creada en esta sesión) y una copia preexistente "… 31/10/2026 21:32:10".
- Quedan en SAS Studio una pestaña "Programa SAS" sin guardar (mi prueba) y la pestaña `cargar_coherencia.sas` con el programa antiguo; el programa válido está en `coherencia/cargar_coherencia.sas` del repo.
- El programa se ejecutó en dos partes tecleadas (no el fichero tal cual); mismo contenido.

## 5. Cifras que Iker debe revisar a mano en el dossier (Google Docs)
| Cifra | Apartado | Valor correcto |
|---|---|---|
| Vehículos retirados / cargo / recuperado | 4.1 | 142.000 · 2.000 M USD · 1.900 M USD (≈ 95 %) |
| Coste medio por vehículo | F1 | 14.085 USD |
| 110.324 | plan original | NO usar |
| POTAFF bruta / deduplicada | NHTSA | 24.375.746 / 1.511.316 (≈ 16 veces menos) |
| Genealogía completa | 4.2 | 87,6 % (530.200 / 605.250), no 96,3 % ni 96 % |
| Registros con genealogía incompleta | 4.2 | 231 de 1.800 (dos indicadores); el "71" solo cuenta el primero |
| Grupo C | 4.2 | 75.050 unidades (12,4 %) |
| Fallos / AUC / línea | 4.2 | 130 · 0,76 · 0,15 |
| Línea 0,15 | 4.2 | 545 vigiladas (30,3 %), 81 de 130, sensibilidad 62 % |
| Tabla 7 | 4.3 | sección 3.5; pago base 12,08 y B base 68,43 (exactos 12,075 / 68,425) |
| Recuperación con I = 6,2 / 24 / 50 M USD | sensibilidad | 0,09 / 0,35 / 0,73 años |

## 6. Veredicto de coherencia
Front HTML ↔ dossier: **coincide** en todo lo verificado. SAS ↔ dossier: **coincide en cifras** (texto estático), con las limitaciones de la sección 4.

## 7. Ronda 4 — correcciones en SAS VA (31-10-2026)
**Reconocimiento de errores previos:** (a) la ronda anterior daba por hecho que la página 08 decía 231; al abrirla en lectura seguía diciendo 71 (la edición no persistió y yo solo había validado 01–07 en lectura); (b) durante esta ronda confundí el icono "Deshacer" con "Guardar", lo que revirtió y rehízo cambios hasta detectarlo. El estado final se verificó recargando el informe y recorriendo las páginas en modo lectura (capturas de la sesión).

| Punto | Resultado | Verificado en lectura |
|---|---|---|
| 1. Pág. 05: dispersión sin roles | **Hecho.** Objeto antiguo (sin roles que persistieran) eliminado y sustituido por uno nuevo con Risk_Probability (X), Temperature_Max_C (Y) y Risk_Level (color). Es una "dispersión de medidas seleccionadas" (rol Medidas), no un scatter con ejes X/Y independientes | sí, con datos |
| 2. Pág. 08: 71 → 231 y fuentes reales | **Hecho.** Texto reescrito: NHTSA (campañas, reclamaciones, seguimiento, POTAFF), costes públicos Bolt y Kona, capa sintética (231 de 1.800 incompletos; 87,6 %; grupo C 75.050). Sin "pendiente de validación" | sí, persiste tras recargar |
| 3. Pág. 01 primera y 3 cifras | **Hecho.** Movida a la primera posición (panel Estructura). Eliminados los KPI 605 mil y 91. Tres cifras en texto grande: 142.000 vehículos (dato público observado), 87,6 % (cálculo derivado) y 68,43 M USD (supuesto académico), más texto explicativo | sí |
| 4. Pág. 06: barras de escenarios | **Hecho.** Gráfico de barras nuevo con `LGTI_ESCENARIOS` (coste evitado y beneficio neto por escenario, M USD). Gráfico mensual sintético (con "EBITDA" en el título) **eliminado**. Texto de la Tabla 7 reescrito sin referencia al gráfico retirado | sí |
| 5. Pág. 07: horas y días separados | **Hecho.** `Resolution_Days` quitado del gráfico de horas y puesto en un gráfico propio por línea de producción | sí |
| 6. Pág. 03: nodos con nombre y más grandes | **Parcial.** Etiquetas de datos activadas (se leen Ochang, NovaCath Industries, Wroclaw…), tamaño del nodo 20→41 % y distancia 20→77 %. Los nodos siguen solapándose parcialmente por el poco espacio del objeto; el rol "Etiqueta" no admite campos de nodo | sí (solapamiento visible) |

Pendientes: la tabla "Pasaporte digital" y la red de la 03 sí cargan ahora en lectura (en la ronda anterior salían vacías; sin causa identificada, posiblemente carga lenta); los gráficos de 02–07 siguen sobre `LGES_TRACEABILITY_ES`; las cifras de 01, 05 y 06 son texto estático; la página 00 (oculta) no se ha abierto ni tocado; el scatter de la 05 usa solo dos medidas.
