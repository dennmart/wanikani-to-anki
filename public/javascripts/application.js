$(document).ready(function() {
  $(".additional-options-toggle").on("click", function(e) {
    e.preventDefault();
    $("#" + $(this).data("export-section") + "_options").slideToggle(200);
  });

  jQuery.validator.addMethod("wanikaniLevelRange", function(value, element) {
    return this.optional(element) || /^[0-9]+(,[0-9]+)*$/.test(value);
  }, "Please use a list of comma-separated numbers (e.g. '1,10,25')");

  $(".full-lists-form input[name='argument']").on("click", function() {
    $(this).prev("input[id='selected_levels_specific']").prop("checked", true);
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

  var fullListsValidation = {
    rules: {
      argument: {
        wanikaniLevelRange: true
      }
    }
  };

  $("#kanji_form").validate(fullListsValidation);
  $("#vocabulary_form").validate(fullListsValidation);
  $("#radicals_form").validate(fullListsValidation);
});
