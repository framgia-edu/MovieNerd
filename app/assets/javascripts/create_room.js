var deleted_seats = new Set();
var map;

function create_room($room_data) {
  map = full_a_map($room_data.data("map"));
  var sc = $("#seat-map").seatCharts({
    map: map,
    naming : {
      top : false,
      getLabel : function (character, row, column) {
        return column;
      }
    },
    legend : {
      node : $("#legend"),
      items : [
        ["a", "selected", $room_data.data("i18n_seat")],
        ["a", "deleted", $room_data.data("i18n_no_seat")]
      ]
    },
    click: function () {
      switch(this.status()) {
        case "deleted":
          add_seat(this.settings.id);
          return "selected";
        case "selected":
          delete_seat(this.settings.id);
          return "deleted";
        default:
          return this.style();
      }
    }
  });
  sc.get(sc.seatIds).status("selected");
  sc.get($room_data.data("deleted_seats")).status("deleted");
};

function add_seat(seat_id) {
  var $field_seat_no = $("#field_seat_no");
  field_seat_no.value++;

  deleted_seats.delete(seat_id);
  modify_seat_in_map(seat_id, "a");

  check_row(seat_id);
  check_column(seat_id);
}

function delete_seat(seat_id) {
  var $field_seat_no = $("#field_seat_no");
  field_seat_no.value--;

  deleted_seats.add(seat_id);
  modify_seat_in_map(seat_id, "_");

  check_row(seat_id);
  check_column(seat_id);
}

function check_row(seat_id) {
  var seat_id_splited = seat_id.split("_");

  var same_row = [...deleted_seats].filter(function(deleted_seat) {
    return seat_id_splited[0] == deleted_seat.split("_")[0];
  });

  if (same_row.length == field_num.value && deleted_seats.has(seat_id)) {
    field_row.value--;
  }
  if (same_row.length == field_num.value - 1 && !deleted_seats.has(seat_id)) {
    field_row.value++;
  }
}

function check_column(seat_id) {
  var seat_id_splited = seat_id.split("_");

  var same_col = [...deleted_seats].filter(function(deleted_seat) {
    return seat_id_splited[1] == deleted_seat.split("_")[1];
  });

  if (same_col.length == field_row.value && deleted_seats.has(seat_id)) {
    field_num.value--;
  }
  if (same_col.length == field_row.value - 1 && !deleted_seats.has(seat_id)) {
    field_num.value++;
  }
}

function modify_seat_in_map(seat_id, new_status) {
  var seat_id_splited = seat_id.split("_"),
      row_num = parseInt(seat_id_splited[0]) - 1,
      col_num = parseInt(seat_id_splited[1]) - 1,
      deleted_row = map[row_num];
  delete map[row_num];
  deleted_row = deleted_row.substring(0, col_num) + new_status +
                deleted_row.substring(col_num + 1);

  map[row_num] = deleted_row;
}

function full_a_map(map) {
  for (i = 0; i < map.length; i++) {
      map[i] = map[i].split("_").join("a");
  }
  return map;
}

function slice_map(field_row, field_num) {
  var $room_data = $("#create_room_data"),
      map = $room_data.data("map"),
      new_map = [];
  if (field_row > map.length) {
    for(i = 0; i < field_row - map.length; i++) {
      map.push("a".repeat(field_num));
    }
  }
  if (field_num > map[0].length) {
    for(i = 0; i < map.length; i++) {
      map[i] += "a".repeat(field_num - map[i].length);
    }
  }
  map.slice(0, field_row).forEach(function(row) {
    new_map.push(row.slice(0, field_num));
  })
  return new_map;
}

function room_changed(map) {
  var $room_data = $("#create_room_data");
  reset_seat_area($room_data);
  $room_data.data("map", map);
  $room_data.data("deleted_seats", Array.from(deleted_seats));

  var $field_seat_no = $("#field_seat_no");
  field_seat_no.value = num_available_seats(map);

  $(document).trigger("turbolinks:load");
};

function num_available_seats(map) {
  var count = 0;
  map.forEach(function(row) {
    for (i = 0; i < row.length; i++) {
      if(row[i] == "a") count++;
    }
  });
  return count;
}

function get_deleted_seats() {
  var $field_deleted_seats = $("#field_deleted_seats");
  field_deleted_seats.value = Array.from(deleted_seats);
};

function get_map() {
  var $field_map = $("#field_map");
  field_map.value = map;
};

function change_room_listener($room_data) {
    var $field_row = $("#field_row"),
        $field_num = $("#field_num");

    $field_row.off("change");
    $field_row.on("change", function() {
      room_changed(slice_map(field_row.value, field_num.value));
    });

    $field_num.off("change");
    $field_num.on("change", function() {
      room_changed(slice_map(field_row.value, field_num.value));
  });
}
