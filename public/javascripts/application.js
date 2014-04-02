$(document).ready(function() {
  $(".additional-options-toggle").on("click", function(e) {
    e.preventDefault();
    $("#" + $(this).data("export-section") + "_options").toggle();
  });
});
