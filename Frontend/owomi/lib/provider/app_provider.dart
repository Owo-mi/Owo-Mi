// final extendedEphemiralPubKeyProvider = Provider<String>((ref) {

// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owomi/data/storage_manager.dart';

final nameProvider = StateProvider<String>((ref) {
  return '';
});
final descriptionProvider = StateProvider<String>((ref) {
  return '';
});
final jwtProvider = StateProvider<String>((ref) {
  return '';
});
final targetAmountProvider = StateProvider<String>((ref) {
  return '';
});
final coinTypeProvider = StateProvider<String>((ref) {
  return '';
});
final addressProvider = StateProvider<String>((ref) {
  return StorageManager.getAddress();
});
final selectedDateProvider = StateProvider<DateTime?>((ref) {
  return;
});
