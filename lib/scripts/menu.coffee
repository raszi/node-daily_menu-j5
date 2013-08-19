# Description:
#   DailyMenu for hungry.
#
# Commands:
#   hubot menu me <location> - Searches Daily Menu in the selected location
module.exports = (robot) ->
  robot.respond /(menu|daily_menu)( me)? (.*)/i, (msg) ->
    query = msg.match[3]
    robot.http("http://daily-menu.herokuapp.com/menus/#{location}")
      .get() (err, res, body) ->
	  	if err
			msg.send "Error while fetching '#{location}'"
			return

        menus = JSON.parse(body)

        unless menus?
          msg.send "No menus for \"#{query}\""
          return

		daily_menus = for restaurant, menu of menus
			"#{restaurant}: #{menu}"

		msg.send daily_menus.join("\n")
