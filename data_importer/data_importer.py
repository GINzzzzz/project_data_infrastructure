import pandas as pd
import numpy as np
import math
import sqlalchemy as sa
from sqlalchemy import create_engine
from sqlalchemy.dialects import postgresql
from sqlalchemy import Table, Column, INTEGER, NUMERIC, VARCHAR


class Session:
    """

    """
    def __init__(self, cl_dbase, cl_dbtable, cl_user, cl_pass):
        """
        Initialisation of Import Session. Session is considered as a process
        of a given data import. Data is presented to the class as the pandas
        dataframe (see Subfunc ClSES.SfIMPORT)
        :param cl_dbase:    (string) name of the target database (DB);
        :param cl_dbtable:  (string) name of the target datatable (DBT);
        :param cl_user:     (string) name of the DB user (trplanner);
        :param cl_pass:     (string) password to access the DB.
        """
        # ClSES.0 Default parameters for all runs.
        self.dbhost = '178.21.8.198'                                                                                    # server host for all DBs.
        self.dbport = '5432'                                                                                            # server port.
        self.dbgeneral = 'amotex_general'                                                                               # general GDB w/admin and ref tables.
        self.dbschema = 'datatables'                                                                                    # standard schema w/data storage.
        self.dbdicts = 'dicts'                                                                                          # standard schema in GDB w/reference tables.
        self.dbdct_objects = 'tobjects'                                                                                 # ref. tbl w/transobject types.
        self.dbdct_fuels = 'fuel_types'                                                                                 # ref. tbl w/fuel types.
        self.dbdct_regions = 'codes_regions'                                                                            # ref. tbl w/OKATO, plate codes, names of regions.

        # ClSES.1 Init vars.
        self.dbase = cl_dbase
        self.dbtable = cl_dbtable
        self.dbuser = cl_user
        self.dbpass = cl_pass

        modes = {'infra_objects': 1,
                 'ptv_routes': 2,
                 'ptv_vehs': 3,
                 'action_plan': 4}
        idx_cols = {1: 'id_object', 2: 'id_thread', 3: 'id_vehset', 4: 'id_act'}

        try:
            self.mode = modes[self.dbtable]
        except KeyError:
            print('Режим проверки не определен (целевая таблица не существует).')

        self.idx_col = idx_cols[self.mode]
        self.download_dcts()

    def choice(self, alternatives):
        """
        ClSES.SfCHOI.
        Standard subfunc to organize interactive user's choice.
        Choice is made with digits.
        :param alternatives:    (string) alternatives for choice;
        :return:                (int) alternative chosen by the user.
        """
        alts_cnt = len(alternatives)
        print()

        for n_alt in range(alts_cnt):
            print(n_alt + 1, '-', alternatives[n_alt])

        sf_alt_chosen = int(input(f'Введите число от 1 до {alts_cnt}: '))

        return sf_alt_chosen

    def connection(self, clsf_dbname):
        """
        ClSES.SfCONN.
        Subfunc to create engine for connection to the DB.
        :param clsf_dbname:     (string) target DB name
                                        (generally - self.dbase,
                                        for ref. tables - self.dbgeneral).
        :return:                (object class) sqlalchemy object of Engine class.
        """
        engine = create_engine(
            f'postgresql+psycopg2://{self.dbuser}:{self.dbpass}@{self.dbhost}:{self.dbport}/{clsf_dbname}')
        return engine

    def download_data(self, clsf_dbtable, clsf_dbschema, clsf_cols=None):
        """
        ClSES.SfDWNDAT.
        Subfunc to form basic SELECT queries (string).
        :param clsf_dbtable:    (string) target DBT.
        :param clsf_dbschema:   (string) schema w/target DBT.
        :param clsf_cols:       (string) cols of the DBT if required.
        :return:                (string) SQL query string to use.
        """
        if clsf_cols is None:
            clsf_cols = '*'
        else:
            clsf_cols = ', '.join(clsf_cols)

        download_data_query = f'SELECT {clsf_cols} ' \
                              f'FROM {clsf_dbschema}.{clsf_dbtable};'

        return download_data_query

    def download_dcts(self):
        """
        ClSES.SfDWNDIC.
        Subfunc to download required reference information.
        -   self.okatos:        (DF) dict. of OKATO/plate codes, full and short names
                                (DF) as regions' attributes;
        -   self.df_tobjects:   (DF) dict. of transport object types;
        -   self.df_fuels:      (DF) dict. of fuel types.
        :return:                nothing, changes class attributes.
        """
        clsf_engine = self.connection(clsf_dbname=self.dbgeneral)

        with clsf_engine.connect() as connection:                                                                       # !!! NB !!! engine and connection created.
            self.okatos = pd.read_sql(
                sa.text(self.download_data(clsf_dbtable=self.dbdct_regions,
                                           clsf_dbschema=self.dbdicts)),
                con=connection
            )
            self.df_tobjects = pd.read_sql(
                sa.text(self.download_data(clsf_dbtable=self.dbdct_objects,
                                           clsf_dbschema=self.dbdicts)),
                con=connection
            )
            self.df_fuels = pd.read_sql(
                sa.text(self.download_data(clsf_dbtable=self.dbdct_fuels,
                                           clsf_dbschema=self.dbdicts)),
                con=connection
            )
            connection.close()                                                                                          # !!! NB !!! connection closed
            clsf_engine.dispose()                                                                                       # !!! NB !!! engine disposed.

    def properties(self):
        """
        ClSES.SfCOLPROP.
        DB and DB table properties from the server.
        Also, as a part of single connection queries - existing idx col.
        - self.oid_dbase:           target DB OID (see SfCLSES.REINDX);
        - self.oid_dbtable:         target DBT OID in the DB (see SfCLSES.REINDX);
        - self.lst_dbtcols_varch:   list of cols in DBT of type CHARACTER VARYING;
        - self.lst_dbtcols_integ:   -//- of type INTEGER;
        - self.lst_dbtcols_decim:   -//- of type NUMERIC;
        - self.lst_dbtcols_arvarch: -//- of type CHARACTER VARYING[];
        - self.lst_dbtcols_arinteg: -//- of type INTEGER[].
        :return: nothing, definition of class atts.
        """
        query_oids_dbases = f"SELECT oid, datname " \
                            f"FROM pg_database;"
        query_oid_dbtable = f"SELECT oid, relname " \
                            f"FROM pg_class " \
                            f"WHERE relname = '{self.dbtable}' " \
                            f"AND relnamespace = (" \
                                                f"SELECT oid " \
                                                f"FROM pg_namespace " \
                                                f"WHERE nspname = '{self.dbschema}');"
        query_cols_props = f"SELECT * " \
                           f"FROM information_schema.columns " \
                           f"WHERE table_schema='{self.dbschema}' " \
                           f"AND table_name = '{self.dbtable}';"
        clsf_engine = self.connection(clsf_dbname=self.dbase)

        with clsf_engine.connect() as connection:                                                                       # !!! NB !!! engine and connection created.
            oid_dbases = pd.read_sql_query(
                sa.text(query_oids_dbases),
                con=connection
            )
            oid_dbtables = pd.read_sql_query(
                sa.text(query_oid_dbtable),
                con=connection
            )
            self.df_dbtcols = pd.read_sql(
                sa.text(query_cols_props),
                con=connection
            )
            self.existing_idxs = pd.read_sql(
                sa.text(self.download_data(clsf_dbtable=self.dbtable,
                                           clsf_dbschema=self.dbschema,
                                           clsf_cols=['id_line', self.idx_col])),
                con=connection
            )
            connection.close()                                                                                          # !!! NB !!! connection closed
            clsf_engine.dispose()                                                                                       # !!! NB !!! engine disposed.

        self.oid_dbase = oid_dbases.loc[
            oid_dbases['datname'] == self.dbase, 'oid'
        ].values[0]
        self.oid_dbtable = oid_dbtables.loc[
            oid_dbtables['relname'] == self.dbtable, 'oid'
        ].values[0]
        self.lst_dbtcols_varch = self.df_dbtcols.loc[
            self.df_dbtcols.data_type.isin(['character varying']), 'column_name'
        ].to_list()
        self.lst_dbtcols_integ = self.df_dbtcols.loc[
            self.df_dbtcols.data_type.isin(['integer', 'bigint']), 'column_name'
        ].to_list()
        self.lst_dbtcols_decim = self.df_dbtcols.loc[
            self.df_dbtcols.data_type.isin(['numeric']), 'column_name'
        ].to_list()
        self.lst_dbtcols_arvarch = self.df_dbtcols.loc[
            (self.df_dbtcols.data_type == 'ARRAY') &
            (self.df_dbtcols.udt_name.isin(['_int4', '_int8'])), 'column_name'
        ].to_list()
        self.lst_dbtcols_arinteg = self.df_dbtcols.loc[
            (self.df_dbtcols.data_type == 'ARRAY') &
            (self.df_dbtcols.udt_name.isin(['varchar'])), 'column_name'
        ].to_list()

    # ...MAIN..SERVICE..CLASS..SUBFUNCTIONS.............................................................................

    def reindexing(self):
        """
        ClSES.SfREINDX.
        Reindexing subfunc. Only for new datalines.
        Replacements are not subject to reindexing.
        :return: nothing, changes initial dataframe self.df.
        """
        self.lst_replacements = self.df.loc[
            self.df[self.idx_col].isin(
                self.existing_idxs[self.idx_col].to_list()
            ), self.idx_col
        ].to_list()

        # new DataFrame w/before and after indices (download in the end).
        df_reindexing = pd.DataFrame(columns=['id_before', 'id_after'])
        df_reindexing.id_before = self.df.loc[
            ~self.df[self.idx_col].isin(self.lst_replacements), self.idx_col
        ]
        df_reindexing.id_after = df_reindexing.id_before.astype('str').str.split('.')

        try:
            new_index_start = int(self.existing_idxs.id_line.max())
        except ValueError:
            new_index_start = 0

        print(new_index_start)
        local_iter = iter(range(new_index_start + 1,
                                new_index_start + len(self.df) + 1))
        df_reindexing.id_after = df_reindexing.id_after.apply(
            lambda x:   '.'.join(x)
                        if len(x) == 3
                        else str(next(local_iter)) + '.' +
                             str(self.oid_dbase) + '.' +
                             str(self.oid_dbtable)
        )
        # Download of the file.
        df_reindexing.to_csv('dct_reindexing.csv', sep=';')

        # JOINT PTV IMPORT: Reserve download of before and after indices for
        # joint ptv_routes and ptv_vehs import to use them for ptv_veh data.
        if (self.route_vehs is True) and (self.run == 0):
            df_reindexing.to_csv('dct_threadidx.csv', sep=';')

        self.df[self.idx_col] = self.df[self.idx_col].astype('object')                                                  # !!!! REPEAT! 1-0 Subj to corr.
        self.df = self.df.merge(df_reindexing,
                                how='left',
                                left_on=self.idx_col,
                                right_on='id_before')
        self.df.loc[
            self.df['id_before'].notna(), self.idx_col
        ] = self.df.loc[
            self.df['id_before'].notna(), 'id_after'
        ]
        self.df = self.df.drop(columns=['id_before', 'id_after'])

        if 'id_parent' in self.df.columns.to_list():
            self.df['id_parent'] = self.df['id_parent'].astype('object')                                                # !!!! REPEAT! 1-0 Subj to corr.
            self.df = self.df.merge(df_reindexing,
                                    how='left',
                                    left_on='id_parent',
                                    right_on='id_before')
            self.df.loc[
                self.df['id_before'].notna(), 'id_parent'
            ] = self.df.loc[
                self.df['id_before'].notna(), 'id_after'
            ]
            self.df = self.df.drop(columns=['id_before', 'id_after'])

    # ..................................................................................................................

    def veh_thread_conn(self):
        """
        ClSES.SfVETHCON.
        Replacement of thread idxs in ptv_veh dataframe.
        File dct_threadidx.csv is required. See ClSES.SfREINDX.
        :return: nothing, changes initial dataframe self.df.
        """
        self.df['threads_idx'] = self.df['threads_idx'].apply(lambda x:
                                                              x[1:-1].replace(' ', '').split(','))
        df_threadsidx = pd.read_csv('dct_threadidx.csv', sep=';')
        self.df['threads_idx'] = self.df['threads_idx'].apply(lambda x:
                                                              [df_threadsidx.loc[
                                                                   df_threadsidx['id_before'] == i,
                                                                   'id_after'
                                                               ] for i in x])

    # ..................................................................................................................

    def primary_process(self):
        """
        ClSES.SfPRIMPRO.
        Primary check. Includes:
        1 - automatic drop of empty rows;
        2 - autodrop of extra columns in import data (self.df);
        3 - autodrop of id_line, d_reg columns that are DBT default cols;
        4 - primary check of null and empty cells in the required columns;
        5 - autoreplace of values in specific columns that shall
            conforms GDB dictionaries (tables in GBD dicts schema);
        """
        if self.mode == 1:
            req_cols = ['id_object', 'object_type', 'okatos_reg',
                        'name_short', 'balance']
            ref_cols = ['object_type']
        elif self.mode == 2:
            req_cols = ['id_thread', 'thread_type', 'okatos_reg',
                        'thread_name']
            ref_cols = ['thread_type']
        elif self.mode == 3:
            req_cols = ['id_vehset', 'thread_idxs', 'veh_type']
            ref_cols = ['veh_type', 'fuel_type']
        elif self.mode == 4:
            ref_cols = ['object_type', 'id_project', 'docs_idxs']

        # ClSES.SfPRIMPRO.1 Delete empty rows.
        self.df = self.df.dropna(how='all')

        # ClSES.SfPRIMPRO.2 Delete extra cols from import data.
        self.df = self.df.drop(columns=list(
            set(self.df.columns) -
            set(self.df_dbtcols.column_name.to_list())
        ))

        # ClSES.SfPRIMPRO.3 Delete default cols of idxs and dates from import data.
        for col in ['id_line', 'd_reg']:

            if col in self.df.columns:
                self.df = self.df.drop(columns=col)

        # ClSES.SfPRIMPRO.4 Checking required columns to be filled.
        for col in req_cols:
            null_errs = self.df.loc[self.df[col].isna()]
            null_errs['error_description'] = f'{col}: value is required.'

        if 'okatos_reg' in self.df.columns.to_list():
            local = self.df.loc[
                    :, 'okatos_reg'
                    ].apply(lambda x:
                            x[1:-1]
                            if '[' in str(x)
                            else str(x)).str.replace(', ', ',').str.split(',')

            local = local.apply(lambda x:
                                [self.okatos.loc[
                                     (self.okatos.name_full == i) |
                                     (self.okatos.name_short == i),
                                     'okato_reg'
                                 ].values[0]
                                if ((i.isnumeric() is False) and
                                     len(self.okatos.loc[
                                             (self.okatos.name_full == i) |
                                             (self.okatos.name_short == i),
                                             'okato_reg'
                                         ]) > 0)
                                else i
                                if i.isnumeric()
                                else None
                                for i in x
            ]).apply(lambda x:
                    [int(i) if i is not None else None for i in x])

            mask = local.apply(lambda x: None in x)
            okatos_errs = self.df.loc[
                self.df.index.isin(local.loc[mask == 1].index)
            ]
            okatos_errs['error_description'] = f'okato(-s): incorrect or empty'
            self.df['okatos_reg'] = local

        for col in ref_cols:
            # local var inside for-cycle to process.
            local = self.df[col].astype('str').apply(lambda x:
                                                     x.split('.')[0])
            local = local.apply(lambda x:
                                self.df_tobjects.loc[
                                    self.df_tobjects.tobject == x, 'obj_id'
                                ].values[0]
                                if x in self.df_tobjects.tobject.to_list()
                                else x)
            df_interim = self.df.loc[
                (~local.isin(self.df_tobjects.obj_id.astype('str'))) &
                (~local.isin(self.df_fuels.id_type.astype('str')))
            ]
            types_errs = df_interim.loc[
                (~df_interim[col].isin(self.df_tobjects.tobject.to_list())) &
                (~df_interim[col].isin(self.df_fuels.fuel.to_list()))
            ]
            self.df[col] = local
            self.df.loc[
                self.df[self.idx_col].isin(types_errs[self.idx_col]),
                col
            ] = 0

        types_errs['error_description'] = f'{col}: object type does not conform the list of permitted.'

        primary_errs = [df for df in (
            null_errs, okatos_errs, types_errs
        ) if len(df) > 0]

        if len(primary_errs) > 1:
            self.df_errs = pd.concat(primary_errs)
        elif len(primary_errs) == 1:
            self.df_errs = primary_errs[0]

    # ..................................................................................................................

    def err_add(self, add_row, err_text):
        """
        ClSES.SfERRA. Service subfunc to add error line into the self.df_errs.
        Used only inside ClSES.SfLICHEK.
        :param add_row:     (tuple) row to add (generally data line from self.df).
        :param err_text:    (str) error descript to add to the self.df_errs.
        :return:            nothing, changes self.df_errs.
        """
        self.df_errs = pd.concat([self.df_errs, add_row[1].to_frame().T])
        self.df_errs.iloc[len(self.df_errs) - 1, -1] = f'{err_text}'

    def line_check(self):
        """
        ClSES.SfLICHEK.
        Row-by-row check of the import data.
        Initial vars are constituted from the intersection of import data cols
        and DBT cols by type of data.

        !!! NOTE: !!!
        There are (5) initial lists of columns for check by type of data
        in them. To enlarge this, set variables in ClSES.SfCOLPROP.
        """
        self.lst_dbtcols_varch = list(set(self.lst_dbtcols_varch) &
                                      set(self.df.columns))
        self.lst_dbtcols_integ = list(set(self.lst_dbtcols_integ) &
                                      set(self.df.columns))
        self.lst_dbtcols_decim = list(set(self.lst_dbtcols_decim) &
                                      set(self.df.columns))
        self.lst_dbtcols_arvarch = list(set(self.lst_dbtcols_arvarch) &
                                        set(self.df.columns))
        self.lst_dbtcols_arinteg = list(set(self.lst_dbtcols_arinteg) &
                                        set(self.df.columns))

        for row in self.df.iterrows():

            # ClSES.SfLICHEK.1 Check of VARCHAR cols on length restriction.
            for col in self.lst_dbtcols_varch:
                length_restrict = \
                self.df_dbtcols.loc[
                    self.df_dbtcols.column_name == col,
                    'character_maximum_length'
                ].values[0]

                if math.isnan(length_restrict):
                    length_restrict = None

                if length_restrict is not None:
                    if len(str(row[1][col])) > length_restrict:
                        self.err_add(row,
                                     err_text=f'{col}: too long for restriction of {length_restrict} characters.')      # ClSES.SfERRA.

            # ClSES.SfLICHEK.2 Check of INTEGER cols on dtype.
            for col in self.lst_dbtcols_integ:

                try:
                    math.isnan(row[1][col])
                except TypeError:
                    try:
                        int(str(row[1][col]).split('.')[0])
                    except ValueError:
                        self.err_add(row,
                                     err_text=f'{col}: not integer.')                                                   # ClSES.SfERRA.

            # ClSES.SfLICHEK.3 Check of NUMERIC cols on dtype.
            for col in self.lst_dbtcols_decim:

                try:
                    float(str(row[1][col]))
                except [ValueError, TypeError]:
                    self.err_add(row, err_text=f'{col}: not float.')                                                    # ClSES.SfERRA.

    # ..................................................................................................................

    def replace_values(self, clsf_df=None):                                                                             # SHALL BE GENERAL! SUBJ TO CORR.
        """
        ClSES.SfREVAL.
        Subfunc to replace thread idxs in the ptv_veh dataframe.
        :param clsf_df:     (DF) import dataframe.
        :return:            (DF) altered import dataframe.
        """
        clsf_df['route_type'] = clsf_df.merge(self.df_tobjects,
                                              how='left',
                                              left_on='route_type',
                                              right_on='tobject')['obj_id']
        clsf_df['veh_type'] = clsf_df.merge(self.df_tobjects,
                                            how='left',
                                            left_on='veh_type',
                                            right_on='tobject')['obj_id']
        return clsf_df

    # ..................................................................................................................

    def main_import(self):
        """
        ClSES.SfMAIN.
        General Subfunc that imports self.df to the DB.
        :return: nothing.
        """
        self.engine = self.connection(clsf_dbname=self.dbase)
        self.df.to_sql(self.dbtable,
                       con=self.engine,
                       schema=self.dbschema,
                       if_exists='append',
                       index=False,
                       dtype={'okatos_reg': postgresql.ARRAY(sa.types.INTEGER)})

    def import_todb(self, clsf_df, dummy_import=True, route_vehs=False):
        """
        ClSES.SfIMPORT.
        General Class Subfunc that describes the import process.
        :param clsf_df:         (DF) import dataframe (initially loaded from the file);
        :param dummy_import:    (bool) flag to test the process w/o final import to the DB;
        :param route_vehs:      (bool) flag for JOINT import to ptv_vehs and ptv_routes DBTs.
        :return:                nothing.
        """
        import_process = True

        while import_process:

            self.run = 0
            self.route_vehs = route_vehs

            if self.mode == 3 and self.run == 0 and self.route_vehs is True:
                self.veh_thread_conn()

            self.df = clsf_df

            # initialisation of self.df_errs dataframe.
            self.df_errs = pd.DataFrame(columns=(self.df.columns.to_list() +
                                                 ['error_description']))
            self.properties()                                                                                           # ClSES.SfCOLPROP.
            self.reindexing()                                                                                           # ClSES.SfREINDX.
            self.primary_process()                                                                                      # ClSES.SfPRIMPRO.
            self.line_check()                                                                                           # ClSES.SfLICHEK.

            # drop of lines w/errors from the self.df DF.
            self.df = self.df.loc[~self.df[self.idx_col].isin(self.df_errs[self.idx_col])]

            # local download of the results (DIRECTORY OF THE CODE).
            with pd.ExcelWriter('data_to_import.xlsx') as writer:
                self.df.to_excel(writer, sheet_name='data_to_import')
                self.df_errs.to_excel(writer, sheet_name='errors')

            # Report lines.
            print(f'Строк готово к загрузке:\t{len(self.df)}\n'
                  f'Строк с ошибками:\t\t{len(self.df_errs)}')

            if len(self.df_errs) > 0:
                print('\nМассив на загрузку и ошибки - в файле data_to_import.xlsx.')
                print('\nМожно исправить ошибки в самом файле и закончить загрузку или'
                      ' загрузить только готовые строки и исправленные ошибки загрузить позже.')
                option = self.choice(alternatives=[
                    'Загрузить верные строки и ошибочные строки после исправления в текущем сеансе.',
                    'Загрузить только верные строки. '
                    'Строки с корректировкой будут загружены позднее отдельной загрузкой.',
                    'Не загружать ничего.'])

                if option == 1:

                    if dummy_import:
                        print('Загрузка...')
                    else:
                        print('Загрузка...')
                        self.main_import()

                    print(
                        '\nОткройте файл data_to_import.xlsx (лист errors), '
                        'исправьте ошибки, сохраните и закройте файл.')
                    print(
                        'УЧТИТЕ: словарь dct_reindexing и файл data_to_import будут перезаписаны. '
                        'Cкопируйте файлы при необходимости.')
                    input('После закрытия файла нажмите любую клавишу...')
                    clsf_df = pd.read_excel('data_to_import.xlsx',
                                            sheet_name='errors')

                elif option == 2:
                    import_process = False

                    if dummy_import:
                        print('Загрузка...')
                    else:
                        print('Загрузка...')
                        self.main_import()

                else:
                    import_process = False

            else:

                if dummy_import:
                    print('Загрузка...')
                else:
                    print('Загрузка...')
                    self.main_import()

                import_process = False

            if self.route_vehs:
                self.run += 1

    def __repr__(self):
        return f'Соединение с сервером:' \
               f'\n-хост:\t{self.dbhost},' \
               f'\n-порт:\t{self.dbport},' \
               f'\n-база:\t{self.dbase},' \
               f'\n-схема:\t{self.dbschema},' \
               f'\n-таблица:\t{self.dbtable},' \
               f'\n-пользователь:\t{self.dbuser},' \
               f'\n-пароль:\t{self.dbpass}'
