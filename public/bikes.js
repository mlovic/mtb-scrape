$(document).ready( function() {

  $('#confirmation-message').hide();

  //var bikeID = .parents('.bike').attr('id');
  console.log($(this)); 
  //$('.model-name').editable('/' + console.log($(this)));
  //
  $('.chosen').chosen();

  $('#brand-select').on('change', function(evt, params) {
    console.log($('#brand-select').val())
    var brand = $('#brand-select').val()
    setModelOptions(brand);
  });

  //cv?
  function setModelOptions(brand) {
    $.ajax({
      type: 'GET',
      url: '/models', // data here?
      data: 'brand_id='+brand,
      success: function(data, status) {
        $('#model-select').empty();
        $.each(data, function(i, m) {
          $('#model-select').append('<option value="' + m.id + '">' + m.name + '</option>');
        });
        $('#model-select').prop('disabled', false);
        $('#model-select').trigger('chosen:updated');
      }
    });
  }

  $('.model-name').each(function() {
     var $this = $(this);
     //$this.editable('/bikes/' + $this.parent().attr('id') + '/update', {
     // Use REST?
     $this.editable('/update-model', {
        submitdata  : { bike_id : $this.parent().attr('id') }
     });
  });

  $('.submodel-name').each(function() {
     var $this = $(this);
     $this.editable('/update-submodel', {
        submitdata  : { bike_id : $this.parent().attr('id') }
     });
  });

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


