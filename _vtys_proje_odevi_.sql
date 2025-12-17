--
-- PostgreSQL database dump
--

\restrict NTotzi9aUQwXwcJIo0x0doJlqc0jmzp646H7YTAJNXnGjopphJqjkuEd92k72B4

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2025-12-17 21:52:38

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 25237)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 276 (class 1255 OID 26183)
-- Name: get_user_active_listings(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_user_active_listings(p_user_id uuid) RETURNS TABLE(listing_id uuid, title character varying, listing_type character varying, status character varying, created_at timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT
    l.listing_id,
    l.title,
    l.listing_type,
    l.status,
    l.created_at
  FROM listings l
  WHERE l.created_by = p_user_id
    AND l.status = 'aktif';
END;
$$;


ALTER FUNCTION public.get_user_active_listings(p_user_id uuid) OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 25606)
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 225 (class 1259 OID 25355)
-- Name: addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.addresses (
    address_id uuid DEFAULT gen_random_uuid() NOT NULL,
    country_id character varying(16) NOT NULL,
    city_id character varying(16) NOT NULL,
    district_id character varying(16) NOT NULL,
    neighborhood_id character varying(16) NOT NULL,
    address_label character varying(80) NOT NULL,
    street character varying(200),
    building_no character varying(50),
    apartment_no character varying(50),
    postal_code character varying(30),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.addresses OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 25286)
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    city_id character varying(16) NOT NULL,
    country_id character varying(16) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 25430)
-- Name: colors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.colors (
    color_id character varying(16) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.colors OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 25555)
-- Name: conversation_participants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversation_participants (
    conversation_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role character varying(30) DEFAULT 'participant'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.conversation_participants OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 25540)
-- Name: conversations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversations (
    conversation_id uuid DEFAULT gen_random_uuid() NOT NULL,
    listing_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.conversations OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 25275)
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    country_id character varying(16) NOT NULL,
    name character varying(100) NOT NULL,
    country_code character varying(10)
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 25303)
-- Name: districts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.districts (
    district_id character varying(16) NOT NULL,
    city_id character varying(16) NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.districts OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 26184)
-- Name: listing_matches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.listing_matches (
    lost_listing_id uuid NOT NULL,
    found_listing_id uuid NOT NULL,
    score integer DEFAULT 0 NOT NULL,
    reasons jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.listing_matches OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 25520)
-- Name: listing_photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.listing_photos (
    photo_id uuid DEFAULT gen_random_uuid() NOT NULL,
    listing_id uuid NOT NULL,
    file_name character varying(255),
    data_url text NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.listing_photos OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 25487)
-- Name: listings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.listings (
    listing_id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_by uuid NOT NULL,
    pet_id uuid,
    address_id uuid NOT NULL,
    listing_type character varying(20) NOT NULL,
    status character varying(20) NOT NULL,
    title character varying(200) NOT NULL,
    description character varying(4000),
    event_time character varying(64),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    species_id text
);


ALTER TABLE public.listings OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 25576)
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    message_id uuid DEFAULT gen_random_uuid() NOT NULL,
    conversation_id uuid NOT NULL,
    sender_user_id uuid NOT NULL,
    body character varying(2000) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 25320)
-- Name: neighborhoods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.neighborhoods (
    neighborhood_id character varying(16) NOT NULL,
    district_id character varying(16) NOT NULL,
    name character varying(120) NOT NULL
);


ALTER TABLE public.neighborhoods OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 25630)
-- Name: pet_colors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pet_colors (
    pet_id uuid NOT NULL,
    color_id character varying(16) NOT NULL
);


ALTER TABLE public.pet_colors OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 25441)
-- Name: pets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pets (
    pet_id uuid DEFAULT gen_random_uuid() NOT NULL,
    owner_user_id uuid NOT NULL,
    species_id character varying(16) NOT NULL,
    name character varying(100),
    sex character varying(20) DEFAULT 'bilinmiyor'::character varying NOT NULL,
    age_years integer,
    microchip_no character varying(80),
    distinctive_marks character varying(2000),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.pets OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 25419)
-- Name: species; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.species (
    species_id character varying(16) NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.species OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 25393)
-- Name: user_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_addresses (
    user_id uuid NOT NULL,
    address_id uuid NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_addresses OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25337)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id uuid DEFAULT gen_random_uuid() NOT NULL,
    full_name character varying(150) NOT NULL,
    email character varying(150) NOT NULL,
    phone character varying(30),
    password_hash character varying(255) NOT NULL,
    primary_address_id uuid,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 26178)
-- Name: vw_active_lost_listings; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_active_lost_listings AS
 SELECT l.listing_id,
    l.title,
    l.description,
    l.event_time,
    l.created_at,
    s.name AS species_name,
    c.name AS city_name,
    d.name AS district_name,
    n.name AS neighborhood_name
   FROM (((((public.listings l
     JOIN public.species s ON (((s.species_id)::text = l.species_id)))
     JOIN public.addresses a ON ((a.address_id = l.address_id)))
     JOIN public.cities c ON (((c.city_id)::text = (a.city_id)::text)))
     JOIN public.districts d ON (((d.district_id)::text = (a.district_id)::text)))
     JOIN public.neighborhoods n ON (((n.neighborhood_id)::text = (a.neighborhood_id)::text)))
  WHERE (((l.listing_type)::text = 'kayıp'::text) AND ((l.status)::text = 'aktif'::text));


ALTER VIEW public.vw_active_lost_listings OWNER TO postgres;

--
-- TOC entry 5011 (class 2606 OID 25372)
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (address_id);


--
-- TOC entry 4995 (class 2606 OID 25688)
-- Name: cities cities_country_id_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_country_id_name_key UNIQUE (country_id, name);


--
-- TOC entry 4997 (class 2606 OID 25668)
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (city_id);


--
-- TOC entry 5019 (class 2606 OID 25440)
-- Name: colors colors_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.colors
    ADD CONSTRAINT colors_name_key UNIQUE (name);


--
-- TOC entry 5021 (class 2606 OID 25775)
-- Name: colors colors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.colors
    ADD CONSTRAINT colors_pkey PRIMARY KEY (color_id);


--
-- TOC entry 5040 (class 2606 OID 25565)
-- Name: conversation_participants conversation_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation_participants
    ADD CONSTRAINT conversation_participants_pkey PRIMARY KEY (conversation_id, user_id);


--
-- TOC entry 5038 (class 2606 OID 25549)
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (conversation_id);


--
-- TOC entry 4991 (class 2606 OID 25285)
-- Name: countries countries_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_name_key UNIQUE (name);


--
-- TOC entry 4993 (class 2606 OID 25650)
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (country_id);


--
-- TOC entry 4999 (class 2606 OID 25721)
-- Name: districts districts_city_id_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_city_id_name_key UNIQUE (city_id, name);


--
-- TOC entry 5001 (class 2606 OID 25701)
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (district_id);


--
-- TOC entry 5049 (class 2606 OID 26198)
-- Name: listing_matches listing_matches_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listing_matches
    ADD CONSTRAINT listing_matches_pk PRIMARY KEY (lost_listing_id, found_listing_id);


--
-- TOC entry 5036 (class 2606 OID 25534)
-- Name: listing_photos listing_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listing_photos
    ADD CONSTRAINT listing_photos_pkey PRIMARY KEY (photo_id);


--
-- TOC entry 5033 (class 2606 OID 25504)
-- Name: listings listings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_pkey PRIMARY KEY (listing_id);


--
-- TOC entry 5042 (class 2606 OID 25589)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (message_id);


--
-- TOC entry 5003 (class 2606 OID 25749)
-- Name: neighborhoods neighborhoods_district_id_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.neighborhoods
    ADD CONSTRAINT neighborhoods_district_id_name_key UNIQUE (district_id, name);


--
-- TOC entry 5005 (class 2606 OID 25734)
-- Name: neighborhoods neighborhoods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.neighborhoods
    ADD CONSTRAINT neighborhoods_pkey PRIMARY KEY (neighborhood_id);


--
-- TOC entry 5044 (class 2606 OID 25846)
-- Name: pet_colors pet_colors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_colors
    ADD CONSTRAINT pet_colors_pkey PRIMARY KEY (pet_id, color_id);


--
-- TOC entry 5023 (class 2606 OID 25457)
-- Name: pets pets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_pkey PRIMARY KEY (pet_id);


--
-- TOC entry 5015 (class 2606 OID 25429)
-- Name: species species_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_name_key UNIQUE (name);


--
-- TOC entry 5017 (class 2606 OID 25762)
-- Name: species species_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.species
    ADD CONSTRAINT species_pkey PRIMARY KEY (species_id);


--
-- TOC entry 5013 (class 2606 OID 25403)
-- Name: user_addresses user_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_pkey PRIMARY KEY (user_id, address_id);


--
-- TOC entry 5007 (class 2606 OID 25354)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 5009 (class 2606 OID 25352)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 5045 (class 1259 OID 26210)
-- Name: idx_listing_matches_found; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_listing_matches_found ON public.listing_matches USING btree (found_listing_id);


--
-- TOC entry 5046 (class 1259 OID 26209)
-- Name: idx_listing_matches_lost; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_listing_matches_lost ON public.listing_matches USING btree (lost_listing_id);


--
-- TOC entry 5047 (class 1259 OID 26211)
-- Name: idx_listing_matches_score; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_listing_matches_score ON public.listing_matches USING btree (score DESC);


--
-- TOC entry 5034 (class 1259 OID 25605)
-- Name: idx_listing_photos_listing_sort; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_listing_photos_listing_sort ON public.listing_photos USING btree (listing_id, sort_order);


--
-- TOC entry 5024 (class 1259 OID 25603)
-- Name: idx_listings_address_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_listings_address_id ON public.listings USING btree (address_id);


--
-- TOC entry 5025 (class 1259 OID 25601)
-- Name: idx_listings_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_listings_created_at ON public.listings USING btree (created_at DESC);


--
-- TOC entry 5026 (class 1259 OID 25602)
-- Name: idx_listings_created_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_listings_created_by ON public.listings USING btree (created_by);


--
-- TOC entry 5027 (class 1259 OID 25892)
-- Name: idx_listings_listing_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_listings_listing_type ON public.listings USING btree (listing_type);


--
-- TOC entry 5028 (class 1259 OID 25890)
-- Name: idx_listings_species; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_listings_species ON public.listings USING btree (species_id);


--
-- TOC entry 5029 (class 1259 OID 25891)
-- Name: idx_listings_species_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_listings_species_id ON public.listings USING btree (species_id);


--
-- TOC entry 5030 (class 1259 OID 25893)
-- Name: idx_listings_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_listings_status ON public.listings USING btree (status);


--
-- TOC entry 5031 (class 1259 OID 25604)
-- Name: idx_listings_type_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_listings_type_status ON public.listings USING btree (listing_type, status);


--
-- TOC entry 5076 (class 2620 OID 25607)
-- Name: listings trg_set_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_set_updated_at BEFORE UPDATE ON public.listings FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- TOC entry 5054 (class 2606 OID 25812)
-- Name: addresses addresses_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(city_id) ON DELETE RESTRICT;


--
-- TOC entry 5055 (class 2606 OID 25800)
-- Name: addresses addresses_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON DELETE RESTRICT;


--
-- TOC entry 5056 (class 2606 OID 25824)
-- Name: addresses addresses_district_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(district_id) ON DELETE RESTRICT;


--
-- TOC entry 5057 (class 2606 OID 25836)
-- Name: addresses addresses_neighborhood_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_neighborhood_id_fkey FOREIGN KEY (neighborhood_id) REFERENCES public.neighborhoods(neighborhood_id) ON DELETE RESTRICT;


--
-- TOC entry 5050 (class 2606 OID 25690)
-- Name: cities cities_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(country_id) ON DELETE RESTRICT;


--
-- TOC entry 5068 (class 2606 OID 25566)
-- Name: conversation_participants conversation_participants_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation_participants
    ADD CONSTRAINT conversation_participants_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(conversation_id) ON DELETE CASCADE;


--
-- TOC entry 5069 (class 2606 OID 25571)
-- Name: conversation_participants conversation_participants_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversation_participants
    ADD CONSTRAINT conversation_participants_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5067 (class 2606 OID 25550)
-- Name: conversations conversations_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.listings(listing_id) ON DELETE CASCADE;


--
-- TOC entry 5051 (class 2606 OID 25723)
-- Name: districts districts_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(city_id) ON DELETE RESTRICT;


--
-- TOC entry 5074 (class 2606 OID 26204)
-- Name: listing_matches fk_match_found; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listing_matches
    ADD CONSTRAINT fk_match_found FOREIGN KEY (found_listing_id) REFERENCES public.listings(listing_id) ON DELETE CASCADE;


--
-- TOC entry 5075 (class 2606 OID 26199)
-- Name: listing_matches fk_match_lost; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listing_matches
    ADD CONSTRAINT fk_match_lost FOREIGN KEY (lost_listing_id) REFERENCES public.listings(listing_id) ON DELETE CASCADE;


--
-- TOC entry 5053 (class 2606 OID 25414)
-- Name: users fk_users_primary_address; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_primary_address FOREIGN KEY (primary_address_id) REFERENCES public.addresses(address_id) ON DELETE SET NULL;


--
-- TOC entry 5066 (class 2606 OID 25535)
-- Name: listing_photos listing_photos_listing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listing_photos
    ADD CONSTRAINT listing_photos_listing_id_fkey FOREIGN KEY (listing_id) REFERENCES public.listings(listing_id) ON DELETE CASCADE;


--
-- TOC entry 5062 (class 2606 OID 25515)
-- Name: listings listings_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(address_id) ON DELETE RESTRICT;


--
-- TOC entry 5063 (class 2606 OID 25505)
-- Name: listings listings_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5064 (class 2606 OID 25510)
-- Name: listings listings_pet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_pet_id_fkey FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON DELETE SET NULL;


--
-- TOC entry 5065 (class 2606 OID 25885)
-- Name: listings listings_species_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.listings
    ADD CONSTRAINT listings_species_id_fkey FOREIGN KEY (species_id) REFERENCES public.species(species_id) ON DELETE RESTRICT;


--
-- TOC entry 5070 (class 2606 OID 25590)
-- Name: messages messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(conversation_id) ON DELETE CASCADE;


--
-- TOC entry 5071 (class 2606 OID 25595)
-- Name: messages messages_sender_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_user_id_fkey FOREIGN KEY (sender_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5052 (class 2606 OID 25751)
-- Name: neighborhoods neighborhoods_district_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.neighborhoods
    ADD CONSTRAINT neighborhoods_district_id_fkey FOREIGN KEY (district_id) REFERENCES public.districts(district_id) ON DELETE RESTRICT;


--
-- TOC entry 5072 (class 2606 OID 25848)
-- Name: pet_colors pet_colors_color_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_colors
    ADD CONSTRAINT pet_colors_color_id_fkey FOREIGN KEY (color_id) REFERENCES public.colors(color_id) ON DELETE RESTRICT;


--
-- TOC entry 5073 (class 2606 OID 25639)
-- Name: pet_colors pet_colors_pet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pet_colors
    ADD CONSTRAINT pet_colors_pet_id_fkey FOREIGN KEY (pet_id) REFERENCES public.pets(pet_id) ON DELETE CASCADE;


--
-- TOC entry 5060 (class 2606 OID 25458)
-- Name: pets pets_owner_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_owner_user_id_fkey FOREIGN KEY (owner_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 5061 (class 2606 OID 25788)
-- Name: pets pets_species_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pets
    ADD CONSTRAINT pets_species_id_fkey FOREIGN KEY (species_id) REFERENCES public.species(species_id) ON DELETE RESTRICT;


--
-- TOC entry 5058 (class 2606 OID 25409)
-- Name: user_addresses user_addresses_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(address_id) ON DELETE CASCADE;


--
-- TOC entry 5059 (class 2606 OID 25404)
-- Name: user_addresses user_addresses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_addresses
    ADD CONSTRAINT user_addresses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


-- Completed on 2025-12-17 21:52:38

--
-- PostgreSQL database dump complete
--

\unrestrict NTotzi9aUQwXwcJIo0x0doJlqc0jmzp646H7YTAJNXnGjopphJqjkuEd92k72B4

