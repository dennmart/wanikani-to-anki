$(document).ready(function() {
  $(".additional-options-toggle").on("click", function(e) {
    e.preventDefault();
    $("#" + $(this).data("export-section") + "_options").toggle();
  });

  $("#kanji_form input[name='argument']").on("click", function() {
    $("#kanji_form input[id='selected_levels_specific']").attr('checked', 'checked');
  });

  $("#vocabulary_form input[name='argument']").on("click", function() {
    $("#vocabulary_form input[id='selected_levels_specific']").attr('checked', 'checked');
  });

  $("#radicals_form input[name='argument']").on("click", function() {
    $("#radicals_form input[id='selected_levels_specific']").attr('checked', 'checked');
  });

  $("#critical_items_form").validate({
    rules: {
      argument: {
        required: false,
        range: [1, 99]
      }
    },
    messages: {
      argument: "Please enter a value between 1 and 99, or leave blank for a default of 75."
    }
  });

  $("#kanji_form input[name='argument']").on("click", function() {
    $("#kanji_form input[id='selected_levels_specific']").attr('checked', 'checked');
  });

});
