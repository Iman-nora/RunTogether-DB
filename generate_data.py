import csv 
import os
import random
from datetime import datetime, timedelta

os.makedirs('CSV', exist_ok = True)

#===============  Sport Data ================

sports = [
    ('Endurance', None),
    ('Course à pied', 'Endurance'),
    ('Trail', 'Course à pied'),
    ('Marathon', 'Course à pied'),
    ('Ultra-trail', 'Trail'),
    ('Cyclisme', 'Endurance'),
    ('Vélo de route', 'Cyclisme'),
    ('VTT', 'Cyclisme'),
    ('Enduro', 'VTT'),
    ('Gravel', 'Cyclisme'),
    ('Natation', 'Endurance'),
    ('Natation en eau libre', 'Natation'),
    ('Randonnée', 'Endurance'),
    ('Marche nordique', 'Randonnée'),
    ('Trekking', 'Randonnée'),
    ('Sports nautiques', 'Endurance'),
    ('Kayak', 'Sports nautiques'),
    ('Aviron', 'Sports nautiques'),
    ('Sports hivernaux', 'Endurance'),
    ('Ski de fond', 'Sports hivernaux'),
    ('Triathlon', 'Endurance'),
    ('Fitness', None),
    ('CrossFit', 'Fitness'),
    ('Yoga', None),
    ('Pilates', None),
    ('Arts martiaux', None),
    ('Judo', 'Arts martiaux'),
    ('Sports collectifs', None),
    ('Football', 'Sports collectifs'),
    ('Basketball', 'Sports collectifs'),
    ('Escalade', None),
    ('Boulder', 'Escalade'),
    ('Danse', None),
    ('Zumba', 'Danse'),
]

with open('CSV/sport.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['sport_label', 'parent_label'])
    for sport, parent in sports:
        writer.writerow([sport, parent if parent else ''])


#=============== AppUser Data ================

pseudos = ['alice', 'bob', 'charlie', 'diana', 'eve', 'frank', 
           'grace', 'hugo', 'iris', 'julien', 'kara', 'leo', 
           'mona', 'nathan', 'olivia']

privacy_options = ['public', 'buddies', 'private']

with open('CSV/appuser.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['pseudo', 'password', 'privacy_setting', 'score', 'registration_date'])
    for pseudo in pseudos:
        password = pseudo + '123'
        privacy = random.choice(privacy_options)
        score = random.randint(0, 500)
        days_ago = random.randint(30, 730)
        reg_date = (datetime.now() - timedelta(days=days_ago)).strftime('%Y-%m-%d')
        writer.writerow([pseudo, password, privacy, score, reg_date])


#=============== Pass Data ================

passes = [
    ('Débutant', 10),
    ('Sportif', 50),
    ('Athlète', 150),
    ('Champion', 300),
    ('Légende', 500),
]

with open('CSV/pass.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['id_pass', 'pass_label', 'required_score'])
    for i, (label, score) in enumerate(passes, 1):
        writer.writerow([i, label, score])


#=============== SportSession Data ================

sport_labels = [s[0] for s in sports]  # liste des noms de sports

sessions = []
with open('CSV/sportsession.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['id_session', 'user_pseudo', 'sport_label', 'start_time', 
                     'end_time', 'distance', 'elevation_gain', 'max_speed', 'min_speed'])
    for i in range(1, 21):
        user = random.choice(pseudos)
        sport = random.choice(sport_labels)
        days_ago = random.randint(1, 365)
        start = datetime.now() - timedelta(days=days_ago, hours=random.randint(6, 20))
        duration = timedelta(minutes=random.randint(20, 180))
        end = start + duration
        distance = round(random.uniform(1, 42), 2)
        elevation = round(random.uniform(0, 1500), 1)
        max_spd = round(random.uniform(5, 30), 1)
        min_spd = round(random.uniform(1, max_spd), 1)
        
        sessions.append({
            'id': i, 'user': user, 'sport': sport,
            'start': start, 'end': end
        })
        
        writer.writerow([i, user, sport,
                        start.strftime('%Y-%m-%d %H:%M:%S'),
                        end.strftime('%Y-%m-%d %H:%M:%S'),
                        distance, elevation, max_spd, min_spd])
        


#=============== Challenge Data ================

def generate_label(goal_type, goal_value):
    if goal_type == 'distance':
        return random.choice([
            f'Parcourir au moins {goal_value} km',
            f'Atteindre {goal_value} km au total',
            f'Cumul de distance : {goal_value} km',
        ])
    elif goal_type == 'elevation':
        return random.choice([
            f'Cumuler {goal_value} m de dénivelé positif',
            f'Atteindre {goal_value} m de dénivelé au total',
            f'Grimper {goal_value} m en tout',
        ])
    elif goal_type == 'time':
        return random.choice([
            f'Effectuer au moins {goal_value} heures d\'activité',
            f'Cumuler {goal_value} h de sport',
            f'Rester actif pendant {goal_value} heures au total',
        ])
    else:  # active_days
        return random.choice([
            f'Être actif pendant {goal_value} jours',
            f'S\'entraîner au moins {goal_value} jours',
            f'Enchaîner {goal_value} jours d\'activité',
        ])

goal_types = ['distance', 'elevation', 'time', 'active_days']

challenges = []
with open('CSV/challenge.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['id_challenge', 'creator', 'challenge_label', 'start_date',
                     'end_date', 'goal_type', 'goal_value', 'max_member'])
    for i in range(1, 11):
        creator = random.choice(pseudos)
        goal_type = random.choice(goal_types)
        if goal_type == 'distance':
            goal_value = random.choice([10, 50, 100, 200])
        elif goal_type == 'elevation':
            goal_value = random.choice([500, 1000, 3000, 5000])
        elif goal_type == 'time':
            goal_value = random.choice([5, 10, 20, 50])
        else:
            goal_value = random.choice([5, 10, 15, 30])
        
        days_ago = random.randint(10, 200)
        start = datetime.now() - timedelta(days=days_ago)
        end = start + timedelta(days=random.randint(7, 60))
        max_member = random.choice([1, 1, 5, 10, 20])
        
        challenges.append({
            'id': i, 'creator': creator, 'max_member': max_member
        })
        
        writer.writerow([i, creator,
                        generate_label(goal_type, goal_value),
                        start.strftime('%Y-%m-%d %H:%M:%S'),
                        end.strftime('%Y-%m-%d %H:%M:%S'),
                        goal_type, goal_value, max_member])
        
    
#=============== Devices Data ================

device_names = ['Garmin Forerunner', 'Apple Watch', 'Polar Vantage', 
                'Suunto Peak', 'Coros Pace', 'Wahoo Tickr']

devices = []
with open('CSV/device.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['device_label', 'user_pseudo'])
    used = set()
    for _ in range(20):
        user = random.choice(pseudos)
        device = random.choice(device_names)
        if (device, user) not in used:
            used.add((device, user))
            devices.append({'label': device, 'user': user})
            writer.writerow([device, user])


#=============== UserPass Data ================

with open('CSV/userpass.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['id_pass', 'user_pseudo', 'obtaining_date'])
    used = set()
    for pseudo in pseudos:
        for p in passes:
            id_pass = passes.index(p) + 1
            if p[1] <= random.randint(0, 500):
                if (id_pass, pseudo) not in used:
                    used.add((id_pass, pseudo))
                    days_ago = random.randint(1, 300)
                    date = (datetime.now() - timedelta(days=days_ago)).strftime('%Y-%m-%d')
                    writer.writerow([id_pass, pseudo, date])


#=============== Member Data ================

with open('CSV/member.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['id_challenge', 'user_pseudo', 'joining_date', 'status'])
    used = set()
    
    # Le créateur est automatiquement membre
    for c in challenges:
        used.add((c['id'], c['creator']))
        days_ago = random.randint(10, 200)
        date = (datetime.now() - timedelta(days=days_ago)).strftime('%Y-%m-%d')
        writer.writerow([c['id'], c['creator'], date, 'active'])
    
    # Ajout d'autres participants
    statuses = ['active', 'completed', 'abandoned']
    for _ in range(15):
        c = random.choice(challenges)
        user = random.choice(pseudos)
        if (c['id'], user) not in used:
            used.add((c['id'], user))
            days_ago = random.randint(1, 150)
            date = (datetime.now() - timedelta(days=days_ago)).strftime('%Y-%m-%d')
            status = random.choice(statuses)
            writer.writerow([c['id'], user, date, status])


#=============== Follow Data ================

with open('CSV/follow.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['follower', 'following'])
    used = set()
    for _ in range(30):
        a = random.choice(pseudos)
        b = random.choice(pseudos)
        if a != b and (a, b) not in used:
            used.add((a, b))
            writer.writerow([a, b])


#=============== Invite Data ================

with open('CSV/invite.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['sender', 'receiver', 'id_challenge'])
    used = set()
    for _ in range(8):
        sender = random.choice(pseudos)
        receiver = random.choice(pseudos)
        c = random.choice(challenges)
        if sender != receiver and (sender, receiver, c['id']) not in used:
            used.add((sender, receiver, c['id']))
            writer.writerow([sender, receiver, c['id']])


#=============== Activity_type Data ================

with open('CSV/activity_type.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['id_challenge', 'sport_label'])
    used = set()
    for c in challenges:
        nb_sports = random.randint(1, 3)
        chosen = random.sample(sport_labels, nb_sports)
        for sport in chosen:
            if (c['id'], sport) not in used:
                used.add((c['id'], sport))
                writer.writerow([c['id'], sport])

    
#=============== Hashtag Data ================

hashtag_options = ['#Trail', '#Montagne', '#Lac', '#Soleil', '#Urbain', 
                   '#EcoChallenge', '#Débutant', '#Compétition', '#Groupe', '#Solo']

with open('CSV/hashtag.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['id_challenge', 'hashtag_label'])
    used = set()
    for c in challenges:
        nb_tags = random.randint(1, 3)
        chosen = random.sample(hashtag_options, nb_tags)
        for tag in chosen:
            if (c['id'], tag) not in used:
                used.add((c['id'], tag))
                writer.writerow([c['id'], tag])



#=============== SessionData  ================

value_types = ['heart_rate', 'cadence', 'power', 'temperature']

with open('CSV/sessiondata.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['id_session', 'user_pseudo', 'device_label', 'value_type', 'data_value'])
    used = set()
    for s in sessions:
        matching_devices = [d for d in devices if d['user'] == s['user']]
        if matching_devices:
            device = random.choice(matching_devices)
            nb_measures = random.randint(1, 3)
            chosen_types = random.sample(value_types, nb_measures)
            for vt in chosen_types:
                if (s['id'], device['label'], vt) not in used:
                    used.add((s['id'], device['label'], vt))
                    if vt == 'heart_rate':
                        value = random.randint(60, 200)
                    elif vt == 'cadence':
                        value = random.randint(50, 120)
                    elif vt == 'power':
                        value = random.randint(80, 400)
                    else:
                        value = random.randint(-5, 40)
                    writer.writerow([s['id'], device['user'], device['label'], vt, value])


#=============== SessionTag  ================

tag_options = ['#Lac', '#Soleil', '#Sombre', '#Pluie', '#Forêt', 
               '#Ville', '#Nuit', '#Matin', '#Froid', '#Chaud']

with open('CSV/sessiontag.csv', 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['id_session', 'tag_label'])
    used = set()
    for s in sessions:
        if random.random() > 0.3:  # 70% des sessions ont des tags
            nb_tags = random.randint(1, 3)
            chosen = random.sample(tag_options, nb_tags)
            for tag in chosen:
                if (s['id'], tag) not in used:
                    used.add((s['id'], tag))
                    writer.writerow([s['id'], tag])