# Setup
`docker-compose up`
Visit:
`localhost;3001`

# Testing
## Test API
`docker-compose run -w /usr/src/app/project  test bash` followed by `rspec`
## Test Web
`docker-compose run frontend /bin/sh` followed by `react-scripts test`



