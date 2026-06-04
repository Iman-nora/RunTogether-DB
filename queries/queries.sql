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


