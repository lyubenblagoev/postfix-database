--
-- PostgreSQL database dump
--

-- Dumped from database version 10.2
-- Dumped by pg_dump version 10.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: on_update_current_timestamp_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION on_update_current_timestamp_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.on_update_current_timestamp_updated() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: mailuser
--

CREATE TABLE accounts (
    id bigint NOT NULL,
    domain_id bigint NOT NULL,
    username character varying(155) NOT NULL,
    password character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE accounts OWNER TO mailuser;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: mailuser
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE accounts_id_seq OWNER TO mailuser;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mailuser
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: aliases; Type: TABLE; Schema: public; Owner: mailuser
--

CREATE TABLE aliases (
    id bigint NOT NULL,
    domain_id bigint NOT NULL,
    alias character varying(155) NOT NULL,
    email character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE aliases OWNER TO mailuser;

--
-- Name: aliases_id_seq; Type: SEQUENCE; Schema: public; Owner: mailuser
--

CREATE SEQUENCE aliases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aliases_id_seq OWNER TO mailuser;

--
-- Name: aliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mailuser
--

ALTER SEQUENCE aliases_id_seq OWNED BY aliases.id;


--
-- Name: domains; Type: TABLE; Schema: public; Owner: mailuser
--

CREATE TABLE domains (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE domains OWNER TO mailuser;

--
-- Name: domains_id_seq; Type: SEQUENCE; Schema: public; Owner: mailuser
--

CREATE SEQUENCE domains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE domains_id_seq OWNER TO mailuser;

--
-- Name: domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mailuser
--

ALTER SEQUENCE domains_id_seq OWNED BY domains.id;


--
-- Name: recipient_bccs; Type: TABLE; Schema: public; Owner: mailuser
--

CREATE TABLE recipient_bccs (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    receiver_email_address character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE recipient_bccs OWNER TO mailuser;

--
-- Name: recipient_bccs_id_seq; Type: SEQUENCE; Schema: public; Owner: mailuser
--

CREATE SEQUENCE recipient_bccs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE recipient_bccs_id_seq OWNER TO mailuser;

--
-- Name: recipient_bccs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mailuser
--

ALTER SEQUENCE recipient_bccs_id_seq OWNED BY recipient_bccs.id;


--
-- Name: sender_bccs; Type: TABLE; Schema: public; Owner: mailuser
--

CREATE TABLE sender_bccs (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    receiver_email_address character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    created timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE sender_bccs OWNER TO mailuser;

--
-- Name: sender_bccs_id_seq; Type: SEQUENCE; Schema: public; Owner: mailuser
--

CREATE SEQUENCE sender_bccs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sender_bccs_id_seq OWNER TO mailuser;

--
-- Name: sender_bccs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mailuser
--

ALTER SEQUENCE sender_bccs_id_seq OWNED BY sender_bccs.id;


--
-- Name: vw_aliases; Type: VIEW; Schema: public; Owner: mailuser
--

CREATE VIEW vw_aliases AS
 SELECT (((a.alias)::text || '@'::text) || (d.name)::text) AS alias,
    a.email,
    (d.enabled AND a.enabled) AS enabled
   FROM (aliases a
     JOIN domains d ON ((d.id = a.domain_id)));


ALTER TABLE vw_aliases OWNER TO mailuser;

--
-- Name: vw_recipient_bccs; Type: VIEW; Schema: public; Owner: mailuser
--

CREATE VIEW vw_recipient_bccs AS
 SELECT (((a.username)::text || '@'::text) || (d.name)::text) AS source_email_address,
    r.receiver_email_address,
    r.enabled
   FROM ((recipient_bccs r
     JOIN accounts a ON ((a.id = r.account_id)))
     JOIN domains d ON ((d.id = a.domain_id)));


ALTER TABLE vw_recipient_bccs OWNER TO mailuser;

--
-- Name: vw_sender_bccs; Type: VIEW; Schema: public; Owner: mailuser
--

CREATE VIEW vw_sender_bccs AS
 SELECT (((a.username)::text || '@'::text) || (d.name)::text) AS source_email_address,
    f.receiver_email_address,
    f.enabled
   FROM ((accounts a
     JOIN domains d ON ((a.domain_id = d.id)))
     JOIN sender_bccs f ON ((f.account_id = a.id)));


ALTER TABLE vw_sender_bccs OWNER TO mailuser;

--
-- Name: vw_user_logins; Type: VIEW; Schema: public; Owner: mailuser
--

CREATE VIEW vw_user_logins AS
 SELECT d.id AS domain_id,
    a.id AS account_id,
    (((a.username)::text || '@'::text) || (d.name)::text) AS login,
    a.password,
    (d.enabled AND a.enabled) AS enabled
   FROM (accounts a
     JOIN domains d ON ((d.id = a.domain_id)));


ALTER TABLE vw_user_logins OWNER TO mailuser;

--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: aliases id; Type: DEFAULT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY aliases ALTER COLUMN id SET DEFAULT nextval('aliases_id_seq'::regclass);


--
-- Name: domains id; Type: DEFAULT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY domains ALTER COLUMN id SET DEFAULT nextval('domains_id_seq'::regclass);


--
-- Name: recipient_bccs id; Type: DEFAULT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY recipient_bccs ALTER COLUMN id SET DEFAULT nextval('recipient_bccs_id_seq'::regclass);


--
-- Name: sender_bccs id; Type: DEFAULT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY sender_bccs ALTER COLUMN id SET DEFAULT nextval('sender_bccs_id_seq'::regclass);


--
-- Name: accounts idx_16647_primary; Type: CONSTRAINT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT idx_16647_primary PRIMARY KEY (id);


--
-- Name: aliases idx_16656_primary; Type: CONSTRAINT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY aliases
    ADD CONSTRAINT idx_16656_primary PRIMARY KEY (id);


--
-- Name: domains idx_16665_primary; Type: CONSTRAINT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY domains
    ADD CONSTRAINT idx_16665_primary PRIMARY KEY (id);


--
-- Name: recipient_bccs idx_16674_primary; Type: CONSTRAINT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY recipient_bccs
    ADD CONSTRAINT idx_16674_primary PRIMARY KEY (id);


--
-- Name: sender_bccs idx_16683_primary; Type: CONSTRAINT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY sender_bccs
    ADD CONSTRAINT idx_16683_primary PRIMARY KEY (id);


--
-- Name: idx_16647_domain_id_user_name; Type: INDEX; Schema: public; Owner: mailuser
--

CREATE UNIQUE INDEX idx_16647_domain_id_user_name ON accounts USING btree (domain_id, username);


--
-- Name: idx_16656_domain_id; Type: INDEX; Schema: public; Owner: mailuser
--

CREATE INDEX idx_16656_domain_id ON aliases USING btree (domain_id);


--
-- Name: idx_16683_account_id_receiver_email_address; Type: INDEX; Schema: public; Owner: mailuser
--

CREATE UNIQUE INDEX idx_16683_account_id_receiver_email_address ON sender_bccs USING btree (account_id, receiver_email_address);


--
-- Name: accounts on_update_current_timestamp; Type: TRIGGER; Schema: public; Owner: mailuser
--

CREATE TRIGGER on_update_current_timestamp BEFORE UPDATE ON accounts FOR EACH ROW EXECUTE PROCEDURE on_update_current_timestamp_updated();


--
-- Name: aliases on_update_current_timestamp; Type: TRIGGER; Schema: public; Owner: mailuser
--

CREATE TRIGGER on_update_current_timestamp BEFORE UPDATE ON aliases FOR EACH ROW EXECUTE PROCEDURE on_update_current_timestamp_updated();


--
-- Name: domains on_update_current_timestamp; Type: TRIGGER; Schema: public; Owner: mailuser
--

CREATE TRIGGER on_update_current_timestamp BEFORE UPDATE ON domains FOR EACH ROW EXECUTE PROCEDURE on_update_current_timestamp_updated();


--
-- Name: recipient_bccs on_update_current_timestamp; Type: TRIGGER; Schema: public; Owner: mailuser
--

CREATE TRIGGER on_update_current_timestamp BEFORE UPDATE ON recipient_bccs FOR EACH ROW EXECUTE PROCEDURE on_update_current_timestamp_updated();


--
-- Name: sender_bccs on_update_current_timestamp; Type: TRIGGER; Schema: public; Owner: mailuser
--

CREATE TRIGGER on_update_current_timestamp BEFORE UPDATE ON sender_bccs FOR EACH ROW EXECUTE PROCEDURE on_update_current_timestamp_updated();


--
-- Name: accounts accounts_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_ibfk_1 FOREIGN KEY (domain_id) REFERENCES domains(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: aliases aliases_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY aliases
    ADD CONSTRAINT aliases_ibfk_1 FOREIGN KEY (domain_id) REFERENCES domains(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: sender_bccs sender_bccs_ibfk_1; Type: FK CONSTRAINT; Schema: public; Owner: mailuser
--

ALTER TABLE ONLY sender_bccs
    ADD CONSTRAINT sender_bccs_ibfk_1 FOREIGN KEY (account_id) REFERENCES accounts(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

