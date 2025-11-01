enum NotificationEndpoints {
  allevia_inclinic,
  allevia_bookings;

  String toEndPoint() {
    return name.split('.').last;
  }
}
