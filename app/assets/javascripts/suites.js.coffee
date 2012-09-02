# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $suite_trigger = $('#suite_trigger')
  toggle_fields = () ->
    if $suite_trigger.val() == 'time'  
      $('.time_only').show();
    else
      $('.time_only').hide();

  $suite_trigger.change(
    () ->
      toggle_fields()
  )
  toggle_fields();
