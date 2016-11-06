# Description
#   A hubot script that does the things
#
# Dependencies:
#   "hubot-jenkins": "^0.2.0"
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot auth admins - List all admins in auth file
#   hubot auth users - List all users in auth file
#   hubot auth jobs - List all jobs and authorized users
#
# Notes:
#   <optional notes required for the script>
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

listAdmins = (msg) ->
  resp = 'Jobs: \n'
  admins = auth_data.admins

  Promise.each admins, (admin) ->
    resp += '\t- ' + admin.name + '\n'
  .then () ->
    Promise.resolve resp

listUsers = (msg) ->
  resp = 'Users: \n'
  users = auth_data.users

  Promise.each users, (user) ->
    resp += '\t- ' + user.name + '\n'
  .then () ->
    Promise.resolve resp

listJobs = (msg) ->
  resp = 'Jobs: \n'
  jobs = auth_data.jobs

  Promise.each jobs, (job) ->
    resp += '\t- ' + job.name + '\n'
  .then () ->
    Promise.resolve resp

save = () ->
  fs.writeFileSync auth_path, (yaml.safeDump auth_data), ENCODING

authAdd = (msg, type) ->
  auth_data[type].push
    'name': msg.match[3]

  save()

  Promise.resolve 'adding ' + msg.match[3]

module.exports = (robot) ->
  robot.respond /auth admins([ ](add|delete|del)[ ](.*))?/i, (msg) ->
    isAdmin(msg).then () ->
      switch msg.match[2]
        when 'add'
          authAdd(msg, 'admins').then (resp) ->
            msg.send resp
        when 'del', 'delete'
          msg.send 'removing ' + user
        else
          listAdmins(msg).then (resp) ->
            msg.send resp
    .catch () ->
      msg.send ERROR_MSG

  robot.respond /auth users([ ](add|delete|del)[ ](.*))?/i, (msg) ->
    isAdmin(msg).then () ->
      switch msg.match[2]
        when 'add'
          authAdd(msg, 'users').then (resp) ->
            msg.send resp
        when 'del', 'delete'
          msg.send 'removing ' + user
        else
          listUsers(msg).then (resp) ->
            msg.send resp
    .catch () ->
      msg.send ERROR_MSG

  robot.respond /auth jobs([ ](add|delete|del)[ ](.*))?/i, (msg) ->
    isAdmin(msg).then () ->
      listJobs(msg).then (resp) ->
        msg.send resp
    .catch () ->
      msg.send ERROR_MSG
