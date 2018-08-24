const PATH = "/i18n/bundle";

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
      getApplications();
      break;
    case 'bundles':
      getBundles(null);
      break;
    default:
      console.log("No handler found");
      break;
  }
}

function getApplications() {
  console.log("Getting apps...");

  $.get(PATH + "/applications", function(data) {
    console.log("Returned: " + data);
  }).fail(function() {
    console.log("Error: " + arguments.length);
  }); 
}

function getBundles(app) {
  if (app === null) app = "synopsis";

  console.log("Getting bundles for '" + app + "' application...");

  $.get(PATH + "/" + app + "/bundles", function(data) {
    console.log("Returned: " + data);
  }).fail(function() {
    console.log("Error: " + arguments.length);
  }); 
}
