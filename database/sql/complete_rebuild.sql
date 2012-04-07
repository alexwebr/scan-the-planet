drop trigger upper_protocol_t on ports;
drop function upper_protocol_f();

drop table port_details;
drop table ports;
drop table port_detail_types;

drop table host_details;
drop table hosts;
drop table host_detail_types;


-- HOST TABLES
-- Types of detailed, unstructured information about a host
create table host_detail_types (
 id BIGSERIAL PRIMARY KEY,
 name varchar(100) NOT NULL,
 searchable boolean NOT NULL
);

-- Hosts table - IP address and last-seen date (should maybe be in details?)
create table hosts (
 ip INET PRIMARY KEY, -- INET holds network and host IPv6 and IPv4 addresses
 last_seen DATE 
);

-- Detailed, unstructured information about a host - we need to create this last, otherwise its FKs don't exist :)
create table host_details (
 id BIGSERIAL PRIMARY KEY,
 host_id INET REFERENCES hosts(ip) ON DELETE CASCADE NOT NULL,
 type bigint REFERENCES host_detail_types(id) ON DELETE CASCADE NOT NULL, text TEXT NOT NULL -- TEXT = "unlimited" length);
);

-- PORTS/SERVICES TABLES
-- Ports table detail types
create table port_detail_types (
 id BIGSERIAL PRIMARY KEY,
 name varchar(100) NOT NULL,
 searchable boolean NOT NULL
);

-- Ports table - this needs to be created last, otherwise the FKs don't exist
create table ports (
 id BIGSERIAL PRIMARY KEY,
 host_id INET REFERENCES hosts(ip) ON DELETE CASCADE NOT NULL,
 port NUMERIC(8),
 transport_protocol varchar(8)
);

-- Ports table details - SSL? Service Version?
create table port_details (
 id BIGSERIAL PRIMARY KEY,
 port_id bigint REFERENCES ports(id) ON DELETE CASCADE NOT NULL,
 type bigint REFERENCES port_detail_types(id) ON DELETE CASCADE NOT NULL,
 text TEXT NOT NULL -- TEXT = "unlimited" length text
);


-- FUNCTIONS AND TRIGGERS
-- Function to force uppercasing of protocols...
create function upper_protocol_f() returns trigger as '
 begin
 NEW.transport_protocol := upper(NEW.transport_protocol);
 return NEW;
 end;
' language 'plpgsql';

-- ...and its corrosponding trigger
create trigger upper_protocol_t
 after insert on ports
 for each row execute procedure upper_protocol_f();

