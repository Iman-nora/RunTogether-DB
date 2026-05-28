\copy Sport(sport_label, parent_label) FROM '/Users/iman/L3_S2/BD/Projet/CSV/sport.csv' WITH (FORMAT csv, HEADER true, NULL '');

\copy AppUser(pseudo, password, privacy_setting, score, registration_date) FROM '/Users/iman/L3_S2/BD/Projet/CSV/appuser.csv' WITH (FORMAT csv, HEADER true);

\copy Pass(id_pass, pass_label, required_score) FROM '/Users/iman/L3_S2/BD/Projet/CSV/pass.csv' WITH (FORMAT csv, HEADER true);

\copy SportSession(id_session, user_pseudo, sport_label, start_time, end_time, distance, elevation_gain, max_speed, min_speed) FROM '/Users/iman/L3_S2/BD/Projet/CSV/sportsession.csv' WITH (FORMAT csv, HEADER true);

\copy Challenge(id_challenge, creator, challenge_label, start_date, end_date, goal_type, goal_value, max_member) FROM '/Users/iman/L3_S2/BD/Projet/CSV/challenge.csv' WITH (FORMAT csv, HEADER true);

\copy Device(device_label, user_pseudo) FROM '/Users/iman/L3_S2/BD/Projet/CSV/device.csv' WITH (FORMAT csv, HEADER true);

\copy UserPass(id_pass, user_pseudo, obtaining_date) FROM '/Users/iman/L3_S2/BD/Projet/CSV/userpass.csv' WITH (FORMAT csv, HEADER true);

\copy Member(id_challenge, user_pseudo, joining_date, status) FROM '/Users/iman/L3_S2/BD/Projet/CSV/member.csv' WITH (FORMAT csv, HEADER true);

\copy Follow(follower, following) FROM '/Users/iman/L3_S2/BD/Projet/CSV/follow.csv' WITH (FORMAT csv, HEADER true);

\copy Invite(sender, receiver, id_challenge) FROM '/Users/iman/L3_S2/BD/Projet/CSV/invite.csv' WITH (FORMAT csv, HEADER true);

\copy Activity_type(id_challenge, sport_label) FROM '/Users/iman/L3_S2/BD/Projet/CSV/activity_type.csv' WITH (FORMAT csv, HEADER true);

\copy Hashtag(id_challenge, hashtag_label) FROM '/Users/iman/L3_S2/BD/Projet/CSV/hashtag.csv' WITH (FORMAT csv, HEADER true);

\copy Session_data(id_session, user_pseudo, device_label, value_type, data_value) FROM '/Users/iman/L3_S2/BD/Projet/CSV/sessiondata.csv' WITH (FORMAT csv, HEADER true);

\copy SessionTag(id_session, tag_label) FROM '/Users/iman/L3_S2/BD/Projet/CSV/sessiontag.csv' WITH (FORMAT csv, HEADER true);