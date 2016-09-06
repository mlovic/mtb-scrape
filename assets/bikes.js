$(document).ready( function() {

  $('#confirmation-message').hide();

  $('.chosen').chosen();

  // Listen for change on "brand" select box. When changed, update options for
  // the "model" select box with the models belonging to the selected brand only.
  $('#brand-select').on('change', function(evt, params) {
    console.log($('#brand-select').val())
    var brand = $('#brand-select').val()
    setModelOptions(brand);
  });

  if ($('#brand-select').val() != "") {
    $('#brand-select').trigger('chosen:updated');
  }

  function setModelOptions(brand) {
    $.ajax({
      type: 'GET',
      url: '/models', // data here?
      data: 'brand_id='+brand,
      success: function(data, status) {
        $('#model-select').empty();
        // best way?
        $('#model-select').append('<option value="">Todos</option>');
        $.each(data, function(i, m) {
          $('#model-select').append('<option value="' + m.id + '">' + m.name + '</option>');
        });
        $('#model-select').prop('disabled', false);
        $('#model-select').trigger('chosen:updated');
      }
    });
  }

  // Make "model" field editable
  $('.model-name').each(function() {
     var $this = $(this);
     //$this.editable('/bikes/' + $this.parent().attr('id') + '/update', {
     // Use REST?
     $this.editable('/update-model', {
        submitdata  : { bike_id : $this.parent().attr('id') }
     });
  });

  // Make "submodel" field editable
  $('.submodel-name').each(function() {
     var $this = $(this);
     $this.editable('/update-submodel', {
        submitdata  : { bike_id : $this.parent().attr('id') }
     });
  });

  // Attach bike-id to form params before sending
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
        url: 'bikes/' + bikeID + '/add-travel',
        data: $(this).serialize(), // serializes the form's elements
        success: function(data) {
          form.replaceWith(travel);
        }
      });
      e.preventDefault(); // avoid to execute the actual submit of the form.
  });

  // Send form on <Enter> keypress
  $('.travel-input').keypress(function (e) {
    if (e.which == 13) {
      console.log( 'trigger submit');
      $(this).trigger('submit');
    }
      //e.preventDefault(); // avoid to execute the actual submit of the form.
  });

  // Confirm and Delete buttons. Admin view only.
  $('.confirm-brand').click(function() { 
    var button = $(this);

      $.ajax({
          url: '/brands/' + $(this).data('brand-id') + '/confirm',
          type: 'POST',
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
          url: '/models/' + $(this).data('model-id') + '/confirm',
          type: 'POST',
          //data: {
              //'submit':true, 
              //'bike_id': $(this).data('bike-id'),
              //'id': $(this).data('model-id')
          //}, // An object with key 'submit' and value 'true;
          success: function (result) {
              $('#confirmation-message').show();
              $('#confirmation-message').delay(3000).fadeOut("slow");
              button.remove()
          }
      });  

  });

//$("#price-slider").slider({});

});


