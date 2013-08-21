# Description:
#   DailyMenu for hungry.
#
# Commands:
#   hubot menu me <location> - Searches Daily Menu in the selected location
module.exports = (robot) ->
  regexp = /(?:menu|daily_menu)(?: me)? (.*)/i

  fetch_menus = (msg, location) ->
    robot.http("http://daily-menu.herokuapp.com/menus/#{location}")
      .get() (err, res, body) ->
        if err
          msg.send "Error while fetching '#{location}'"
          return

        menus = JSON.parse(body)

        unless menus?
          msg.send "No menus for \"#{location}\""
          return

        daily_menus = for restaurant, menu of menus
          "#{restaurant}: #{menu}"

        msg.send daily_menus.join("\n")

  robot.respond regexp, (msg) ->
    fetch_menus(msg, msg.match[1])

  robot.hear regexp, (msg) ->
    fetch_menus(msg, msg.match[1])
