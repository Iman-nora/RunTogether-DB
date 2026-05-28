
----------------------------- ENTITES  -------------------------------
----------------------------------------------------------------------
-- Table Sport
CREATE  TABLE   Sport (
    sport_label              VARCHAR(50)    PRIMARY KEY,
    parent_label             VARCHAR(50),
    FOREIGN KEY (parent_label)  REFERENCES Sport(sport_label)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ;

-- AppUser
CREATE  TABLE   AppUser (
    pseudo                  VARCHAR(50)     PRIMARY KEY,
    password                VARCHAR(60)     NOT NULL,
    privacy_setting         VARCHAR(7)      DEFAULT 'public'    NOT NULL   CHECK (privacy_setting IN ('public', 'buddies', 'private') ) ,
    score                   INTEGER         DEFAULT 0,
    registration_date       DATE            DEFAULT CURRENT_DATE
);

-- Pass
CREATE  TABLE   Pass (
    id_pass                 SERIAL          PRIMARY KEY,
    pass_label              VARCHAR(100)    NOT NULL,
    required_score          INTEGER         NOT NULL
);

-- Session
CREATE  TABLE   SportSession (
    id_session              SERIAL          PRIMARY KEY,
    user_pseudo             VARCHAR(50),
    sport_label             VARCHAR(50),
    start_time              TIMESTAMP       DEFAULT CURRENT_TIMESTAMP   NOT NULL,
    end_time                TIMESTAMP,      
    distance                REAL            CHECK (distance >= 0),
    elevation_gain          REAL            CHECK (elevation_gain >= 0),
    max_speed               REAL            CHECK (max_speed >= 0),
    min_speed               REAL            CHECK (min_speed >= 0),
    FOREIGN KEY (user_pseudo)   REFERENCES  AppUser(pseudo)
        ON DELETE CASCADE   -- une seance sans utilisateur n'a pas de sens 
        ON UPDATE CASCADE,
    FOREIGN KEY (sport_label)   REFERENCES  Sport(sport_label)
        ON DELETE SET NULL  -- une seance existe de façon indépendante avec ou sans sport prealable 
        ON UPDATE CASCADE
);

-- Challenge
CREATE  TABLE   Challenge (
    id_challenge            SERIAL          PRIMARY KEY,
    creator                 VARCHAR(50),
    challenge_label         TEXT            NOT NULL,   -- description du défi
    start_date              TIMESTAMP       DEFAULT CURRENT_TIMESTAMP   NOT NULL,
    end_date                TIMESTAMP       NOT NULL,
    goal_type               TEXT            CHECK (goal_type IN ('distance', 'elevation', 'time', 'active_days')),   -- tag d'objectif 
    goal_value              REAL            NOT NULL,   -- REAL pour rester flexible sur la valeur de l'objectif du defi
    max_member              INTEGER         DEFAULT 1   NOT NULL   CHECK (max_member >= 1),  -- 1 car un defi a son createur comme participant automatiquement
    FOREIGN KEY (creator)   REFERENCES  AppUser(pseudo)
        ON DELETE SET NULL --un defi peut exister même si son createur n'est plus mais comment refuser la suppression tant qu'il y a des participants
        ON UPDATE CASCADE
);

--Device
CREATE  TABLE   Device  (
    device_label            VARCHAR(50),
    user_pseudo             VARCHAR(50),
    PRIMARY KEY (device_label, user_pseudo),
    FOREIGN KEY (user_pseudo)   REFERENCES  AppUser(pseudo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

----------------------  TABLES D'ASSOCIATION  ------------------------
----------------------------------------------------------------------

-- Table UserPass : User --> Pass

CREATE  TABLE   UserPass (
    id_pass                 INTEGER,
    user_pseudo             VARCHAR(50),
    obtaining_date          DATE            DEFAULT CURRENT_DATE    NOT NULL,
    PRIMARY KEY (id_pass, user_pseudo),
    FOREIGN KEY (id_pass)   REFERENCES    Pass(id_pass)
        ON DELETE CASCADE,
    FOREIGN KEY (user_pseudo)   REFERENCES  AppUser(pseudo)
        ON DELETE CASCADE      
        ON UPDATE CASCADE
);

-- Table Member : User --> Challenge

CREATE  TABLE   Member (
    id_challenge            INTEGER,
    user_pseudo             VARCHAR(50),
    joining_date            DATE            DEFAULT CURRENT_DATE    NOT NULL,
    status                  TEXT            DEFAULT 'active'    NOT NULL   CHECK   (status IN  ('active', 'completed', 'abandoned')),
    PRIMARY KEY (id_challenge, user_pseudo),
    FOREIGN KEY (id_challenge)  REFERENCES  Challenge(id_challenge)
        ON DELETE CASCADE,
    FOREIGN KEY (user_pseudo)   REFERENCES  AppUser(pseudo)
        ON DELETE CASCADE
        ON UPDATE CASCADE   
);

-- Table Follow : User --> User

CREATE  TABLE   Follow  (
    follower                VARCHAR(50),
    following               VARCHAR(50),
    PRIMARY KEY (follower, following),
    CHECK   (follower != following),
    FOREIGN KEY (follower)  REFERENCES  AppUser(pseudo)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (following) REFERENCES  AppUser(pseudo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

--  Table Invite : User --> User et User --> Challenge 

CREATE  TABLE   Invite  (
    sender                  VARCHAR(50),
    receiver                VARCHAR(50),
    id_challenge            INTEGER,
    PRIMARY KEY (sender, receiver, id_challenge),
    CHECK   (sender != receiver),
    FOREIGN KEY (sender)    REFERENCES  AppUser(pseudo)
        ON  DELETE CASCADE
        ON  UPDATE CASCADE,
    FOREIGN KEY (receiver)    REFERENCES  AppUser(pseudo)
        ON  DELETE CASCADE
        ON  UPDATE CASCADE,
    FOREIGN KEY (id_challenge)    REFERENCES  Challenge(id_challenge)
        ON  DELETE CASCADE
);

--  Table   Activity_type : Sport --> Challenge ==> Allowed Activities

CREATE  TABLE   Activity_type   (
    id_challenge            INTEGER,
    sport_label             VARCHAR(50),
    PRIMARY KEY (id_challenge, sport_label),
    FOREIGN KEY (id_challenge)    REFERENCES  Challenge(id_challenge)
        ON  DELETE CASCADE,
    FOREIGN KEY (sport_label)    REFERENCES  Sport(sport_label)
        ON  DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table Hashtag : Hashtag --> Challenge  

CREATE  TABLE   Hashtag (
    id_challenge            INTEGER,
    hashtag_label           VARCHAR(50),
    PRIMARY KEY (id_challenge, hashtag_label),
    FOREIGN KEY (id_challenge)    REFERENCES  Challenge(id_challenge)
        ON  DELETE CASCADE
);

-- Table Session_data : Session --> Device ==> pour les données supplementaires selon l'appareil de l'utilisateur

CREATE  TABLE   Session_data (
    id_session              INTEGER,
    user_pseudo             VARCHAR(50),
    device_label            VARCHAR(50),
    value_type              VARCHAR(50),
    data_value              REAL    CHECK   (data_value >= 0),
    PRIMARY KEY (id_session, device_label, value_type),
    FOREIGN KEY (id_session)    REFERENCES  SportSession(id_session)
        ON  DELETE CASCADE,
    FOREIGN KEY (device_label, user_pseudo)   REFERENCES  Device(device_label, user_pseudo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table SessionTag : SessionTag --> Session

CREATE TABLE    SessionTag  (
    id_session              INTEGER,
    tag_label               VARCHAR(50),
    PRIMARY KEY (id_session, tag_label),
    FOREIGN KEY (id_session)    REFERENCES  SportSession(id_session)
        ON  DELETE CASCADE
);