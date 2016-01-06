$(document).ready( function() {

  $('#confirmation-message').hide();



  $('.travel-form').submit(function (e) {
      var form = $(this);
      var bikeID = form.parents('.bike').attr('id');
      console.log(bikeID);
       //fix this at some point
      var travel = $(this).serializeArray()[0].value;
      console.log($(this).serialize() + '&id=' + bikeID);
      console.log(travel);
      $.ajax({
        type: "POST",
        url: 'add-travel/' + bikeID,
        data: $(this).serialize(), // serializes the form's elements
        success: function(data) {
          form.replaceWith(travel);
        }
      });
      e.preventDefault(); // avoid to execute the actual submit of the form.
  });

  $('.travel-input').keypress(function (e) {
    if (e.which == 13) {
      console.log( 'trigger submit');
      $(this).trigger('submit');
    }


      //e.preventDefault(); // avoid to execute the actual submit of the form.
      //return false;    
  });

  $('.confirm-brand').click(function() { 
    var button = $(this);

      $.ajax({
          url: '/confirm-brand',
          type: 'POST',
          data: {'submit':true, 'id': $(this).data('brand-id') }, // An object with key 'submit' and value 'true;
          success: function (result) {
              $('#confirmation-message').show();
              $('#confirmation-message').delay(3000).fadeOut("slow");
              button.remove()
          }
      });  

  });

  $('.delete-brand').click(function() { 
    var button = $(this);

      $.ajax({
          url: '/delete-brand',
          type: 'POST',
          data: {'submit':true, 'id': $(this).data('brand-id') }, // An object with key 'submit' and value 'true;
          success: function (result) {
              $('#confirmation-message').show();
              $('#confirmation-message').delay(3000).fadeOut("slow");
              button.remove()
          }
      });  

  });

  $('.confirm-model').click(function() { 
    var button = $(this);

      $.ajax({
          url: '/confirm-model',
          type: 'POST',
          data: {
              'submit':true, 
              'bike_id': $(this).data('bike-id'),
              'id': $(this).data('model-id')
          }, // An object with key 'submit' and value 'true;
          success: function (result) {
              $('#confirmation-message').show();
              $('#confirmation-message').delay(3000).fadeOut("slow");
              button.remove()
          }
      });  

  });
});


