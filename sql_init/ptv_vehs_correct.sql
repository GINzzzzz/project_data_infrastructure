-- DROP TABLE IF EXISTS datatables.ptv_vehs CASCADE;

CREATE TABLE IF NOT EXISTS datatables.ptv_vehs
(
					id_line serial NOT NULL PRIMARY KEY,
					id_vehset character varying NOT NULL,
					threads_idxs character varying[] NOT NULL,
					veh_type integer NOT NULL,
					typomodel character varying(128),
					class_size character varying(50),
					class_cap character varying(50),
					class_dist character varying(50),
					class_eco character varying(50),
					classaux_i character varying(128),
					classaux character varying(50),
					consist integer,
					cap_full numeric(100,4) NOT NULL,
					capaux_i character varying(128),
					capaux numeric(100,4),
					equip_disabled boolean NOT NULL DEFAULT false,
					equip_aticket boolean NOT NULL DEFAULT false,
					equip_other character varying(128),
					fuel_type integer NOT NULL,
					reserve boolean NOT NULL DEFAULT false,
					vehs_cnt integer NOT NULL DEFAULT 0,
					aux1_i character varying(128),
					aux1 character varying(128),
					aux2_i character varying(128),
					aux2 character varying(128),
					aux3_i character varying(128),
					aux3 character varying(128),
					veh_src character varying(128),
					commentas character varying(500),
					revision character varying(128),
					d_reg date NOT NULL DEFAULT CURRENT_DATE
);

GRANT ALL ON TABLE 	datatables.ptv_vehs TO user_amotex;

COMMENT ON TABLE 	datatables.ptv_vehs
    IS 				'Data on vehicles and units on Public Transit Routes (ptv_vehs). ';

COMMENT ON COLUMN 	datatables.ptv_vehs.id_line
    IS 				'Automatic. Data row (line) UID within the table. Used as the table identifier ONLY. Note: the value DOES NOT REPRESENT unique identifier of the object (data line) within the whole system.';
COMMENT ON COLUMN 	datatables.ptv_vehs.threads_idxs
    IS 				'Data row (line) UIDs for the respective threads (ptv_routes) within the server framework. Consists of 3 parts incl. (1) free element (often the serial number of the line within a table), (2) OID of the DB, (3) OID  the table. Both (2) and (3) are system oids.';

COMMENT ON COLUMN 	datatables.ptv_vehs.veh_type
    IS 				'Numeric designation of vehicle type accord to the veh_types dictionary (table).';
COMMENT ON COLUMN 	datatables.ptv_vehs.typomodel
    IS 				'Typical model of the respective vehicle.';

COMMENT ON COLUMN 	datatables.ptv_vehs.class_size
    IS 				'Vehicle class by physical parameters of its frame (not related to the capacity e.g. weight, dimensions etc.).';
COMMENT ON COLUMN 	datatables.ptv_vehs.class_cap
    IS 				'Vehicle class by its capacity (pax).';
COMMENT ON COLUMN 	datatables.ptv_vehs.class_dist
    IS 				'Vehicle class by its reach in operation.';
COMMENT ON COLUMN 	datatables.ptv_vehs.class_eco
    IS 				'Vehicle ecological class.';

COMMENT ON COLUMN 	datatables.ptv_vehs.classaux_i
    IS 				'Auxiliary classfier.';
COMMENT ON COLUMN 	datatables.ptv_vehs.classaux
    IS 				'Vehicle class by the  aux classifier (classaux_i required).';

COMMENT ON COLUMN 	datatables.ptv_vehs.consist
    IS 				'Number of units in the vehicles (commonly - trains and trams).';

COMMENT ON COLUMN 	datatables.ptv_vehs.cap_full
    IS 				'Full vehicle capacity incl. seats and standing passengers if applicable.';
COMMENT ON COLUMN 	datatables.ptv_vehs.capaux_i
    IS 				'Description of an auxiliary capacity paremeter (e.g. seats only).';
COMMENT ON COLUMN 	datatables.ptv_vehs.capaux
    IS 				'Auxiliary capacity paremeter. Numeric.';

COMMENT ON COLUMN 	datatables.ptv_vehs.equip_disabled
    IS 				'Flag for disabled accessible vehicles. Default false.';
COMMENT ON COLUMN 	datatables.ptv_vehs.equip_aticket
    IS 				'Flag for vehicles equipped with automated ticketing solutions. Default false.';
COMMENT ON COLUMN 	datatables.ptv_vehs.equip_other
    IS 				'Additional description of the vehicle equipment (if req.)';

COMMENT ON COLUMN 	datatables.ptv_vehs.fuel_type
    IS 				'Fuel type code accord. to the fuel_types table.';

COMMENT ON COLUMN 	datatables.ptv_vehs.reserve
    IS 				'Boolean flag to indicate reserve vehicles against main operational vehicles (False  - main).';
COMMENT ON COLUMN 	datatables.ptv_vehs.vehs_cnt
    IS 				'Number of vehicles in the group described with the data row.';

COMMENT ON COLUMN 	datatables.ptv_vehs.aux1_i
    IS 				'Information about the auxiliary attribute (1).';
COMMENT ON COLUMN 	datatables.ptv_vehs.aux1
    IS 				'Auxiliary attribute (1).';
COMMENT ON COLUMN 	datatables.ptv_vehs.aux2_i
    IS 				'Information about the auxiliary attribute (2).';
COMMENT ON COLUMN 	datatables.ptv_vehs.aux2
    IS 				'Auxiliary attribute (2).';
COMMENT ON COLUMN 	datatables.ptv_vehs.aux3_i
    IS 				'Information about the auxiliary attribute (3).';
COMMENT ON COLUMN 	datatables.ptv_vehs.aux3
    IS 				'Auxiliary attribute (3).';

COMMENT ON COLUMN 	datatables.ptv_vehs.veh_src
    IS 				'Data source (reference document).';
COMMENT ON COLUMN 	datatables.ptv_vehs.commentas
    IS 				'Field for comments (500 characters incl. spaces).';
COMMENT ON COLUMN 	datatables.ptv_vehs.revision
    IS 				'Field for revision remarks (correction instructions).';
COMMENT ON COLUMN 	datatables.ptv_vehs.d_reg
    IS 				'Automatic. Date when the data row (line) was introduced. Stated only when the line is added. UPDATE of single values afterwards does not change the date. However, when changes are made through the new import with deletion of old lines - date is subject to automatic updating.';