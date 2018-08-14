function init() {
  console.log("Initializing...");
  
  $(document).on('click', 'a.link', function() {
    console.log("Link clicked...");
    let name = $(this).attr('name');
    processClick(name);
  }); 
}

function processClick(name) {
  console.log("Clicked on '" + name + "'");
  switch (name) {
    case 'apps':
      getApplication();
      break;
    default:
      console.log("No handler found");
      break;
  }
}

function getApplication() {
  console.log("Getting application...");

  $.get(PATH + "/application", function(data) {
    console.log("Returned: " + data);
  }).fail(function() {
    console.log("Error: " + arguments.length);
  }); 
}

