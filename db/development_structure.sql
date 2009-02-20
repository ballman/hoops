--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: conference; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE conference (
    id serial NOT NULL,
    name character varying(64) NOT NULL,
    short_name character varying(32) NOT NULL,
    espn_code integer,
    cnnsi_code character varying(5),
    fox_code integer
);


SET default_with_oids = false;

--
-- Name: conference_membership; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE conference_membership (
    id serial NOT NULL,
    conference_id integer NOT NULL,
    team_id integer NOT NULL,
    "year" integer NOT NULL
);


SET default_with_oids = true;

--
-- Name: game_files; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE game_files (
    id serial NOT NULL,
    game_date date NOT NULL,
    "type" character varying(32) NOT NULL,
    content text,
    parse_notes character varying(4000),
    source_id character varying(32),
    game_id integer,
    created_at timestamp without time zone
);


--
-- Name: games; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE games (
    id serial NOT NULL,
    home_team_id integer,
    visit_team_id integer,
    played_on date NOT NULL,
    neutral_site boolean DEFAULT false NOT NULL
);


--
-- Name: player; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE player (
    id serial NOT NULL,
    number integer NOT NULL,
    first_name character varying(32) NOT NULL,
    last_name character varying(32) NOT NULL,
    suffix_name character(3),
    "position" character varying(6) NOT NULL,
    height integer,
    weight integer,
    hometown character varying(64),
    acad_year smallint
);


--
-- Name: player_averages; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
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


--
-- Name: player_games; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE player_games (
    id serial NOT NULL,
    game_id integer,
    team_game_id integer,
    player_id integer,
    "type" character varying(32),
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


SET default_with_oids = false;

--
-- Name: players_2007; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE players_2007 (
    id serial NOT NULL,
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
-- Name: roster; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE roster (
    id serial NOT NULL,
    team_id integer NOT NULL,
    player_id integer NOT NULL,
    "year" integer NOT NULL
);


SET default_with_oids = true;

--
-- Name: team; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE team (
    id serial NOT NULL,
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
-- Name: team_averages; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE team_averages (
    id integer,
    team_id integer,
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
    half1_point numeric,
    half2_point numeric,
    total_point numeric
);


--
-- Name: team_diff_ranks; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE team_diff_ranks (
    id serial NOT NULL,
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
    total_point integer
);


--
-- Name: team_foe_averages; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE team_foe_averages (
    id integer,
    team_id integer,
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
    half1_point numeric,
    half2_point numeric,
    total_point numeric
);


--
-- Name: team_foe_ranks; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE team_foe_ranks (
    id serial NOT NULL,
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
    total_point integer
);


--
-- Name: team_games; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE team_games (
    id serial NOT NULL,
    game_id integer,
    team_id integer,
    "type" character varying(32),
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
-- Name: team_ranks; Type: TABLE; Schema: public; Owner: ballman; Tablespace: 
--

CREATE TABLE team_ranks (
    id serial NOT NULL,
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
    total_point integer
);


--
-- Name: conference_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: ballman; Tablespace: 
--

ALTER TABLE ONLY conference_membership
    ADD CONSTRAINT conference_membership_pkey PRIMARY KEY (id);


--
-- Name: conference_pkey; Type: CONSTRAINT; Schema: public; Owner: ballman; Tablespace: 
--

ALTER TABLE ONLY conference
    ADD CONSTRAINT conference_pkey PRIMARY KEY (id);


--
-- Name: game_files_pkey; Type: CONSTRAINT; Schema: public; Owner: ballman; Tablespace: 
--

ALTER TABLE ONLY game_files
    ADD CONSTRAINT game_files_pkey PRIMARY KEY (id);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: ballman; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: player_games_pkey; Type: CONSTRAINT; Schema: public; Owner: ballman; Tablespace: 
--

ALTER TABLE ONLY player_games
    ADD CONSTRAINT player_games_pkey PRIMARY KEY (id);


--
-- Name: player_pkey; Type: CONSTRAINT; Schema: public; Owner: ballman; Tablespace: 
--

ALTER TABLE ONLY player
    ADD CONSTRAINT player_pkey PRIMARY KEY (id);


--
-- Name: players_2007_pkey; Type: CONSTRAINT; Schema: public; Owner: ballman; Tablespace: 
--

ALTER TABLE ONLY players_2007
    ADD CONSTRAINT players_2007_pkey PRIMARY KEY (id);


--
-- Name: roster_pkey; Type: CONSTRAINT; Schema: public; Owner: ballman; Tablespace: 
--

ALTER TABLE ONLY roster
    ADD CONSTRAINT roster_pkey PRIMARY KEY (id);


--
-- Name: team_games_pkey; Type: CONSTRAINT; Schema: public; Owner: ballman; Tablespace: 
--

ALTER TABLE ONLY team_games
    ADD CONSTRAINT team_games_pkey PRIMARY KEY (id);


--
-- Name: team_pkey; Type: CONSTRAINT; Schema: public; Owner: ballman; Tablespace: 
--

ALTER TABLE ONLY team
    ADD CONSTRAINT team_pkey PRIMARY KEY (id);


--
-- Name: game_file_game_date; Type: INDEX; Schema: public; Owner: ballman; Tablespace: 
--

CREATE INDEX game_file_game_date ON game_files USING btree (game_date);


--
-- Name: player_games_team_games_id; Type: INDEX; Schema: public; Owner: ballman; Tablespace: 
--

CREATE INDEX player_games_team_games_id ON player_games USING btree (team_game_id);


--
-- Name: player_games_type_team_games_id; Type: INDEX; Schema: public; Owner: ballman; Tablespace: 
--

CREATE INDEX player_games_type_team_games_id ON player_games USING btree ("type", team_game_id);


--
-- Name: team_games_game_id; Type: INDEX; Schema: public; Owner: ballman; Tablespace: 
--

CREATE INDEX team_games_game_id ON team_games USING btree (game_id);


--
-- Name: team_games_game_id_type; Type: INDEX; Schema: public; Owner: ballman; Tablespace: 
--

CREATE INDEX team_games_game_id_type ON team_games USING btree (game_id, "type");


--
-- Name: conference_membership_conference_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ballman
--

ALTER TABLE ONLY conference_membership
    ADD CONSTRAINT conference_membership_conference_id_fkey FOREIGN KEY (conference_id) REFERENCES conference(id);


--
-- Name: conference_membership_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ballman
--

ALTER TABLE ONLY conference_membership
    ADD CONSTRAINT conference_membership_team_id_fkey FOREIGN KEY (team_id) REFERENCES team(id);


--
-- Name: games_home_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ballman
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_home_team_id_fkey FOREIGN KEY (home_team_id) REFERENCES team(id);


--
-- Name: games_visit_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ballman
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_visit_team_id_fkey FOREIGN KEY (visit_team_id) REFERENCES team(id);


--
-- Name: player_games_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ballman
--

ALTER TABLE ONLY player_games
    ADD CONSTRAINT player_games_game_id_fkey FOREIGN KEY (game_id) REFERENCES games(id);


--
-- Name: player_games_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ballman
--

ALTER TABLE ONLY player_games
    ADD CONSTRAINT player_games_player_id_fkey FOREIGN KEY (player_id) REFERENCES player(id);


--
-- Name: player_games_team_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ballman
--

ALTER TABLE ONLY player_games
    ADD CONSTRAINT player_games_team_game_id_fkey FOREIGN KEY (team_game_id) REFERENCES team_games(id);


--
-- Name: roster_player_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ballman
--

ALTER TABLE ONLY roster
    ADD CONSTRAINT roster_player_id_fkey FOREIGN KEY (player_id) REFERENCES player(id);


--
-- Name: roster_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ballman
--

ALTER TABLE ONLY roster
    ADD CONSTRAINT roster_team_id_fkey FOREIGN KEY (team_id) REFERENCES team(id);


--
-- Name: team_games_game_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ballman
--

ALTER TABLE ONLY team_games
    ADD CONSTRAINT team_games_game_id_fkey FOREIGN KEY (game_id) REFERENCES games(id);


--
-- Name: team_games_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ballman
--

ALTER TABLE ONLY team_games
    ADD CONSTRAINT team_games_team_id_fkey FOREIGN KEY (team_id) REFERENCES team(id);


--
-- PostgreSQL database dump complete
--

