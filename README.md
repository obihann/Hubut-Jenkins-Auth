# Hubot Jenkins Auth Manager

A Hubot plugin to manage the credentiasl database of obihann/hubot-jenkins. Stop editting it by hand, let the robots do it for you.

## Installation

In hubot project repo, run:

`npm install obihann/hubot-jenkins-auth --save`

Then add **hubot-jenkins-auth** to your `external-scripts.json`:

```json
[
  "hubot-jenkins-auth"
]
```

## Commands:
- ```hubot auth admins <del|delete|remove|add> <user>``` - List all admins in auth file, delete an admin, or create a new one
- ```hubot auth users <del|delete|remove|add> <user>``` - List all users in auth file, delete a job, or create a new one
- ```hubot auth jobs <del|delete|remove|add> <job>``` - List all jobs and authorized users, delete a job, or create a new one
- ```hubot auth job <del|delete|remove|add> <user> <job>``` - List add, or remove authorized users for a specific job.

## Sample Interaction

```
user1>> auth admins
hubot>>
users: 
    - obihann

user1>> auth projects
hubot>>
users: 
    - Prod Deployment A

user1>> auth users
hubot>>
users: 
    - obihann
    - bob
```
