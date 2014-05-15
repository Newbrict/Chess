"use strict"

module.exports = (grunt) ->
	# Load grunt tasks automatically
	require("load-grunt-tasks") grunt

	# Time how long tasks take. Can help when optimizing build times
	require("time-grunt") grunt

	# Define the configuration for all the tasks
	grunt.initConfig
		jshint:
			options:
				jshintrc: ".jshintrc"
				reporter: require("jshint-stylish")

			all: ["js/*.js"]
