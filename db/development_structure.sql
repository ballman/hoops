--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'LATIN1';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: -
--

CREATE PROCEDURAL LANGUAGE plpgsql;


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: conferences; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE conferences (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    short_name character varying(32) NOT NULL,
    espn_code integer,
    cnnsi_code character varying(6),
    fox_code integer
);


--
-- Name: conference_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE conference_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: conference_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE conference_id_seq OWNED BY conferences.id;


SET default_with_oids = false;

--
-- Name: conference_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE conference_memberships (
    id integer NOT NULL,
    conference_id integer NOT NULL,
    team_id integer NOT NULL,
    year integer NOT NULL
);


--
-- Name: conference_membership_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE conference_membership_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: conference_membership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE conference_membership_id_seq OWNED BY conference_memberships.id;


SET default_with_oids = true;

--
-- Name: game_files; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE game_files (
    id integer NOT NULL,
    game_date date NOT NULL,
    type character varying(32) NOT NULL,
    content text,
    parse_notes character varying(4000),
    source_id character varying(32),
    game_id integer,
    created_at timestamp without time zone
);


--
-- Name: game_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE game_files_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: game_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE game_files_id_seq OWNED BY game_files.id;


--
-- Name: games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games (
    id integer NOT NULL,
    home_team_id integer,
    away_team_id integer,
    played_on date NOT NULL,
    neutral_site boolean DEFAULT false NOT NULL
);


--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE games_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE games_id_seq OWNED BY games.id;


--
-- Name: new_players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE new_players_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


SET default_with_oids = false;

--
-- Name: new_players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE new_players (
    id integer DEFAULT nextval('new_players_id_seq'::regclass) NOT NULL,
    first_name character varying(64) NOT NULL,
    last_name character varying(64) NOT NULL,
    suffix_name character varying(10),
    number integer NOT NULL,
    year integer NOT NULL,
    height integer NOT NULL,
    weight integer NOT NULL,
    "position" character varying(6) NOT NULL,
    hometown character varying(64) NOT NULL,
    team_id integer NOT NULL
);


--
-- Name: player_averages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE player_averages (
    id integer,
    player_id integer,
    games_played bigint,
    fgm numeric,
    fga numeric,
    fgp double precision,
    tpm numeric,
    tpa numeric,
    tpp double precision,
    ftm numeric,
    fta numeric,
    ftp double precision,
    offense_rebound numeric,
    total_rebound numeric,
    assist numeric,
    steal numeric,
    block numeric,
    turnover numeric,
    foul numeric,
    total_point numeric
);


SET default_with_oids = true;

--
-- Name: player_games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE player_games (
    id integer NOT NULL,
    game_id integer,
    team_game_id integer,
    player_id integer,
    type character varying(32),
    minutes integer DEFAULT 0 NOT NULL,
    fgm integer DEFAULT 0 NOT NULL,
    fga integer DEFAULT 0 NOT NULL,
    tpm integer DEFAULT 0 NOT NULL,
    tpa integer DEFAULT 0 NOT NULL,
    fta integer DEFAULT 0 NOT NULL,
    ftm integer DEFAULT 0 NOT NULL,
    offense_rebound integer DEFAULT 0 NOT NULL,
    total_rebound integer DEFAULT 0 NOT NULL,
    assist integer DEFAULT 0 NOT NULL,
    steal integer DEFAULT 0 NOT NULL,
    block integer DEFAULT 0 NOT NULL,
    turnover integer DEFAULT 0 NOT NULL,
    foul integer DEFAULT 0 NOT NULL,
    total_point integer DEFAULT 0 NOT NULL,
    player_name character varying(32)
);


--
-- Name: player_games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE player_games_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: player_games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE player_games_id_seq OWNED BY player_games.id;


--
-- Name: players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE players (
    id integer NOT NULL,
    number integer NOT NULL,
    first_name character varying(32) NOT NULL,
    last_name character varying(32) NOT NULL,
    suffix_name character(3),
    "position" character varying(6) NOT NULL,
    height integer,
    weight integer,
    hometown character varying(64),
    acad_year smallint,
    cstv_bs_name character varying(64),
    fox_bs_name character varying(64),
    sn_bs_name character varying(64),
    yahoo_bs_name character varying(64)
);


--
-- Name: player_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE player_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: player_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE player_id_seq OWNED BY players.id;


SET default_with_oids = false;

--
-- Name: players_2007; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE players_2007 (
    id integer NOT NULL,
    number integer,
    first_name character varying(32),
    last_name character varying(32),
    suffix_name character(3),
    "position" character varying(6),
    height integer,
    weight integer,
    hometown character varying(64),
    acad_year smallint,
    team_id integer
);


--
-- Name: players_2007_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE players_2007_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: players_2007_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE players_2007_id_seq OWNED BY players_2007.id;


--
-- Name: rosters; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rosters (
    id integer NOT NULL,
    team_id integer NOT NULL,
    player_id integer NOT NULL,
    year integer NOT NULL
);


--
-- Name: roster_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roster_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: roster_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roster_id_seq OWNED BY rosters.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: team_averages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE team_averages (
    id integer,
    team_id integer,
    games bigint,
    fgm numeric,
    fga numeric,
    fgp double precision,
    tpm numeric,
    tpa numeric,
    tpp double precision,
    ftm numeric,
    fta numeric,
    ftp double precision,
    eff_fgp double precision,
    offense_rebound numeric,
    total_rebound numeric,
    assist numeric,
    steal numeric,
    block numeric,
    turnover numeric,
    foul numeric,
    half1_point numeric,
    half2_point numeric,
    total_point numeric,
    total_to double precision,
    ppp double precision,
    get_ft double precision,
    orp double precision,
    to_rate double precision,
    poss double precision,
    as_of date
);


SET default_with_oids = true;

--
-- Name: team_diff_ranks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE team_diff_ranks (
    id integer NOT NULL,
    team_id integer,
    fgm integer,
    fga integer,
    fgp integer,
    tpm integer,
    tpa integer,
    tpp integer,
    ftm integer,
    fta integer,
    ftp integer,
    offense_rebound integer,
    total_rebound integer,
    assist integer,
    steal integer,
    block integer,
    turnover integer,
    foul integer,
    half1_point integer,
    half2_point integer,
    total_point integer,
    eff_fgp integer,
    to_rate integer,
    orp integer,
    get_ft integer,
    poss integer,
    ppp integer
);


--
-- Name: team_diff_ranks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE team_diff_ranks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: team_diff_ranks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE team_diff_ranks_id_seq OWNED BY team_diff_ranks.id;


SET default_with_oids = false;

--
-- Name: team_foe_averages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE team_foe_averages (
    id integer,
    team_id integer,
    games bigint,
    fgm numeric,
    fga numeric,
    fgp double precision,
    tpm numeric,
    tpa numeric,
    tpp double precision,
    ftm numeric,
    fta numeric,
    ftp double precision,
    eff_fgp double precision,
    offense_rebound numeric,
    orp double precision,
    poss double precision,
    ppp double precision,
    total_to double precision,
    total_rebound numeric,
    assist numeric,
    steal numeric,
    block numeric,
    turnover numeric,
    foul numeric,
    half1_point numeric,
    half2_point numeric,
    total_point numeric,
    get_ft double precision,
    to_rate double precision,
    as_of date
);


SET default_with_oids = true;

--
-- Name: team_foe_ranks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE team_foe_ranks (
    id integer NOT NULL,
    team_id integer,
    fgm integer,
    fga integer,
    fgp integer,
    tpm integer,
    tpa integer,
    tpp integer,
    ftm integer,
    fta integer,
    ftp integer,
    offense_rebound integer,
    total_rebound integer,
    assist integer,
    steal integer,
    block integer,
    turnover integer,
    foul integer,
    half1_point integer,
    half2_point integer,
    total_point integer,
    eff_fgp integer,
    to_rate integer,
    orp integer,
    get_ft integer,
    poss integer,
    ppp integer
);


--
-- Name: team_foe_ranks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE team_foe_ranks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: team_foe_ranks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE team_foe_ranks_id_seq OWNED BY team_foe_ranks.id;


--
-- Name: team_games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE team_games (
    id integer NOT NULL,
    game_id integer,
    team_id integer,
    type character varying(32),
    minutes integer NOT NULL,
    fgm integer DEFAULT 0 NOT NULL,
    fga integer DEFAULT 0 NOT NULL,
    tpm integer DEFAULT 0 NOT NULL,
    tpa integer DEFAULT 0 NOT NULL,
    fta integer DEFAULT 0 NOT NULL,
    ftm integer DEFAULT 0 NOT NULL,
    offense_rebound integer DEFAULT 0 NOT NULL,
    total_rebound integer DEFAULT 0 NOT NULL,
    team_rebound integer DEFAULT 0 NOT NULL,
    assist integer DEFAULT 0 NOT NULL,
    steal integer DEFAULT 0 NOT NULL,
    block integer DEFAULT 0 NOT NULL,
    turnover integer DEFAULT 0 NOT NULL,
    team_turnover integer DEFAULT 0 NOT NULL,
    foul integer DEFAULT 0 NOT NULL,
    half1_point integer DEFAULT 0 NOT NULL,
    half2_point integer DEFAULT 0 NOT NULL,
    ot1_point integer DEFAULT 0,
    ot2_point integer DEFAULT 0,
    ot3_point integer DEFAULT 0,
    ot4_point integer DEFAULT 0,
    total_point integer DEFAULT 0 NOT NULL,
    team_name character varying(32),
    ot5_point integer DEFAULT 0
);


--
-- Name: team_games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE team_games_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: team_games_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE team_games_id_seq OWNED BY team_games.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying(128) NOT NULL,
    mascot character varying(64),
    homepage character varying(256),
    espn_code integer,
    yahoo_code character(3),
    cbs_code character(8),
    fox_code integer,
    usatoday_code character varying(128),
    cnnsi_code character varying(16),
    color_1 character(6),
    color_2 character(6),
    color_3 character(6),
    cstv_code character varying(32),
    in_64 boolean,
    sn_code character varying(32)
);


--
-- Name: team_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE team_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE team_id_seq OWNED BY teams.id;


--
-- Name: team_ranks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE team_ranks (
    id integer NOT NULL,
    team_id integer,
    fgm integer,
    fga integer,
    fgp integer,
    tpm integer,
    tpa integer,
    tpp integer,
    ftm integer,
    fta integer,
    ftp integer,
    offense_rebound integer,
    total_rebound integer,
    assist integer,
    steal integer,
    block integer,
    turnover integer,
    foul integer,
    half1_point integer,
    half2_point integer,
    total_point integer,
    eff_fgp integer,
    to_rate integer,
    orp integer,
    get_ft integer,
    poss integer,
    ppp integer
);


--
-- Name: team_ranks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE team_ranks_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: team_ranks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE team_ranks_id_seq OWNED BY team_ranks.id;


SET default_with_oids = false;

--
-- Name: time_averages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE time_averages (
    id integer NOT NULL,
    team_id integer NOT NULL,
    as_of date NOT NULL,
    ppp double precision DEFAULT 0.0
);


--
-- Name: time_averages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE time_averages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: time_averages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE time_averages_id_seq OWNED BY time_averages.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE conference_memberships ALTER COLUMN id SET DEFAULT nextval('conference_membership_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE conferences ALTER COLUMN id SET DEFAULT nextval('conference_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE game_files ALTER COLUMN id SET DEFAULT nextval('game_files_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE games ALTER COLUMN id SET DEFAULT nextval('games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE player_games ALTER COLUMN id SET DEFAULT nextval('player_games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE players ALTER COLUMN id SET DEFAULT nextval('player_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE players_2007 ALTER COLUMN id SET DEFAULT nextval('players_2007_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE rosters ALTER COLUMN id SET DEFAULT nextval('roster_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE team_diff_ranks ALTER COLUMN id SET DEFAULT nextval('team_diff_ranks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE team_foe_ranks ALTER COLUMN id SET DEFAULT nextval('team_foe_ranks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE team_games ALTER COLUMN id SET DEFAULT nextval('team_games_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE team_ranks ALTER COLUMN id SET DEFAULT nextval('team_ranks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE teams ALTER COLUMN id SET DEFAULT nextval('team_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE time_averages ALTER COLUMN id SET DEFAULT nextval('time_averages_id_seq'::regclass);


--
-- Name: conference_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY conference_memberships
    ADD CONSTRAINT conference_membership_pkey PRIMARY KEY (id);


--
-- Name: conference_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY conferences
    ADD CONSTRAINT conference_pkey PRIMARY KEY (id);


--
-- Name: game_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY game_files
    ADD CONSTRAINT game_files_pkey PRIMARY KEY (id);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: new_players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY new_players
    ADD CONSTRAINT new_players_pkey PRIMARY KEY (id);


--
-- Name: player_games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY player_games
    ADD CONSTRAINT player_games_pkey PRIMARY KEY (id);


--
-- Name: player_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY players
    ADD CONSTRAINT player_pkey PRIMARY KEY (id);


--
-- Name: players_2007_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY players_2007
    ADD CONSTRAINT players_2007_pkey PRIMARY KEY (id);


--
-- Name: roster_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rosters
    ADD CONSTRAINT roster_pkey PRIMARY KEY (id);


--
-- Name: team_games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY team_games
    ADD CONSTRAINT team_games_pkey PRIMARY KEY (id);


--
-- Name: team_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT team_pkey PRIMARY KEY (id);


--
-- Name: time_averages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY time_averages
    ADD CONSTRAINT time_averages_pkey PRIMARY KEY (id);


--
-- Name: game_file_game_date; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX game_file_game_date ON game_files USING btree (game_date);


--
-- Name: games_played_on; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX games_played_on ON games USING btree (played_on);


--
-- Name: player_games_team_games_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX player_games_team_games_id ON player_games USING btree (team_game_id);


--
-- Name: player_games_type_team_games_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX player_games_type_team_games_id ON player_games USING btree (type, team_game_id);


--
-- Name: team_games_game_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX team_games_game_id ON team_games USING btree (game_id);


--
-- Name: team_games_game_id_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX team_games_game_id_type ON team_games USING btree (game_id, type);


--
-- Name: time_averages_team_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX time_averages_team_id ON time_averages USING btree (team_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: conference_membership_conference_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY conference_memberships
    ADD CONSTRAINT conference_membership_conference_id_fkey FOREIGN KEY (conference_id) REFERENCES conferences(id);


--
-- Name: conference_membership_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY conference_memberships
    ADD CONSTRAINT conference_membership_team_id_fkey FOREIGN KEY (team_id) REFERENCES teams(id);


--
-- Name: games_home_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_home_team_id_fkey FOREIGN KEY (home_team_id) REFERENCES teams(id);


--
-- Name: games_visit_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_visit_team_id_fkey FOREIGN KEY (away_team_id) REFERENCES teams(id);


--
-- Name: player_games_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY player_games
    ADD CONSTRAINT player_games_game_id_fkey FOREIGN KEY (game_id) REFERENCES games(id);


--
-- Name: player_games_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY player_games
    ADD CONSTRAINT player_games_player_id_fkey FOREIGN KEY (player_id) REFERENCES players(id);


--
-- Name: player_games_team_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY player_games
    ADD CONSTRAINT player_games_team_game_id_fkey FOREIGN KEY (team_game_id) REFERENCES team_games(id);


--
-- Name: roster_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rosters
    ADD CONSTRAINT roster_player_id_fkey FOREIGN KEY (player_id) REFERENCES players(id);


--
-- Name: roster_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rosters
    ADD CONSTRAINT roster_team_id_fkey FOREIGN KEY (team_id) REFERENCES teams(id);


--
-- Name: team_games_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_games
    ADD CONSTRAINT team_games_game_id_fkey FOREIGN KEY (game_id) REFERENCES games(id);


--
-- Name: team_games_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY team_games
    ADD CONSTRAINT team_games_team_id_fkey FOREIGN KEY (team_id) REFERENCES teams(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20090317210441');

INSERT INTO schema_migrations (version) VALUES ('20090317211503');