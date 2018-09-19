$(document).ready(function() {
  $('#group-description').on('shown.bs.modal', function (e) {
    $('#group-description .modal-title').html($('#group-info-button').data('title'));
    $('#group-description .modal-body-image').html($('#group-info-button').data('image'));
    $('#group-description .modal-body-content').html($('#group-info-button').data('content'));
  });
});
