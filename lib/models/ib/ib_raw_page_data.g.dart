// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ib_raw_page_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IbRawPageDataAdapter extends TypeAdapter<IbRawPageData> {
  @override
  final int typeId = 0;

  @override
  IbRawPageData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IbRawPageData(
      id: fields[0] as String,
      title: fields[1] as String,
      name: fields[2] as String?,
      content: fields[3] as String?,
      rawContent: fields[4] as String,
      navOrder: fields[5] as String?,
      cvibLevel: fields[6] as String?,
      parent: fields[7] as String?,
      hasChildren: fields[8] as bool,
      hasToc: fields[9] as bool,
      disableComments: fields[10] as bool,
      frontMatter: (fields[11] as Map).cast<String, dynamic>(),
      httpUrl: fields[12] as String,
      apiUrl: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IbRawPageData obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.rawContent)
      ..writeByte(5)
      ..write(obj.navOrder)
      ..writeByte(6)
      ..write(obj.cvibLevel)
      ..writeByte(7)
      ..write(obj.parent)
      ..writeByte(8)
      ..write(obj.hasChildren)
      ..writeByte(9)
      ..write(obj.hasToc)
      ..writeByte(10)
      ..write(obj.disableComments)
      ..writeByte(11)
      ..write(obj.frontMatter)
      ..writeByte(12)
      ..write(obj.httpUrl)
      ..writeByte(13)
      ..write(obj.apiUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IbRawPageDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
