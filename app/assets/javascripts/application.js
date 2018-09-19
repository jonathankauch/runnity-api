// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets

//= require_self

//= require cable
//= require action_cable
//= require_tree ./channels
//= require conversation
//= require messenger
//= require Chart.min
//= require sweetalert2
//= require sweet-alert2-rails

$(document).ready(function() {
  $(".comment-form-index").submit(function(){
      event.preventDefault();
      var postId = $(this).attr('data-post');
      var fd = new FormData();
      var file_data = $('input[type="file"]')[0].files; // for multiple files
      for (var i = 0;i<file_data.length;i++){
        fd.append("file_"+i, file_data[i]);
      }

      var other_data = $(this).serializeArray();

      console.log(other_data);

      $.each(other_data,function(key,input){
        fd.append(input.name, input.value);
      });

      console.log(fd);

      $.ajax({
          url: '/posts/' + postId + '/comments',
          type: 'POST',
          data: fd,
          success: function (data) {
              alert(data)
          },
          contentType: false,
          cache: false,
          processData: false
      });

      return false;
  });

  $('.show-comment-link').click(function() {
      var postId = $(this).attr('data-post');
      var tmp = ".comment-list-nb-" + postId;
      if ($(tmp).is(':visible'))
          return;
      $(tmp).slideDown(1000);
  });

  $('.submit-comment').click(function(event) {
      var postId = $(this).attr('data-post');
      var userId = $(this).attr('data-user');
      var comment = $('.input-post-' + postId).val();
      console.log(postId);
      console.log(userId);
      console.log(comment);

      // var file = $('#comment-file-' + postId).prop('files')[0];


      var data = {
          comment: {
              post_id: postId,
              user_id: userId,
              content: comment,
              // file: file
          }
      };

      console.log(data);

      var url = '/posts/' + postId + '/comments';
      $.ajax({
          url: url,
          type: 'POST',
          dataType: 'JSON',
          data: data,
          error: function(xhr, status, error) {
              console.log('FAIL');
          },
          success: function(data, status, xhr) {
              location.reload();
          }
      });
  });
});
