# Octacle API

## Project setup

### Installs dependencies
```
bundle install
```
### Create DB / Migrate
```
rails db:create
rails db:migrate
```
### Launch Sidekiq
```
sidekiq
```
### Launch a server
```
rails s
```
### .env
```
CLOUDINARY_URL=cloudinary://*******/:********@trouni
ADMIN_PASSWORD=*******
SIDEKIQ_USERNAME=*******
SIDEKIQ_PASSWORD=*******
FOOTBALL_DATA_TOKEN=*******
```

## Download the DB
Pull from Heroku
```
rails heroku:pg_pull
```

## Football-Data API
[Import the Postman endpoints](https://www.football-data.org/documentation/quickstart)
