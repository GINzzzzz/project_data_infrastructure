--DROP TABLE IF EXISTS	datatables.ptv_routes CASCADE;

CREATE TABLE datatables.ptv_routes
(
					id_line serial NOT NULL PRIMARY KEY,
					id_thread character varying NOT NULL,
					id_parent character varying,
					thread_type integer NOT NULL,
					regno character varying(128),
					threadno character varying(128),
					okatos_reg integer[] NOT NULL,
					thread_name character varying(128) NOT NULL,
					opertype character varying(50),
					opername character varying(128),
					opertin bigint,
					stops_dir character varying[],
					lenkm_dir numeric(100,4),
					time_dir_days integer,
					time_dir_hrs integer,
					time_dir_min integer,
					stops_rev character varying[],
					lenkm_rev numeric(100,4),
					time_rev_days integer,
					time_rev_hrs integer,
					time_rev_min integer,
					operation_type character varying(128),
					operation_periods character varying(128),
					runs_cnt_period character varying(50),
					runs_cnt_dir integer,
					runs_cnt_rev integer,
					runs_cnt_coef numeric(100,4),
					runs_cnty_dir integer,
					runs_cnty_rev integer,
					aux1_i character varying(128),
					aux1 character varying(128),
					aux2_i character varying(128),
					aux2 character varying(128),
					aux3_i character varying(128),
					aux3 character varying(128),
					thread_src character varying(128),
					commentas character varying(500),
					revision character varying(128),
					d_reg date NOT NULL DEFAULT CURRENT_DATE,
					dev_layer_name character varying,
					prod_layer_name character varying
);

GRANT ALL ON TABLE 	datatables.ptv_routes TO user_amotex;

COMMENT ON TABLE 	datatables.ptv_routes
    IS 				'Public transit routes.';

COMMENT ON COLUMN 	datatables.ptv_routes.id_line
    IS 				'Automatic. Data row (line) UID within the table. Used as the table identifier ONLY. Note: the value DOES NOT REPRESENT unique identifier of the object (data line) within the whole system. For unique number please refer to the id_thread value.';

COMMENT ON COLUMN 	datatables.ptv_routes.id_thread
    IS 				'Data row (line) UID within the server framework. Consists of 3 parts incl. (1) free element (often the serial number of the line within a table), (2) OID of the DB, (3) OID  the table. Both (2) and (3) are system oids.';
COMMENT ON COLUMN 	datatables.ptv_routes.id_parent
    IS 				'Reference to the main data row (line) id_thread (aka groupper line). Used with sublines that contents partial information comprised in the groupper line.';

COMMENT ON COLUMN 	datatables.ptv_routes.thread_type
    IS 				'Type of the route accord. to the thread_types DB (that shall contain codes and meanings for route types).';

COMMENT ON COLUMN 	datatables.ptv_routes.regno
    IS 				'Registration number of the route accord. to the reference information (data) source. Sometimes when regno is not available in the data source - serial (or any alike) number of the element within the data source is used.';
COMMENT ON COLUMN 	datatables.ptv_routes.threadno
    IS 				'Number of the route. Basically, for intermunicipal and city transit routes it is the designation of the route commonly used for route naming. On the contrary, for rail, aviation, marine and river transport rarely available.';
COMMENT ON COLUMN 	datatables.ptv_routes.okatos_reg
    IS 				'Array like list of OKATO codes for regions serviced with the route. Shall contain 1 value at least. For interregional routes: 2 values at least.';

COMMENT ON COLUMN 	datatables.ptv_routes.thread_name
    IS 				'Name of the thread that often is the description of initial and final stops. Foramt in the mentioned case: Start - Finish  (spaced values).';

COMMENT ON COLUMN 	datatables.ptv_routes.opertype
    IS 				'Type of the transit operator form. Describes organisational type: public/private organization/private contractor. Note: DO NOT confuse with the operation_type val.';
COMMENT ON COLUMN 	datatables.ptv_routes.opername
    IS 				'Transit operator name. Shall be without quotation marks (!).';
COMMENT ON COLUMN 	datatables.ptv_routes.opertin
    IS 				'Unique tax identification number of the transit operator.';

COMMENT ON COLUMN 	datatables.ptv_routes.stops_dir
    IS 				'List of stops in the forward direction. Object identifiers ONLY (object UIDs within the server framework).';
COMMENT ON COLUMN 	datatables.ptv_routes.lenkm_dir
    IS 				'Route distance in the forward direction.';
COMMENT ON COLUMN 	datatables.ptv_routes.time_dir_days
    IS 				'Route travel time in the forward direction (Days). Only INTEGER (complete) number of days. Combination of time_..._days, time_..._hours,  time_..._minutes shall represent duration as ''... days ... hours ... minutes''.';
COMMENT ON COLUMN 	datatables.ptv_routes.time_dir_hrs
    IS 				'Route travel time in the forward direction (Hours). Only INTEGER (complete) number of hours. Combination of time_..._days, time_..._hours,  time_..._minutes shall represent duration as ''... days ... hours ... minutes''.';
COMMENT ON COLUMN datatables.ptv_routes.time_dir_min
    IS 				'Route travel time in the forward direction (Minutes). Only INTEGER (complete) number of minutes. Combination of time_..._days, time_..._hours,  time_..._minutes shall represent duration as ''... days ... hours ... minutes''.';

COMMENT ON COLUMN 	datatables.ptv_routes.stops_rev
    IS 				'List of stops in the forward direction. Object identifiers ONLY (object UIDs within the server framework).';
COMMENT ON COLUMN 	datatables.ptv_routes.lenkm_rev
    IS 				'Route distance in the reverse direction.';
COMMENT ON COLUMN 	datatables.ptv_routes.time_rev_days
    IS 				'Route travel time in the reverse direction (Days). Only INTEGER (complete) number of days. Combination of time_..._days, time_..._hours,  time_..._minutes shall represent duration as ''... days ... hours ... minutes''.';
COMMENT ON COLUMN 	datatables.ptv_routes.time_rev_hrs
    IS 				'Route travel time in the reverse direction (Hours). Only INTEGER (complete) number of hours. Combination of time_..._days, time_..._hours,  time_..._minutes shall represent duration as ''... days ... hours ... minutes''.';
COMMENT ON COLUMN 	datatables.ptv_routes.time_rev_min
    IS 				'Route travel time in the reverse direction (Minutes). Only INTEGER (complete) number of minutes. Combination of time_..._days, time_..._hours,  time_..._minutes shall represent duration as ''... days ... hours ... minutes''.';

COMMENT ON COLUMN 	datatables.ptv_routes.operation_type
    IS 				'Operation type of the route considering its temporal service periods: year-round, weekends, seasonal.';
COMMENT ON COLUMN 	datatables.ptv_routes.operation_periods
    IS 				'Description of operational periods. In the best practice: lists of lists, where 1st list of lists contains operational months, 2nd list of lists -  operational weekdays (text), 3d list of lists - operational hours or similar information. One of two lists can be omitted. E.g.: [[1, 2, 3, 4, 5, 9, 10, 11, 12], [6, 7, 8]]/[[пн, ср, пт], [вт, чт]]/[[7-19], [7-19]] means the operation in (1) Jan, Feb, March, Sept, Oct, Nov, Dec on Mon, Wed, Fri from 7:00 to 19:00, in (2) Jun, Jul, Aug on Tue, Thu also from 7:00 to 19:00. But can be variable. E.g.: [[6, 7, 8]]/[[1 через 1]] means day-on/day-off operational period during summer months.';

COMMENT ON COLUMN 	datatables.ptv_routes.runs_cnt_period
    IS 				'Relative unit for service frequency. E.g. НЕД means per week. СУТ, НЕД, МЕС shall be used only. (Not hourly frequency!)';
COMMENT ON COLUMN 	datatables.ptv_routes.runs_cnt_dir
    IS 				'Number of runs/flights per the runs_cnt_period in the forward direction.';
COMMENT ON COLUMN 	datatables.ptv_routes.runs_cnt_rev
    IS 				'Number of runs/flights per the runs_cnt_period in the reverse direction.';
COMMENT ON COLUMN 	datatables.ptv_routes.runs_cnt_coef
    IS 				'Coefficient (integer) to convert the runs_cnt_... to the annual values (commonly number of the conditional days). Can be omitted as the annual runs can be input directly.';
COMMENT ON COLUMN 	datatables.ptv_routes.runs_cnty_dir
    IS 				'Annual number of runs/flights in the forward direction.';
COMMENT ON COLUMN 	datatables.ptv_routes.runs_cnty_rev
    IS 				'Annual number of runs/flights in the reverse direction.';

COMMENT ON COLUMN 	datatables.ptv_routes.aux1_i
    IS 				'Information about the auxiliary attribute (1) (For bus routes aux1 is used to describe the boarding/unboarding mode).';
COMMENT ON COLUMN 	datatables.ptv_routes.aux1
    IS 				'Auxiliary attribute (1) (For bus, trol, tram routes aux1 is used to describe the boarding/unboarding mode).';
COMMENT ON COLUMN 	datatables.ptv_routes.aux2_i
    IS 				'Information about the auxiliary attribute (2) (For bus, trol, tram routes aux2 is used to describe the ticketing rate regulation).';
COMMENT ON COLUMN 	datatables.ptv_routes.aux2
    IS 				'Auxiliary attribute (2) (For bus, trol, tram routes aux2 is used to describe the ticketing rate regulation).';
COMMENT ON COLUMN 	datatables.ptv_routes.aux3_i
    IS 				'Information about the auxiliary attribute (3).';
COMMENT ON COLUMN 	datatables.ptv_routes.aux3
    IS 				'Auxiliary attribute (3).';

COMMENT ON COLUMN 	datatables.ptv_routes.thread_src
    IS 				'Information (data) source (reference document).';
COMMENT ON COLUMN 	datatables.ptv_routes.commentas
    IS 				'Field for comments (500 characters incl. spaces).';
COMMENT ON COLUMN 	datatables.ptv_routes.revision
    IS 				'Field for revision remarks (correction instructions).';
COMMENT ON COLUMN 	datatables.ptv_routes.d_reg
    IS 				'Automatic. Date when the data row (line) was introduced. Stated only when the line is added. UPDATE of single values afterwards does not change the date. However, when changes are made through the new import with deletion of old lines - date is subject to automatic updating.';
COMMENT ON COLUMN 	datatables.ptv_routes.dev_layer_name
    IS 				'Semi-automatic. Development layer of GIS projects.';
COMMENT ON COLUMN 	datatables.ptv_routes.prod_layer_name
    IS 				'Semi-automatic. Production layer of GIS projects.';