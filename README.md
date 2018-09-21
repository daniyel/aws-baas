# BaaS (bcrypt as a service)

There are 3 parts of this service. 1st one is baas-server that runs multiple workers, 2nd one is baas-lb that connects all servers and 3rd one is baas-client that sends request to baas-lb and gets response from it.

CloudFormation template that creates autoscaling bcrypt as a service is found in `aws/stack.yaml`. This will create one EC2 instance with baas service running in docker container and classic load balancer that forwards TCP traffic to the EC2 instance. EC2 instances are connected into auto scaling group.

Second CloudFormation template (`baas-client/aws/service.yaml`) creates a BaaS client. It creates service and task in an exsisting ECS. This ECS is a little bit out of standard, because it is running a [Traefik](https://traefik.io/) as Task which forwards requests to other tasks.

Reason behind all of this is we also had a performance issue with bcrypting our customer passwords. The whole thing is inspired by auth0 article https://auth0.engineering/bcrypt-as-a-service-9e71707bda47 and thing used behind the hood is https://github.com/auth0/node-baas. 

## Development

All logic for client is in the `baas-client/server.js`.

```
$ cd baas-client
$ docker-compose up --build
```

## How to use

There are two endpoints to the baas-client.

1.

```
curl -X POST \
  http://localhost:3000/hash \
  -H 'Content-Type: application/json' \
  -d '{
        "password": "admin12345"
    }'

// returns hash
$2b$10$Vps5b5yYZ7n2wk8acxEBoedOy0yaUx2jP8luqaxFvkCcgzEyWwux.
```

2.
```
curl -X POST \
  http://localhost:3000/compare \
  -H 'Content-Type: application/json' \
  -d '{
        "password": "admin12345",
        "hash": "$2b$10$Vps5b5yYZ7n2wk8acxEBoedOy0yaUx2jP8luqaxFvkCcgzEyWwux."
    }'

// returns boolean
true
```

