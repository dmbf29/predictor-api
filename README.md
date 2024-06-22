# predictor-app
## Project setup

### Create and populate .env file as follows (do the necessary changes):
```
CLOUDINARY_URL=CLOUDINARY_URL=cloudinary://<your_api_key>:<your_api_secret>@yanninthesky
FOOTBALL_DATA_TOKEN=<your_football_token>
ADMIN_PASSWORD=<your admin password>
```

### Install and run sidekiq
```
# On macOS
brew update
brew install redis
brew services start redis
sidekiq
```

```
# On Ubuntu
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

sudo apt-get update
sudo apt-get install redis
sudo apt-get install redis-server
sidekiq
```

### Create DB / Migrate / Seed
```
rails db:create
rails db:migrate
rails db:seed
```

### Installs dependencies
```
bundle install
```
### Launch a server
```
rails s
```


## Live-score API
#### Competition List
https://livescore-api.com/api-client/competitions/list.json?key=REPLACE_ME&secret=REPLACE_ME

#### Matches for Euros
https://livescore-api.com/api-client/fixtures/matches.json?key=REPLACE_ME&secret=REPLACE_ME&competition_id=387

To retreive the H2H info, you can access it in the matches list:
<img width="579" alt="Screen Shot 2021-06-01 at 15 45 21" src="https://user-images.githubusercontent.com/25542223/120278547-635e5c00-c2f0-11eb-8041-b15dd6a8970c.png">

#### Single Fixture Info
https://livescore-api.com/api-client/teams/head2head.json?key=REPLACE_ME&secret=REPLACE_ME&team1_id=1744&team2_id=1740

<img width="382" alt="Screen Shot 2021-06-01 at 15 57 25" src="https://user-images.githubusercontent.com/25542223/120279969-11b6d100-c2f2-11eb-8d62-11a19542aedc.png">

#### Getting Groups in Euros
https://livescore-api.com/api-client/competitions/groups.json?key=REPLACE_ME&secret=REPLACE_ME&competition_id=387
<img width="284" alt="Screen Shot 2021-06-01 at 16 02 54" src="https://user-images.githubusercontent.com/25542223/120280590-d668d200-c2f2-11eb-8c93-3b5c0a09aafe.png">

#### Getting Country Flag
https://livescore-api.com/api-client/countries/flag.json?key=REPLACE_ME&secret=REPLACE_ME&team_id=1440

#### Getting Live Scores
http://livescore-api.com/api-client/scores/live.json?key=REPLACE_ME&secret=REPLACE_ME&competition_id=387

#### Getting Results 
http://livescore-api.com/api-client/scores/history.json?key=REPLACE_ME&secret=REPLACE_ME&competition_id=387

<img width="645" alt="Screen Shot 2021-06-01 at 16 17 48" src="https://user-images.githubusercontent.com/25542223/120282296-ea153800-c2f4-11eb-89d0-1076596a05de.png">
