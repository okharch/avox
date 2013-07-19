COMMENT ON TABLE clerk_type IS 'This is reference table for clerk_id value. clerk_id => name';
COMMENT ON TABLE accounts is 'Accounts of clients';
COMMENT ON TABLE accounts_log is 'Logging changes of accounts. Structure is the same but add date_change to primary key';
COMMENT ON TABLE clerk_status is 'Reference for clerk_status_id. clerk_status is the status of record in clerk_record: created/active/blocked/closed';
COMMENT ON TABLE clerk_type is 'Reference for clerk_type_id. type is analog to group for giving permission to use admin GUI';
COMMENT ON TABLE clerks is 'Records on who can access admin GUI';
COMMENT ON TABLE clerks_log is 'Logging changes on clerks table';
COMMENT ON TABLE client_status is 'Reference for client_status_id. client_status is the status of record in client_record: created/active/blocked/closed';
COMMENT ON TABLE client_type is 'Reference for client_type_id - which type of services client can use';
COMMENT ON TABLE clients is 'Records on clients who receives some kind of services and pays money for it';
COMMENT ON clients_log is 'Logging changes on clients table';
COMMENT ON TABLE contract_status is 'Reference for contract_status_id. contract_status is the status of record in contracts: created/active/blocked/closed';
COMMENT ON TABLE contracts is 'contracts between client and system';
COMMENT ON TABLE contracts_log is 'Logging changes on contracts records';
COMMENT ON currency_rate is 'Historical records on exchange rate for each operational day';
COMMENT ON  public | currency_type          | table    | rink_dba | 16 kB      |
 public | msg_type               | table    | rink_dba | 8192 bytes |
 public | problem_status         | table    | rink_dba | 8192 bytes |
 public | problem_type           | table    | rink_dba | 8192 bytes |
 public | problems               | table    | rink_dba | 8192 bytes |
problems_log           | table    | rink_dba | 8192 bytes |
 public | service_status         | table    | rink_dba | 16 kB      |
 public | service_type           | table    | rink_dba | 16 kB      |
 public | services               | table    | rink_dba | 8192 bytes |
 public | services_log           | table    | rink_dba | 8192 bytes |
 public | services_tariff        | table    | rink_dba | 0 bytes    |
 public | services_tariff_log    | table    | rink_dba | 0 bytes    |
 public | sysmsg                 | table    | rink_dba | 8192 bytes |
 public | sysmsg_type            | table    | rink_dba | 8192 bytes |
 public | tariff                 | table    | rink_dba | 0 bytes    |
 public | tariff_day             | table    | rink_dba | 0 bytes    |
 public | tariff_day_log         | table    | rink_dba | 0 bytes    |
 public | tariff_plan            | table    | rink_dba | 8192 bytes |
 public | tariff_plan_log        | table    | rink_dba | 8192 bytes |
 public | tariff_time            | table    | rink_dba | 0 bytes    |
 public | tariff_time_log        | table    | rink_dba | 0 bytes    |
 public | tariff_type            | table    | rink_dba | 8192 bytes |
