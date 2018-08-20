$(document).on("turbolinks:load", function() {
  if ($("#admin_room_show_data").length != 0) {
    admin_show_room();
  }
  else if ($("#room_show_data").length != 0) {
    var $room_data = $("#room_show_data");
    reset_seat_area($room_data);
    select_seats();
  }
  else if ($("#create_room_data").length != 0) {
    var $room_data = $("#create_room_data");
    update_room($room_data);
    change_room_listener($room_data);
  }
  else if ($("#edit_room_data").length != 0) {
    var $room_data = $("#edit_room_data");
    update_room($room_data);
    change_room_listener($room_data);
  }
  set_room_css();
});

function reset_seat_area($room_data) {
  var i18n_screen = $room_data.data("i18n_screen");
  $("#seat-partial").html("<div id='seat-map'><div class='front'>" +
    i18n_screen + "</div></div>");
  $("#legend-partial").html("<div id='legend'></div>");
}

function set_room_css() {
  var screen = $("div.front"),
      row_element = $("div.seatCharts-row"),
      cell_width = 35,
      num_cell = row_element.first().children().length - 1;
  screen.width(cell_width * num_cell);
}
