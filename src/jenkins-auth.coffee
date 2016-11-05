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

auth_path = path.join(__dirname, '../', AUTH_FILE)
auth_data = yaml.safeLoad(fs.readFileSync(auth_path, 'utf8'))

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

authAdmins = (msg) ->
  resp = 'Jobs: \n'
  admins = auth_data.admins

  Promise.each admins, (admin) ->
    resp += '\t- ' + admin.name + '\n'
  .then () ->
    Promise.resolve resp

authUsers = (msg) ->
  resp = 'Users: \n'
  users = auth_data.users

  Promise.each users, (user) ->
    resp += '\t- ' + user.name + '\n'
  .then () ->
    Promise.resolve resp

authJobs = (msg) ->
  resp = 'Jobs: \n'
  jobs = auth_data.jobs

  Promise.each jobs, (job) ->
    resp += '\t- ' + job.name + '\n'
  .then () ->
    Promise.resolve resp

module.exports = (robot) ->
  robot.respond /auth admins/i, (msg) ->
    isAdmin(msg).then () ->
      authAdmins(msg).then (resp) ->
        msg.send resp
    .catch () ->
      msg.send ERROR_MSG

  robot.respond /auth users/i, (msg) ->
    isAdmin(msg).then () ->
      authUsers(msg).then (resp) ->
        msg.send resp
    .catch () ->
      msg.send ERROR_MSG

  robot.respond /auth jobs/i, (msg) ->
    isAdmin(msg).then () ->
      authJobs(msg).then (resp) ->
        msg.send resp
    .catch () ->
      msg.send ERROR_MSG
