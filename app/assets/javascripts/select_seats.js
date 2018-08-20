var order = new Set();

function select_seats() {
  var $cart = $("#selected-seats"),
    $counter = $("#counter"),
    $total = $("#total"),
    $room_data = $("#room_show_data"),
    price = $room_data.data("price"),
    i18n_locate = $room_data.data("i18n_locate"),
    i18n_unit = $room_data.data("i18n_unit"),
    i18n_precision = $room_data.data("i18n_precision"),
    i18n_row = $room_data.data("i18n_row"),
    i18n_number = $room_data.data("i18n_number");

    var formatter = new Intl.NumberFormat(i18n_locate,
      {
        style: "currency",
        currency: i18n_unit,
        minimumFractionDigits: i18n_precision
      }
    );

    var sc = $("#seat-map").seatCharts({
      map: $room_data.data("map"),
      naming : {
        top : false,
        getLabel : function (character, row, column) {
          return column;
        }
      },
      legend : {
        node : $("#legend"),
        items : [
          ["a", "available", "Available"],
          ["a", "unavailable", "Sold"],
          ["a", "selected", "Selected"]
        ]
      },
      click: function () {
        if (this.status() == "available") {
          $("<li>" + i18n_row + " " + (this.settings.row+1) + " " +
            i18n_number + " " + this.settings.label + "</li>")
            .attr("id", "cart-item-" + this.settings.id)
            .data("seatId", this.settings.id)
            .appendTo($cart);

          $counter.text(sc.find("selected").length + 1);

          $total.text(formatter.format(recalculateTotal(sc) + price));

          order.add(this.settings.id);

          return "selected";
        } else if (this.status() == "selected") {
            $counter.text(sc.find("selected").length-1);
            $total.text(recalculateTotal(sc)-price);

            order.delete(this.settings.id);

            $("#cart-item-" + this.settings.id).remove();
            return "available";
        } else if (this.status() == "unavailable") {
          return "unavailable";
        } else {
          return this.style();
        }
      }
    });

    var selected_seats = $room_data.data("selected_seats");
    console.log(selected_seats);

    sc.get(selected_seats).status("selected");
    order = new Set();
    selected_seats.forEach(function(selected_seat) {
      order.add(selected_seat);
    });
    sc.get($room_data.data("sold")).status("unavailable");

    function recalculateTotal(sc) {
      var total = 0;
      sc.find("selected").each(function () {
        total += price;
      });

      return total;
    }
}

function bookSeats() {
  var $selected_seats = $("#selected_seats");
  selected_seats.value = Array.from(order);
};
