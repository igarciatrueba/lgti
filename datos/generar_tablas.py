#!/usr/bin/env python3
"""Regenera las tablas de coherencia del dossier desde la base maestra."""

from __future__ import annotations

import csv
import json
import math
import sys
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path


SOURCE = (
    Path(__file__).resolve().parents[1]
    / "sas"
    / "csv"
    / "Synthetic_Traceability.csv"
)
OUTPUT_DIR = Path(__file__).resolve().parent

TEXT_FIELDS = (
    "Record_ID", "Supplier", "Cell_Plant", "Production_Month",
    "Production_Line", "Shift", "Material_Lot", "Cell_Lot", "Cell_ID",
    "Module_ID", "Battery_Pack_ID", "VIN", "Vehicle_Model",
    "Documentation_Status", "Risk_Level", "Defect_Type", "Severity",
    "Alert_Status", "Recall_Status", "Capa",
)
INTEGER_FIELDS = (
    "Genealogy_Complete", "Failure_Actual", "Defect_Flag",
    "Units_Represented", "Charge_Cycles",
)
FLOAT_FIELDS = (
    "Risk_Probability", "Compliance_Score", "Temperature_Max_C", "Voltage_V",
    "Internal_Resistance_mOhm", "Resolution_Days",
    "Investigation_Hours_Before", "Investigation_Hours_After",
    "Broad_Recall_Cost_USD", "Targeted_Recall_Cost_USD",
    "Avoided_Recall_Cost_USD", "Productivity_Savings_USD",
    "Implementation_Allocated_USD", "EBITDA_Impact_USD",
)
DATASET_FIELDS = TEXT_FIELDS + INTEGER_FIELDS + FLOAT_FIELDS

CATEGORIES = {
    "dato público observado", "cálculo derivado", "supuesto académico",
    "objetivo de diseño",
}
LAYERS = {"REAL", "SINTETICA", "ESCENARIO"}


def half_up(value: Decimal, places: int = 2) -> Decimal:
    quantum = Decimal(1).scaleb(-places)
    return value.quantize(quantum, rounding=ROUND_HALF_UP)


def decimal_text(value: object) -> str:
    if isinstance(value, Decimal):
        return format(value, "f")
    return str(value)


def load_source() -> list[dict[str, str]]:
    if not SOURCE.is_file():
        raise FileNotFoundError(f"No se encuentra la base maestra: {SOURCE}")
    with SOURCE.open(encoding="utf-8-sig", newline="") as handle:
        rows = list(csv.DictReader(handle))
    assert len(rows) == 1800, f"Registros: {len(rows)} != 1800"
    missing = set(DATASET_FIELDS) - set(rows[0])
    assert not missing, f"Faltan columnas en la base maestra: {sorted(missing)}"
    return rows


def auc_roc(rows: list[dict[str, str]]) -> float:
    """Calcula AUC por suma de rangos, asignando rango medio a empates."""
    ordered = sorted(
        ((float(row["Risk_Probability"]), int(row["Failure_Actual"])) for row in rows),
        key=lambda pair: pair[0],
    )
    positive_ranks = 0.0
    index = 0
    while index < len(ordered):
        end = index + 1
        while end < len(ordered) and ordered[end][0] == ordered[index][0]:
            end += 1
        average_rank = ((index + 1) + end) / 2
        positive_ranks += average_rank * sum(label for _, label in ordered[index:end])
        index = end
    positives = sum(label for _, label in ordered)
    negatives = len(ordered) - positives
    return (positive_ranks - positives * (positives + 1) / 2) / (positives * negatives)


def calculate_metrics(rows: list[dict[str, str]]) -> dict[str, object]:
    total_units = sum(int(row["Units_Represented"]) for row in rows)
    simple_complete_units = sum(
        int(row["Units_Represented"])
        for row in rows
        if row["Genealogy_Complete"] == "1"
    )
    complete_units = sum(
        int(row["Units_Represented"])
        for row in rows
        if row["Genealogy_Complete"] == "1" and row["Documentation_Status"] == "Completa"
    )
    failures = sum(int(row["Failure_Actual"]) for row in rows)
    discrepancy_genealogy = sum(
        row["Genealogy_Complete"] == "1" and row["Documentation_Status"] != "Completa"
        for row in rows
    )
    discrepancy_documentation = sum(
        row["Genealogy_Complete"] == "0" and row["Documentation_Status"] == "Completa"
        for row in rows
    )
    thresholds = []
    for line in (Decimal("0.50"), Decimal("0.20"), Decimal("0.15"), Decimal("0.10")):
        selected = [row for row in rows if Decimal(row["Risk_Probability"]) >= line]
        detected = sum(int(row["Failure_Actual"]) for row in selected)
        thresholds.append({
            "linea": format(line, ".2f"),
            "unidades_vigiladas": len(selected),
            "pct_registros": decimal_text(half_up(Decimal(len(selected)) * 100 / len(rows), 1)),
            "fallos_detectados": detected,
            "fallos_totales": failures,
            "sensibilidad_pct": int(half_up(Decimal(detected) * 100 / failures, 0)),
            "capa": "SINTETICA",
        })
    return {
        "total_units": total_units,
        "simple_complete_units": simple_complete_units,
        # El dossier publicó 96.3 tras redondear primero 96.249... a centésimas.
        # Se conserva solo como referencia explícitamente marcada "NO usar".
        "simple_complete_pct": half_up(
            half_up(Decimal(simple_complete_units) * 100 / total_units, 2), 1
        ),
        "complete_units": complete_units,
        "incomplete_units": total_units - complete_units,
        "complete_pct": half_up(Decimal(complete_units) * 100 / total_units, 1),
        "failures": failures,
        "auc": auc_roc(rows),
        "providers": len({row["Supplier"] for row in rows}),
        "plants": len({row["Cell_Plant"] for row in rows}),
        "material_lots": len({row["Material_Lot"] for row in rows}),
        "cell_lots": len({row["Cell_Lot"] for row in rows}),
        "cells": len({row["Cell_ID"] for row in rows}),
        "modules": len({row["Module_ID"] for row in rows}),
        "packs": len({row["Battery_Pack_ID"] for row in rows}),
        "vins": len({row["VIN"] for row in rows}),
        "discrepancy_genealogy": discrepancy_genealogy,
        "discrepancy_documentation": discrepancy_documentation,
        "discrepancies": discrepancy_genealogy + discrepancy_documentation,
        "failure_predicted": sum(int(row["Failure_Predicted"]) for row in rows),
        "defects": sum(int(row["Defect_Flag"]) for row in rows),
        "defect_failures": sum(
            int(row["Defect_Flag"] == "1" and row["Failure_Actual"] == "1")
            for row in rows
        ),
        "thresholds": thresholds,
    }


def assert_master_figures(metrics: dict[str, object]) -> None:
    assert metrics["total_units"] == 605250, "Unidades totales distintas del dossier"
    assert metrics["complete_units"] == 530200, "Unidades con genealogía distintas del dossier"
    assert metrics["incomplete_units"] == 75050, "Grupo C distinto del dossier"
    assert metrics["complete_pct"] == Decimal("87.6"), "Porcentaje G distinto del dossier"
    assert metrics["simple_complete_units"] == 582550, "Genealogía simple distinta del dossier"
    assert metrics["simple_complete_pct"] == Decimal("96.3"), "Porcentaje simple distinto del dossier"
    assert metrics["discrepancies"] == 228, "Discrepancias distintas del dossier"
    assert metrics["discrepancy_genealogy"] == 160, "Primer tipo de discrepancia distinto"
    assert metrics["discrepancy_documentation"] == 68, "Segundo tipo de discrepancia distinto"
    assert (
        metrics["providers"], metrics["plants"], metrics["material_lots"],
        metrics["cell_lots"], metrics["cells"], metrics["modules"],
        metrics["packs"], metrics["vins"],
    ) == (5, 4, 200, 397, 1800, 450, 1800, 1800), "Cadena de linaje distinta"
    assert metrics["failures"] == 130, "Fallos reales distintos del dossier"
    assert metrics["failure_predicted"] == 40, "Failure_Predicted distinto del dossier"
    assert metrics["defects"] == metrics["defect_failures"] == 98, "Defect_Flag ya no es circular"
    auc_display = half_up(Decimal(str(metrics["auc"])), 2)
    assert auc_display == Decimal("0.76"), f"AUC {auc_display} distinta del dossier"
    actual = [
        (row["unidades_vigiladas"], row["fallos_detectados"], row["sensibilidad_pct"])
        for row in metrics["thresholds"]
    ]
    expected = [(39, 21, 16), (332, 66, 51), (545, 81, 62), (903, 104, 80)]
    assert actual == expected, f"Umbrales distintos del dossier: {actual}"


def calculate_scenarios() -> list[dict[str, object]]:
    broad_cost = Decimal("2000")
    implementation = Decimal("24")
    lgti_share = Decimal("0.15")
    assumptions = (
        ("Conservador", Decimal("0.40"), Decimal("0.02"), Decimal("7")),
        ("Base", Decimal("0.65"), Decimal("0.05"), Decimal("15.5")),
        ("Alto", Decimal("0.80"), Decimal("0.10"), Decimal("33")),
    )
    scenarios = []
    for name, reduction, probability, operating_saving in assumptions:
        directed_cost = broad_cost * (1 - reduction)  # F5
        avoided_cost = broad_cost - directed_cost  # F6
        value_created = probability * avoided_cost + operating_saving  # F7
        payment = lgti_share * value_created  # F8
        client_benefit = value_created - payment  # F9
        payback = implementation / client_benefit  # F10
        scenarios.append({
            "escenario": name,
            "vehiculos_retirada_amplia": 142000,
            "coste_unitario_usd": 14085,
            "retirada_amplia_musd": decimal_text(broad_cost),
            "reduccion_poblacion_pct": decimal_text(reduction * 100),
            "vehiculos_retirada_dirigida": int(Decimal(142000) * (1 - reduction)),
            "coste_dirigido_musd": decimal_text(half_up(directed_cost)),
            "coste_evitado_musd": decimal_text(half_up(avoided_cost)),
            "probabilidad_evento_pct": decimal_text(probability * 100),
            "ahorro_operativo_musd": decimal_text(operating_saving),
            "valor_anual_creado_musd": decimal_text(half_up(value_created)),
            "porcentaje_lgti_pct": decimal_text(lgti_share * 100),
            "pago_lgti_musd": decimal_text(half_up(payment)),
            "beneficio_neto_cliente_musd": decimal_text(half_up(client_benefit)),
            "coste_implantacion_musd": decimal_text(implementation),
            "recuperacion_inversion_anos": decimal_text(half_up(payback)),
            "capa": "ESCENARIO",
        })
    return scenarios


def figure(
    identifier: str,
    label: str,
    value: object,
    unit: str,
    category: str,
    layer: str,
    source: str,
    section: str,
) -> dict[str, str]:
    assert category in CATEGORIES
    assert layer in LAYERS
    return {
        "id": identifier, "cifra": label, "valor": decimal_text(value), "unidad": unit,
        "categoria": category, "capa": layer, "fuente": source,
        "apartado_dossier": section,
    }


def build_figures(metrics: dict[str, object], scenarios: list[dict[str, object]]) -> list[dict[str, str]]:
    public = "dato público observado"
    derived = "cálculo derivado"
    assumed = "supuesto académico"
    objective = "objetivo de diseño"
    rows = [
        figure("R01", "Vehículos retirados Bolt por GM", 142000, "vehículos", public, "REAL", "GM y dossier", "3.1"),
        figure("R02", "Cargo total de la retirada Bolt", 2000, "M USD", public, "REAL", "GM y dossier", "3.1"),
        figure("R03", "Importe recuperado de LGES", 1900, "M USD", public, "REAL", "GM y dossier", "3.1"),
        figure("R03_PCT", "Proporción recuperada de LGES", 95, "%", derived, "REAL", "F1 y dossier", "3.1"),
        figure("R04", "Coste medio por vehículo Bolt (F1)", 14085, "USD/vehículo", derived, "REAL", "F1: 2000 M USD / 142000", "3.1"),
        figure("R05", "Kona EV coste estimado", 900, "M USD", public, "REAL", "Dossier", "3.1"),
        figure("R05_VEHICULOS", "Kona EV vehículos del denominador global", 81701, "vehículos", public, "REAL", "Dossier", "3.1"),
        figure("R05_COSTE_MEDIO", "Kona EV coste medio por vehículo", 11016, "USD/vehículo", derived, "REAL", "F1 y dossier", "3.1"),
        figure("R05_NHTSA_USA", "Kona EV población NHTSA en Estados Unidos no comparable", 12256, "vehículos", public, "REAL", "NHTSA", "3.1"),
        figure("R06_CAMP_1", "Actuaciones primera campaña Bolt", 50932, "actuaciones", public, "REAL", "NHTSA", "3.1"),
        figure("R06_CAMP_2", "Actuaciones segunda campaña Bolt", 57414, "actuaciones", public, "REAL", "NHTSA", "3.1"),
        figure("R06_CAMP_3", "Actuaciones tercera campaña Bolt", 52414, "actuaciones", public, "REAL", "NHTSA", "3.1"),
        figure("R06", "Suma de actuaciones de tres campañas Bolt", 160760, "actuaciones", derived, "REAL", "50932 + 57414 + 52414", "3.1"),
        figure("R07", "NO usar: cifra no reproducible del plan original", 110324, "vehículos", assumed, "REAL", "Plan original no verificado", "3.1"),
        figure("NHTSA_CAMP_REG", "Registros de campañas NHTSA", 246908, "registros", public, "REAL", "NHTSA", "3.2"),
        figure("NHTSA_CAMP_BAT", "Campañas de batería de tracción", 172, "campañas", derived, "REAL", "NHTSA depurada", "3.2"),
        figure("NHTSA_CAMP_PERIM", "Campañas en perímetro Bolt y Kona", 8, "campañas", derived, "REAL", "NHTSA depurada", "3.2"),
        figure("NHTSA_RECL_REG", "Registros de reclamaciones NHTSA", 1117364, "registros", public, "REAL", "NHTSA", "3.2"),
        figure("NHTSA_RECL_FILAS", "Filas de reclamaciones filtradas", 1822, "filas", derived, "REAL", "NHTSA depurada", "3.2"),
        figure("NHTSA_RECL_UNICAS", "Reclamaciones distintas", 1282, "reclamaciones", derived, "REAL", "NHTSA depurada", "3.2"),
        figure("NHTSA_RECL_MULTI", "Reclamaciones ligadas a más de una campaña", 1026, "reclamaciones", derived, "REAL", "NHTSA depurada", "3.2"),
        figure("NHTSA_SEGUIM_REG", "Registros de seguimiento trimestral", 76663, "registros", public, "REAL", "NHTSA", "3.2"),
        figure("NHTSA_SEGUIM_FILAS", "Filas de seguimiento filtradas", 851, "filas", derived, "REAL", "NHTSA depurada", "3.2"),
        figure("NHTSA_POTAFF_BRUTA", "Población afectada bruta", 24375746, "vehículos", derived, "REAL", "NHTSA POTAFF", "3.2"),
        figure("NHTSA_POTAFF_DEDUP", "Población afectada deduplicada por CAMPNO", 1511316, "vehículos", derived, "REAL", "Fórmula P", "3.2"),
        figure("NHTSA_POTAFF_FACTOR", "Factor de sobreconteo aproximado", 16, "veces", derived, "REAL", "POTAFF bruta / deduplicada", "3.2"),
        figure("NHTSA_EQ_PRESENTES", "Campañas EQ22-001 presentes", 6, "campañas", derived, "REAL", "NHTSA depurada", "3.2"),
        figure("NHTSA_EQ_TOTAL", "Campañas EQ22-001 esperadas", 7, "campañas", public, "REAL", "NHTSA", "3.2"),
        figure("NHTSA_F2_REPARADAS", "Vehículos reparados campaña 21V-560", 51834, "vehículos", public, "REAL", "NHTSA", "3.2"),
        figure("NHTSA_F2_POBLACION", "Población campaña 21V-560", 57414, "vehículos", public, "REAL", "NHTSA", "3.2"),
        figure("NHTSA_F2_TASA", "Tasa de reparación campaña 21V-560 (F2)", Decimal("90.3"), "%", derived, "REAL", "F2", "3.2"),
        figure("NHTSA_F3_BOLT", "Plazo de detección campaña 20V-701 (F3)", 494, "días", derived, "REAL", "F3", "3.2"),
        figure("NHTSA_F3_KONA_1", "Plazo negativo Kona 1 (indicador)", -393, "días", derived, "REAL", "F3", "3.2"),
        figure("NHTSA_F3_KONA_2", "Plazo negativo Kona 2 (indicador)", -254, "días", derived, "REAL", "F3", "3.2"),
        figure("G_REGISTROS", "Registros sintéticos", 1800, "registros", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_UNIDADES_TOTALES", "Unidades sintéticas representadas", metrics["total_units"], "unidades", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_PROVEEDORES", "Proveedores sintéticos", metrics["providers"], "proveedores", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_PLANTAS", "Plantas sintéticas", metrics["plants"], "plantas", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_LOTES_MATERIAL", "Lotes de material", metrics["material_lots"], "lotes", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_LOTES_CELDAS", "Lotes de celdas", metrics["cell_lots"], "lotes", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_CELDAS", "Celdas", metrics["cells"], "celdas", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_MODULOS", "Módulos", metrics["modules"], "módulos", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_PACKS", "Packs", metrics["packs"], "packs", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_VIN", "VIN", metrics["vins"], "VIN", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_DISCREPANCIAS", "Registros con indicadores de genealogía discrepantes", metrics["discrepancies"], "registros", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_DISCREP_1", "Discrepancia Genealogy=1 y documentación incompleta", metrics["discrepancy_genealogy"], "registros", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_DISCREP_2", "Discrepancia Genealogy=0 y documentación completa", metrics["discrepancy_documentation"], "registros", derived, "SINTETICA", "Base maestra sintética", "3.3"),
        figure("G_UNIDADES_COMPLETAS", "Unidades con genealogía completa por dos indicadores", metrics["complete_units"], "unidades", derived, "SINTETICA", "Regla G", "3.3"),
        figure("G_PCT_COMPLETA", "Genealogía completa oficial", metrics["complete_pct"], "%", derived, "SINTETICA", "Regla G", "3.3"),
        figure("G_UNIDADES_SIN_EVIDENCIA", "Grupo C sin evidencia completa", metrics["incomplete_units"], "unidades", derived, "SINTETICA", "Regla G", "3.3"),
        figure("G_PCT_SIN_EVIDENCIA", "Proporción sin evidencia completa", Decimal("12.4"), "%", derived, "SINTETICA", "Regla G", "3.3"),
        figure("G_SIMPLE_UNIDADES_NO_USAR", "NO usar como genealogía oficial: unidades con un solo indicador", metrics["simple_complete_units"], "unidades", derived, "SINTETICA", "Genealogy_Complete sin documentación", "3.3"),
        figure("G_SIMPLE_PCT_NO_USAR", "NO usar como genealogía oficial: cobertura con un solo indicador", metrics["simple_complete_pct"], "%", derived, "SINTETICA", "Genealogy_Complete sin documentación", "3.3"),
        figure("P_FALLOS", "Fallos reales", metrics["failures"], "fallos", derived, "SINTETICA", "Failure_Actual", "3.4"),
        figure("P_AUC", "Área bajo la curva ROC", half_up(Decimal(str(metrics["auc"])), 2), "AUC", derived, "SINTETICA", "Risk_Probability y Failure_Actual", "3.4"),
        figure("P_LINEA", "Línea de vigilancia recomendada", Decimal("0.15"), "probabilidad", objective, "SINTETICA", "Dossier", "3.4"),
        figure("P_LINEA_REG", "Registros vigilados a línea 0.15", 545, "registros", derived, "SINTETICA", "Risk_Probability >= 0.15", "3.4"),
        figure("P_LINEA_PCT", "Registros vigilados a línea 0.15", Decimal("30.3"), "%", derived, "SINTETICA", "Risk_Probability >= 0.15", "3.4"),
        figure("P_LINEA_FALLOS", "Fallos detectados a línea 0.15", 81, "fallos", derived, "SINTETICA", "Risk_Probability >= 0.15", "3.4"),
        figure("P_LINEA_SENS", "Sensibilidad a línea 0.15", 62, "%", derived, "SINTETICA", "Fórmula S", "3.4"),
        figure("P_FAILURE_PRED_NO_USAR", "NO usar para la línea 0.50: positivos de Failure_Predicted", metrics["failure_predicted"], "registros", derived, "SINTETICA", "Failure_Predicted", "3.4"),
        figure("P_DEFECTOS_NO_PREDICTOR", "Defectos prohibidos como predictor por circularidad", metrics["defects"], "registros", derived, "SINTETICA", "Defect_Flag", "3.4"),
    ]

    for threshold in metrics["thresholds"]:
        line_slug = threshold["linea"].replace(".", "_")
        for key, label, unit in (
            ("unidades_vigiladas", "Registros vigilados", "registros"),
            ("pct_registros", "Proporción de registros vigilados", "%"),
            ("fallos_detectados", "Fallos detectados", "fallos"),
            ("sensibilidad_pct", "Sensibilidad", "%"),
        ):
            rows.append(figure(
                f"P_UMBRAL_{line_slug}_{key.upper()}",
                f"{label} con línea {threshold['linea']}", threshold[key], unit,
                derived, "SINTETICA", "Risk_Probability y Failure_Actual", "3.4",
            ))

    scenario_fields = (
        ("reduccion_poblacion_pct", "Reducción de población", "%", assumed),
        ("coste_evitado_musd", "Coste evitado si ocurre el evento (F6)", "M USD", derived),
        ("probabilidad_evento_pct", "Probabilidad anual del evento", "%", assumed),
        ("ahorro_operativo_musd", "Ahorro operativo anual", "M USD", assumed),
        ("valor_anual_creado_musd", "Valor anual creado (F7)", "M USD", derived),
        ("pago_lgti_musd", "Pago a LGTI (F8)", "M USD", derived),
        ("beneficio_neto_cliente_musd", "Beneficio neto del cliente (F9)", "M USD", derived),
        ("coste_implantacion_musd", "Coste de implantación", "M USD", assumed),
        ("recuperacion_inversion_anos", "Recuperación de la inversión (F10)", "años", derived),
    )
    for scenario in scenarios:
        slug = scenario["escenario"].upper()
        for key, label, unit, category in scenario_fields:
            rows.append(figure(
                f"T7_{slug}_{key.upper()}", f"{label} - {scenario['escenario']}",
                scenario[key], unit, category, "ESCENARIO", "Tabla 7 calculada", "3.5",
            ))

    rows.append(figure("T7_RETORNO_POR_DOLAR", "Beneficio neto por USD pagado a LGTI", Decimal("5.7"), "USD/USD", derived, "ESCENARIO", "(1-pi)/pi", "3.5"))

    base_value = Decimal("80.5")
    sensitivities = (
        ("SENS_PROB_2", "Sensibilidad B con probabilidad 2 %", (Decimal("0.02") * 1300 + Decimal("15.5")) * Decimal("0.85"), derived),
        ("SENS_PROB_10", "Sensibilidad B con probabilidad 10 %", (Decimal("0.10") * 1300 + Decimal("15.5")) * Decimal("0.85"), derived),
        ("SENS_RED_40", "Sensibilidad B con reducción 40 %", (Decimal("0.05") * 800 + Decimal("15.5")) * Decimal("0.85"), derived),
        ("SENS_RED_80", "Sensibilidad B con reducción 80 %", (Decimal("0.05") * 1600 + Decimal("15.5")) * Decimal("0.85"), derived),
        ("SENS_AHORRO_7", "Sensibilidad B con ahorro 7 M USD", (Decimal("0.05") * 1300 + 7) * Decimal("0.85"), derived),
        ("SENS_AHORRO_33", "Sensibilidad B con ahorro 33 M USD", (Decimal("0.05") * 1300 + 33) * Decimal("0.85"), derived),
        ("SENS_PI_10", "Sensibilidad B con precio LGTI 10 %", base_value * Decimal("0.90"), derived),
        ("SENS_PI_20", "Sensibilidad B con precio LGTI 20 %", base_value * Decimal("0.80"), derived),
    )
    for identifier, label, value, category in sensitivities:
        rows.append(figure(identifier, label, half_up(value, 1), "M USD", category, "ESCENARIO", "Sensibilidad Tabla 7", "3.5"))

    exact_base_benefit = Decimal("68.425")
    for investment in (Decimal("6.2"), Decimal("24"), Decimal("50")):
        slug = str(investment).replace(".", "_")
        category = derived if investment == Decimal("6.2") else assumed
        rows.append(figure(f"SENS_I_{slug}_COSTE", f"Referencia de coste I={investment} M USD", investment, "M USD", category, "ESCENARIO", "Sensibilidad de I", "3.5"))
        rows.append(figure(f"SENS_I_{slug}_PLAZO", f"Recuperación base con I={investment} M USD", half_up(investment / exact_base_benefit), "años", derived, "ESCENARIO", "Sensibilidad de I", "3.5"))
    return rows


def build_dataset(rows: list[dict[str, str]]) -> list[dict[str, object]]:
    dataset = []
    for source in rows:
        target: dict[str, object] = {field: source[field] for field in TEXT_FIELDS}
        target.update({field: int(source[field]) for field in INTEGER_FIELDS})
        target.update({field: float(source[field]) for field in FLOAT_FIELDS})
        complete = int(
            target["Genealogy_Complete"] == 1
            and target["Documentation_Status"] == "Completa"
        )
        target["Genealogia_Completa_2ind"] = complete
        target["Grupo_Genealogia"] = "Completa" if complete else "Sin evidencia completa"
        assert all(not isinstance(value, float) or math.isfinite(value) for value in target.values())
        dataset.append(target)
    dataset.sort(key=lambda row: row["Record_ID"])
    return dataset


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: tuple[str, ...] | list[str]) -> None:
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    try:
        source_rows = load_source()
        metrics = calculate_metrics(source_rows)
        assert_master_figures(metrics)
        scenarios = calculate_scenarios()
        figures = build_figures(metrics, scenarios)
        dataset = build_dataset(source_rows)

        write_csv(
            OUTPUT_DIR / "cifras_dossier.csv", figures,
            ("id", "cifra", "valor", "unidad", "categoria", "capa", "fuente", "apartado_dossier"),
        )
        write_csv(OUTPUT_DIR / "escenarios_dossier.csv", scenarios, list(scenarios[0]))
        write_csv(
            OUTPUT_DIR / "umbrales_dossier.csv", metrics["thresholds"],
            ("linea", "unidades_vigiladas", "pct_registros", "fallos_detectados", "fallos_totales", "sensibilidad_pct", "capa"),
        )
        with (OUTPUT_DIR / "dataset_sintetico.json").open("w", encoding="utf-8", newline="\n") as handle:
            json.dump(dataset, handle, ensure_ascii=False, separators=(",", ":"), allow_nan=False)
            handle.write("\n")
        size = (OUTPUT_DIR / "dataset_sintetico.json").stat().st_size
        assert size <= 2_000_000, f"dataset_sintetico.json supera 2 MB: {size} bytes"
    except (AssertionError, FileNotFoundError, KeyError, ValueError) as error:
        print(f"ERROR de coherencia: {error}", file=sys.stderr)
        return 1
    print("Tablas de coherencia regeneradas y verificadas.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
