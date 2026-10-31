# Contexto: coherencia entre el dossier y los dos fronts de LGTI

## 1. Proyecto
Proyecto universitario (ADE + Business Analytics), defendido ante un tribunal con demostración en las oficinas de SAS. LGTI (LG Traceability Intelligence) es una empresa HIPOTÉTICA que vende, como proveedor externo de software, una plataforma de trazabilidad, calidad y valoración económica del riesgo a LG Energy Solution (LGES). Referencia: retiradas del Chevrolet Bolt. Sin vínculo real con LG; sin logotipo de LG.

Hay tres piezas que deben decir lo mismo:
1. **El dossier** (documento de unas 10 páginas, ya redactado en Google Docs, cuyas cifras figuran en la sección 3 de este archivo).
2. **El front web HTML** (`index.html`, HTML + Three.js; páginas Inicio, Seguimiento, Calidad, Impacto económico; carpeta `claude-code-test`).
3. **El informe de SAS Visual Analytics** "LGES Traceability Intelligence · Torre de Control" (7 páginas útiles; hay una "00 Prototipo histórico" que no se presenta).

**Regla central (decisión de Iker):** las cifras, las conclusiones y las explicaciones que muestren ambos fronts deben ser las mismas que las del dossier. La fuente única de cifras es la sección 3 de este archivo.

## 2. Reglas de rigor (obligatorias)
- Separar siempre cuatro categorías: dato público observado, cálculo derivado, supuesto académico, objetivo de diseño. Cada cifra visible lleva su categoría (en el front, con el control "i" que ya existe en Impacto; en SAS, en una nota o columna).
- Los datos sintéticos se etiquetan "elaboración propia, datos sintéticos". Nunca se presentan como datos internos o históricos de LGES.
- No mezclar la capa real/escenarios (dossier 4.1 y 4.2) con la capa sintética. Cualquier cifra que se muestre y NO esté en la sección 3 debe ir rotulada "capa sintética (demostración del método)" y listarse en el inventario de incidencias para que Iker decida si se quita.
- No afirmar que el modelo descubre un defecto real: demuestra el método.
- Sin evidencia de genealogía completa, la unidad NO se excluye.
- Evitar doble conteo entre coste evitado, ahorro operativo e impacto EBITDA.
- No presentar módulos de SAS cuya licencia no esté confirmada (núcleo: DATA step, PROC SQL, FREQ, MEANS, TABULATE, Visual Analytics).
- Formato: coma decimal y punto de millares, moneda USD, "M USD" para millones, siglas desplegadas la primera vez.
- Si no se puede verificar algo, marcar "supuesto no verificado". No inventar cifras.

## 3. Tabla maestra de cifras (fuente única)
Identificadores de fórmula: F1 a F10 (ver 3.8). Las tres fórmulas sin número en el dossier se nombran P (población deduplicada), G (genealogía completa) y S (sensibilidad).

### 3.1 Caso Bolt (datos reales)
| Id | Cifra | Valor | Categoría |
|---|---|---:|---|
| R01 | Vehículos retirados Bolt (GM) | 142.000 | dato público observado |
| R02 | Cargo total de la retirada | 2.000 M USD | dato público observado |
| R03 | Importe recuperado de LGES | 1.900 M USD (≈ 95 %) | dato público observado |
| R04 | Coste medio por vehículo (F1: c = C/N) | 14.085 USD | cálculo derivado |
| R05 | Kona EV: coste estimado / vehículos / por vehículo | ≈ 900 M USD / 81.701 / 11.016 USD | observado y derivado; denominador global, NO mezclar con población NHTSA (12.256 en EE. UU.) |
| R06 | Suma de las tres campañas principales del Bolt | 50.932 + 57.414 + 52.414 = 160.760 | cálculo derivado (suma de actuaciones, no de vehículos distintos) |
| R07 | 110.324 (cifra del plan original) | NO usar | supuesto no verificado, no reproducible |

### 3.2 Base de datos (NHTSA) y limpieza
- Campañas: 246.908 registros → 172 campañas de batería de tracción (8 en el perímetro Bolt/Kona).
- Reclamaciones: 1.117.364 → 1.822 filas (1.282 reclamaciones distintas); 1.026 pertenecen a más de una campaña, por eso los recuentos por campaña no son aditivos (se cuentan por modelo).
- Seguimiento trimestral: 76.663 → 851.
- POTAFF (población afectada) en baterías de tracción: suma bruta 24.375.746; deduplicada por CAMPNO 1.511.316 (≈ 16 veces menos). Fórmula P = Σ POTAFF_c, una observación por campaña.
- Investigación EQ22-001: 6 de 7 campañas presentes; la 22V-077 figura como "HYBRID PROPULSION SYSTEM" (componente ambiguo) y queda excluida.
- F2 (tasa de reparación t = R/P). Ejemplo 21V-560: 51.834 / 57.414 = 90,3 %.
- F3 (plazo de detección d = RCDATE − mín(LDATE | FIRE = Y), en días). Ejemplo 20V-701: 494 días. Negativo en 2 campañas del Kona (−393 y −254): indicador de plazo, no prueba causal.

### 3.3 Capa sintética: genealogía
- 1.800 registros, 605.250 unidades, 5 proveedores, 4 plantas.
- Cadena: Proveedor → Lote de material (200) → Lote de celdas (397) → Celda (1.800) → Módulo (450) → Pack (1.800) → VIN (1.800).
- Regla de prudencia: genealogía completa solo si `Genealogy_Complete = 1` Y `Documentation_Status = 'Completa'`. 228 de 1.800 registros discrepan (160 y 68).
- G = unidades completas / unidades totales = 530.200 / 605.250 = **87,6 %**. Con solo `Genealogy_Complete`: 582.550 / 605.250 = 96,3 % (NO es la cifra oficial).
- Unidades sin evidencia completa: 75.050 (12,4 %): grupo C.
- Grupos: A (expuestas con evidencia, se retiran), B (no expuestas con evidencia, se excluyen y se audita), C (sin evidencia, se retiran por prudencia). LGTI reduce C.

### 3.4 Predicción de fallos (capa sintética)
- 130 fallos reales en 1.800 registros. Probabilidad de riesgo (`Risk_Probability`): AUC = 0,76.
- Línea de vigilancia recomendada: **0,15**.
| Línea | Unidades vigiladas | % de registros | Fallos detectados (de 130) | Sensibilidad |
|---:|---:|---:|---:|---:|
| 0,50 | 39 | 2,2 % | 21 | 16 % |
| 0,20 | 332 | 18,4 % | 66 | 51 % |
| **0,15** | **545** | **30,3 %** | **81** | **62 %** |
| 0,10 | 903 | 50,2 % | 104 | 80 % |
(Las cifras de esta tabla se calculan aplicando cada línea a `Risk_Probability` con `Failure_Actual` como fallo real. La columna `Failure_Predicted` del dataset marca 40 unidades, una más que la línea 0,50; para el front y el informe usar siempre la regla `Risk_Probability ≥ línea`.)
- S = VP / (VP + FN). Con 0,15: 81 / 130 = 62 %.
- Prohibido usar `Defect_Flag` como variable predictora (los 98 defectos son todos fallos reales: sería circular).
- La exclusión se decide con la genealogía; la probabilidad de riesgo solo sirve para priorizar vigilancia.

### 3.5 Impacto económico: escenarios (Tabla 7 del dossier)
Punto de partida común: 142.000 vehículos, 14.085 USD por vehículo (F1), retirada amplia 2.000 M USD.
| | Conservador | Base | Alto |
|---|---:|---:|---:|
| Reducción de población (supuesto) | 40 % | 65 % | 80 % |
| Coste evitado si ocurre el evento (F6), M USD | 800 | 1.300 | 1.600 |
| Probabilidad anual del evento (supuesto) | 2 % | 5 % | 10 % |
| Ahorro operativo anual (supuesto), M USD | 7 | 15,5 | 33 |
| Valor anual creado V (F7), M USD | 23,00 | 80,50 | 193,00 |
| Pago a LGTI, π = 15 % (F8), M USD | 3,45 | 12,08 | 28,95 |
| Beneficio neto del cliente B (F9), M USD | 19,55 | 68,43 | 164,05 |
| Coste de implantación I (supuesto) | 24 M USD | 24 M USD | 24 M USD |
| Recuperación de la inversión T = I/B (F10), años | 1,23 | 0,35 | 0,15 |
- Por cada dólar pagado a LGTI el cliente obtiene (1 − π)/π = 5,7 USD de beneficio neto.
- Sensibilidad sobre B del escenario base (68,43 M USD; una variable cada vez, con valores de los otros escenarios): probabilidad 2 %–10 %: 35,3–123,7; reducción 40 %–80 %: 47,2–81,2; ahorro operativo 7–33: 61,2–83,3; π 10 %–20 %: 72,5–64,4. El supuesto que más pesa es la probabilidad del evento; I solo afecta al plazo.
- Referencias de sensibilidad de I: 6,2 M USD (dataset sintético) → T base 0,09 años; 24 M USD (plan original, ADOPTADO) → 0,35; 50 M USD → 0,73. Nota: el coste de implantación de 24 M USD está adoptado como supuesto académico; pendiente de confirmación final de Iker.
- Fórmulas: F4 C_amplia = N_a × c; F5 C_dirigida = N_d × c; F6 C_evitado = C_amplia − C_dirigida = (N_a − N_d) × c; F7 V = p × C_evitado + A; F8 P_LGTI = π × V; F9 B = V − P_LGTI; F10 T = I / B.
- El precio de LGTI (π) es una hipótesis (rango 10–20 %, por defecto 15 %), pendiente de decidir.
- Nota: GM recuperó el 95 % del cargo de LGES; el ahorro se atribuye al cliente (LGES).

### 3.6 Lo que NO debe aparecer como cifra principal
Las cifras del dataset sintético antiguo: EBITDA 346,60 M USD, coste de retirada amplia 721,98 M, dirigida 399,57 M, coste evitado 322,42 M, cobertura de trazabilidad 96 %, "40 fallos predichos", horas de investigación 110.046 → 12.812 (−88 %), 6,2 M USD de implantación como valor por defecto. Si alguna se conserva, va rotulada "capa sintética" y no se compara con 3.5.

### 3.7 Conclusiones del dossier que los fronts deben reproducir
1. El problema es retirar por prudencia las unidades sin evidencia (grupo C). El valor de LGTI es reducir C completando la genealogía.
2. Las cifras de población deben deduplicarse por campaña antes de sumar.
3. La genealogía completa exige dos indicadores coincidentes; 87,6 % de las unidades sintéticas la cumplen.
4. La nota de riesgo ordena bien (AUC 0,76) pero solo sirve para priorizar vigilancia, con línea 0,15 (62 % de fallos detectados, 30,3 % de unidades vigiladas). Excluir se decide con genealogía.
5. El coste evitado se calcula sobre la retirada real del Bolt (2.000 M USD) con tres supuestos de reducción; el supuesto que más pesa es la probabilidad anual del evento.
6. Los datos sintéticos demuestran el método, no un defecto real de LGES. Las dos capas (escenarios y sintética) no son comparables.

### 3.8 Fórmulas del dossier
F1 c = C/N (coste medio por vehículo). F2 t = R/P. F3 d = RCDATE − mín(LDATE | FIRE = Y). F4–F6 coste amplia, dirigida y evitado. F7–F10 valor, pago, beneficio, plazo. Sin número: P (población deduplicada), G (proporción de genealogía completa), S (sensibilidad).

## 4. Estado actual a corregir (inventario inicial, verificar)
**Front HTML (`index.html`, 528 líneas, ≈ 182 KB, una sola página con enrutado por hash).**
- Genera el dataset en el navegador: `DATA.cargarDataset() → generateDataset(DEFAULT_CONFIG)` con `packCount:1800`, `genealogyRate:.96`, `seed:88421`, `unitCost:5000`, `costRange:[2500,10000]`, `scenarios:{Conservador:2500,Base:5000,Alto:10000}`. Por tanto sus agregados NO coinciden con la base maestra.
- Impacto económico: población 110.324 y costes 2.500/5.000/10.000 USD en textos y cálculos (aparecen en varias líneas, entre ellas 153, 156, 168, 201, 216, 276–285); porcentaje de LGTI por defecto 15 %; incluye cascada, tornado, tabla de escenarios, agregados del dataset, serie mensual y productividad.
- Calidad: umbral del modelo por defecto 0,5 (línea 440); matriz de confusión y KPI (PPM, FPY, control estadístico) calculados sobre el dataset generado.
- Inicio y Seguimiento: simulación en vivo del almacén 3D; los textos pueden citar cifras.
**SAS Visual Analytics:** informe con fuentes `LGES_TRACEABILITY_ES` y `LGES_NETWORK_EDGES` (dataset sintético antiguo). Cifras visibles conocidas: EBITDA ≈ 347 M, 605 mil unidades, cumplimiento 91, "40 fallos predichos", cobertura de genealogía 96 %, red proveedor → planta.
**Base maestra (xlsx):** `LGTI_master_db.xlsx`, 8 tablas + Diccionario, Calidad, Calidad_Resumen, Linaje, Fórmulas, Cifras. Pendiente de aplicar: regla de genealogía de los dos indicadores y tabla puente reclamación-campaña.

## 5. Qué NO tocar
- La escena 3D (Three.js), el almacén, la simulación en vivo de Seguimiento, la landing de Inicio (salvo cifras y textos que contradigan la sección 3), la navegación y el diseño visual.
- La página "00 Prototipo histórico" de SAS (no se presenta; no editarla).
- Los ficheros originales de NHTSA y la carpeta de la base maestra (solo lectura).
