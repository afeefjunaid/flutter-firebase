// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class myOrdersAdapter extends TypeAdapter<myOrders> {
  @override
  final int typeId = 0;

  @override
  myOrders read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return myOrders(
      CombinedList: (fields[0] as List)
          .map((dynamic e) => (e as List).cast<myOrdersViewModel>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, myOrders obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.CombinedList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is myOrdersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
