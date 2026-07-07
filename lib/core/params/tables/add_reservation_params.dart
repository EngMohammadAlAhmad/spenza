import 'package:equatable/equatable.dart';

class AddReservationParams extends Equatable {
  final int tableId;
  final String reservationStartTime;
  final String guestName;
  final String guestMobile;
  final String? reservationNote;
  final int guestCount;

  final int restaurantId;
  final int sectionId;
  final int status;

  const AddReservationParams({
    required this.tableId,
    required this.reservationStartTime,
    required this.guestName,
    required this.guestMobile,
    this.reservationNote,
    required this.guestCount,

    required this.restaurantId,
    required this.sectionId,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    final map = {
      "table_id": tableId,
      "reservation_start_time": reservationStartTime,
      "guest_name": guestName,
      "guest_mobile": guestMobile,
      "guest_count": guestCount,
    };

    if (reservationNote != null &&
        reservationNote!.trim().isNotEmpty) {
      map["reservation_note"] = reservationNote!;
    }

    return map;
  }

  @override
  List<Object?> get props => [
    tableId,
    restaurantId,
    reservationStartTime,
    guestName,
    guestMobile,
    reservationNote,
    guestCount,
  ];
}