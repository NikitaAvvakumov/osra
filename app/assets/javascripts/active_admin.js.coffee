#= require active_admin/base
#= require fancybox
jQuery ->
  $('a.fancybox').fancybox({
    minWidth: 800,
    padding: 40,
    fitToView: false,
    autosize: false
  })
