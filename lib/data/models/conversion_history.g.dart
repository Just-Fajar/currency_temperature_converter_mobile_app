// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversion_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversionHistoryAdapter extends TypeAdapter<ConversionHistory> {
  @override
  final int typeId = 0;

  @override
  ConversionHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversionHistory(
      type: fields[0] as String,
      inputValue: fields[1] as double,
      fromUnit: fields[2] as String,
      toUnit: fields[3] as String,
      result: fields[4] as double,
      timestamp: fields[5] as DateTime,
      exchangeRate: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ConversionHistory obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.inputValue)
      ..writeByte(2)
      ..write(obj.fromUnit)
      ..writeByte(3)
      ..write(obj.toUnit)
      ..writeByte(4)
      ..write(obj.result)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.exchangeRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversionHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
