$(document).on('ready pjax:success', () ->
  $suite_trigger = $('#suite_trigger')
  toggle_fields = () ->
    if $suite_trigger.val() == 'time'  
      $('.time_only').show()
    else
      $('.time_only').hide()
  $suite_trigger.change(
    () ->
      toggle_fields()
  )
  toggle_fields()
)
