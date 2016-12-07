// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require turbolinks
//= require pickadate/picker
//= require pickadate/picker.date
//= require pickadate/picker.time
//= require_tree .

$(function (){
  $('.purchase-button').on("click", function(){
    $(this).html('<i class="fa fa-spin fa-spinner"></i>');
  });
})

$(function() {
  $('.datepicker').pickadate({format:'ddd, d mmm yyyy'});
  $('.timepicker').pickatime({format: 'h:i A',interval: 15});
});

$(function(){
	$('#order_delivery').on('click', function(){
		$('#delivery-address').toggleClass('hidden');
	});
});

// announcementInterval = window.setInterval(function(){
//   $('#announcement').toggleClass('alert-real-danger');
// }, 1000)
//
// $(function(){
//   $('#announcement').on('click', function(){
//     $(this).removeClass('alert-danger');
//     $(this).removeClass('alert-real-danger');
//     $(this).addClass('alert-gtr-green');
//     clearInterval(announcementInterval)
//   });
// })
