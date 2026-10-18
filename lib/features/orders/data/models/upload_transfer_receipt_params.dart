import 'dart:io';

class UploadTransferReceiptParams {
  final String orderNumber;
  final File image;
  final String? reference;
  final String? amount;
  final String? transferredAt;
  final String? note;

  const UploadTransferReceiptParams({
    required this.orderNumber,
    required this.image,
    this.reference,
    this.amount,
    this.transferredAt,
    this.note,
  });
}
