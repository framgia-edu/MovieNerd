$(document).on("turbolinks:load", function() {
  if ($("#admin_room_show_data").length != 0) {
    admin_show_room();
  }
  else if ($("#room_show_data").length != 0) {
    select_seats();
  }
  else if ($("#create_room_data").length != 0) {
    var ruby_data = $("#create_room_data");
    create_room(ruby_data);
  }
  set_room_css();
});

function set_room_css() {
  var screen = $("div.front"),
      row_element = $("div.seatCharts-row"),
      cell_width = 35,
      num_cell = row_element.first().children().length - 1;
  screen.width(cell_width * num_cell);
}
