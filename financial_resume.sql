/*Financial summary for action_plan. Calculations represented as formatted numeric with 
group and decimal separators per locale.*/ 
SELECT 
		aux1 AS "Вариант", 
		COALESCE(fin_source, 'Все') AS "Источ. фин.", 
		TO_CHAR("total", '999G999G999G990D99') AS "Итого", 
		TO_CHAR("2023", '999G999G999G990D99') AS "2023", 
		TO_CHAR("2024", '999G999G999G990D99') AS "2024", 
		TO_CHAR("2025", '999G999G999G990D99') AS "2025", 
		TO_CHAR("2026", '999G999G999G990D99') AS "2026", 
		TO_CHAR("2027", '999G999G999G990D99') AS "2027", 
		TO_CHAR("2028", '999G999G999G990D99') AS "2028", 
		TO_CHAR("2029", '999G999G999G990D99') AS "2029", 
		TO_CHAR("2030", '999G999G999G990D99') AS "2030", 
		TO_CHAR("2031", '999G999G999G990D99') AS "2031", 
		TO_CHAR("2032", '999G999G999G990D99') AS "2032", 
		TO_CHAR("2033", '999G999G999G990D99') AS "2033", 
		TO_CHAR("2034", '999G999G999G990D99') AS "2034", 
		TO_CHAR("2035", '999G999G999G990D99') AS "2035" 
FROM 
		(
			WITH basic_calculation AS 
			(
				/*Basic calculation of costs per years. 
				N.B.: total column is counted as a sum of year columns.*/ 
				SELECT 
					aux1, 
					fin_source, 
					SUM(cost_1 + cost_2 + cost_3 +
						cost_4 + cost_5 + cost_6 + 
						cost_7 + cost_8 + cost_9 + 
						cost_10 + cost_11 + cost_12 + 
						cost_13 + cost_14 + cost_15) AS "total", 
					SUM(cost_1) AS "2023", 
					SUM(cost_2) AS "2024", 
					SUM(cost_3) AS "2025", 
					SUM(cost_4) AS "2026", 
					SUM(cost_5) AS "2027", 
					SUM(cost_6) AS "2028", 
					SUM(cost_7) AS "2029", 
					SUM(cost_8) AS "2030", 
					SUM(cost_9) AS "2031", 
					SUM(cost_10) AS "2032", 
					SUM(cost_11) AS "2033", 
					SUM(cost_12) AS "2034", 
					SUM(cost_13) AS "2035" 
				FROM datatables.bashkiria_action_plan 
				/*Calculation logic: sum of all basic rows that are 
				the rows without included rows ("head rows") and rows of 
				the lowest level. All are not present in the parent_id column*/ 
				WHERE id_act NOT IN 
							(
								SELECT id_parent 
								FROM datatables.bashkiria_action_plan 
								WHERE id_parent > 0
							) 
					AND 
					aux1 != 'Удал' 
				GROUP BY aux1, fin_source
			) 
			SELECT * 
			FROM 
				(
					/*Part 1. All costs grouped (summed) by scenario and financial level.*/ 
					SELECT * 
					FROM basic_calculation 

					UNION 

					/*Part 2. All costs grouped (summed) only by scenario as total rows.*/ 
					SELECT 
							aux1, 
							NULL AS "fin_source", 
							SUM("total") AS "total", 
							SUM("2023") AS "2023", 
							SUM("2024") AS "2024", 
							SUM("2025") AS "2025", 
							SUM("2026") AS "2026", 
							SUM("2027") AS "2027", 
							SUM("2028") AS "2028", 
							SUM("2029") AS "2029", 
							SUM("2030") AS "2030", 
							SUM("2031") AS "2031", 
							SUM("2032") AS "2032", 
							SUM("2033") AS "2033", 
							SUM("2034") AS "2034", 
							SUM("2035") AS "2035"
					FROM basic_calculation
					GROUP BY aux1
				) AS calculation_with_totals
		) AS calculation_formatted
ORDER BY 
		aux1, 
		fin_source DESC