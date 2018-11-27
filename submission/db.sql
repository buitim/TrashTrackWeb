--
-- PostgreSQL database dump
--

-- Dumped from database version 10.6 (Ubuntu 10.6-1.pgdg14.04+1)
-- Dumped by pg_dump version 11.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE d14j8thmbumn45;
--
-- Name: d14j8thmbumn45; Type: DATABASE; Schema: -; Owner: npnjvtrjerimpq
--

CREATE DATABASE d14j8thmbumn45 WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE d14j8thmbumn45 OWNER TO npnjvtrjerimpq;

\connect d14j8thmbumn45

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: F17; Type: TABLE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE TABLE public."F17" (
    show_id integer,
    title_romaji text,
    title_english text,
    tudios_id integer,
    studios_name text,
    characters_role text,
    characters_id integer,
    characters_name_first text,
    characters_name_last text,
    "characters_voiceActors_id" integer,
    "characters_voiceActors_name_first" text,
    "characters_voiceActors_name_last" text,
    season_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public."F17" OWNER TO npnjvtrjerimpq;

--
-- Name: F18; Type: TABLE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE TABLE public."F18" (
    show_id integer,
    title_romaji text,
    title_english text,
    tudios_id integer,
    studios_name text,
    characters_role text,
    characters_id integer,
    characters_name_first text,
    characters_name_last text,
    "characters_voiceActors_id" integer,
    "characters_voiceActors_name_first" text,
    "characters_voiceActors_name_last" text,
    season_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public."F18" OWNER TO npnjvtrjerimpq;

--
-- Name: Sp18; Type: TABLE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE TABLE public."Sp18" (
    show_id integer,
    title_romaji text,
    title_english text,
    tudios_id integer,
    studios_name text,
    characters_role text,
    characters_id integer,
    characters_name_first text,
    characters_name_last text,
    "characters_voiceActors_id" integer,
    "characters_voiceActors_name_first" text,
    "characters_voiceActors_name_last" text,
    season_id integer DEFAULT 3 NOT NULL
);


ALTER TABLE public."Sp18" OWNER TO npnjvtrjerimpq;

--
-- Name: Su18; Type: TABLE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE TABLE public."Su18" (
    show_id integer,
    title_romaji text,
    title_english text,
    tudios_id integer,
    studios_name text,
    characters_role text,
    characters_id integer,
    characters_name_first text,
    characters_name_last text,
    "characters_voiceActors_id" integer,
    "characters_voiceActors_name_first" text,
    "characters_voiceActors_name_last" text,
    season_id integer DEFAULT 4 NOT NULL
);


ALTER TABLE public."Su18" OWNER TO npnjvtrjerimpq;

--
-- Name: W18; Type: TABLE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE TABLE public."W18" (
    show_id integer,
    title_romaji text,
    title_english text,
    tudios_id integer,
    studios_name text,
    characters_role text,
    characters_id integer,
    characters_name_first text,
    characters_name_last text,
    "characters_voiceActors_id" integer,
    "characters_voiceActors_name_first" text,
    "characters_voiceActors_name_last" text,
    season_id integer DEFAULT 5 NOT NULL
);


ALTER TABLE public."W18" OWNER TO npnjvtrjerimpq;

--
-- Name: character; Type: TABLE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE TABLE public."character" (
    char_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100),
    actor_id integer NOT NULL,
    show_id integer NOT NULL
);


ALTER TABLE public."character" OWNER TO npnjvtrjerimpq;

--
-- Name: character_char_id_seq; Type: SEQUENCE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE SEQUENCE public.character_char_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.character_char_id_seq OWNER TO npnjvtrjerimpq;

--
-- Name: character_char_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: npnjvtrjerimpq
--

ALTER SEQUENCE public.character_char_id_seq OWNED BY public."character".char_id;


--
-- Name: season; Type: TABLE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE TABLE public.season (
    season_id integer NOT NULL,
    season character varying(10) NOT NULL,
    year integer NOT NULL
);


ALTER TABLE public.season OWNER TO npnjvtrjerimpq;

--
-- Name: show; Type: TABLE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE TABLE public.show (
    show_id integer NOT NULL,
    title character varying(200) NOT NULL,
    studio_id integer NOT NULL,
    season_id integer
);


ALTER TABLE public.show OWNER TO npnjvtrjerimpq;

--
-- Name: voice_actor; Type: TABLE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE TABLE public.voice_actor (
    actor_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL
);


ALTER TABLE public.voice_actor OWNER TO npnjvtrjerimpq;

--
-- Name: character_view; Type: VIEW; Schema: public; Owner: npnjvtrjerimpq
--

CREATE VIEW public.character_view AS
 SELECT concat("character".first_name, ' ', "character".last_name) AS name,
    concat(voice_actor.first_name, ' ', voice_actor.last_name) AS voiced_by,
    show.title AS appeared_in,
    season.season,
    season.year
   FROM (((public."character"
     JOIN public.voice_actor ON (("character".actor_id = voice_actor.actor_id)))
     JOIN public.show ON (("character".show_id = show.show_id)))
     JOIN public.season ON ((show.season_id = season.season_id)))
  ORDER BY (concat("character".first_name, ' ', "character".last_name));


ALTER TABLE public.character_view OWNER TO npnjvtrjerimpq;

--
-- Name: season_season_id_seq; Type: SEQUENCE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE SEQUENCE public.season_season_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.season_season_id_seq OWNER TO npnjvtrjerimpq;

--
-- Name: season_season_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: npnjvtrjerimpq
--

ALTER SEQUENCE public.season_season_id_seq OWNED BY public.season.season_id;


--
-- Name: show_show_id_seq; Type: SEQUENCE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE SEQUENCE public.show_show_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.show_show_id_seq OWNER TO npnjvtrjerimpq;

--
-- Name: show_show_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: npnjvtrjerimpq
--

ALTER SEQUENCE public.show_show_id_seq OWNED BY public.show.show_id;


--
-- Name: studio; Type: TABLE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE TABLE public.studio (
    studio_id integer NOT NULL,
    name character varying(200) NOT NULL
);


ALTER TABLE public.studio OWNER TO npnjvtrjerimpq;

--
-- Name: show_view; Type: VIEW; Schema: public; Owner: npnjvtrjerimpq
--

CREATE VIEW public.show_view AS
 SELECT show.title AS show,
    studio.name AS made_by,
    season.season,
    season.year
   FROM ((public.show
     JOIN public.studio USING (studio_id))
     JOIN public.season USING (season_id))
  ORDER BY show.title;


ALTER TABLE public.show_view OWNER TO npnjvtrjerimpq;

--
-- Name: studio_studio_id_seq; Type: SEQUENCE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE SEQUENCE public.studio_studio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.studio_studio_id_seq OWNER TO npnjvtrjerimpq;

--
-- Name: studio_studio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: npnjvtrjerimpq
--

ALTER SEQUENCE public.studio_studio_id_seq OWNED BY public.studio.studio_id;


--
-- Name: studio_view; Type: VIEW; Schema: public; Owner: npnjvtrjerimpq
--

CREATE VIEW public.studio_view AS
 SELECT studio.name,
    show.title AS made,
    season.season,
    season.year
   FROM ((public.studio
     JOIN public.show USING (studio_id))
     JOIN public.season USING (season_id))
  ORDER BY studio.name;


ALTER TABLE public.studio_view OWNER TO npnjvtrjerimpq;

--
-- Name: voice_actor_actor_id_seq; Type: SEQUENCE; Schema: public; Owner: npnjvtrjerimpq
--

CREATE SEQUENCE public.voice_actor_actor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.voice_actor_actor_id_seq OWNER TO npnjvtrjerimpq;

--
-- Name: voice_actor_actor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: npnjvtrjerimpq
--

ALTER SEQUENCE public.voice_actor_actor_id_seq OWNED BY public.voice_actor.actor_id;


--
-- Name: voice_actor_view; Type: VIEW; Schema: public; Owner: npnjvtrjerimpq
--

CREATE VIEW public.voice_actor_view AS
 SELECT concat(voice_actor.first_name, ' ', voice_actor.last_name) AS name,
    concat("character".first_name, ' ', "character".last_name) AS voiced,
    season.season,
    season.year
   FROM (((public.voice_actor
     JOIN public."character" ON (("character".actor_id = voice_actor.actor_id)))
     JOIN public.show ON (("character".show_id = show.show_id)))
     JOIN public.season ON ((show.season_id = season.season_id)))
  ORDER BY (concat(voice_actor.first_name, ' ', voice_actor.last_name));


ALTER TABLE public.voice_actor_view OWNER TO npnjvtrjerimpq;

--
-- Name: character char_id; Type: DEFAULT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public."character" ALTER COLUMN char_id SET DEFAULT nextval('public.character_char_id_seq'::regclass);


--
-- Name: season season_id; Type: DEFAULT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public.season ALTER COLUMN season_id SET DEFAULT nextval('public.season_season_id_seq'::regclass);


--
-- Name: show show_id; Type: DEFAULT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public.show ALTER COLUMN show_id SET DEFAULT nextval('public.show_show_id_seq'::regclass);


--
-- Name: studio studio_id; Type: DEFAULT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public.studio ALTER COLUMN studio_id SET DEFAULT nextval('public.studio_studio_id_seq'::regclass);


--
-- Name: voice_actor actor_id; Type: DEFAULT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public.voice_actor ALTER COLUMN actor_id SET DEFAULT nextval('public.voice_actor_actor_id_seq'::regclass);


--
-- Data for Name: F17; Type: TABLE DATA; Schema: public; Owner: npnjvtrjerimpq
--

COPY public."F17" (show_id, title_romaji, title_english, tudios_id, studios_name, characters_role, characters_id, characters_name_first, characters_name_last, "characters_voiceActors_id", "characters_voiceActors_name_first", "characters_voiceActors_name_last", season_id) FROM stdin;
98443	Juuni Taisen	JUNI TAISEN：ZODIAC WAR	894	Graphinica	\N	\N	\N	\N	\N	\N	\N	2
99255	Shokugeki no Souma: San no Sara	Food Wars! The Third Plate	7	J.C. Staff	\N	\N	\N	\N	\N	\N	\N	2
99255	Shokugeki no Souma: San no Sara	Food Wars! The Third Plate	104	Lantis	MAIN	75284	Erina	Nakiri	103555	Hisako	Kanemoto	2
99255	Shokugeki no Souma: San no Sara	Food Wars! The Third Plate	104	Lantis	MAIN	76026	Megumi	Tadokoro	117003	Minami	Takahashi	2
97940	Black Clover	\N	1	Studio Pierrot	MAIN	123285	Asta	\N	123286	Gakuto	Kajiwara	2
98707	Houseki no Kuni	Land of the Lustrous	6077	Orange	MAIN	123384	Cinnabar	\N	105071	Mikako	Komatsu	2
99726	Net-juu no Susume	Recovery of an MMO Junkie	6186	comico	MAIN	123096	Lily	\N	118602	Reina\n	Ueda	2
97922	Inuyashiki	INUYASHIKI LAST HERO	569	MAPPA	MAIN	123581	Hiro	Shishigami	123582	Nijirou	Murakami	2
99255	Shokugeki no Souma: San no Sara	Food Wars! The Third Plate	104	Lantis	MAIN	75216	Souma	Yukihira	106817	Yoshitsugu	Matsuoka	2
99726	Net-juu no Susume	Recovery of an MMO Junkie	6186	comico	MAIN	123095	Hayashi	\N	123450	Ryouta	Suzuki	2
97940	Black Clover	\N	1	Studio Pierrot	MAIN	123285	Asta	\N	125129	Nao	Fujita	2
99726	Net-juu no Susume	Recovery of an MMO Junkie	6101	Signal.MD	\N	\N	\N	\N	\N	\N	\N	2
98436	Mahoutsukai no Yome	The Ancient Magus' Bride	10	Production I.G	MAIN	129385	Cartaphilus	\N	110919	Ayumu	Murase	2
97994	Blend S	BLEND-S	561	A-1 Pictures	MAIN	123294	Dino	\N	96489	Tomoaki	Maeno	2
99420	Shoujo Shuumatsu Ryokou	Girls' Last Tour	314	White Fox	MAIN	120890	\N	Yuuri	112209	Yurika	Kubo	2
99726	Net-juu no Susume	Recovery of an MMO Junkie	6186	comico	MAIN	123092	Yuuta	Sakurai	95079	Takahiro	Sakurai	2
98436	Mahoutsukai no Yome	The Ancient Magus' Bride	10	Production I.G	MAIN	88344	Chise 	Hatori	112215	Atsumi	Tanezaki	2
97994	Blend S	BLEND-S	561	A-1 Pictures	MAIN	123080	Kaho	Hinata	119722	Akari	Kito	2
99726	Net-juu no Susume	Recovery of an MMO Junkie	464	flying DOG	\N	\N	\N	\N	\N	\N	\N	2
97940	Black Clover	\N	1	Studio Pierrot	MAIN	123284	Yuno	\N	105989	Nobunaga	Shimazaki	2
97940	Black Clover	\N	1	Studio Pierrot	MAIN	123284	Yuno	\N	125130	Aki	Sekine	2
98436	Mahoutsukai no Yome	The Ancient Magus' Bride	858	Wit Studio	\N	\N	\N	\N	\N	\N	\N	2
97994	Blend S	BLEND-S	561	A-1 Pictures	MAIN	123078	Maika	Sakuranomiya	119517	Azumi	Waki	2
97994	Blend S	BLEND-S	561	A-1 Pictures	MAIN	123079	Mafuyu	Hoshikawa	122615	Anzu	Haruno	2
97922	Inuyashiki	INUYASHIKI LAST HERO	569	MAPPA	MAIN	123583	Ichirou	Inuyashiki	123584	Fumiyo	Kohinata	2
97886	Kekkai Sensen & BEYOND	Blood Blockade Battlefront & Beyond	4	BONES	MAIN	89025	Leonardo	Watch	95278	Daisuke	Sakaguchi	2
97940	Black Clover	\N	1	Studio Pierrot	MAIN	123283	Noelle	Silva	118739	Kana\n	Yuuki	2
98707	Houseki no Kuni	Land of the Lustrous	6077	Orange	MAIN	123385	Phosphophyllite	\N	106661	Tomoyo	Kurosawa	2
97994	Blend S	BLEND-S	561	A-1 Pictures	MAIN	123293	Kouyou	Akizuki	95735	Tatsuhisa	Suzuki	2
98436	Mahoutsukai no Yome	The Ancient Magus' Bride	10	Production I.G	MAIN	121430	Elias	Ainsworth	107615	Ryouta	Takeuchi	2
99726	Net-juu no Susume	Recovery of an MMO Junkie	6186	comico	MAIN	123085	Moriko	Morioka	95040	Mamiko	Noto	2
99420	Shoujo Shuumatsu Ryokou	Girls' Last Tour	314	White Fox	MAIN	120889	\N	Chito	106297	Inori	Minase	2
\.


--
-- Data for Name: F18; Type: TABLE DATA; Schema: public; Owner: npnjvtrjerimpq
--

COPY public."F18" (show_id, title_romaji, title_english, tudios_id, studios_name, characters_role, characters_id, characters_name_first, characters_name_last, "characters_voiceActors_id", "characters_voiceActors_name_first", "characters_voiceActors_name_last", season_id) FROM stdin;
101165	Goblin Slayer	GOBLIN SLAYER	314	White Fox	MAIN	126458	Goblin Slayer	\N	118908	Yuuichirou	Umehara	1
101165	Goblin Slayer	GOBLIN SLAYER	314	White Fox	MAIN	126483	Onna Shinkan	\N	105981	Yui	Ogura	1
100182	Sword Art Online: Alicization	\N	561	A-1 Pictures	MAIN	36765	Kazuto	Kirigaya	106817	Yoshitsugu	Matsuoka	1
100182	Sword Art Online: Alicization	\N	561	A-1 Pictures	MAIN	36828	Asuna	Yuuki	95890	Haruka	Tomatsu	1
100182	Sword Art Online: Alicization	\N	561	A-1 Pictures	MAIN	70899	Eugeo	\N	105989	Nobunaga	Shimazaki	1
100182	Sword Art Online: Alicization	\N	561	A-1 Pictures	MAIN	75450	Alice	Schuberg	105765	Ai	Kayano	1
101291	Seishun Buta Yarou wa Bunny Girl-senpai no Yume wo Minai	Rascal Does Not Dream of Bunny Girl Senpai	6222	CloverWorks	MAIN	127221	Sakuta	Azusagawa	115156	Kaito	Ishikawa	1
101291	Seishun Buta Yarou wa Bunny Girl-senpai no Yume wo Minai	Rascal Does Not Dream of Bunny Girl Senpai	6222	CloverWorks	MAIN	127222	Mai	Sakurajima	106787	Asami	Seto	1
101280	Tensei Shitara Slime Datta Ken	That Time I Got Reincarnated as a Slime	4418	8-bit	MAIN	123962	Rimuru	Tempest	127666	Miho	Okasaki	1
101280	Tensei Shitara Slime Datta Ken	That Time I Got Reincarnated as a Slime	4418	8-bit	MAIN	128034	Veldora	Tempest	96489	Tomoaki	Maeno	1
101280	Tensei Shitara Slime Datta Ken	That Time I Got Reincarnated as a Slime	4418	8-bit	MAIN	128035	Ranga	\N	124703	Chikahiro	Kobayashi	1
101280	Tensei Shitara Slime Datta Ken	That Time I Got Reincarnated as a Slime	4418	8-bit	MAIN	128037	Shizue	Izawa	116543	Yumiri	Hanamori	1
101280	Tensei Shitara Slime Datta Ken	That Time I Got Reincarnated as a Slime	4418	8-bit	MAIN	129347	Great Sage	\N	95144	Megumi	Toyoguchi	1
101280	Tensei Shitara Slime Datta Ken	That Time I Got Reincarnated as a Slime	4418	8-bit	MAIN	129348	Rigurdo	\N	110543	Kanehira	Yamamoto	1
101280	Tensei Shitara Slime Datta Ken	That Time I Got Reincarnated as a Slime	4418	8-bit	MAIN	129349	Rigor	\N	119200	Haruki	Ishiya	1
101280	Tensei Shitara Slime Datta Ken	That Time I Got Reincarnated as a Slime	4418	8-bit	MAIN	129350	Gobuta	\N	129351	Asuna	Tomari	1
103871	Zombie Land Saga	ZOMBIE LAND SAGA	569	MAPPA	MAIN	127538	Saki	Nikaidou	107666	Asami	Tano	1
103871	Zombie Land Saga	ZOMBIE LAND SAGA	569	MAPPA	MAIN	127539	Ai	Mizuno	111135	Risa	Taneda	1
103871	Zombie Land Saga	ZOMBIE LAND SAGA	569	MAPPA	MAIN	127540	Sakura	Minamoto	119416	Kaede	Hondo	1
103871	Zombie Land Saga	ZOMBIE LAND SAGA	569	MAPPA	MAIN	127541	Junko	Konno	127542	Maki	Kawase	1
103871	Zombie Land Saga	ZOMBIE LAND SAGA	569	MAPPA	MAIN	127543	Koutarou	Tatsumi	95065	Mamoru	Miyano	1
103871	Zombie Land Saga	ZOMBIE LAND SAGA	569	MAPPA	MAIN	127651	Yuugiri	\N	119821	Rika	Kinugawa	1
103871	Zombie Land Saga	ZOMBIE LAND SAGA	569	MAPPA	MAIN	127652	Lily	Hoshikawa	118473	Minami	Tanaka	1
102351	Tokyo Ghoul:re 2	Tokyo Ghoul:re 2	1	Studio Pierrot	MAIN	87275	Ken	Kaneki	111635	Natsuki	Hanae	1
102351	Tokyo Ghoul:re 2	Tokyo Ghoul:re 2	1	Studio Pierrot	MAIN	88932	Haise	Sasaki	111635	Natsuki	Hanae	1
102351	Tokyo Ghoul:re 2	Tokyo Ghoul:re 2	1	Studio Pierrot	MAIN	126031	Nimura	Furuta	95440	Daisuke	Kishio	1
101316	Irozuku Sekai no Ashita kara	IRODUKU: The World in Colors	132	P.A. Works	MAIN	128075	Hitomi	Tsukishiro	105217	Kaori	Ishihara	1
101316	Irozuku Sekai no Ashita kara	IRODUKU: The World in Colors	132	P.A. Works	MAIN	128080	Yuito	Aoi	119672	Shouya	Chiba	1
100049	Re:Zero kara Hajimeru Isekai Seikatsu OVA	\N	314	White Fox	MAIN	88573	Subaru	Natsuki 	\N	\N	\N	1
102883	JoJo no Kimyou na Bouken: Ougon no Kaze	JoJo's Bizarre Adventure: Golden Wind	287	David Production	MAIN	10529	Giorno	Giovanna	95819	Kensho	Ono	1
102883	JoJo no Kimyou na Bouken: Ougon no Kaze	JoJo's Bizarre Adventure: Golden Wind	287	David Production	MAIN	11895	Narancia	Ghirga	116971	Daiki	Yamashita	1
102883	JoJo no Kimyou na Bouken: Ougon no Kaze	JoJo's Bizarre Adventure: Golden Wind	287	David Production	MAIN	13045	Bruno	Bucciarati	95513	Yuuichi	Nakamura	1
102883	JoJo no Kimyou na Bouken: Ougon no Kaze	JoJo's Bizarre Adventure: Golden Wind	287	David Production	MAIN	13083	Pannacotta	Fugo	119319	Junya	Enoki	1
102883	JoJo no Kimyou na Bouken: Ougon no Kaze	JoJo's Bizarre Adventure: Golden Wind	287	David Production	MAIN	13084	Guido	Mista	95097	Kousuke	Toriumi	1
102883	JoJo no Kimyou na Bouken: Ougon no Kaze	JoJo's Bizarre Adventure: Golden Wind	287	David Production	MAIN	17525	Leone	Abbacchio	95095	Junichi	Suwabe	1
102883	JoJo no Kimyou na Bouken: Ougon no Kaze	JoJo's Bizarre Adventure: Golden Wind	287	David Production	MAIN	27153	Trish	Una	\N	\N	\N	1
102883	JoJo no Kimyou na Bouken: Ougon no Kaze	JoJo's Bizarre Adventure: Golden Wind	287	David Production	MAIN	27155	Diavolo	\N	\N	\N	\N	1
102883	JoJo no Kimyou na Bouken: Ougon no Kaze	JoJo's Bizarre Adventure: Golden Wind	287	David Production	MAIN	27156	Vinegar	Doppio	\N	\N	\N	1
99749	Fairy Tail (2018)	Fairy Tail Final Season	561	A-1 Pictures	\N	\N	\N	\N	\N	\N	\N	1
99749	Fairy Tail (2018)	Fairy Tail Final Season	397	Bridge	MAIN	4839	Gray	Fullbuster	95513	Yuuichi	Nakamura	1
99749	Fairy Tail (2018)	Fairy Tail Final Season	397	Bridge	MAIN	5186	Lucy	Heartfilia	95004	Aya	Hirano	1
99749	Fairy Tail (2018)	Fairy Tail Final Season	397	Bridge	MAIN	5187	Natsu	Dragneel	95167	Tetsuya	Kakihara	1
99749	Fairy Tail (2018)	Fairy Tail Final Season	397	Bridge	MAIN	5188	Happy	\N	95008	Rie	Kugimiya	1
99749	Fairy Tail (2018)	Fairy Tail Final Season	397	Bridge	MAIN	5189	Erza	Scarlet	95092	Sayaka	Oohara	1
99749	Fairy Tail (2018)	Fairy Tail Final Season	397	Bridge	MAIN	22723	Charlés	\N	95028	Yui	Horie	1
99749	Fairy Tail (2018)	Fairy Tail Final Season	397	Bridge	MAIN	28886	Wendy	Marvell	101560	Satomi	Satou	1
\.


--
-- Data for Name: Sp18; Type: TABLE DATA; Schema: public; Owner: npnjvtrjerimpq
--

COPY public."Sp18" (show_id, title_romaji, title_english, tudios_id, studios_name, characters_role, characters_id, characters_name_first, characters_name_last, "characters_voiceActors_id", "characters_voiceActors_name_first", "characters_voiceActors_name_last", season_id) FROM stdin;
100166	Boku no Hero Academia 3	My Hero Academia Season 3	4	BONES	MAIN	88892	Katsuki	Bakugou	95270	Nobuhiko	Okamoto	3
100166	Boku no Hero Academia 3	My Hero Academia Season 3	4	BONES	MAIN	89028	Izuku	Midoriya	116971	Daiki	Yamashita	3
100166	Boku no Hero Academia 3	My Hero Academia Season 3	4	BONES	MAIN	89222	Tenya	Iida	115156	Kaito	Ishikawa	3
100166	Boku no Hero Academia 3	My Hero Academia Season 3	4	BONES	MAIN	89222	Tenya	Iida	115156	Kaito	Ishikawa	3
100166	Boku no Hero Academia 3	My Hero Academia Season 3	4	BONES	MAIN	89224	Toshinori	Yagi	95720	Kenta	Miyake	3
21127	Steins;Gate 0	\N	314	White Fox	MAIN	34470	Kurisu	Makise	103662	Asami	Imai	3
21127	Steins;Gate 0	\N	314	White Fox	MAIN	34470	Kurisu	Makise	103662	Asami	Imai	3
21127	Steins;Gate 0	\N	314	White Fox	MAIN	35252	Rintarou	Okabe	95065	Mamoru	Miyano	3
21127	Steins;Gate 0	\N	314	White Fox	MAIN	35253	Mayuri	Shiina	95185	Kana	Hanazawa	3
21127	Steins;Gate 0	\N	314	White Fox	MAIN	35255	Suzuha	Amane	95027	Yukari	Tamura	3
21127	Steins;Gate 0	\N	314	White Fox	MAIN	35258	Itaru	Hashida	95001	Tomokazu	Seki	3
100183	Sword Art Online Alternative: Gun Gale Online	Sword Art Online Alternative: Gun Gale Online	6069	Studio 3Hz	MAIN	124926	Karen	Kohiruimaki	124923	Tomori	Kusunoki	3
100183	Sword Art Online Alternative: Gun Gale Online	Sword Art Online Alternative: Gun Gale Online	6069	Studio 3Hz	MAIN	125024	Goushi	Asougi	102288	Kazuyuki	Okitsu	3
100183	Sword Art Online Alternative: Gun Gale Online	Sword Art Online Alternative: Gun Gale Online	6069	Studio 3Hz	MAIN	125026	Miyu	Shinohara	107652	Chinatsu	Akasaki	3
100183	Sword Art Online Alternative: Gun Gale Online	Sword Art Online Alternative: Gun Gale Online	6069	Studio 3Hz	MAIN	125027	\N	Pitohui	102263	Youko	Hikasa	3
100240	Tokyo Ghoul:re	Tokyo Ghoul:re	1	Studio Pierrot	MAIN	88872	Saiko	Yonebayashi	106622	Ayane	Sakura	3
100240	Tokyo Ghoul:re	Tokyo Ghoul:re	1	Studio Pierrot	MAIN	88886	Tooru	Mutsuki	119740	Natsumi	Fujiwara	3
100240	Tokyo Ghoul:re	Tokyo Ghoul:re	1	Studio Pierrot	MAIN	88887	Ginshi	Shirazu	119617	Yuuma	Uchida	3
100240	Tokyo Ghoul:re	Tokyo Ghoul:re	1	Studio Pierrot	MAIN	88932	Haise	Sasaki	111635	Natsuki	Hanae	3
100240	Tokyo Ghoul:re	Tokyo Ghoul:re	1	Studio Pierrot	MAIN	88935	Kuki	Urie	115156	Kaito	Ishikawa	3
99578	Wotaku ni Koi wa Muzukashii	Wotakoi: Love is Hard for Otaku	561	A-1 Pictures	MAIN	122189	Hirotaka	Nifuji	122874	Kento	Itou	3
99578	Wotaku ni Koi wa Muzukashii	Wotakoi: Love is Hard for Otaku	561	A-1 Pictures	MAIN	122190	Narumi	Momose	122873	Arisa	Date	3
100077	Hinamatsuri	HINAMATSURI	91	feel.	MAIN	89228	Hina	\N	125361	Takako	Tanaka	3
100077	Hinamatsuri	HINAMATSURI	91	feel.	MAIN	89229	Yoshifumi	Nitta	115096	Yoshiki	Nakajima	3
100298	Megalo Box	MEGALOBOX	73	TMS Entertainment	MAIN	125369	Joe	\N	100626	Yoshimasa	Hosoya	3
100298	Megalo Box	MEGALOBOX	73	TMS Entertainment	MAIN	127574	Yuuri	\N	95025	Hiroki	Yasumoto	3
100773	Shokugeki no Souma: San no Sara - Tootsuki Ressha-hen	Food Wars! The Third Plate: Totsuki Train Arc	7	J.C. Staff	MAIN	75216	Souma	Yukihira	106817	Yoshitsugu	Matsuoka	3
100773	Shokugeki no Souma: San no Sara - Tootsuki Ressha-hen	Food Wars! The Third Plate: Totsuki Train Arc	7	J.C. Staff	MAIN	75284	Erina	Nakiri	103555	Hisako	Kanemoto	3
100773	Shokugeki no Souma: San no Sara - Tootsuki Ressha-hen	Food Wars! The Third Plate: Totsuki Train Arc	7	J.C. Staff	MAIN	76026	Megumi	Tadokoro	117003	Minami	Takahashi	3
100179	Tada-kun wa Koi wo Shinai	Tada Never Falls In Love	95	Doga Kobo	MAIN	125332	Mitsuyoshi	Tada	95513	Yuuichi	Nakamura	3
100179	Tada-kun wa Koi wo Shinai	Tada Never Falls In Love	95	Doga Kobo	MAIN	125334	Teresa	Wagner	121821	Manaka	Iwami	3
99693	Persona 5 The Animation	PERSONA5 the Animation	17	Aniplex	\N	\N	\N	\N	\N	\N	\N	3
99693	Persona 5 The Animation	PERSONA5 the Animation	6222	CloverWorks	MAIN	120335	Ann	Takamaki	95081	Nana	Mizuki	3
99693	Persona 5 The Animation	PERSONA5 the Animation	6222	CloverWorks	MAIN	121590	Ren	Amamiya	95086	Jun	Fukuyama	3
99693	Persona 5 The Animation	PERSONA5 the Animation	6222	CloverWorks	MAIN	121635	Futaba	Sakura	101686	Aoi	Yuuki	3
99693	Persona 5 The Animation	PERSONA5 the Animation	6222	CloverWorks	MAIN	122974	Ryuji	Sakamoto	95065	Mamoru	Miyano	3
99693	Persona 5 The Animation	PERSONA5 the Animation	6222	CloverWorks	MAIN	122975	Yusuke	Kitagawa	95002	Tomokazu	Sugita	3
99693	Persona 5 The Animation	PERSONA5 the Animation	6222	CloverWorks	MAIN	122976	Morgana	\N	95128	Ikue	Ootani	3
99693	Persona 5 The Animation	PERSONA5 the Animation	6222	CloverWorks	MAIN	122977	Makoto	Niijima	95241	Rina	Satou	3
99693	Persona 5 The Animation	PERSONA5 the Animation	6222	CloverWorks	MAIN	122978	Haru	Okumura	95890	Haruka	Tomatsu	3
\.


--
-- Data for Name: Su18; Type: TABLE DATA; Schema: public; Owner: npnjvtrjerimpq
--

COPY public."Su18" (show_id, title_romaji, title_english, tudios_id, studios_name, characters_role, characters_id, characters_name_first, characters_name_last, "characters_voiceActors_id", "characters_voiceActors_name_first", "characters_voiceActors_name_last", season_id) FROM stdin;
99147	Shingeki no Kyojin 3	Attack on Titan Season 3	858	Wit Studio	MAIN	40881	Mikasa	Ackerman	100142	Yui	Ishikawa	4
99147	Shingeki no Kyojin 3	Attack on Titan Season 3	858	Wit Studio	MAIN	40882	Eren	Yeager	95672	Yuuki	Kaji	4
99147	Shingeki no Kyojin 3	Attack on Titan Season 3	858	Wit Studio	MAIN	45627	Levi	\N	95118	Hiroshi	Kamiya	4
99147	Shingeki no Kyojin 3	Attack on Titan Season 3	858	Wit Studio	MAIN	46494	Armin	Arlert	95158	Marina	Inoue	4
100977	Hataraku Saibou	Cells at Work!	287	David Production	MAIN	126975	AE3803	\N	95185	Kana	Hanazawa	4
100977	Hataraku Saibou	Cells at Work!	287	David Production	MAIN	126981	U-1146	\N	96489	Tomoaki	Maeno	4
101474	Overlord III	\N	11	MADHOUSE	MAIN	89103	Momonga	\N	95245	Satoshi	Hino	4
99629	Satsuriku no Tenshi	Angels of Death	7	J.C. Staff	MAIN	123327	Rachel	Gardner	115795	Haruka	Chisuga	4
99629	Satsuriku no Tenshi	Angels of Death	7	J.C. Staff	MAIN	123328	Isaac	Foster	95270	Nobuhiko	Okamoto	4
101004	Isekai Maou to Shoukan Shoujo no Dorei Majutsu	How Not to Summon a Demon Lord	30	Ajia-Do	MAIN	126791	Shera	L Greenwood	116515	Yuu	Serizawa	4
101004	Isekai Maou to Shoukan Shoujo no Dorei Majutsu	How Not to Summon a Demon Lord	30	Ajia-Do	MAIN	126793	Diablo	\N	126794	Masaaki	Mizunaka	4
101004	Isekai Maou to Shoukan Shoujo no Dorei Majutsu	How Not to Summon a Demon Lord	30	Ajia-Do	MAIN	126795	Rem	Galleu	119517	Azumi	Waki	4
100922	Grand Blue	Grand Blue Dreaming	6117	Zero-G	MAIN	123181	Chisa	Kotegawa	106030	Chika	Anzai	4
100922	Grand Blue	Grand Blue Dreaming	6117	Zero-G	MAIN	123182	Iori	Kitahara	119617	Yuuma	Uchida	4
100922	Grand Blue	Grand Blue Dreaming	6117	Zero-G	MAIN	127420	Aina	Yoshiwara	95817	Kana	Asumi	4
100723	Boku no Hero Academia THE MOVIE: Futari no Hero	My Hero Academia the Movie: Two Heroes	4	BONES	MAIN	89028	Izuku	Midoriya	116971	Daiki	Yamashita	4
100723	Boku no Hero Academia THE MOVIE: Futari no Hero	My Hero Academia the Movie: Two Heroes	4	BONES	MAIN	89224	Toshinori	Yagi	95720	Kenta	Miyake	4
100723	Boku no Hero Academia THE MOVIE: Futari no Hero	My Hero Academia the Movie: Two Heroes	4	BONES	MAIN	125951	Melissa	Shield	105433	Mirai	Shida	4
100723	Boku no Hero Academia THE MOVIE: Futari no Hero	My Hero Academia the Movie: Two Heroes	4	BONES	MAIN	125952	David	Shield	125953	Katsuhisa	Namase	4
100723	Boku no Hero Academia THE MOVIE: Futari no Hero	My Hero Academia the Movie: Two Heroes	4	BONES	MAIN	126277	Wolfram	\N	95113	Rikiya	Koyama	4
101001	Asobi Asobase	Asobi Asobase - workshop of fun -	456	Lerche	MAIN	126452	Hanako	Honda	119822	Hina	Kino	4
101001	Asobi Asobase	Asobi Asobase - workshop of fun -	456	Lerche	MAIN	126453	Kasumi	Nomura	121961	Konomi	Kohara	4
100388	BANANA FISH	\N	569	MAPPA	MAIN	13580	Ash	Lynx	119617	Yuuma	Uchida	4
100388	BANANA FISH	\N	569	MAPPA	MAIN	21928	Eiji	Okumura	95074	Kenji	Nojima	4
101045	Hanebado!	HANEBADO!	839	LIDENFILMS	MAIN	126609	Ayano	Hanesaki	118920	Hitomi	Ohwada	4
101045	Hanebado!	HANEBADO!	839	LIDENFILMS	MAIN	126826	Nagisa	Aragaki	126579	Miyuri	Shimabukuro	4
\.


--
-- Data for Name: W18; Type: TABLE DATA; Schema: public; Owner: npnjvtrjerimpq
--

COPY public."W18" (show_id, title_romaji, title_english, tudios_id, studios_name, characters_role, characters_id, characters_name_first, characters_name_last, "characters_voiceActors_id", "characters_voiceActors_name_first", "characters_voiceActors_name_last", season_id) FROM stdin;
99423	Darling in the Franxx	DARLING in the FRANXX	803	Trigger	\N	\N	\N	\N	\N	\N	\N	5
99423	Darling in the Franxx	DARLING in the FRANXX	17	Aniplex	\N	\N	\N	\N	\N	\N	\N	5
99423	Darling in the Franxx	DARLING in the FRANXX	6222	CloverWorks	\N	\N	\N	\N	\N	\N	\N	5
99423	Darling in the Franxx	DARLING in the FRANXX	561	A-1 Pictures	MAIN	124380	Hiro	\N	118498	Yuto	Uemura	5
99423	Darling in the Franxx	DARLING in the FRANXX	561	A-1 Pictures	MAIN	124381	Zero Two	\N	95890	Haruka	Tomatsu	5
99423	Darling in the Franxx	DARLING in the FRANXX	561	A-1 Pictures	MAIN	124382	Ichigo	\N	124390	Kana	Ichinose	5
21827	Violet Evergarden	Violet Evergarden	2	Kyoto Animation	MAIN	90169	Violet	Evergarden	100142	Yui	Ishikawa	5
98437	Overlord II	\N	11	MADHOUSE	MAIN	89103	Momonga	\N	95245	Satoshi	Hino	5
98460	DEVILMAN crybaby	Devilman Crybaby	6145	Science SARU	\N	\N	\N	\N	\N	\N	\N	5
98460	DEVILMAN crybaby	Devilman Crybaby	17	Aniplex	MAIN	2456	Akira	Fudou	96764	Kouki	Uchiyama	5
98460	DEVILMAN crybaby	Devilman Crybaby	17	Aniplex	MAIN	4092	Ryou	Asuka	110919	Ayumu	Murase	5
98460	DEVILMAN crybaby	Devilman Crybaby	17	Aniplex	MAIN	7968	Miki	Makimura	107961	Megumi	Han	5
99539	Nanatsu no Taizai: Imashime no Fukkatsu	The Seven Deadly Sins: Revival of the Commandments	561	A-1 Pictures	MAIN	72921	Meliodas	\N	95672	Yuuki	Kaji	5
99539	Nanatsu no Taizai: Imashime no Fukkatsu	The Seven Deadly Sins: Revival of the Commandments	561	A-1 Pictures	MAIN	72923	Elizabeth	Liones	116517	Sora	Amamiya	5
99539	Nanatsu no Taizai: Imashime no Fukkatsu	The Seven Deadly Sins: Revival of the Commandments	561	A-1 Pictures	MAIN	74653	Diane	\N	101686	Aoi	Yuuki	5
99539	Nanatsu no Taizai: Imashime no Fukkatsu	The Seven Deadly Sins: Revival of the Commandments	561	A-1 Pictures	MAIN	77605	Ban	\N	95735	Tatsuhisa	Suzuki	5
99539	Nanatsu no Taizai: Imashime no Fukkatsu	The Seven Deadly Sins: Revival of the Commandments	561	A-1 Pictures	MAIN	83801	King	\N	95086	Jun	Fukuyama	5
99539	Nanatsu no Taizai: Imashime no Fukkatsu	The Seven Deadly Sins: Revival of the Commandments	561	A-1 Pictures	MAIN	86683	Hawk	\N	106641	Misaki	Kuno	5
99539	Nanatsu no Taizai: Imashime no Fukkatsu	The Seven Deadly Sins: Revival of the Commandments	561	A-1 Pictures	MAIN	88823	Gowther	\N	119202	Yuuhei	Takagi	5
99539	Nanatsu no Taizai: Imashime no Fukkatsu	The Seven Deadly Sins: Revival of the Commandments	561	A-1 Pictures	MAIN	89180	Merlin	\N	95090	Maaya	Sakamoto	5
99539	Nanatsu no Taizai: Imashime no Fukkatsu	The Seven Deadly Sins: Revival of the Commandments	561	A-1 Pictures	MAIN	90202	Escanor	\N	95002	Tomokazu	Sugita	5
99426	Sora yori mo Tooi Basho	A Place Further Than the Universe	11	MADHOUSE	MAIN	124545	Mari	Tamaki	106297	Inori	Minase	5
99426	Sora yori mo Tooi Basho	A Place Further Than the Universe	11	MADHOUSE	MAIN	124546	Shirase	Kobuchizawa	95185	Kana	Hanazawa	5
99426	Sora yori mo Tooi Basho	A Place Further Than the Universe	11	MADHOUSE	MAIN	124547	Hinata	Miyake	95885	Yuka	Iguchi	5
99426	Sora yori mo Tooi Basho	A Place Further Than the Universe	11	MADHOUSE	MAIN	124548	Yuzuki	Shiraishi	95869	Saori	Hayami	5
98444	Yuru Camp△	Laid-Back Camp	6074	C-Station	MAIN	124576	Nadeshiko	Kagamihara	116543	Yumiri	Hanamori	5
98444	Yuru Camp△	Laid-Back Camp	6074	C-Station	MAIN	124577	Aoi	Inuyama	95599	Aki	Toyosaki	5
98444	Yuru Camp△	Laid-Back Camp	6074	C-Station	MAIN	124578	Chiaki	Oogaki	107013	Sayuri	Hara	5
98444	Yuru Camp△	Laid-Back Camp	6074	C-Station	MAIN	124579	Ena	Saitou	119331	Rie	Takahashi	5
98444	Yuru Camp△	Laid-Back Camp	6074	C-Station	MAIN	124586	Rin	Shima	106184	Nao	Touyama	5
97832	Citrus	Citrus	911	Passione	\N	\N	\N	\N	\N	\N	\N	5
97832	Citrus	Citrus	104	Lantis	\N	\N	\N	\N	\N	\N	\N	5
97832	Citrus	Citrus	6064	Infinite	MAIN	83209	Mei	Aihara	106492	Minami	Tsuda	5
97832	Citrus	Citrus	6064	Infinite	MAIN	83367	Yuzu	Aihara	101996	Ayana	Taketatsu	5
99468	Karakai Jouzu no Takagi-san	KARAKAI JOZU NO TAKAGI-SAN	247	Shin-Ei Animation	MAIN	120799	\N	Nishikata	95672	Yuuki	Kaji	5
99468	Karakai Jouzu no Takagi-san	KARAKAI JOZU NO TAKAGI-SAN	247	Shin-Ei Animation	MAIN	120800	\N	Takagi	119331	Rie	Takahashi	5
97907	Death March Kara Hajimaru Isekai Kyousoukyoku	Death March to the Parallel World Rhapsody	300	SILVER LINK.	MAIN	124912	Pochi	\N	128640	Hiyori	Kono	5
97907	Death March Kara Hajimaru Isekai Kyousoukyoku	Death March to the Parallel World Rhapsody	300	SILVER LINK.	MAIN	124914	Tama	\N	118474	Kaya	Okuno	5
97907	Death March Kara Hajimaru Isekai Kyousoukyoku	Death March to the Parallel World Rhapsody	300	SILVER LINK.	MAIN	124916	Liza	\N	106492	Minami	Tsuda	5
97907	Death March Kara Hajimaru Isekai Kyousoukyoku	Death March to the Parallel World Rhapsody	300	SILVER LINK.	MAIN	124917	Arisa	\N	101686	Aoi	Yuuki	5
97907	Death March Kara Hajimaru Isekai Kyousoukyoku	Death March to the Parallel World Rhapsody	300	SILVER LINK.	MAIN	124918	Lulu	\N	120170	Marika	Hayase	5
97907	Death March Kara Hajimaru Isekai Kyousoukyoku	Death March to the Parallel World Rhapsody	300	SILVER LINK.	MAIN	124921	Ichiro	Suzuki	119869	Shun	Horie	5
\.


--
-- Data for Name: character; Type: TABLE DATA; Schema: public; Owner: npnjvtrjerimpq
--

COPY public."character" (char_id, first_name, last_name, actor_id, show_id) FROM stdin;
129386	Send	Help	129352	21127
124912	Pochi	\N	128640	97907
124578	Chiaki	Oogaki	107013	98444
89028	Izuku	Midoriya	116971	100166
128037	Shizue	Izawa	116543	101280
123328	Isaac	Foster	95270	99629
76026	Megumi	Tadokoro	117003	99255
123181	Chisa	Kotegawa	106030	100922
126791	Shera	L Greenwood	116515	101004
122978	Haru	Okumura	95890	99693
72921	Meliodas	\N	95672	99539
89228	Hina	\N	125361	100077
123962	Rimuru	Tempest	127666	101280
122976	Morgana	\N	95128	99693
124586	Rin	Shima	106184	98444
124545	Mari	Tamaki	106297	99426
126981	U-1146	\N	96489	100977
124917	Arisa	\N	101686	97907
4839	Gray	Fullbuster	95513	99749
121635	Futaba	Sakura	101686	99693
89103	Momonga	\N	95245	98437
13580	Ash	Lynx	119617	100388
46494	Armin	Arlert	95158	99147
121430	Elias	Ainsworth	107615	98436
123095	Hayashi	\N	123450	99726
124921	Ichiro	Suzuki	119869	97907
40882	Eren	Yeager	95672	99147
123294	Dino	\N	96489	97994
126609	Ayano	Hanesaki	118920	101045
89224	Toshinori	Yagi	95720	100723
120335	Ann	Takamaki	95081	99693
88344	Chise 	Hatori	112215	98436
124380	Hiro	\N	118498	99423
88823	Gowther	\N	119202	99539
83367	Yuzu	Aihara	101996	97832
28886	Wendy	Marvell	101560	99749
124547	Hinata	Miyake	95885	99426
123327	Rachel	Gardner	115795	99629
126453	Kasumi	Nomura	121961	101001
126483	Onna Shinkan	\N	105981	101165
74653	Diane	\N	101686	99539
89229	Yoshifumi	Nitta	115096	100077
129348	Rigurdo	\N	110543	101280
128034	Veldora	Tempest	96489	101280
122975	Yusuke	Kitagawa	95002	99693
125369	Joe	\N	100626	100298
35258	Itaru	Hashida	95001	21127
124918	Lulu	\N	120170	97907
123078	Maika	Sakuranomiya	119517	97994
127652	Lily	Hoshikawa	118473	103871
126452	Hanako	Honda	119822	101001
121590	Ren	Amamiya	95086	99693
45627	Levi	\N	95118	99147
124546	Shirase	Kobuchizawa	95185	99426
36828	Asuna	Yuuki	95890	100182
75284	Erina	Nakiri	103555	100773
5187	Natsu	Dragneel	95167	99749
13084	Guido	Mista	95097	102883
124926	Karen	Kohiruimaki	124923	100183
126277	Wolfram	\N	95113	100723
124576	Nadeshiko	Kagamihara	116543	98444
122190	Narumi	Momose	122873	99578
127541	Junko	Konno	127542	103871
122974	Ryuji	Sakamoto	95065	99693
77605	Ban	\N	95735	99539
123080	Kaho	Hinata	119722	97994
125334	Teresa	Wagner	121821	100179
123092	Yuuta	Sakurai	95079	99726
127651	Yuugiri	\N	119821	103871
127538	Saki	Nikaidou	107666	103871
125951	Melissa	Shield	105433	100723
129385	Cartaphilus	\N	110919	98436
129350	Gobuta	\N	129351	101280
5189	Erza	Scarlet	95092	99749
7968	Miki	Makimura	107961	98460
2456	Akira	Fudou	96764	98460
5186	Lucy	Heartfilia	95004	99749
123384	Cinnabar	\N	105071	98707
75216	Souma	Yukihira	106817	100773
40881	Mikasa	Ackerman	100142	99147
36765	Kazuto	Kirigaya	106817	100182
124548	Yuzuki	Shiraishi	95869	99426
123079	Mafuyu	Hoshikawa	122615	97994
124579	Ena	Saitou	119331	98444
125024	Goushi	Asougi	102288	100183
34470	Kurisu	Makise	103662	21127
126975	AE3803	\N	95185	100977
128080	Yuito	Aoi	119672	101316
126793	Diablo	\N	126794	101004
129347	Great Sage	\N	95144	101280
125332	Mitsuyoshi	Tada	95513	100179
123583	Ichirou	Inuyashiki	123584	97922
124577	Aoi	Inuyama	95599	98444
124382	Ichigo	\N	124390	99423
127574	Yuuri	\N	95025	100298
123385	Phosphophyllite	\N	106661	98707
123581	Hiro	Shishigami	123582	97922
90202	Escanor	\N	95002	99539
125952	David	Shield	125953	100723
126795	Rem	Galleu	119517	101004
123085	Moriko	Morioka	95040	99726
124381	Zero Two	\N	95890	99423
13083	Pannacotta	Fugo	119319	102883
89180	Merlin	\N	95090	99539
11895	Narancia	Ghirga	116971	102883
83209	Mei	Aihara	106492	97832
35253	Mayuri	Shiina	95185	21127
126826	Nagisa	Aragaki	126579	101045
123293	Kouyou	Akizuki	95735	97994
129349	Rigor	\N	119200	101280
72923	Elizabeth	Liones	116517	99539
127540	Sakura	Minamoto	119416	103871
10529	Giorno	Giovanna	95819	102883
127539	Ai	Mizuno	111135	103871
89222	Tenya	Iida	115156	100166
35255	Suzuha	Amane	95027	21127
124916	Liza	\N	106492	97907
122189	Hirotaka	Nifuji	122874	99578
126458	Goblin Slayer	\N	118908	101165
5188	Happy	\N	95008	99749
125026	Miyu	Shinohara	107652	100183
127222	Mai	Sakurajima	106787	101291
128035	Ranga	\N	124703	101280
35252	Rintarou	Okabe	95065	21127
70899	Eugeo	\N	105989	100182
123182	Iori	Kitahara	119617	100922
21928	Eiji	Okumura	95074	100388
4092	Ryou	Asuka	110919	98460
123096	Lily	\N	118602	99726
22723	Charlés	\N	95028	99749
89025	Leonardo	Watch	95278	97886
127221	Sakuta	Azusagawa	115156	101291
127543	Koutarou	Tatsumi	95065	103871
88892	Katsuki	Bakugou	95270	100166
128075	Hitomi	Tsukishiro	105217	101316
17525	Leone	Abbacchio	95095	102883
83801	King	\N	95086	99539
75450	Alice	Schuberg	105765	100182
90169	Violet	Evergarden	100142	21827
122977	Makoto	Niijima	95241	99693
124914	Tama	\N	118474	97907
127420	Aina	Yoshiwara	95817	100922
13045	Bruno	Bucciarati	95513	102883
86683	Hawk	\N	106641	99539
\.


--
-- Data for Name: season; Type: TABLE DATA; Schema: public; Owner: npnjvtrjerimpq
--

COPY public.season (season_id, season, year) FROM stdin;
1	Fall	2018
2	Fall	2017
3	Spring	2018
4	Summer	2018
5	Winter	2018
6	Winter	2017
\.


--
-- Data for Name: show; Type: TABLE DATA; Schema: public; Owner: npnjvtrjerimpq
--

COPY public.show (show_id, title, studio_id, season_id) FROM stdin;
99255	Shokugeki no Souma: San no Sara	104	2
99420	Shoujo Shuumatsu Ryokou	314	2
97922	Inuyashiki	569	2
98436	Mahoutsukai no Yome	10	2
98707	Houseki no Kuni	6077	2
97886	Kekkai Sensen & BEYOND	4	2
100077	Hinamatsuri	91	3
99749	Fairy Tail (2018)	397	1
99629	Satsuriku no Tenshi	7	4
100049	Re:Zero kara Hajimeru Isekai Seikatsu OVA	314	1
99693	Persona 5 The Animation	17	3
99423	Darling in the Franxx	6222	5
100179	Tada-kun wa Koi wo Shinai	95	3
101474	Overlord III	11	4
101291	Seishun Buta Yarou wa Bunny Girl-senpai no Yume wo Minai	6222	1
103871	Zombie Land Saga	569	1
99726	Net-juu no Susume	464	2
98443	Juuni Taisen	894	2
100773	Shokugeki no Souma: San no Sara - Tootsuki Ressha-hen	7	3
21127	Steins;Gate 0	314	3
97994	Blend S	561	2
100182	Sword Art Online: Alicization	561	1
100166	Boku no Hero Academia 3	4	3
97832	Citrus	6064	5
101280	Tensei Shitara Slime Datta Ken	4418	1
100723	Boku no Hero Academia THE MOVIE: Futari no Hero	4	4
99578	Wotaku ni Koi wa Muzukashii	561	3
100388	BANANA FISH	569	4
101316	Irozuku Sekai no Ashita kara	132	1
102883	JoJo no Kimyou na Bouken: Ougon no Kaze	287	1
100183	Sword Art Online Alternative: Gun Gale Online	6069	3
98444	Yuru Camp△	6074	5
101004	Isekai Maou to Shoukan Shoujo no Dorei Majutsu	30	4
100298	Megalo Box	73	3
98437	Overlord II	11	5
101045	Hanebado!	839	4
100977	Hataraku Saibou	287	4
21827	Violet Evergarden	2	5
99426	Sora yori mo Tooi Basho	11	5
100922	Grand Blue	6117	4
99468	Karakai Jouzu no Takagi-san	247	5
99539	Nanatsu no Taizai: Imashime no Fukkatsu	561	5
98460	DEVILMAN crybaby	6145	5
101165	Goblin Slayer	314	1
97907	Death March Kara Hajimaru Isekai Kyousoukyoku	300	5
101001	Asobi Asobase	456	4
99147	Shingeki no Kyojin 3	858	4
100240	Tokyo Ghoul:re	1	3
97940	Black Clover	1	2
102351	Tokyo Ghoul:re 2	1	1
\.


--
-- Data for Name: studio; Type: TABLE DATA; Schema: public; Owner: npnjvtrjerimpq
--

COPY public.studio (studio_id, name) FROM stdin;
858	Wit Studio
10	Production I.G
6223	Studio Ouch
7	J.C. Staff
104	Lantis
561	A-1 Pictures
6101	Signal.MD
464	flying DOG
6186	comico
569	MAPPA
6077	Orange
314	White Fox
4	BONES
894	Graphinica
6222	CloverWorks
4418	8-bit
1	Studio Pierrot
132	P.A. Works
287	David Production
397	Bridge
6069	Studio 3Hz
91	feel.
73	TMS Entertainment
95	Doga Kobo
17	Aniplex
11	MADHOUSE
30	Ajia-Do
6117	Zero-G
456	Lerche
839	LIDENFILMS
803	Trigger
2	Kyoto Animation
6145	Science SARU
6074	C-Station
911	Passione
6064	Infinite
247	Shin-Ei Animation
300	SILVER LINK.
\.


--
-- Data for Name: voice_actor; Type: TABLE DATA; Schema: public; Owner: npnjvtrjerimpq
--

COPY public.voice_actor (actor_id, first_name, last_name) FROM stdin;
129352	Nani	Dafuq
107961	Megumi	Han
106184	Nao	Touyama
106297	Inori	Minase
119202	Yuuhei	Takagi
106661	Tomoyo	Kurosawa
102263	Youko	Hikasa
117003	Minami	Takahashi
119869	Shun	Horie
112209	Yurika	Kubo
115795	Haruka	Chisuga
128640	Hiyori	Kono
126794	Masaaki	Mizunaka
118474	Kaya	Okuno
105433	Mirai	Shida
129351	Asuna	Tomari
105989	Nobunaga	Shimazaki
123450	Ryouta	Suzuki
95128	Ikue	Ootani
96764	Kouki	Uchiyama
126579	Miyuri	Shimabukuro
110919	Ayumu	Murase
120170	Marika	Hayase
100142	Yui	Ishikawa
106492	Minami	Tsuda
95065	Mamoru	Miyano
123582	Nijirou	Murakami
116517	Sora	Amamiya
118498	Yuto	Uemura
115096	Yoshiki	Nakajima
124703	Chikahiro	Kobayashi
125361	Takako	Tanaka
95028	Yui	Horie
95599	Aki	Toyosaki
121961	Konomi	Kohara
95672	Yuuki	Kaji
95002	Tomokazu	Sugita
95118	Hiroshi	Kamiya
95027	Yukari	Tamura
95819	Kensho	Ono
95440	Daisuke	Kishio
105981	Yui	Ogura
106641	Misaki	Kuno
112215	Atsumi	Tanezaki
106030	Chika	Anzai
115156	Kaito	Ishikawa
95081	Nana	Mizuki
95735	Tatsuhisa	Suzuki
105765	Ai	Kayano
106817	Yoshitsugu	Matsuoka
95144	Megumi	Toyoguchi
95817	Kana	Asumi
123286	Gakuto	Kajiwara
119722	Akari	Kito
127542	Maki	Kawase
110543	Kanehira	Yamamoto
116971	Daiki	Yamashita
95079	Takahiro	Sakurai
95092	Sayaka	Oohara
101686	Aoi	Yuuki
95245	Satoshi	Hino
95008	Rie	Kugimiya
95185	Kana	Hanazawa
122615	Anzu	Haruno
119821	Rika	Kinugawa
119617	Yuuma	Uchida
95090	Maaya	Sakamoto
116515	Yuu	Serizawa
95720	Kenta	Miyake
106622	Ayane	Sakura
106787	Asami	Seto
95869	Saori	Hayami
122874	Kento	Itou
119517	Azumi	Waki
119331	Rie	Takahashi
121821	Manaka	Iwami
96489	Tomoaki	Maeno
95890	Haruka	Tomatsu
118602	Reina\n	Ueda
107652	Chinatsu	Akasaki
118920	Hitomi	Ohwada
107615	Ryouta	Takeuchi
123584	Fumiyo	Kohinata
103662	Asami	Imai
95040	Mamiko	Noto
122873	Arisa	Date
111635	Natsuki	Hanae
118473	Minami	Tanaka
95278	Daisuke	Sakaguchi
101996	Ayana	Taketatsu
125130	Aki	Sekine
95004	Aya	Hirano
107666	Asami	Tano
95025	Hiroki	Yasumoto
105217	Kaori	Ishihara
95074	Kenji	Nojima
125953	Katsuhisa	Namase
95001	Tomokazu	Seki
119822	Hina	Kino
95095	Junichi	Suwabe
95097	Kousuke	Toriumi
100626	Yoshimasa	Hosoya
125129	Nao	Fujita
119740	Natsumi	Fujiwara
119319	Junya	Enoki
118908	Yuuichirou	Umehara
124390	Kana	Ichinose
119672	Shouya	Chiba
118739	Kana\n	Yuuki
101560	Satomi	Satou
111135	Risa	Taneda
119416	Kaede	Hondo
95513	Yuuichi	Nakamura
95086	Jun	Fukuyama
95167	Tetsuya	Kakihara
116543	Yumiri	Hanamori
95885	Yuka	Iguchi
102288	Kazuyuki	Okitsu
124923	Tomori	Kusunoki
95270	Nobuhiko	Okamoto
95158	Marina	Inoue
119200	Haruki	Ishiya
127666	Miho	Okasaki
95113	Rikiya	Koyama
95241	Rina	Satou
105071	Mikako	Komatsu
107013	Sayuri	Hara
103555	Hisako	Kanemoto
\.


--
-- Name: character_char_id_seq; Type: SEQUENCE SET; Schema: public; Owner: npnjvtrjerimpq
--

SELECT pg_catalog.setval('public.character_char_id_seq', 129386, true);


--
-- Name: season_season_id_seq; Type: SEQUENCE SET; Schema: public; Owner: npnjvtrjerimpq
--

SELECT pg_catalog.setval('public.season_season_id_seq', 7, true);


--
-- Name: show_show_id_seq; Type: SEQUENCE SET; Schema: public; Owner: npnjvtrjerimpq
--

SELECT pg_catalog.setval('public.show_show_id_seq', 103871, true);


--
-- Name: studio_studio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: npnjvtrjerimpq
--

SELECT pg_catalog.setval('public.studio_studio_id_seq', 6223, true);


--
-- Name: voice_actor_actor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: npnjvtrjerimpq
--

SELECT pg_catalog.setval('public.voice_actor_actor_id_seq', 129352, true);


--
-- Name: character character_pkey; Type: CONSTRAINT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public."character"
    ADD CONSTRAINT character_pkey PRIMARY KEY (char_id);


--
-- Name: season season_pkey; Type: CONSTRAINT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public.season
    ADD CONSTRAINT season_pkey PRIMARY KEY (season_id);


--
-- Name: show show_pkey; Type: CONSTRAINT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public.show
    ADD CONSTRAINT show_pkey PRIMARY KEY (show_id);


--
-- Name: studio studio_pkey; Type: CONSTRAINT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public.studio
    ADD CONSTRAINT studio_pkey PRIMARY KEY (studio_id);


--
-- Name: voice_actor voice_actor_pk; Type: CONSTRAINT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public.voice_actor
    ADD CONSTRAINT voice_actor_pk PRIMARY KEY (actor_id);


--
-- Name: show Aired In; Type: FK CONSTRAINT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public.show
    ADD CONSTRAINT "Aired In" FOREIGN KEY (season_id) REFERENCES public.season(season_id) ON UPDATE CASCADE;


--
-- Name: character Appeared In; Type: FK CONSTRAINT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public."character"
    ADD CONSTRAINT "Appeared In" FOREIGN KEY (show_id) REFERENCES public.show(show_id) ON UPDATE CASCADE;


--
-- Name: show Made By; Type: FK CONSTRAINT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public.show
    ADD CONSTRAINT "Made By" FOREIGN KEY (studio_id) REFERENCES public.studio(studio_id) ON UPDATE CASCADE;


--
-- Name: character Voiced By; Type: FK CONSTRAINT; Schema: public; Owner: npnjvtrjerimpq
--

ALTER TABLE ONLY public."character"
    ADD CONSTRAINT "Voiced By" FOREIGN KEY (actor_id) REFERENCES public.voice_actor(actor_id) ON UPDATE CASCADE;


--
-- Name: DATABASE d14j8thmbumn45; Type: ACL; Schema: -; Owner: npnjvtrjerimpq
--

REVOKE CONNECT,TEMPORARY ON DATABASE d14j8thmbumn45 FROM PUBLIC;


--
-- Name: LANGUAGE plpgsql; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON LANGUAGE plpgsql TO npnjvtrjerimpq;


--
-- PostgreSQL database dump complete
--

