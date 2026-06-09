------------------  SQL QUERIES  -----------------------
--------------------------------------------------------

-- Multi-table join => users with sport sessions eligible for an ongoing challenge

SELECT DISTINCT user_pseudo
FROM SportSession, Member, Activity_type, Challenge
WHERE   SportSession.user_pseudo = Member.user_pseudo
AND Member.id_challenge = Activity_type.id_challenge
AND Activity_type.sport_label = SportSession.sport_label
AND Challenge.id_challenge = Member.id_challenge
AND CURRENT_TIMESTAMP BETWEEN Challenge.start_date AND Challenge.end_date;

-- Self-join => all followers of X who are also followed by someone X follows : X might know them -> friend recommendation for X. Example: X = 'nathan'
SELECT F1.follower AS utilisateur_recommande, COUNT(*) AS amis_en_commun
FROM Follow F1, Follow F2
WHERE F1.following = 'nathan'
AND   F2.following = F1.follower
AND F2.follower IN (
     SELECT following FROM Follow 
    WHERE follower = ‘nathan’
)
AND F1.follower NOT IN (
    SELECT following FROM Follow
    WHERE follower = 'nathan'
)
GROUP BY F1.follower
ORDER BY amis_en_commun DESC;

-- Correlated subquery => users whose score is above the average score of the users following them

SELECT u.pseudo, u.score
FROM AppUser u
WHERE u.score > (
    SELECT AVG(u2.score)
    FROM AppUser u2, Follow f
    WHERE u2.pseudo = f.follower
    AND u.pseudo = f.following
);


-- Subquery in FROM => average number of sessions per user per month
SELECT user_pseudo, AVG(nb_ss) 
FROM    (
    SELECT user_pseudo, COUNT(id_session) as nb_ss
    FROM SportSession
    GROUP BY user_pseudo, DATE_TRUNC('month', start_time)   
) as Count_ss 
GROUP BY user_pseudo
;


-- Subquery in WHERE => users who never joined a group challenge
SELECT  pseudo
FROM    AppUser
WHERE   pseudo NOT IN (
    SELECT  user_pseudo
    FROM    Member, Challenge
    WHERE   Member.id_challenge = Challenge.id_challenge
    AND     max_member > 1
);

-- 1st aggregation with GROUP BY & HAVING  => users whose minimum sport session duration is below the average for a given sport 

SELECT user_pseudo, sport_label, MIN(end_time - start_time) as min_time
FROM    SportSession S1
GROUP BY user_pseudo, sport_label
HAVING  MIN(end_time - start_time) < (
    SELECT AVG(end_time - start_time)
    FROM    SportSession S2
    WHERE   S2.sport_label = S1.sport_label
);

-- 2nd aggregation with GROUP BY & HAVING => sports with more than X sessions recorded per user on average 

SELECT  sport_label, AVG(nb_sessions) AS avg_per_user
FROM (
    SELECT sport_label, COUNT(id_session) as nb_sessions
    FROM SportSession
    GROUP BY sport_label, user_pseudo
) AS count_session
GROUP BY sport_label
HAVING AVG(nb_sessions) > 2;

-- Query involving the calculation of two nested aggregates  => sport with the highest sum of average elevation gain per user 
SELECT sport_label, MAX(sum_elv) as max_sum
FROM (
    SELECT sport_label, SUM(elevation) AS sum_elv
    FROM (
        SELECT sport_label, AVG(elevation_gain) as elevation
        FROM SportSession
        GROUP BY sport_label, user_pseudo
    ) AS sum_elevation
    GROUP BY sport_label
) AS max_elevation
ORDER BY sum_elv DESC LIMIT 1;

-- Outer Join LEFT JOIN  => Users and their badges, including those with no badge yet

SELECT  pseudo, pass_label
FROM    AppUser   
LEFT JOIN   UserPass    ON  AppUser.pseudo = UserPass.user_pseudo
LEFT JOIN   Pass        ON  Pass.id_pass = UserPass.id_pass; 



-- 1st Equivalent query  : totality condition with correlated subquery => buddy users with no untagged sports sessions
SELECT F1.follower
FROM Follow F1, Follow F2
WHERE F2.following = F1.follower
AND   F2.follower = F1.following 
AND NOT EXISTS (
    SELECT *
    FROM SportSession
    WHERE SportSession.user_pseudo = F1.follower
    AND NOT EXISTS (
        SELECT 1
        FROM SessionTag
        WHERE SessionTag.id_session = SportSession.id_session
    )
);

-- 2nd equivalent query : totality condition with aggregation => buddy users whose number of tagged sports sessions equals their total number of sports sessions 

SELECT F1.follower
FROM Follow F1
JOIN Follow F2 ON F2.following = F1.follower AND F2.follower = F1.following
JOIN SportSession S ON S.user_pseudo = F1.follower
LEFT JOIN SessionTag st ON st.id_session = S.id_session
GROUP BY F1.follower
HAVING COUNT(S.id_session) = COUNT(st.tag_label);

-- NULL Query version  1 ( should return the same result as version 2 if no NULLs ,different otherwise ) => sport sessions whose sport appears in no challenge (NOT IN)

SELECT id_session, sport_label
FROM SportSession
WHERE sport_label NOT IN (
    SELECT sport_label FROM Activity_type
);

-- NULL query version 2 (same result as version 1 if no NULLs, different otherwise ) => sport sessions whose sport appears in no challenge (NOT EXISTS) 
SELECT id_session, sport_label
FROM SportSession
WHERE NOT EXISTS(
    SELECT * FROM Activity_type 
    WHERE Activity_type.sport_label = SportSession.sport_label
);

