--DROP TABLE IF EXISTS datatables.action_plan CASCADE;

CREATE TABLE datatables.action_plan (
					id_line serial NOT NULL PRIMARY KEY,
					id_act bigint,
					id_parent bigint,
					sn_main integer,
					sn_sub integer,
					sn_fin integer,
					object_type integer,
					name_mo1 character varying(128),
					name_mo2 character varying(128),
					name_np character varying(128),
					regno character varying(128),
					name_full character varying(500),
					name_short character varying(128),
					address character varying(128),
					balance character varying(128),
					opertype character varying(50),
					opername character varying(128),
					opertin bigint,
					content_full character varying(1800),
					content_short character varying(128),
					act_type character varying(10),
					rd_cat character varying(10),
					str_cat character varying(10),
					class1_i character varying(128),
					class1 character varying(50),
					class2_i character varying(128),
					class2 character varying(50),
					cap1_dypass_i character varying(128),
					cap1_dypass numeric(100,4),
					cap2_spass_i character varying(128),
					cap2_spass numeric(100,4),
					cap3_dytrans_i character varying(128),
					cap3_dytrans numeric(100,4),
					cap4_strans_i character varying(128),
					cap4_strans numeric(100,4),
					cap5_i character varying(128),
					cap5 numeric(100,4),
					cap6_i character varying(128),
					cap6 numeric(100,4),
					param1_lin_i character varying(128),
					param1_lin numeric(100,4),
					param2_cnt_i character varying(128),
					param2_cnt numeric(100,4),
					param3_sqr_i character varying(128),
					param3_sqr numeric(100,4),
					param4_i character varying(128),
					param4 numeric(100,4),
					param5_i character varying(128),
					param5 numeric(100,4),
					param6_i character varying(128),
					param6 numeric(100,4),
					act_st_y integer,
					act_fin_y integer,
					fin_source character varying(50),
					cost_nd character varying(128),
					cost_base_i character varying(128),
					cost_base_y integer,
					cost_base numeric(100,4),
					cost_1 numeric(100,4),
					cost_2 numeric(100,4),
					cost_3 numeric(100,4),
					cost_4 numeric(100,4),
					cost_5 numeric(100,4),
					cost_6 numeric(100,4),
					cost_7 numeric(100,4),
					cost_8 numeric(100,4),
					cost_9 numeric(100,4),
					cost_10 numeric(100,4),
					cost_11 numeric(100,4),
					cost_12 numeric(100,4),
					cost_13 numeric(100,4),
					cost_14 numeric(100,4),
					cost_15 numeric(100,4),
					cost_16 numeric(100,4),
					cost_17 numeric(100,4),
					cost_18 numeric(100,4),
					cost_19 numeric(100,4),
					cost_20 numeric(100,4),
					aux1_i character varying(128),
					aux1 character varying(128),
					aux2_i character varying(128),
					aux2 character varying(128),
					aux3_i character varying(128),
					aux3 character varying(128),
					aux4_i character varying(128),
					aux4 character varying(128),
					finaux1 character varying(128),
					finaux2 character varying(128),
					act_src character varying(128),
					src_el character varying(128),
					var character varying(128),
					gis_data character varying(128),
					objects_idxs character varying[],
					id_project integer,
					docs_idxs integer[],
					commentas character varying(128),
					revision character varying(128),
					d_reg date NOT NULL DEFAULT CURRENT_DATE,
					dev_layer_name character varying,
					prod_layer_name character varying
);

GRANT ALL ON TABLE 	datatables.action_plan 
TO 					user_amotex;

COMMENT ON TABLE 	datatables.action_plan 
IS 					'Project Main Action Plan (MAP)';
COMMENT ON COLUMN 	datatables.action_plan.id_line 
IS 					'UID of the line within a table. Auto generated.';
COMMENT ON COLUMN 	datatables.action_plan.id_act 
IS 					'Action UID within projects. Contains okato_reg, id_object, sn_main, sn_sub, sn_fin all together.';
COMMENT ON COLUMN 	datatables.action_plan.id_parent 
IS 					'Main UID action within project (that contains the action being described).';

COMMENT ON COLUMN 	datatables.action_plan.sn_main 
IS 					'Simple number (main) of the action in the action. Used on the site of a planner as simple way to enumerate the action.';
COMMENT ON COLUMN 	datatables.action_plan.sn_sub 
IS 					'Simple number for subact within an action group.';
COMMENT ON COLUMN 	datatables.action_plan.sn_fin 
IS 					'Subline of the main or subact line. Financial level described with the code according to the dicts.sn_fin dictionary (table). Only for single actions with different financing sources (when additional lines for each finsource are required). Otherwise shall be 0. DO NOT �ONFUSE the fin_source parameter below which is obligatory.';

COMMENT ON COLUMN 	datatables.action_plan.object_type 
IS 					'Effected / new Object type UID accord. to the dicts.tobjects dictionary (table).';

COMMENT ON COLUMN 	datatables.action_plan.name_mo1 
IS 					'High level municipalities (not more than 3 municipalities) where the action is taken. Otherweise - null (empty). For urban agglomerations Best Practice: shall be names from the list of the municipalities accord. to the dicts.agglo_municipalities.';
COMMENT ON COLUMN 	datatables.action_plan.name_mo2 
IS 					'Low level municipality (single one only for a pnt type object) where the action is taken. Only for objects inside a single municipality.';
COMMENT ON COLUMN 	datatables.action_plan.name_np 
IS 					'Name of a settlement where the action is taken. Only for objects inside a single settlement.';

COMMENT ON COLUMN 	datatables.action_plan.regno 
IS 					'Registration code of the effected object accord. to official registries. For new objects - mark �.�.';
COMMENT ON COLUMN 	datatables.action_plan.name_full 
IS 					'Full name (title) of the effected or new object accord. to official docs. 500 characters max. (incl. spaces).';
COMMENT ON COLUMN 	datatables.action_plan.name_short 
IS 					'Shortened name (title) of the effected or new object. Required for correct input to GIS atributes. 128 characters max. (incl. spaces).Can be left blank and generated automatically from name_full.';
COMMENT ON COLUMN 	datatables.action_plan.address 
IS 					'Address of the action. For roads and linear objects - km milestones if needed. Also segment can be used (Best Practice: from ... to ... e.g. for streets).';
COMMENT ON COLUMN 	datatables.action_plan.balance 
IS 					'Object belonging to the pub. authority or private entity. Obligatory for roads and streets, repective objects.';

COMMENT ON COLUMN 	datatables.action_plan.opertype 
IS 					'Type of the operator form (exist. or perspective). Describes organisational type: public/private organization/private contractor.';
COMMENT ON COLUMN 	datatables.action_plan.opername 
IS					'Operator name (eixst. or perspective). Shall be without quotation marks (!).';
COMMENT ON COLUMN 	datatables.action_plan.opertin 
IS					 'Unique tax identification number of the operator (exist. or perspective).';

COMMENT ON COLUMN 	datatables.action_plan.content_full 
IS 					'Full description of theaction(as far as it is practically required for the table representation) incl. goals of the action. 1 800 characters max. (incl. spaces).';
COMMENT ON COLUMN 	datatables.action_plan.content_short 
IS 					'Shortened action description. Required for correct input to GIS atributes. 128 characters max. (incl. spaces). Can be left blank and generated automatically from content_full.';
COMMENT ON COLUMN 	datatables.action_plan.act_type 
IS 					'Action type (construction, reconstruction, overhaul etc.)';

COMMENT ON COLUMN 	datatables.action_plan.rd_cat 
IS 					'Road category. GOST R 52398.';
COMMENT ON COLUMN 	datatables.action_plan.str_cat 
IS 					'Street/road cat. in settlements. SP 42.13330.';
COMMENT ON COLUMN 	datatables.action_plan.class1_i 
IS 					'Classfier (1).';
COMMENT ON COLUMN 	datatables.action_plan.class1 
IS 					'Object class by the classifier (1).';
COMMENT ON COLUMN 	datatables.action_plan.class2_i 
IS 					'Classfier (2).';
COMMENT ON COLUMN 	datatables.action_plan.class2 
IS 					'Object class by the classifier (2).';

COMMENT ON COLUMN 	datatables.action_plan.cap1_dypass_i 
IS 					'Unit for the object after-action capacity in respect to the dynamic passenger flow (used for flow capacity e.g. per day, per hour etc.). CAPITALIZED AS IN OKEI.';
COMMENT ON COLUMN 	datatables.action_plan.cap1_dypass 
IS 					'Object after-action capacity in respect to the dynamic passenger flow (used for flow capacity e.g. per day, per hour etc.).';
COMMENT ON COLUMN 	datatables.action_plan.cap2_spass_i 
IS 					'Unit for the object after-action capacity in respect to the static passenger flow (used for volume capacity e.g. seats, lots etc.). CAPITALIZED AS IN OKEI.';
COMMENT ON COLUMN 	datatables.action_plan.cap2_spass 
IS 					'Object after-action capacity in respect to the static passenger flow (used for volume capacity e.g. seats, lots etc.).';
COMMENT ON COLUMN 	datatables.action_plan.cap3_dytrans_i 
IS 					'Unit for the object after-action capacity in respect to the dynamic transport flow (used for flow capacity e.g. per day, per hour etc.). CAPITALIZED AS IN OKEI.';
COMMENT ON COLUMN 	datatables.action_plan.cap3_dytrans 
IS 					'Object after-action capacity in respect to the dynamic transport flow (used for flow capacity e.g. per day, per hour etc.).';
COMMENT ON COLUMN 	datatables.action_plan.cap4_strans_i 
IS 					'Unit for the object after-action capacity in respect to the static transport flow (used for flow capacity e.g. per day, per hour etc.). CAPITALIZED AS IN OKEI.';
COMMENT ON COLUMN 	datatables.action_plan.cap4_strans 
IS 					'Object after-action capacity in respect to the static transport flow (used for flow capacity e.g. per day, per hour etc.).';
COMMENT ON COLUMN 	datatables.action_plan.cap5_i 
IS 					'Unit for the aux object capacity parameter (5).';
COMMENT ON COLUMN 	datatables.action_plan.cap5 
IS 					'Aux object capacity parameter (5).';
COMMENT ON COLUMN 	datatables.action_plan.cap6_i 
IS 					'Unit for the aux object capacity parameter (6).';
COMMENT ON COLUMN 	datatables.action_plan.cap6 
IS 					'Aux object capacity parameter (6).';

COMMENT ON COLUMN 	datatables.action_plan.param1_lin_i 
IS 					'Linear object parameter (length) unit. Commonly - ��.';
COMMENT ON COLUMN 	datatables.action_plan.param1_lin 
IS 					'Linear object parameter (length).';
COMMENT ON COLUMN 	datatables.action_plan.param2_cnt_i 
IS 					'Quantative parameter unit. Commonly - ��. with pointing countable entities if several. E.g. �� (���. ����)';
COMMENT ON COLUMN 	datatables.action_plan.param2_cnt 
IS 					'Quantative parameter. Number of objects or contents incl. in the object (data row)';
COMMENT ON COLUMN 	datatables.action_plan.param3_sqr_i 
IS 					'Aerial parameter unit.';
COMMENT ON COLUMN 	datatables.action_plan.param3_sqr 
IS 					'Aerial parameter.';
COMMENT ON COLUMN 	datatables.action_plan.param4_i 
IS 					'Auxiliary parameter (4) unit.';
COMMENT ON COLUMN 	datatables.action_plan.param4 
IS 					'Auxiliary parameter (4).';
COMMENT ON COLUMN 	datatables.action_plan.param5_i 
IS 					'Auxiliary parameter (5) unit.';
COMMENT ON COLUMN 	datatables.action_plan.param5 
IS 					'Auxiliary parameter (5).';
COMMENT ON COLUMN 	datatables.action_plan.param6_i 
IS 					'Auxiliary parameter (6) unit.';
COMMENT ON COLUMN 	datatables.action_plan.param6 
IS 					'Auxiliary parameter (6).';

COMMENT ON COLUMN 	datatables.action_plan.act_st_y 
IS 					'Action starting year.';
COMMENT ON COLUMN 	datatables.action_plan.act_fin_y 
IS 					'Action finish year.';

COMMENT ON COLUMN 	datatables.action_plan.fin_source 
IS 					'Financial level described with the code according to the dicts.sn_fin dictionary (table).';

COMMENT ON COLUMN 	datatables.action_plan.cost_nd 
IS 					'Special mark for cost-indefined actions (e.g. project defined, management actions w/o financing etc.)';
COMMENT ON COLUMN 	datatables.action_plan.cost_base_i 
IS 					'Information about base (real on the date of financing) cost of the action. Generally used to define source of the information or estimation unit. E.g. per km.';
COMMENT ON COLUMN 	datatables.action_plan.cost_base_y 
IS 					'Year of the base action cost.';
COMMENT ON COLUMN 	datatables.action_plan.cost_base 
IS 					'Base action cost.';

COMMENT ON COLUMN 	datatables.action_plan.cost_1 
IS 					'Cost in year 1.';
COMMENT ON COLUMN 	datatables.action_plan.cost_2 
IS 					'Cost in year 2.';
COMMENT ON COLUMN 	datatables.action_plan.cost_3 
IS 					'Cost in year 3.';
COMMENT ON COLUMN 	datatables.action_plan.cost_4 
IS 					'Cost in year 4.';
COMMENT ON COLUMN 	datatables.action_plan.cost_5 
IS 					'Cost in year 5.';
COMMENT ON COLUMN 	datatables.action_plan.cost_6 
IS 					'Cost in year 6.';
COMMENT ON COLUMN 	datatables.action_plan.cost_7 
IS 					'Cost in year 7.';
COMMENT ON COLUMN 	datatables.action_plan.cost_8 
IS 					'Cost in year 8.';
COMMENT ON COLUMN 	datatables.action_plan.cost_9 
IS 					'Cost in year 9.';
COMMENT ON COLUMN 	datatables.action_plan.cost_10 
IS 					'Cost in year 10.';
COMMENT ON COLUMN 	datatables.action_plan.cost_11 
IS 					'Cost in year 11.';
COMMENT ON COLUMN 	datatables.action_plan.cost_12 
IS 					'Cost in year 12.';
COMMENT ON COLUMN 	datatables.action_plan.cost_13 
IS 					'Cost in year 13.';
COMMENT ON COLUMN 	datatables.action_plan.cost_14 
IS 					'Cost in year 14.';
COMMENT ON COLUMN 	datatables.action_plan.cost_15 
IS 					'Cost in year 15.';
COMMENT ON COLUMN 	datatables.action_plan.cost_16 
IS 					'Cost in year 16.';
COMMENT ON COLUMN 	datatables.action_plan.cost_17 
IS 					'Cost in year 17.';
COMMENT ON COLUMN 	datatables.action_plan.cost_18 
IS 					'Cost in year 18.';
COMMENT ON COLUMN 	datatables.action_plan.cost_19 
IS 					'Cost in year 19.';
COMMENT ON COLUMN 	datatables.action_plan.cost_20 
IS 					'Cost in year 20.';

COMMENT ON COLUMN 	datatables.action_plan.aux1_i 
IS 					'Information about the auxiliary attribute (1).';
COMMENT ON COLUMN 	datatables.action_plan.aux1 
IS 					'Auxiliary attribute (1).';
COMMENT ON COLUMN 	datatables.action_plan.aux2_i 
IS 					'Information about the auxiliary attribute (2).';
COMMENT ON COLUMN 	datatables.action_plan.aux2 
IS 					'Auxiliary attribute (2).';
COMMENT ON COLUMN 	datatables.action_plan.aux3_i 
IS 					'Information about the auxiliary attribute (3).';
COMMENT ON COLUMN 	datatables.action_plan.aux3 
IS 					'Auxiliary attribute (3).';
COMMENT ON COLUMN 	datatables.action_plan.aux4_i 
IS 					'Information about the auxiliary attribute (4).';
COMMENT ON COLUMN 	datatables.action_plan.aux4 
IS 					'Auxiliary attribute (4).';

COMMENT ON COLUMN 	datatables.action_plan.finaux1 
IS 					'Additional information of action financing. Generally used to point out the lines that shall be included to the finance totals.';
COMMENT ON COLUMN 	datatables.action_plan.finaux2 
IS 					'Additional information of action financing. Generally used to point out the lines the outside documents (plans) that consider financing of the action.';

COMMENT ON COLUMN 	datatables.action_plan.act_src 
IS 					'Data source (reference document).';
COMMENT ON COLUMN 	datatables.action_plan.src_el 
IS 					'Structure element in the data source (seq, paragraph, chapter, part etc.). Used for quick reference to the source. Due to possible amendements structural elements of high level shall be used.';

COMMENT ON COLUMN 	datatables.action_plan.var 
IS 					'Plan variant that comprises the action.';
COMMENT ON COLUMN 	datatables.action_plan.gis_data 
IS 					'GIS data source. For action plan is used to point out whether the action (or action line) shall be georeferenced (put on the map).';
COMMENT ON COLUMN 	datatables.action_plan.objects_idxs 
IS 					'Idxs of the objects / routes effected with the action from infra_objects tables (global or local).';
COMMENT ON COLUMN 	datatables.action_plan.id_project 
IS 					'Project ID from the administrative projects registry (table) which action is initially assigned to. NOTE: the very first project containing the action.';
COMMENT ON COLUMN 	datatables.action_plan.docs_idxs 
IS 					'Project documents that include the action. (NOTE: in comparison to the id_project this list contains all documents considered from all projects).';
COMMENT ON COLUMN 	datatables.action_plan.commentas 
IS 					'Field for comments (500 characters max. incl. spaces).';
COMMENT ON COLUMN 	datatables.action_plan.revision 
IS 					'Field for revision remarks (correction instructions).';
COMMENT ON COLUMN 	datatables.action_plan.d_reg 
IS 					'Automatic. Date when the data row (line) was introduced. Stated only when the line is added. UPDATE of single values afterwards does not change the date. However, when changes are made through the new import with deletion of old lines - date is subject to automatic updating.';
COMMENT ON COLUMN 	datatables.action_plan.dev_layer_name 
IS 					'Semi-automatic. Development layer of GIS projects.';
COMMENT ON COLUMN 	datatables.action_plan.prod_layer_name 
IS 					'Semi-automatic. Production layer of GIS projects.';