# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $("#item_category_id").on "change", ->
    $.ajax
      url: "/items/get_attributes"
      type: "GET"
      dataType: "script"
      data:
        category_id: $('#item_category_id option:selected').val()

  $(".custom_attributes").on "change", ".attribute_select:last", ->
    $( ".attribute_select:last" ).clone().appendTo( ".custom_attributes" );