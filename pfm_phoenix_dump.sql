--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg24.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: role; Type: TYPE; Schema: public; Owner: pfm_phoenix
--

CREATE TYPE public.role AS ENUM (
    'user',
    'admin'
);


ALTER TYPE public.role OWNER TO pfm_phoenix;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: budgets; Type: TABLE; Schema: public; Owner: pfm_phoenix
--

CREATE TABLE public.budgets (
    id bigint NOT NULL,
    name character varying(255),
    description text,
    user_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.budgets OWNER TO pfm_phoenix;

--
-- Name: budgets_id_seq; Type: SEQUENCE; Schema: public; Owner: pfm_phoenix
--

CREATE SEQUENCE public.budgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.budgets_id_seq OWNER TO pfm_phoenix;

--
-- Name: budgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pfm_phoenix
--

ALTER SEQUENCE public.budgets_id_seq OWNED BY public.budgets.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: pfm_phoenix
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE public.schema_migrations OWNER TO pfm_phoenix;

--
-- Name: transactions; Type: TABLE; Schema: public; Owner: pfm_phoenix
--

CREATE TABLE public.transactions (
    id bigint NOT NULL,
    amount numeric,
    description character varying(255),
    date date,
    category character varying(255),
    type character varying(255),
    user_id bigint NOT NULL,
    budget_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.transactions OWNER TO pfm_phoenix;

--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: pfm_phoenix
--

CREATE SEQUENCE public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_id_seq OWNER TO pfm_phoenix;

--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pfm_phoenix
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: pfm_phoenix
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email public.citext NOT NULL,
    hashed_password character varying(255) NOT NULL,
    confirmed_at timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    role public.role NOT NULL
);


ALTER TABLE public.users OWNER TO pfm_phoenix;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: pfm_phoenix
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO pfm_phoenix;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pfm_phoenix
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_tokens; Type: TABLE; Schema: public; Owner: pfm_phoenix
--

CREATE TABLE public.users_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token bytea NOT NULL,
    context character varying(255) NOT NULL,
    sent_to character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE public.users_tokens OWNER TO pfm_phoenix;

--
-- Name: users_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: pfm_phoenix
--

CREATE SEQUENCE public.users_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_tokens_id_seq OWNER TO pfm_phoenix;

--
-- Name: users_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pfm_phoenix
--

ALTER SEQUENCE public.users_tokens_id_seq OWNED BY public.users_tokens.id;


--
-- Name: budgets id; Type: DEFAULT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.budgets ALTER COLUMN id SET DEFAULT nextval('public.budgets_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_tokens id; Type: DEFAULT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.users_tokens ALTER COLUMN id SET DEFAULT nextval('public.users_tokens_id_seq'::regclass);


--
-- Data for Name: budgets; Type: TABLE DATA; Schema: public; Owner: pfm_phoenix
--

COPY public.budgets (id, name, description, user_id, inserted_at, updated_at) FROM stdin;
4	Default Budget	Automatically created default budget	2	2024-10-07 13:39:01	2024-10-07 13:39:01
5	otro budget	test con 2 budgets	\N	2024-10-07 13:40:11	2024-10-07 13:40:11
6	prueba	mlñasmñlmñsd	\N	2024-10-07 13:40:57	2024-10-07 13:40:57
3	Personal 	Budget de cosas personales	1	2024-10-07 13:39:01	2024-10-07 20:48:44
8	nuevo budget	test	1	2024-10-10 17:19:43	2024-10-10 17:19:43
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: pfm_phoenix
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20240913221444	2024-10-03 01:49:11
20240920210133	2024-10-03 01:49:11
20240920210616	2024-10-03 01:49:11
20240923184442	2024-10-03 01:49:11
20240924175917	2024-10-03 01:49:11
20240924180201	2024-10-03 01:49:11
20241001203737	2024-10-03 01:49:11
20241004154828	2024-10-07 13:28:20
20241007133730	2024-10-07 13:39:01
20241007134030	2024-10-07 13:39:01
20241008174022	2024-10-08 19:55:55
20241008192404	2024-10-08 19:55:55
20241009020934	2024-10-09 02:16:50
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: pfm_phoenix
--

COPY public.transactions (id, amount, description, date, category, type, user_id, budget_id, inserted_at, updated_at) FROM stdin;
2	98000	coto	2024-10-06	supermercado	expense	1	3	2024-10-06 22:55:57	2024-10-06 22:55:57
3	5500	verdulería	2024-10-06	supermercado	expense	1	3	2024-10-06 22:56:25	2024-10-06 22:56:25
4	276000	Navegacion 	2024-10-02	hobbies	expense	1	3	2024-10-03 02:15:00	2024-10-08 19:51:00
5	67000	Lente - Cuota 3/6	2024-10-01	hobbies	expense	1	3	2024-10-04 14:04:12	2024-10-08 19:51:11
6	8699.5	Farmacity - Ovulos agus	2024-10-02	supermercado	expense	1	3	2024-10-04 14:00:09	2024-10-08 19:51:27
7	13793	Cabanas	2024-10-02	supermercado	expense	1	3	2024-10-04 14:05:07	2024-10-08 19:51:33
9	10500	Carbon y frutillas	2024-10-05	supermercado	expense	1	3	2024-10-05 18:48:31	2024-10-08 19:51:45
10	15700	panadería 	2024-10-06	supermercado	expense	1	3	2024-10-06 22:56:51	2024-10-08 19:52:14
12	13125	dietética 	2024-10-06	supermercado	expense	1	3	2024-10-06 22:57:54	2024-10-08 19:52:24
13	1167894.49	Brubank	2024-10-04	tarjetas	expense	1	3	2024-10-04 13:55:27	2024-10-08 19:52:46
14	123000	Regalo Naty y mami día de la madre	2024-10-03	otros	expense	1	3	2024-10-04 13:56:35	2024-10-08 19:52:56
15	35000	Cochera	2024-01-01	auto	expense	1	3	2024-10-04 14:03:33	2024-10-08 19:53:12
16	5500	BruPlus	2024-10-02	tarjetas	expense	1	3	2024-10-04 14:05:37	2024-10-08 19:53:24
17	37000	Muestra Naty 	2024-10-05	salidas	expense	1	3	2024-10-06 13:45:36	2024-10-08 19:53:37
18	8700	lavadero	2024-10-06	auto	expense	1	3	2024-10-06 22:54:58	2024-10-08 19:53:55
19	10000	nafta axion	2024-10-06	auto	expense	1	3	2024-10-06 22:58:23	2024-10-08 19:54:28
20	28140	pastas	2024-10-08	supermercado	expense	1	3	2024-10-08 21:16:11	2024-10-08 21:16:11
21	1900000	Sueldo	2024-10-01	otros	income	1	3	2024-10-09 00:36:01	2024-10-09 00:36:01
22	2000	Devolución nafta Axion Brubank	2024-10-06	auto	income	1	3	2024-10-09 00:36:40	2024-10-09 00:36:40
23	7000	chino pañales, pan y coca	2024-10-10	supermercado	expense	1	3	2024-10-10 13:04:33	2024-10-10 13:04:33
24	36466.75	transferencia Agus para dentista de los nenes	2024-10-10	otros	expense	1	3	2024-10-10 18:01:07	2024-10-10 18:01:07
25	372725.40	entrada belo	2024-10-04	otros	income	1	3	2024-10-10 18:23:33	2024-10-10 18:23:33
26	29762.24	entrada belo	2024-10-04	otros	income	1	3	2024-10-10 18:24:26	2024-10-10 18:24:26
27	751000	imr	2024-10-01	otros	income	1	3	2024-10-10 18:26:02	2024-10-10 18:26:02
65	50022.23	belo	2024-10-23	extras	income	1	3	2024-10-25 11:25:21	2024-10-25 11:25:21
28	250000	Agus me lo pase yo desde cuenta dni	2024-10-04	otros	income	1	3	2024-10-10 18:29:13	2024-10-10 18:29:13
29	200000	me paso agus de dls que vendimos	2024-10-06	otros	income	1	3	2024-10-10 18:30:01	2024-10-10 18:30:01
8	59650	panning - asado en lo de puri	2024-10-04	supermercado	expense	1	3	2024-10-05 12:33:43	2024-10-10 18:30:43
31	530329.89	Cuota Toyota	2024-10-10	auto	expense	1	3	2024-10-12 10:04:53	2024-10-12 10:04:53
32	8000	chino	2024-10-12	supermercado	expense	1	3	2024-10-12 17:46:32	2024-10-12 17:46:32
33	50000	Belo	2024-10-15	otros	income	1	3	2024-10-15 20:35:13	2024-10-15 20:35:13
34	23000	pastas	2024-10-15	supermercado	expense	1	3	2024-10-15 21:56:55	2024-10-15 21:56:55
35	40000	belo	2024-10-16	otros	income	1	3	2024-10-16 19:06:45	2024-10-16 19:06:45
36	40000	sueldo Helen 	2024-10-16	otros	expense	1	3	2024-10-16 19:07:38	2024-10-16 19:07:38
37	18800	pizza y empanadas	2024-10-16	salidas	expense	1	3	2024-10-16 22:44:23	2024-10-16 22:44:23
38	2400	alfajores	2024-10-17	supermercado	expense	1	3	2024-10-18 02:51:33	2024-10-18 02:51:33
39	8800	auto	2024-10-17	auto	expense	1	3	2024-10-18 02:51:56	2024-10-18 02:51:56
40	50000	belo para Agus	2024-10-18	otros	income	1	3	2024-10-18 12:15:52	2024-10-18 12:15:52
41	50000	Agus	2024-10-18	otros	expense	1	3	2024-10-18 12:16:13	2024-10-18 12:16:13
42	50000	belo	2024-10-18	otros	income	1	3	2024-10-18 12:16:30	2024-10-18 12:16:30
43	30000	macarons 	2024-10-18	otros	expense	1	3	2024-10-18 12:16:53	2024-10-18 12:16:53
44	2500	Coca 	2024-10-18	supermercado	expense	1	3	2024-10-18 13:30:28	2024-10-18 13:30:28
45	21060	pastas	2024-10-18	supermercado	expense	1	3	2024-10-18 13:31:04	2024-10-18 13:31:04
46	730000	colegio	2024-10-01	familia	expense	1	3	2024-10-20 02:04:35	2024-10-20 02:04:35
47	11800	belo	2024-10-19	extras	income	1	3	2024-10-20 13:02:15	2024-10-20 13:02:15
48	11800	napo	2024-10-19	supermercado	expense	1	3	2024-10-20 13:02:41	2024-10-20 13:02:41
49	16000	remera	2024-10-18	otros	expense	1	3	2024-10-22 21:35:35	2024-10-22 21:35:35
50	14400	chino	2024-10-18	supermercado	expense	1	3	2024-10-22 21:36:47	2024-10-22 21:36:47
51	30400	belo	2024-10-18	extras	income	1	3	2024-10-22 21:37:36	2024-10-22 21:37:36
52	7330	belo	2024-10-21	extras	income	1	3	2024-10-22 21:38:39	2024-10-22 21:38:39
53	7330	chino	2024-10-21	supermercado	expense	1	3	2024-10-22 21:39:23	2024-10-22 21:39:23
54	60000	belo	2024-10-21	extras	income	1	3	2024-10-22 21:40:09	2024-10-22 21:40:09
55	26239.43	farmacia	2024-10-21	familia	expense	1	3	2024-10-22 21:41:23	2024-10-22 21:41:23
56	27165	verduleria	2024-10-21	supermercado	expense	1	3	2024-10-22 21:41:53	2024-10-22 21:41:53
58	20000	regalo Leon	2024-10-22	familia	expense	1	3	2024-10-22 21:43:41	2024-10-22 21:43:41
59	80000	belo	2024-10-24	extras	income	1	3	2024-10-24 11:36:30	2024-10-24 11:36:30
60	80000	Agus para pagar a Helen y extras	2024-10-24	otros	expense	1	3	2024-10-24 11:37:07	2024-10-24 11:37:07
61	8200	belo	2024-10-24	extras	income	1	3	2024-10-25 11:17:07	2024-10-25 11:17:07
62	8200	chino	2024-10-24	supermercado	expense	1	3	2024-10-25 11:17:26	2024-10-25 11:17:26
63	20000	belo	2024-10-22	extras	income	1	3	2024-10-25 11:21:28	2024-10-25 11:21:28
57	60000	belo	2024-10-22	extras	income	1	3	2024-10-22 21:43:25	2024-10-25 11:22:01
64	17240	libreria chicos	2024-10-23	familia	expense	1	3	2024-10-25 11:23:55	2024-10-25 11:23:55
66	10000	cash	2024-10-31	extras	income	1	3	2024-10-31 19:35:40	2024-10-31 19:35:40
67	10000	merienda en el club	2024-10-31	familia	expense	1	3	2024-10-31 19:36:12	2024-10-31 19:36:12
68	1923825	cash	2024-10-31	sueldo	income	1	3	2024-11-01 14:09:02	2024-11-01 14:09:02
69	7120	Cafe + roll de canela	2024-11-01	salidas	expense	1	3	2024-11-01 14:15:32	2024-11-01 14:15:32
70	28000	pizza y napo	2024-11-01	salidas	expense	1	3	2024-11-01 23:58:54	2024-11-01 23:58:54
71	43000	para agus (helado vacalin merienda, taller yoga)	2024-11-01	familia	expense	1	3	2024-11-02 00:00:28	2024-11-02 00:00:28
72	750000	sueldo Rojas x brubank	2024-11-04	sueldo	income	1	3	2024-11-04 17:39:40	2024-11-04 17:39:40
73	21000	verdulería	2024-11-03	supermercado	expense	1	3	2024-11-04 17:40:41	2024-11-04 17:40:41
74	50000	La fuerza	2024-11-02	salidas	expense	1	3	2024-11-04 17:41:17	2024-11-04 17:41:17
75	18500	Birras Niceto	2024-11-02	salidas	expense	1	3	2024-11-04 17:41:54	2024-11-04 17:41:54
76	1350000	IMR	2024-11-01	sueldo	income	1	3	2024-11-04 17:45:16	2024-11-04 17:45:16
77	29000	Agus 	2024-11-03	familia	expense	1	3	2024-11-04 17:46:12	2024-11-04 17:46:12
78	67000	cuota lente	2024-11-04	hobbies	expense	1	3	2024-11-04 17:47:08	2024-11-04 17:47:08
79	40000	cochera	2024-11-04	auto	expense	1	3	2024-11-04 17:47:43	2024-11-04 17:47:43
80	1393204.58	tarjeta brubank	2024-11-04	tarjetas	expense	1	3	2024-11-04 17:48:22	2024-11-04 17:48:22
81	5500	bruplus	2024-11-03	tarjetas	expense	1	3	2024-11-04 17:49:09	2024-11-04 17:49:09
82	15000	taxi	2024-11-02	salidas	expense	1	3	2024-11-04 17:49:44	2024-11-04 17:49:44
83	5650	cabify	2024-11-02	salidas	expense	1	3	2024-11-04 18:58:41	2024-11-04 18:58:41
84	720000	Colegio 	2024-11-05	familia	expense	1	3	2024-11-06 01:45:06	2024-11-06 01:45:06
85	37737.5	Internet	2024-11-05	otros	expense	1	3	2024-11-06 01:47:09	2024-11-06 01:47:09
86	125737.05	Expensas	2024-11-05	otros	expense	1	3	2024-11-06 01:48:10	2024-11-06 01:48:10
87	51367.37	Gas	2024-11-05	otros	expense	1	3	2024-11-06 01:48:41	2024-11-06 01:48:41
88	12839.18	Luz Edesur	2024-11-05	otros	expense	1	3	2024-11-06 01:49:18	2024-11-06 01:49:18
89	460944.33	OSDE	2024-11-05	otros	expense	1	3	2024-11-06 01:49:48	2024-11-06 01:49:48
90	137391	Club	2024-11-06	familia	expense	1	3	2024-11-06 21:24:07	2024-11-06 21:24:07
91	446000	Sueldo (400usd a 1115)	2024-11-06	sueldo	income	1	3	2024-11-06 21:24:28	2024-11-06 21:25:48
92	46000	Agus (me paso 400)	2024-11-06	familia	expense	1	3	2024-11-06 21:26:21	2024-11-06 21:26:21
93	5000	sube	2024-11-06	otros	expense	1	3	2024-11-06 21:55:28	2024-11-06 21:55:28
94	20000	Air 	2024-11-06	salidas	expense	1	3	2024-11-07 11:20:34	2024-11-07 11:20:34
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: pfm_phoenix
--

COPY public.users (id, email, hashed_password, confirmed_at, inserted_at, updated_at, role) FROM stdin;
1	admin@zlnk.im	$2b$12$uUBF3wXRW6gmltldfqr6xewE.qmfOoeeYrmVyHrofDRgRamR573iK	\N	2024-10-03 01:59:18	2024-10-03 01:59:18	admin
2	user@zlnk.im	$2b$12$4PMh46C6pilSzLwgGSjMXOKPt/AXreQbW1U8RXsXYtFOKI85Wi2MG	\N	2024-10-03 02:00:01	2024-10-03 02:00:01	user
3	test@zlnk.im	$2b$12$gtY2BdGCto/BStV8gHir/uGPwP3PcFqSs0tuwcLtw4FdsMquwRf4q	\N	2024-10-08 20:01:54	2024-10-08 20:01:54	user
4	test@zlnk.com	$2b$12$p/whOcbzMUX/gFanFitVn.LLVAklt7O3zKSZHR76IrB1iB.2co1QS	\N	2024-10-08 20:03:29	2024-10-08 20:03:29	user
5	test@zlnk.comsadasd	$2b$12$MsBCc07tJRMbJTWTlPx1qe/BcBkl0lFqwqNd6yOHPTvezwm.LEJQm	\N	2024-10-08 20:04:25	2024-10-08 20:04:25	user
6	test@zsema.com	$2b$12$bjXR.Jk5SOn/GMUKH8gyUu.NGiS06Z5HukSKx0/kH0C5HChVtP6US	\N	2024-10-08 20:07:58	2024-10-08 20:07:58	user
7	test@lols.com	$2b$12$doo.fHEL8lKFNUvFRUc82eyAdj4lMRcIhvQn8cPjlNWBsVM7ASAFS	2024-10-08 20:11:16	2024-10-08 20:08:38	2024-10-08 20:11:16	user
8	dev@zlnk.im	$2b$12$Mp.pVhMj0nMcoy7OJdEK..nYp49eC9lRQEtiE4G4fzMxjCbnJ9HEO	2024-10-08 20:11:51	2024-10-08 20:11:31	2024-10-08 20:11:51	user
\.


--
-- Data for Name: users_tokens; Type: TABLE DATA; Schema: public; Owner: pfm_phoenix
--

COPY public.users_tokens (id, user_id, token, context, sent_to, inserted_at) FROM stdin;
2	2	\\x1d3d4bf1e00fd273ae4eda87d58f4128f04eb9898a9d98094ec39826f9385b16	confirm	user@zlnk.im	2024-10-03 02:00:01
5	1	\\x8bed396b45227e3802cac62fa4ae3a70fda16880b26b81c478e9c5a7e8e946f1	session	\N	2024-10-04 14:12:03
6	3	\\xa4a98960171f99052fd6bdd5002b486b7b485d88ad1661ed8aef3786724b0b53	confirm	test@zlnk.im	2024-10-08 20:01:54
7	4	\\xbeff3ac406643072696f5e264807b3696cba3dedd028620cbea7eb4db623ede9	confirm	test@zlnk.com	2024-10-08 20:03:29
8	5	\\x0feaa89e3efe73853dd2f728165501bbe099d17885f5c29ce3787b3b1fe250d0	confirm	test@zlnk.comsadasd	2024-10-08 20:04:25
9	6	\\x3f27a757024a34cbecd21dce536c296dc6e77c1bb9b04e1c54750a960425d17b	confirm	test@zsema.com	2024-10-08 20:07:58
13	1	\\xaf5dd7b329ab7fa9a93fe622634806afb9cd81f6c4edda542991376cf0c09188	session	\N	2024-10-08 20:12:56
14	1	\\x22b46b8f6016c55aec5ef8ea2b8eef30e41ccdb88127615ca629e4fc3c99e348	session	\N	2024-10-10 03:47:06
15	1	\\x6f1ee3f3d5cec9dfd203aca9787cd12d06e9e422418bf342d4b8bb087e39f705	session	\N	2024-10-15 20:34:49
16	1	\\x7e2c654a308dfbc0c2b00b81b0caebd8a0d157c8cd76323c28ae3d01d1ad6c5c	session	\N	2024-10-31 19:35:17
17	1	\\x07e2174f12ba267dc2c15b299e19a95320f228c12f9bdab066d2a8364f0bfb1e	session	\N	2024-11-01 14:07:41
18	1	\\x7e363dad754fe4b258d7f12656b6c6a9f3e03ad17c5ec6f006957e6fe3d0b12a	session	\N	2024-11-04 17:38:02
\.


--
-- Name: budgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pfm_phoenix
--

SELECT pg_catalog.setval('public.budgets_id_seq', 8, true);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pfm_phoenix
--

SELECT pg_catalog.setval('public.transactions_id_seq', 94, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pfm_phoenix
--

SELECT pg_catalog.setval('public.users_id_seq', 8, true);


--
-- Name: users_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pfm_phoenix
--

SELECT pg_catalog.setval('public.users_tokens_id_seq', 18, true);


--
-- Name: budgets budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_tokens users_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_pkey PRIMARY KEY (id);


--
-- Name: budgets_user_id_index; Type: INDEX; Schema: public; Owner: pfm_phoenix
--

CREATE INDEX budgets_user_id_index ON public.budgets USING btree (user_id);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: pfm_phoenix
--

CREATE UNIQUE INDEX users_email_index ON public.users USING btree (email);


--
-- Name: users_tokens_context_token_index; Type: INDEX; Schema: public; Owner: pfm_phoenix
--

CREATE UNIQUE INDEX users_tokens_context_token_index ON public.users_tokens USING btree (context, token);


--
-- Name: users_tokens_user_id_index; Type: INDEX; Schema: public; Owner: pfm_phoenix
--

CREATE INDEX users_tokens_user_id_index ON public.users_tokens USING btree (user_id);


--
-- Name: budgets budgets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.budgets
    ADD CONSTRAINT budgets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: transactions transactions_budget_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_budget_id_fkey FOREIGN KEY (budget_id) REFERENCES public.budgets(id) ON DELETE CASCADE;


--
-- Name: transactions transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users_tokens users_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pfm_phoenix
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

