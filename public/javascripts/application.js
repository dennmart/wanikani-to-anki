$(document).ready(function() {
  $(".additional-options-toggle").on("click", function(e) {
    e.preventDefault();
    $("#" + $(this).data("export-section") + "_options").toggle();
  });

  jQuery.validator.addMethod("wanikaniLevelRange", function(value, element) {
    return this.optional(element) || /^[0-9]+(,[0-9]+)*$/.test(value);
  }, "Please use a list of comma-separated numbers (e.g. '1,10,25')");

  $("#kanji_form input[name='argument']").on("click", function() {
    $("#kanji_form input[id='selected_levels_specific']").prop('checked', true);
  });

  $("#vocabulary_form input[name='argument']").on("click", function() {
    $("#vocabulary_form input[id='selected_levels_specific']").prop('checked', true);
  });

  $("#radicals_form input[name='argument']").on("click", function() {
    $("#radicals_form input[id='selected_levels_specific']").prop('checked', true);
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

  $("#kanji_form").validate({
    rules: {
      argument: {
        wanikaniLevelRange: true
      }
    }
  });

  $("#vocabulary_form").validate({
    rules: {
      argument: {
        wanikaniLevelRange: true
      }
    }
  });

  $("#radicals_form").validate({
    rules: {
      argument: {
        wanikaniLevelRange: true
      }
    }
  });
});
