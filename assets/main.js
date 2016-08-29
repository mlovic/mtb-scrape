$(document).ready( function() {

  var bikes;
  $('#bikes-table').dynatable({
    features: {
      paginate: false
    },
    dataset: {
      records: [{price: 333}, {price: 444}]
    }
  });

  var dynatable = $('#bikes-table').data('dynatable');

  $.ajax({
    url: 'data',
    success: function(data){
      bikes = data;
      console.log(bikes);
      console.log('loaded data');
      console.log(data);


      updateTable(dynatable, data);
      addUrls(data);
        //table: {
          //headRowSelector: 'thead'
        //},
        //dataset: {
          //records: data
        //}
    }
  });

  function updateTable(dynatable, data) {
    dynatable.settings.dataset.originalRecords = data;
    dynatable.process();
  }

  function addUrls(data) {
    $('tr').each(function(index){
      $(this).find('td').eq(5).wrap(function() {
        var link = $('<a/>');
        //link.attr('href', data[index].uri);
        link.attr('href', $(this).text());
        //link.text($(this).text());
        return link;
      });
      var idElement = $(this).find('td').eq(0)
      idElement.attr('id', idElement.text());
      $(this).find('td').eq(0).wrap(function() {
        var link = $('<a/>');
        console.log($(this));
        link.attr('href', '/bikes/' + $(this).attr('id'));
        //link.text($(this).text());
        return link;
      });
    })
  }

});
