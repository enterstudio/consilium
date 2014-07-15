CREATE TABLE webmasters
(
  id serial NOT NULL,
  password character varying(255) NOT NULL,
  email character varying(255) NOT NULL,
  CONSTRAINT webmasters_pkey PRIMARY KEY (id),
  CONSTRAINT webmasters_email_key UNIQUE (email)
);
 
CREATE TABLE stats
(
  id serial NOT NULL,
  webmaster_id integer NOT NULL,
  widget_id integer NOT NULL,
  uniq integer NOT NULL,
  "raw" integer NOT NULL,
  sales integer NOT NULL,
  date date NOT NULL,
  CONSTRAINT stats_pkey PRIMARY KEY (id)
);
