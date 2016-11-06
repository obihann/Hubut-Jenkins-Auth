# Hubot Jenkins Auth Manager

A Hubot plugin to manage the credentiasl database of obihann/hubot-jenkins. Stop editting it by hand, let the robots do it for you.

See [`src/jenkins-auth.coffee`](src/jenkins-auth.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install obihann/hubot-jenkins-auth --save`

Then add **hubot-jenkins-auth** to your `external-scripts.json`:

```json
[
  "hubot-jenkins-auth"
]
```

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
