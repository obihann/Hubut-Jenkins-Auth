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

authUsers = (msg) ->
  auth_path = path.join(__dirname, '../.jenkins-access.yml')
  users = yaml.safeLoad(fs.readFileSync(auth_path, 'utf8')).users

  resp = ''
  users.forEach (user) ->
    resp += '- ' + user.name + ' (' + user.level + ')' + '\n'

  msg.send resp

authJobs = (msg) ->
  auth_path = path.join(__dirname, '../.jenkins-access.yml')
  doc = yaml.safeLoad(fs.readFileSync(auth_path, 'utf8'))
  jenkins_access = doc

  resp = ''
  jenkins_access.jobs.forEach (job) ->
    resp += '- ' + job.name + '\n\tUsers:\n'

    #job.users.forEach(user) ->
    #  resp + '\t' + user.user + ' (' + user.access + ')\n'

  msg.send resp

module.exports = (robot) ->
  robot.respond /auth users/i, (msg) ->
    authUsers(msg)

  robot.respond /auth jobs/i, (msg) ->
    authJobs(msg)

  robot.auth = {
    users: authUsers
    job: authJobs
  }
