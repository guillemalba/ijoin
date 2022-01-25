  class EventFilter {
  String location;
  DateTime date;
  List categoria = [];

  EventFilter(this.location, this.date, this.categoria);

  List getCategoria() {
    return categoria;
  }

  DateTime getDate() {
    return date;
  }

  String getLocation() {
    return location;
  }
}