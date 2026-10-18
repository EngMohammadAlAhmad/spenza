import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/orders/data/models/upload_transfer_receipt_params.dart';
import 'package:spenza/features/orders/domain/repositories/orders_repository.dart';

class UploadTransferReceiptUseCase {
  final OrdersRepository repository;

  UploadTransferReceiptUseCase({required this.repository});

  Future<Either<Failure, void>> call(UploadTransferReceiptParams params) async {
    return await repository.uploadTransferReceipt(params);
  }
}
