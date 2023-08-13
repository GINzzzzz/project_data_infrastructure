--DROP TABLE IF EXISTS datatables.infra_objects CASCADE;

CREATE TABLE IF NOT EXISTS datatables.infra_objects
(
					id_line serial NOT NULL PRIMARY KEY,
					id_object character varying,
					id_parent character varying,
					object_type integer,
					okatos_reg integer[],
					mo1_name character varying(128),
					mo2_name character varying(128),
					name_np character varying(128),
					regno character varying(128),
					name_full character varying(500),
					name_short character varying(128),
					address character varying(128),
					balance character varying(128),
					opertype character varying(50),
					opername character varying(128),
					opertin bigint,
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
					comission_y integer,
					cost_base_i character varying(128),
					cost_base_y integer,
					cost_base numeric(100,4),
					aux1_i character varying(128),
					aux1 character varying(128),
					aux2_i character varying(128),
					aux2 character varying(128),
					aux3_i character varying(128),
					aux3 character varying(128),
					aux4_i character varying(128),
					aux4 character varying(128),
					obj_src character varying(128),
					src_el character varying(128),
					gis_data character varying(128),
					commentas character varying(500),
					revision character varying(128),
					d_reg date NOT NULL DEFAULT CURRENT_DATE,
					dev_layer_name character varying,
					prod_layer_name character varying
);

GRANT ALL ON TABLE 	datatables.infra_objects TO user_amotex;

COMMENT ON TABLE 	datatables.infra_objects
	IS 				'Existing objects of transport infrastructure for general use.';

COMMENT ON COLUMN 	datatables.infra_objects.id_line
    IS 				'UID of the line within a table. Auto generated.';
COMMENT ON COLUMN 	datatables.infra_objects.id_object
    IS 				'Object UID within projects. Contains id_line, project UID, object UID.';
COMMENT ON COLUMN 	datatables.infra_objects.id_parent
    IS 				'Main object UID within projects.';

COMMENT ON COLUMN 	datatables.infra_objects.object_type
    IS 				'Object type UID accord. to dicts.tobjects dictionary (table).';

COMMENT ON COLUMN 	datatables.infra_objects.okatos_reg
    IS 				'List of OKATO codes defining regions where the object is situated.';
COMMENT ON COLUMN 	datatables.infra_objects.mo1_name
    IS 				'High level municipalities (not more than 3 municipalities) where the object is situated. Otherwise - null (blank).';
COMMENT ON COLUMN 	datatables.infra_objects.mo2_name
    IS 				'Low level municipality (single one only for a pnt type object) where the object is situated. Only for objects inside a single municipality. ';
COMMENT ON COLUMN 	datatables.infra_objects.name_np
    IS 				'Name of a settlement where the object is situated. Only for objects inside a single settlement. ';

COMMENT ON COLUMN 	datatables.infra_objects.regno
    IS 				'Registration code of the object accord. to official registries.';
COMMENT ON COLUMN 	datatables.infra_objects.name_full
    IS 				'Full name (title) of the object accord. to official docs. 500 characters max. (incl. spaces).';
COMMENT ON COLUMN 	datatables.infra_objects.name_short
    IS 				'Shortened name (title) of the object. Required for correct input to GIS atributes. 128 characters max. (incl. spaces).';
COMMENT ON COLUMN 	datatables.infra_objects.address
    IS 				'Address of the object. For roads and linear objects - km milestones if needed. Also segment can be used (Best Practice: from ... to ... e.g. for streets).';

COMMENT ON COLUMN 	datatables.infra_objects.balance
    IS 				'Object belonging to the pub. authority or private entity. Obligatory for roads and streets, repective objects.';
COMMENT ON COLUMN 	datatables.infra_objects.opertype
    IS 				'Type of the operator form. Describes organisational type: public/private organization/private contractor.';
COMMENT ON COLUMN 	datatables.infra_objects.opername
    IS 				'Operator name. Shall be without quotation marks (!).';
COMMENT ON COLUMN 	datatables.infra_objects.opertin
    IS 				'Unique tax identification number of the operator.';

COMMENT ON COLUMN 	datatables.infra_objects.rd_cat
    IS 				'Road category. GOST R 52398.';
COMMENT ON COLUMN 	datatables.infra_objects.str_cat
    IS 				'Street/road cat. in settlements. SP 42.13330.';

COMMENT ON COLUMN 	datatables.infra_objects.class1_i
    IS 				'Classfier (1).';
COMMENT ON COLUMN 	datatables.infra_objects.class1
    IS 				'Object class by the classifier (1).';
COMMENT ON COLUMN 	datatables.infra_objects.class2_i
    IS 				'Classfier (2).';
COMMENT ON COLUMN 	datatables.infra_objects.class2
    IS 				'Object class by the classifier (2).';

COMMENT ON COLUMN 	datatables.infra_objects.cap1_dypass_i
    IS 				'Unit for the object capacity in respect to the dynamic passenger flow (used for flow capacity e.g. per day, per hour etc.). CAPITALIZED AS IN OKEI.';
COMMENT ON COLUMN 	datatables.infra_objects.cap1_dypass
    IS 				'Object capacity in respect to the dynamic passenger flow (used for flow capacity e.g. per day, per hour etc.).';
COMMENT ON COLUMN 	datatables.infra_objects.cap2_spass_i
    IS 				'Unit for the object capacity in respect to the static passenger flow (used for volume capacity e.g. seats, lots etc.). CAPITALIZED AS IN OKEI.';
COMMENT ON COLUMN 	datatables.infra_objects.cap2_spass
    IS 				'Object capacity in respect to the static passenger flow (used for volume capacity e.g. seats, lots etc.).';
COMMENT ON COLUMN 	datatables.infra_objects.cap3_dytrans_i
    IS 				'Unit for the object capacity in respect to the dynamic transport flow (used for flow capacity e.g. per day, per hour etc.). CAPITALIZED AS IN OKEI.';
COMMENT ON COLUMN 	datatables.infra_objects.cap3_dytrans
    IS 				'Object capacity in respect to the dynamic transport flow (used for flow capacity e.g. per day, per hour etc.).';
COMMENT ON COLUMN 	datatables.infra_objects.cap4_strans_i
    IS 				'Unit for the object capacity in respect to the static transport flow (used for flow capacity e.g. per day, per hour etc.). CAPITALIZED AS IN OKEI.';
COMMENT ON COLUMN 	datatables.infra_objects.cap4_strans
    IS 				'Object capacity in respect to the static transport flow (used for flow capacity e.g. per day, per hour etc.).';
COMMENT ON COLUMN 	datatables.infra_objects.cap5_i
    IS 				'Unit for the aux object capacity parameter (5).';
COMMENT ON COLUMN 	datatables.infra_objects.cap5
    IS 				'Aux object capacity parameter (5).';
COMMENT ON COLUMN 	datatables.infra_objects.cap6_i
    IS 				'Unit for the aux object capacity parameter (6).';
COMMENT ON COLUMN 	datatables.infra_objects.cap6
    IS 				'Aux object capacity parameter (6).';

COMMENT ON COLUMN 	datatables.infra_objects.param1_lin_i
    IS 				'Linear object parameter (length) unit. Commonly - КМ. ';
COMMENT ON COLUMN 	datatables.infra_objects.param1_lin
    IS 				'Linear object parameter (length).';
COMMENT ON COLUMN 	datatables.infra_objects.param2_cnt_i
    IS 				'Quantative parameter unit. Commonly - ЕД. with pointing countable entities if several. E.g. ЕД (дор. знак)';
COMMENT ON COLUMN 	datatables.infra_objects.param2_cnt
    IS 				'Quantative parameter. Number of objects or contents incl. in the object (data row)';
COMMENT ON COLUMN 	datatables.infra_objects.param3_sqr_i
    IS 				'Aerial parameter unit.';
COMMENT ON COLUMN 	datatables.infra_objects.param3_sqr
    IS 				'Aerial parameter.';

COMMENT ON COLUMN 	datatables.infra_objects.param4_i
    IS 				'Auxiliary parameter (4) unit.';
COMMENT ON COLUMN 	datatables.infra_objects.param4
    IS 				'Auxiliary parameter (4).';
COMMENT ON COLUMN 	datatables.infra_objects.param5_i
    IS 				'Auxiliary parameter (5) unit.';
COMMENT ON COLUMN 	datatables.infra_objects.param5
    IS 				'Auxiliary parameter (5).';
COMMENT ON COLUMN 	datatables.infra_objects.param6_i
    IS 				'Auxiliary parameter (6) unit.';
COMMENT ON COLUMN 	datatables.infra_objects.param6
    IS 				'Auxiliary parameter (6).';

COMMENT ON COLUMN 	datatables.infra_objects.comission_y
    IS 				'Object comissioning year.';

COMMENT ON COLUMN 	datatables.infra_objects.cost_base_i
    IS 				'Information about base (real on the date of financing) cost of the object construction/creation. Generally used to define source of the information or estimation unit. E.g. per km.';
COMMENT ON COLUMN 	datatables.infra_objects.cost_base_y
    IS 				'Year of base cost of the object construction/creation.';
COMMENT ON COLUMN 	datatables.infra_objects.cost_base
    IS 				'Base cost of the object construction/creation.';

COMMENT ON COLUMN 	datatables.infra_objects.aux1_i
    IS 				'Information about the auxiliary attribute (1).';
COMMENT ON COLUMN 	datatables.infra_objects.aux1
    IS 				'Auxiliary attribute (1).';
COMMENT ON COLUMN 	datatables.infra_objects.aux2_i
    IS 				'Information about the auxiliary attribute (2).';
COMMENT ON COLUMN 	datatables.infra_objects.aux2
    IS 				'Auxiliary attribute (2).';
COMMENT ON COLUMN 	datatables.infra_objects.aux3_i
    IS 				'Information about the auxiliary attribute (3).';
COMMENT ON COLUMN 	datatables.infra_objects.aux3
    IS 				'Auxiliary attribute (3).';
COMMENT ON COLUMN 	datatables.infra_objects.aux4_i
    IS 				'Information about the auxiliary attribute (4).';
COMMENT ON COLUMN 	datatables.infra_objects.aux4
    IS 				'Auxiliary attribute (4).';

COMMENT ON COLUMN 	datatables.infra_objects.obj_src
    IS 				'Data source (reference document).';
COMMENT ON COLUMN 	datatables.infra_objects.src_el
    IS 				'Structure element in the data source (seq, paragraph, chapter, part etc.). Used for quick reference to the source. Due to possible amendements structural elements of high level shall be used.';

COMMENT ON COLUMN 	datatables.infra_objects.commentas
    IS 				'Field for comments (500 characters max. incl. spaces).';
COMMENT ON COLUMN 	datatables.infra_objects.revision
    IS 				'Field for revision remarks (correction instructions).';
COMMENT ON COLUMN 	datatables.infra_objects.d_reg
    IS 				'Automatic. Date when the data row (line) was introduced. Stated only when the line is added. UPDATE of single values afterwards does not change the date. However, when changes are made through the new import with deletion of old lines - date is subject to automatic updating.';
COMMENT ON COLUMN 	datatables.infra_objects.dev_layer_name
    IS 				'Semi-automatic. Development layer of GIS projects.';
COMMENT ON COLUMN 	datatables.infra_objects.prod_layer_name
    IS 				'Semi-automatic. Production layer of GIS projects.';