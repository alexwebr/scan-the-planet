-- DROPPING THINGS - LOTS OF ERRORS, AHOY
drop function upper_protocol;
drop trigger upper_protocol;

drop table hosts;
drop table ports;

drop table port_details;
drop table host_details;

drop table port_detail_type;
drop table host_detail_type;


-- FUNCTIONS AND TRIGGERS
-- Function to force uppercasing of protocols...
create function upper_protocol() returns trigger as '
 begin
 NEW.protocol := upper(NEW.protocol);
 return NEW;
 end;
' language 'plpgsql';

-- ...and its corrosponding trigger
create trigger upper_protocol
 after insert on ports
 for each row execute procedure upper_protocol();


-- TABLE DECLARATIONS
-- Hosts table
create table hosts (
 id BIGSERIAL PRIMARY KEY,
 ip INET NOT NULL, -- INET holds network and host IPv6 and IPv4 addresses
 last_seen DATE 
);

-- Detailed, unstructured information about a host
create table host_details (
 id BIGSERIAL PRIMARY KEY,
 host_id REFERENCES hosts(id) ON DELETE CASCADE NOT NULL,
 type REFERENCES host_detail_type(id) NOT NULL ON DELETE CASCADE;
 text TEXT NOT NULL -- TEXT = "unlimited" length
);

-- Types of detailed, unstructured information about a host
create table host_detail_types (
 id BIGSERIAL PRIMARY KEY,
 name varchar(100) NOT NULL,
 searchable boolean NOT NULL
);

-- Ports table
create table ports (
 id BIGSERIAL PRIMARY KEY,
 host_id REFERENCES hosts(id) ON DELETE CASCADE NOT NULL,
 port NUMBER(8)
 transport_protocol varchar(8),
);

-- TODO Ports table detail types

-- TODO Ports table details - SSL? Service Version?
