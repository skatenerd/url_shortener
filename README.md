# Setup
`docker-compose up`
Visit:
`localhost;3001`

On changes to the API code, just run:
`docker-compose restart api`

# Testing
## Test API

**MAKE SURE THAT YOU HAVE SET UP THE TEST DB**
Run either `docker-compose up test` or `docker-compose up`.  This will have the side effect of running migrations.

**THEN**

`docker-compose run -w /usr/src/app/project  test bash` followed by `rspec`

OR

`docker-compose run -w /usr/src/app/project  test rspec`

## Test Web
`docker-compose run frontend /bin/sh` followed by `react-scripts test`

# Why no selenium tests?

That would be a bit of a pain to set up, and the tradeoff doesn't make sense yet.  If I run all of the other tests, then I will be pretty confident in the whole app, and I can just load it up and use it once, to check it before deploying it.

# Why nginx?

To solve the gross CORS code I had to write.  You might find it a bit confusing that nginx is forwarding frontend requests to another server, rather than serving up assets directly.  You're right, this is a bit weird.  The point is to do the bare minimum of work so I could get rid of any CORS-awareness in the API backend.  I don't think it makes sense to put more work in here, since I'd start making a bunch of assumptions about a theoretical deploy process.

