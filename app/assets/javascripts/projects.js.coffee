# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ($) ->
  $('#add_task').click (e) ->
    e.preventDefault
    $.fancybox
      href: '#'
      helpers:
        overlay:
          css:
          background: 'rgba(58, 42, 45, 0.95)'