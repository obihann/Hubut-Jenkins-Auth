# Description
#   A hubot script that does the things
#
# Dependencies:
#   "obihann/hubot-jenkins": "^0.2.0"
#
# Commands:
#   hubot auth admins <del|delete|remove|add> <user> - List all admins in auth file, delete an admin, or create a new one
#   hubot auth users <del|delete|remove|add> <user> - List all users in auth file, delete a job, or create a new one
#   hubot auth jobs <del|delete|remove|add> <user> - List all jobs and authorized users, delete a job, or create a new one
#
# Author:
#   Jeff Hann <jeffhann@gmail.com>

querystring = require 'querystring'
yaml        = require 'js-yaml'
fs          = require 'fs'
path        = require 'path'
Promise     = require 'bluebird'

AUTH_FILE = '.jenkins-access.yml'
ERROR_MSG = 'http://i.imgur.com/gcxjB9d.png'
ENCODING  = 'utf8'

auth_path = path.join(__dirname, '../', AUTH_FILE)
auth_data = yaml.safeLoad(fs.readFileSync(auth_path, ENCODING))

isAdmin = (msg) ->
  resp = false
  admins = auth_data.admins
  currentUser = msg.message.user.name

  Promise.each admins, (admin) ->
    resp = true if admin.name == currentUser
  .then () ->
    if resp == true
      Promise.resolve()
    else
      Promise.reject()

authSave = () ->
  fs.writeFileSync auth_path, (yaml.safeDump auth_data), ENCODING

authList = (msg, type) ->
  resp = type + ': \n'
  items = auth_data[type]

  Promise.each items, (item) ->
    resp += '\t- ' + item.name + '\n'
  .then () ->
    Promise.resolve resp

authAdd = (msg, type) ->
  auth_data[type].push
    'name': msg.match[3]

  authSave()

  Promise.resolve 'adding ' + msg.match[3]

authRemove = (msg, type) ->
  names = auth_data[type].map (item) ->
    item.name

  pos = names.indexOf msg.match[3]

  auth_data[type].splice(pos, 1)
  authSave()

  Promise.resolve 'removing ' + msg.match[3]

module.exports = (robot) ->
  robot.respond /auth admins([ ](add|delete|del)[ ](.*))?/i, (msg) ->
    type = 'admins'

    isAdmin(msg).then () ->
      switch msg.match[2]
        when 'add'
          authAdd(msg, type).then (resp) ->
            msg.send resp
        when 'del', 'delete'
          authRemove(msg, type).then (resp) ->
            msg.send resp
        else
          listAdmins(msg).then (resp) ->
            msg.send resp
    .catch () ->
      msg.send ERROR_MSG

  robot.respond /auth users([ ](add|delete|del)[ ](.*))?/i, (msg) ->
    type = 'users'

    isAdmin(msg).then () ->
      switch msg.match[2]
        when 'add'
          authAdd(msg, type).then (resp) ->
            msg.send resp
        when 'del', 'delete', 'remove'
          authRemove(msg, type).then (resp) ->
            msg.send resp
        else
          authList(msg, type).then (resp) ->
            msg.send resp
    .catch () ->
      msg.send ERROR_MSG

  robot.respond /auth jobs([ ](add|delete|del)[ ](.*))?/i, (msg) ->
    type = 'jobs'

    switch msg.match[2]
      when 'add'
        isAdmin(msg).then () ->
          authAdd(msg, type).then (resp) ->
            msg.send resp
        .catch () ->
          msg.send ERROR_MSG
      when 'del', 'delete'
        isAdmin(msg).then () ->
          authRemove(msg, type).then (resp) ->
            msg.send resp
        .catch () ->
          msg.send ERROR_MSG
      else
        listJobs(msg).then (resp) ->
          msg.send resp
