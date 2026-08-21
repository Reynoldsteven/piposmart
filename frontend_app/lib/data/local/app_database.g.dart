// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PelangganEntriesTable extends PelangganEntries
    with TableInfo<$PelangganEntriesTable, PelangganEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PelangganEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outletIdMeta = const VerificationMeta(
    'outletId',
  );
  @override
  late final GeneratedColumn<int> outletId = GeneratedColumn<int>(
    'outlet_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outletNameMeta = const VerificationMeta(
    'outletName',
  );
  @override
  late final GeneratedColumn<String> outletName = GeneratedColumn<String>(
    'outlet_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    address,
    gender,
    outletId,
    outletName,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pelanggan_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PelangganEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('outlet_id')) {
      context.handle(
        _outletIdMeta,
        outletId.isAcceptableOrUnknown(data['outlet_id']!, _outletIdMeta),
      );
    }
    if (data.containsKey('outlet_name')) {
      context.handle(
        _outletNameMeta,
        outletName.isAcceptableOrUnknown(data['outlet_name']!, _outletNameMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PelangganEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PelangganEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      outletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}outlet_id'],
      ),
      outletName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outlet_name'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $PelangganEntriesTable createAlias(String alias) {
    return $PelangganEntriesTable(attachedDatabase, alias);
  }
}

class PelangganEntry extends DataClass implements Insertable<PelangganEntry> {
  final int id;
  final String name;
  final String? phone;
  final String? address;
  final String? gender;
  final int? outletId;
  final String? outletName;
  final DateTime syncedAt;
  const PelangganEntry({
    required this.id,
    required this.name,
    this.phone,
    this.address,
    this.gender,
    this.outletId,
    this.outletName,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || outletId != null) {
      map['outlet_id'] = Variable<int>(outletId);
    }
    if (!nullToAbsent || outletName != null) {
      map['outlet_name'] = Variable<String>(outletName);
    }
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  PelangganEntriesCompanion toCompanion(bool nullToAbsent) {
    return PelangganEntriesCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      outletId: outletId == null && nullToAbsent
          ? const Value.absent()
          : Value(outletId),
      outletName: outletName == null && nullToAbsent
          ? const Value.absent()
          : Value(outletName),
      syncedAt: Value(syncedAt),
    );
  }

  factory PelangganEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PelangganEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      gender: serializer.fromJson<String?>(json['gender']),
      outletId: serializer.fromJson<int?>(json['outletId']),
      outletName: serializer.fromJson<String?>(json['outletName']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'gender': serializer.toJson<String?>(gender),
      'outletId': serializer.toJson<int?>(outletId),
      'outletName': serializer.toJson<String?>(outletName),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  PelangganEntry copyWith({
    int? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<int?> outletId = const Value.absent(),
    Value<String?> outletName = const Value.absent(),
    DateTime? syncedAt,
  }) => PelangganEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    gender: gender.present ? gender.value : this.gender,
    outletId: outletId.present ? outletId.value : this.outletId,
    outletName: outletName.present ? outletName.value : this.outletName,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  PelangganEntry copyWithCompanion(PelangganEntriesCompanion data) {
    return PelangganEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      gender: data.gender.present ? data.gender.value : this.gender,
      outletId: data.outletId.present ? data.outletId.value : this.outletId,
      outletName: data.outletName.present
          ? data.outletName.value
          : this.outletName,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PelangganEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('gender: $gender, ')
          ..write('outletId: $outletId, ')
          ..write('outletName: $outletName, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    phone,
    address,
    gender,
    outletId,
    outletName,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PelangganEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.gender == this.gender &&
          other.outletId == this.outletId &&
          other.outletName == this.outletName &&
          other.syncedAt == this.syncedAt);
}

class PelangganEntriesCompanion extends UpdateCompanion<PelangganEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<String?> gender;
  final Value<int?> outletId;
  final Value<String?> outletName;
  final Value<DateTime> syncedAt;
  const PelangganEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.gender = const Value.absent(),
    this.outletId = const Value.absent(),
    this.outletName = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  PelangganEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.gender = const Value.absent(),
    this.outletId = const Value.absent(),
    this.outletName = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PelangganEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<String>? gender,
    Expression<int>? outletId,
    Expression<String>? outletName,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (gender != null) 'gender': gender,
      if (outletId != null) 'outlet_id': outletId,
      if (outletName != null) 'outlet_name': outletName,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  PelangganEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<String?>? address,
    Value<String?>? gender,
    Value<int?>? outletId,
    Value<String?>? outletName,
    Value<DateTime>? syncedAt,
  }) {
    return PelangganEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      outletId: outletId ?? this.outletId,
      outletName: outletName ?? this.outletName,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (outletId.present) {
      map['outlet_id'] = Variable<int>(outletId.value);
    }
    if (outletName.present) {
      map['outlet_name'] = Variable<String>(outletName.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PelangganEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('gender: $gender, ')
          ..write('outletId: $outletId, ')
          ..write('outletName: $outletName, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $KaryawanEntriesTable extends KaryawanEntries
    with TableInfo<$KaryawanEntriesTable, KaryawanEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KaryawanEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outletNamesMeta = const VerificationMeta(
    'outletNames',
  );
  @override
  late final GeneratedColumn<String> outletNames = GeneratedColumn<String>(
    'outlet_names',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _joinDateMeta = const VerificationMeta(
    'joinDate',
  );
  @override
  late final GeneratedColumn<String> joinDate = GeneratedColumn<String>(
    'join_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    email,
    phone,
    role,
    outletNames,
    joinDate,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'karyawan_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<KaryawanEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('outlet_names')) {
      context.handle(
        _outletNamesMeta,
        outletNames.isAcceptableOrUnknown(
          data['outlet_names']!,
          _outletNamesMeta,
        ),
      );
    }
    if (data.containsKey('join_date')) {
      context.handle(
        _joinDateMeta,
        joinDate.isAcceptableOrUnknown(data['join_date']!, _joinDateMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KaryawanEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KaryawanEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      outletNames: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outlet_names'],
      )!,
      joinDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}join_date'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $KaryawanEntriesTable createAlias(String alias) {
    return $KaryawanEntriesTable(attachedDatabase, alias);
  }
}

class KaryawanEntry extends DataClass implements Insertable<KaryawanEntry> {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String outletNames;
  final String? joinDate;
  final DateTime syncedAt;
  const KaryawanEntry({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.outletNames,
    this.joinDate,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['role'] = Variable<String>(role);
    map['outlet_names'] = Variable<String>(outletNames);
    if (!nullToAbsent || joinDate != null) {
      map['join_date'] = Variable<String>(joinDate);
    }
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  KaryawanEntriesCompanion toCompanion(bool nullToAbsent) {
    return KaryawanEntriesCompanion(
      id: Value(id),
      name: Value(name),
      email: Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      role: Value(role),
      outletNames: Value(outletNames),
      joinDate: joinDate == null && nullToAbsent
          ? const Value.absent()
          : Value(joinDate),
      syncedAt: Value(syncedAt),
    );
  }

  factory KaryawanEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KaryawanEntry(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      role: serializer.fromJson<String>(json['role']),
      outletNames: serializer.fromJson<String>(json['outletNames']),
      joinDate: serializer.fromJson<String?>(json['joinDate']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String>(email),
      'phone': serializer.toJson<String?>(phone),
      'role': serializer.toJson<String>(role),
      'outletNames': serializer.toJson<String>(outletNames),
      'joinDate': serializer.toJson<String?>(joinDate),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  KaryawanEntry copyWith({
    int? id,
    String? name,
    String? email,
    Value<String?> phone = const Value.absent(),
    String? role,
    String? outletNames,
    Value<String?> joinDate = const Value.absent(),
    DateTime? syncedAt,
  }) => KaryawanEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    phone: phone.present ? phone.value : this.phone,
    role: role ?? this.role,
    outletNames: outletNames ?? this.outletNames,
    joinDate: joinDate.present ? joinDate.value : this.joinDate,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  KaryawanEntry copyWithCompanion(KaryawanEntriesCompanion data) {
    return KaryawanEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      role: data.role.present ? data.role.value : this.role,
      outletNames: data.outletNames.present
          ? data.outletNames.value
          : this.outletNames,
      joinDate: data.joinDate.present ? data.joinDate.value : this.joinDate,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KaryawanEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('role: $role, ')
          ..write('outletNames: $outletNames, ')
          ..write('joinDate: $joinDate, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    email,
    phone,
    role,
    outletNames,
    joinDate,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KaryawanEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.role == this.role &&
          other.outletNames == this.outletNames &&
          other.joinDate == this.joinDate &&
          other.syncedAt == this.syncedAt);
}

class KaryawanEntriesCompanion extends UpdateCompanion<KaryawanEntry> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> email;
  final Value<String?> phone;
  final Value<String> role;
  final Value<String> outletNames;
  final Value<String?> joinDate;
  final Value<DateTime> syncedAt;
  const KaryawanEntriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.role = const Value.absent(),
    this.outletNames = const Value.absent(),
    this.joinDate = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  KaryawanEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String email,
    this.phone = const Value.absent(),
    required String role,
    this.outletNames = const Value.absent(),
    this.joinDate = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : name = Value(name),
       email = Value(email),
       role = Value(role);
  static Insertable<KaryawanEntry> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? role,
    Expression<String>? outletNames,
    Expression<String>? joinDate,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (role != null) 'role': role,
      if (outletNames != null) 'outlet_names': outletNames,
      if (joinDate != null) 'join_date': joinDate,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  KaryawanEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? email,
    Value<String?>? phone,
    Value<String>? role,
    Value<String>? outletNames,
    Value<String?>? joinDate,
    Value<DateTime>? syncedAt,
  }) {
    return KaryawanEntriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      outletNames: outletNames ?? this.outletNames,
      joinDate: joinDate ?? this.joinDate,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (outletNames.present) {
      map['outlet_names'] = Variable<String>(outletNames.value);
    }
    if (joinDate.present) {
      map['join_date'] = Variable<String>(joinDate.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KaryawanEntriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('role: $role, ')
          ..write('outletNames: $outletNames, ')
          ..write('joinDate: $joinDate, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $PesananEntriesTable extends PesananEntries
    with TableInfo<$PesananEntriesTable, PesananEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PesananEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kodeMeta = const VerificationMeta('kode');
  @override
  late final GeneratedColumn<String> kode = GeneratedColumn<String>(
    'kode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outletIdMeta = const VerificationMeta(
    'outletId',
  );
  @override
  late final GeneratedColumn<int> outletId = GeneratedColumn<int>(
    'outlet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outletNameMeta = const VerificationMeta(
    'outletName',
  );
  @override
  late final GeneratedColumn<String> outletName = GeneratedColumn<String>(
    'outlet_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _pelangganIdMeta = const VerificationMeta(
    'pelangganId',
  );
  @override
  late final GeneratedColumn<int> pelangganId = GeneratedColumn<int>(
    'pelanggan_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pelangganNameMeta = const VerificationMeta(
    'pelangganName',
  );
  @override
  late final GeneratedColumn<String> pelangganName = GeneratedColumn<String>(
    'pelanggan_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isLunasMeta = const VerificationMeta(
    'isLunas',
  );
  @override
  late final GeneratedColumn<bool> isLunas = GeneratedColumn<bool>(
    'is_lunas',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_lunas" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _pickupEstimateMeta = const VerificationMeta(
    'pickupEstimate',
  );
  @override
  late final GeneratedColumn<String> pickupEstimate = GeneratedColumn<String>(
    'pickup_estimate',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _layananSummaryMeta = const VerificationMeta(
    'layananSummary',
  );
  @override
  late final GeneratedColumn<String> layananSummary = GeneratedColumn<String>(
    'layanan_summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kode,
    outletId,
    outletName,
    pelangganId,
    pelangganName,
    status,
    isLunas,
    total,
    pickupEstimate,
    notes,
    layananSummary,
    createdAt,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pesanan_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PesananEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kode')) {
      context.handle(
        _kodeMeta,
        kode.isAcceptableOrUnknown(data['kode']!, _kodeMeta),
      );
    } else if (isInserting) {
      context.missing(_kodeMeta);
    }
    if (data.containsKey('outlet_id')) {
      context.handle(
        _outletIdMeta,
        outletId.isAcceptableOrUnknown(data['outlet_id']!, _outletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_outletIdMeta);
    }
    if (data.containsKey('outlet_name')) {
      context.handle(
        _outletNameMeta,
        outletName.isAcceptableOrUnknown(data['outlet_name']!, _outletNameMeta),
      );
    }
    if (data.containsKey('pelanggan_id')) {
      context.handle(
        _pelangganIdMeta,
        pelangganId.isAcceptableOrUnknown(
          data['pelanggan_id']!,
          _pelangganIdMeta,
        ),
      );
    }
    if (data.containsKey('pelanggan_name')) {
      context.handle(
        _pelangganNameMeta,
        pelangganName.isAcceptableOrUnknown(
          data['pelanggan_name']!,
          _pelangganNameMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('is_lunas')) {
      context.handle(
        _isLunasMeta,
        isLunas.isAcceptableOrUnknown(data['is_lunas']!, _isLunasMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    }
    if (data.containsKey('pickup_estimate')) {
      context.handle(
        _pickupEstimateMeta,
        pickupEstimate.isAcceptableOrUnknown(
          data['pickup_estimate']!,
          _pickupEstimateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('layanan_summary')) {
      context.handle(
        _layananSummaryMeta,
        layananSummary.isAcceptableOrUnknown(
          data['layanan_summary']!,
          _layananSummaryMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PesananEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PesananEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kode'],
      )!,
      outletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}outlet_id'],
      )!,
      outletName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outlet_name'],
      )!,
      pelangganId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pelanggan_id'],
      ),
      pelangganName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pelanggan_name'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isLunas: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_lunas'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      pickupEstimate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pickup_estimate'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      layananSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layanan_summary'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $PesananEntriesTable createAlias(String alias) {
    return $PesananEntriesTable(attachedDatabase, alias);
  }
}

class PesananEntry extends DataClass implements Insertable<PesananEntry> {
  final int id;
  final String kode;
  final int outletId;
  final String outletName;
  final int? pelangganId;
  final String? pelangganName;
  final String status;
  final bool isLunas;
  final double total;
  final String? pickupEstimate;
  final String? notes;
  final String layananSummary;
  final String createdAt;
  final DateTime syncedAt;
  const PesananEntry({
    required this.id,
    required this.kode,
    required this.outletId,
    required this.outletName,
    this.pelangganId,
    this.pelangganName,
    required this.status,
    required this.isLunas,
    required this.total,
    this.pickupEstimate,
    this.notes,
    required this.layananSummary,
    required this.createdAt,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kode'] = Variable<String>(kode);
    map['outlet_id'] = Variable<int>(outletId);
    map['outlet_name'] = Variable<String>(outletName);
    if (!nullToAbsent || pelangganId != null) {
      map['pelanggan_id'] = Variable<int>(pelangganId);
    }
    if (!nullToAbsent || pelangganName != null) {
      map['pelanggan_name'] = Variable<String>(pelangganName);
    }
    map['status'] = Variable<String>(status);
    map['is_lunas'] = Variable<bool>(isLunas);
    map['total'] = Variable<double>(total);
    if (!nullToAbsent || pickupEstimate != null) {
      map['pickup_estimate'] = Variable<String>(pickupEstimate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['layanan_summary'] = Variable<String>(layananSummary);
    map['created_at'] = Variable<String>(createdAt);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  PesananEntriesCompanion toCompanion(bool nullToAbsent) {
    return PesananEntriesCompanion(
      id: Value(id),
      kode: Value(kode),
      outletId: Value(outletId),
      outletName: Value(outletName),
      pelangganId: pelangganId == null && nullToAbsent
          ? const Value.absent()
          : Value(pelangganId),
      pelangganName: pelangganName == null && nullToAbsent
          ? const Value.absent()
          : Value(pelangganName),
      status: Value(status),
      isLunas: Value(isLunas),
      total: Value(total),
      pickupEstimate: pickupEstimate == null && nullToAbsent
          ? const Value.absent()
          : Value(pickupEstimate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      layananSummary: Value(layananSummary),
      createdAt: Value(createdAt),
      syncedAt: Value(syncedAt),
    );
  }

  factory PesananEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PesananEntry(
      id: serializer.fromJson<int>(json['id']),
      kode: serializer.fromJson<String>(json['kode']),
      outletId: serializer.fromJson<int>(json['outletId']),
      outletName: serializer.fromJson<String>(json['outletName']),
      pelangganId: serializer.fromJson<int?>(json['pelangganId']),
      pelangganName: serializer.fromJson<String?>(json['pelangganName']),
      status: serializer.fromJson<String>(json['status']),
      isLunas: serializer.fromJson<bool>(json['isLunas']),
      total: serializer.fromJson<double>(json['total']),
      pickupEstimate: serializer.fromJson<String?>(json['pickupEstimate']),
      notes: serializer.fromJson<String?>(json['notes']),
      layananSummary: serializer.fromJson<String>(json['layananSummary']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kode': serializer.toJson<String>(kode),
      'outletId': serializer.toJson<int>(outletId),
      'outletName': serializer.toJson<String>(outletName),
      'pelangganId': serializer.toJson<int?>(pelangganId),
      'pelangganName': serializer.toJson<String?>(pelangganName),
      'status': serializer.toJson<String>(status),
      'isLunas': serializer.toJson<bool>(isLunas),
      'total': serializer.toJson<double>(total),
      'pickupEstimate': serializer.toJson<String?>(pickupEstimate),
      'notes': serializer.toJson<String?>(notes),
      'layananSummary': serializer.toJson<String>(layananSummary),
      'createdAt': serializer.toJson<String>(createdAt),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  PesananEntry copyWith({
    int? id,
    String? kode,
    int? outletId,
    String? outletName,
    Value<int?> pelangganId = const Value.absent(),
    Value<String?> pelangganName = const Value.absent(),
    String? status,
    bool? isLunas,
    double? total,
    Value<String?> pickupEstimate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? layananSummary,
    String? createdAt,
    DateTime? syncedAt,
  }) => PesananEntry(
    id: id ?? this.id,
    kode: kode ?? this.kode,
    outletId: outletId ?? this.outletId,
    outletName: outletName ?? this.outletName,
    pelangganId: pelangganId.present ? pelangganId.value : this.pelangganId,
    pelangganName: pelangganName.present
        ? pelangganName.value
        : this.pelangganName,
    status: status ?? this.status,
    isLunas: isLunas ?? this.isLunas,
    total: total ?? this.total,
    pickupEstimate: pickupEstimate.present
        ? pickupEstimate.value
        : this.pickupEstimate,
    notes: notes.present ? notes.value : this.notes,
    layananSummary: layananSummary ?? this.layananSummary,
    createdAt: createdAt ?? this.createdAt,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  PesananEntry copyWithCompanion(PesananEntriesCompanion data) {
    return PesananEntry(
      id: data.id.present ? data.id.value : this.id,
      kode: data.kode.present ? data.kode.value : this.kode,
      outletId: data.outletId.present ? data.outletId.value : this.outletId,
      outletName: data.outletName.present
          ? data.outletName.value
          : this.outletName,
      pelangganId: data.pelangganId.present
          ? data.pelangganId.value
          : this.pelangganId,
      pelangganName: data.pelangganName.present
          ? data.pelangganName.value
          : this.pelangganName,
      status: data.status.present ? data.status.value : this.status,
      isLunas: data.isLunas.present ? data.isLunas.value : this.isLunas,
      total: data.total.present ? data.total.value : this.total,
      pickupEstimate: data.pickupEstimate.present
          ? data.pickupEstimate.value
          : this.pickupEstimate,
      notes: data.notes.present ? data.notes.value : this.notes,
      layananSummary: data.layananSummary.present
          ? data.layananSummary.value
          : this.layananSummary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PesananEntry(')
          ..write('id: $id, ')
          ..write('kode: $kode, ')
          ..write('outletId: $outletId, ')
          ..write('outletName: $outletName, ')
          ..write('pelangganId: $pelangganId, ')
          ..write('pelangganName: $pelangganName, ')
          ..write('status: $status, ')
          ..write('isLunas: $isLunas, ')
          ..write('total: $total, ')
          ..write('pickupEstimate: $pickupEstimate, ')
          ..write('notes: $notes, ')
          ..write('layananSummary: $layananSummary, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kode,
    outletId,
    outletName,
    pelangganId,
    pelangganName,
    status,
    isLunas,
    total,
    pickupEstimate,
    notes,
    layananSummary,
    createdAt,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PesananEntry &&
          other.id == this.id &&
          other.kode == this.kode &&
          other.outletId == this.outletId &&
          other.outletName == this.outletName &&
          other.pelangganId == this.pelangganId &&
          other.pelangganName == this.pelangganName &&
          other.status == this.status &&
          other.isLunas == this.isLunas &&
          other.total == this.total &&
          other.pickupEstimate == this.pickupEstimate &&
          other.notes == this.notes &&
          other.layananSummary == this.layananSummary &&
          other.createdAt == this.createdAt &&
          other.syncedAt == this.syncedAt);
}

class PesananEntriesCompanion extends UpdateCompanion<PesananEntry> {
  final Value<int> id;
  final Value<String> kode;
  final Value<int> outletId;
  final Value<String> outletName;
  final Value<int?> pelangganId;
  final Value<String?> pelangganName;
  final Value<String> status;
  final Value<bool> isLunas;
  final Value<double> total;
  final Value<String?> pickupEstimate;
  final Value<String?> notes;
  final Value<String> layananSummary;
  final Value<String> createdAt;
  final Value<DateTime> syncedAt;
  const PesananEntriesCompanion({
    this.id = const Value.absent(),
    this.kode = const Value.absent(),
    this.outletId = const Value.absent(),
    this.outletName = const Value.absent(),
    this.pelangganId = const Value.absent(),
    this.pelangganName = const Value.absent(),
    this.status = const Value.absent(),
    this.isLunas = const Value.absent(),
    this.total = const Value.absent(),
    this.pickupEstimate = const Value.absent(),
    this.notes = const Value.absent(),
    this.layananSummary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  PesananEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String kode,
    required int outletId,
    this.outletName = const Value.absent(),
    this.pelangganId = const Value.absent(),
    this.pelangganName = const Value.absent(),
    required String status,
    this.isLunas = const Value.absent(),
    this.total = const Value.absent(),
    this.pickupEstimate = const Value.absent(),
    this.notes = const Value.absent(),
    this.layananSummary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : kode = Value(kode),
       outletId = Value(outletId),
       status = Value(status);
  static Insertable<PesananEntry> custom({
    Expression<int>? id,
    Expression<String>? kode,
    Expression<int>? outletId,
    Expression<String>? outletName,
    Expression<int>? pelangganId,
    Expression<String>? pelangganName,
    Expression<String>? status,
    Expression<bool>? isLunas,
    Expression<double>? total,
    Expression<String>? pickupEstimate,
    Expression<String>? notes,
    Expression<String>? layananSummary,
    Expression<String>? createdAt,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kode != null) 'kode': kode,
      if (outletId != null) 'outlet_id': outletId,
      if (outletName != null) 'outlet_name': outletName,
      if (pelangganId != null) 'pelanggan_id': pelangganId,
      if (pelangganName != null) 'pelanggan_name': pelangganName,
      if (status != null) 'status': status,
      if (isLunas != null) 'is_lunas': isLunas,
      if (total != null) 'total': total,
      if (pickupEstimate != null) 'pickup_estimate': pickupEstimate,
      if (notes != null) 'notes': notes,
      if (layananSummary != null) 'layanan_summary': layananSummary,
      if (createdAt != null) 'created_at': createdAt,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  PesananEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? kode,
    Value<int>? outletId,
    Value<String>? outletName,
    Value<int?>? pelangganId,
    Value<String?>? pelangganName,
    Value<String>? status,
    Value<bool>? isLunas,
    Value<double>? total,
    Value<String?>? pickupEstimate,
    Value<String?>? notes,
    Value<String>? layananSummary,
    Value<String>? createdAt,
    Value<DateTime>? syncedAt,
  }) {
    return PesananEntriesCompanion(
      id: id ?? this.id,
      kode: kode ?? this.kode,
      outletId: outletId ?? this.outletId,
      outletName: outletName ?? this.outletName,
      pelangganId: pelangganId ?? this.pelangganId,
      pelangganName: pelangganName ?? this.pelangganName,
      status: status ?? this.status,
      isLunas: isLunas ?? this.isLunas,
      total: total ?? this.total,
      pickupEstimate: pickupEstimate ?? this.pickupEstimate,
      notes: notes ?? this.notes,
      layananSummary: layananSummary ?? this.layananSummary,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kode.present) {
      map['kode'] = Variable<String>(kode.value);
    }
    if (outletId.present) {
      map['outlet_id'] = Variable<int>(outletId.value);
    }
    if (outletName.present) {
      map['outlet_name'] = Variable<String>(outletName.value);
    }
    if (pelangganId.present) {
      map['pelanggan_id'] = Variable<int>(pelangganId.value);
    }
    if (pelangganName.present) {
      map['pelanggan_name'] = Variable<String>(pelangganName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isLunas.present) {
      map['is_lunas'] = Variable<bool>(isLunas.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (pickupEstimate.present) {
      map['pickup_estimate'] = Variable<String>(pickupEstimate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (layananSummary.present) {
      map['layanan_summary'] = Variable<String>(layananSummary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PesananEntriesCompanion(')
          ..write('id: $id, ')
          ..write('kode: $kode, ')
          ..write('outletId: $outletId, ')
          ..write('outletName: $outletName, ')
          ..write('pelangganId: $pelangganId, ')
          ..write('pelangganName: $pelangganName, ')
          ..write('status: $status, ')
          ..write('isLunas: $isLunas, ')
          ..write('total: $total, ')
          ..write('pickupEstimate: $pickupEstimate, ')
          ..write('notes: $notes, ')
          ..write('layananSummary: $layananSummary, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PelangganEntriesTable pelangganEntries = $PelangganEntriesTable(
    this,
  );
  late final $KaryawanEntriesTable karyawanEntries = $KaryawanEntriesTable(
    this,
  );
  late final $PesananEntriesTable pesananEntries = $PesananEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    pelangganEntries,
    karyawanEntries,
    pesananEntries,
  ];
}

typedef $$PelangganEntriesTableCreateCompanionBuilder =
    PelangganEntriesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> phone,
      Value<String?> address,
      Value<String?> gender,
      Value<int?> outletId,
      Value<String?> outletName,
      Value<DateTime> syncedAt,
    });
typedef $$PelangganEntriesTableUpdateCompanionBuilder =
    PelangganEntriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> phone,
      Value<String?> address,
      Value<String?> gender,
      Value<int?> outletId,
      Value<String?> outletName,
      Value<DateTime> syncedAt,
    });

class $$PelangganEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PelangganEntriesTable> {
  $$PelangganEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outletId => $composableBuilder(
    column: $table.outletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outletName => $composableBuilder(
    column: $table.outletName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PelangganEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PelangganEntriesTable> {
  $$PelangganEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outletId => $composableBuilder(
    column: $table.outletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outletName => $composableBuilder(
    column: $table.outletName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PelangganEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PelangganEntriesTable> {
  $$PelangganEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<int> get outletId =>
      $composableBuilder(column: $table.outletId, builder: (column) => column);

  GeneratedColumn<String> get outletName => $composableBuilder(
    column: $table.outletName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$PelangganEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PelangganEntriesTable,
          PelangganEntry,
          $$PelangganEntriesTableFilterComposer,
          $$PelangganEntriesTableOrderingComposer,
          $$PelangganEntriesTableAnnotationComposer,
          $$PelangganEntriesTableCreateCompanionBuilder,
          $$PelangganEntriesTableUpdateCompanionBuilder,
          (
            PelangganEntry,
            BaseReferences<
              _$AppDatabase,
              $PelangganEntriesTable,
              PelangganEntry
            >,
          ),
          PelangganEntry,
          PrefetchHooks Function()
        > {
  $$PelangganEntriesTableTableManager(
    _$AppDatabase db,
    $PelangganEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PelangganEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PelangganEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PelangganEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<int?> outletId = const Value.absent(),
                Value<String?> outletName = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => PelangganEntriesCompanion(
                id: id,
                name: name,
                phone: phone,
                address: address,
                gender: gender,
                outletId: outletId,
                outletName: outletName,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<int?> outletId = const Value.absent(),
                Value<String?> outletName = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => PelangganEntriesCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                address: address,
                gender: gender,
                outletId: outletId,
                outletName: outletName,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PelangganEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PelangganEntriesTable,
      PelangganEntry,
      $$PelangganEntriesTableFilterComposer,
      $$PelangganEntriesTableOrderingComposer,
      $$PelangganEntriesTableAnnotationComposer,
      $$PelangganEntriesTableCreateCompanionBuilder,
      $$PelangganEntriesTableUpdateCompanionBuilder,
      (
        PelangganEntry,
        BaseReferences<_$AppDatabase, $PelangganEntriesTable, PelangganEntry>,
      ),
      PelangganEntry,
      PrefetchHooks Function()
    >;
typedef $$KaryawanEntriesTableCreateCompanionBuilder =
    KaryawanEntriesCompanion Function({
      Value<int> id,
      required String name,
      required String email,
      Value<String?> phone,
      required String role,
      Value<String> outletNames,
      Value<String?> joinDate,
      Value<DateTime> syncedAt,
    });
typedef $$KaryawanEntriesTableUpdateCompanionBuilder =
    KaryawanEntriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> email,
      Value<String?> phone,
      Value<String> role,
      Value<String> outletNames,
      Value<String?> joinDate,
      Value<DateTime> syncedAt,
    });

class $$KaryawanEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $KaryawanEntriesTable> {
  $$KaryawanEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outletNames => $composableBuilder(
    column: $table.outletNames,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get joinDate => $composableBuilder(
    column: $table.joinDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KaryawanEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $KaryawanEntriesTable> {
  $$KaryawanEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outletNames => $composableBuilder(
    column: $table.outletNames,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get joinDate => $composableBuilder(
    column: $table.joinDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KaryawanEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $KaryawanEntriesTable> {
  $$KaryawanEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get outletNames => $composableBuilder(
    column: $table.outletNames,
    builder: (column) => column,
  );

  GeneratedColumn<String> get joinDate =>
      $composableBuilder(column: $table.joinDate, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$KaryawanEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KaryawanEntriesTable,
          KaryawanEntry,
          $$KaryawanEntriesTableFilterComposer,
          $$KaryawanEntriesTableOrderingComposer,
          $$KaryawanEntriesTableAnnotationComposer,
          $$KaryawanEntriesTableCreateCompanionBuilder,
          $$KaryawanEntriesTableUpdateCompanionBuilder,
          (
            KaryawanEntry,
            BaseReferences<_$AppDatabase, $KaryawanEntriesTable, KaryawanEntry>,
          ),
          KaryawanEntry,
          PrefetchHooks Function()
        > {
  $$KaryawanEntriesTableTableManager(
    _$AppDatabase db,
    $KaryawanEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KaryawanEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KaryawanEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KaryawanEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> outletNames = const Value.absent(),
                Value<String?> joinDate = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => KaryawanEntriesCompanion(
                id: id,
                name: name,
                email: email,
                phone: phone,
                role: role,
                outletNames: outletNames,
                joinDate: joinDate,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String email,
                Value<String?> phone = const Value.absent(),
                required String role,
                Value<String> outletNames = const Value.absent(),
                Value<String?> joinDate = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => KaryawanEntriesCompanion.insert(
                id: id,
                name: name,
                email: email,
                phone: phone,
                role: role,
                outletNames: outletNames,
                joinDate: joinDate,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$KaryawanEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KaryawanEntriesTable,
      KaryawanEntry,
      $$KaryawanEntriesTableFilterComposer,
      $$KaryawanEntriesTableOrderingComposer,
      $$KaryawanEntriesTableAnnotationComposer,
      $$KaryawanEntriesTableCreateCompanionBuilder,
      $$KaryawanEntriesTableUpdateCompanionBuilder,
      (
        KaryawanEntry,
        BaseReferences<_$AppDatabase, $KaryawanEntriesTable, KaryawanEntry>,
      ),
      KaryawanEntry,
      PrefetchHooks Function()
    >;
typedef $$PesananEntriesTableCreateCompanionBuilder =
    PesananEntriesCompanion Function({
      Value<int> id,
      required String kode,
      required int outletId,
      Value<String> outletName,
      Value<int?> pelangganId,
      Value<String?> pelangganName,
      required String status,
      Value<bool> isLunas,
      Value<double> total,
      Value<String?> pickupEstimate,
      Value<String?> notes,
      Value<String> layananSummary,
      Value<String> createdAt,
      Value<DateTime> syncedAt,
    });
typedef $$PesananEntriesTableUpdateCompanionBuilder =
    PesananEntriesCompanion Function({
      Value<int> id,
      Value<String> kode,
      Value<int> outletId,
      Value<String> outletName,
      Value<int?> pelangganId,
      Value<String?> pelangganName,
      Value<String> status,
      Value<bool> isLunas,
      Value<double> total,
      Value<String?> pickupEstimate,
      Value<String?> notes,
      Value<String> layananSummary,
      Value<String> createdAt,
      Value<DateTime> syncedAt,
    });

class $$PesananEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PesananEntriesTable> {
  $$PesananEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kode => $composableBuilder(
    column: $table.kode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outletId => $composableBuilder(
    column: $table.outletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outletName => $composableBuilder(
    column: $table.outletName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pelangganId => $composableBuilder(
    column: $table.pelangganId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pelangganName => $composableBuilder(
    column: $table.pelangganName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLunas => $composableBuilder(
    column: $table.isLunas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pickupEstimate => $composableBuilder(
    column: $table.pickupEstimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get layananSummary => $composableBuilder(
    column: $table.layananSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PesananEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PesananEntriesTable> {
  $$PesananEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kode => $composableBuilder(
    column: $table.kode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outletId => $composableBuilder(
    column: $table.outletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outletName => $composableBuilder(
    column: $table.outletName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pelangganId => $composableBuilder(
    column: $table.pelangganId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pelangganName => $composableBuilder(
    column: $table.pelangganName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLunas => $composableBuilder(
    column: $table.isLunas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pickupEstimate => $composableBuilder(
    column: $table.pickupEstimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get layananSummary => $composableBuilder(
    column: $table.layananSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PesananEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PesananEntriesTable> {
  $$PesananEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kode =>
      $composableBuilder(column: $table.kode, builder: (column) => column);

  GeneratedColumn<int> get outletId =>
      $composableBuilder(column: $table.outletId, builder: (column) => column);

  GeneratedColumn<String> get outletName => $composableBuilder(
    column: $table.outletName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pelangganId => $composableBuilder(
    column: $table.pelangganId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pelangganName => $composableBuilder(
    column: $table.pelangganName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isLunas =>
      $composableBuilder(column: $table.isLunas, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get pickupEstimate => $composableBuilder(
    column: $table.pickupEstimate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get layananSummary => $composableBuilder(
    column: $table.layananSummary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$PesananEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PesananEntriesTable,
          PesananEntry,
          $$PesananEntriesTableFilterComposer,
          $$PesananEntriesTableOrderingComposer,
          $$PesananEntriesTableAnnotationComposer,
          $$PesananEntriesTableCreateCompanionBuilder,
          $$PesananEntriesTableUpdateCompanionBuilder,
          (
            PesananEntry,
            BaseReferences<_$AppDatabase, $PesananEntriesTable, PesananEntry>,
          ),
          PesananEntry,
          PrefetchHooks Function()
        > {
  $$PesananEntriesTableTableManager(
    _$AppDatabase db,
    $PesananEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PesananEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PesananEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PesananEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kode = const Value.absent(),
                Value<int> outletId = const Value.absent(),
                Value<String> outletName = const Value.absent(),
                Value<int?> pelangganId = const Value.absent(),
                Value<String?> pelangganName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isLunas = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String?> pickupEstimate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> layananSummary = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => PesananEntriesCompanion(
                id: id,
                kode: kode,
                outletId: outletId,
                outletName: outletName,
                pelangganId: pelangganId,
                pelangganName: pelangganName,
                status: status,
                isLunas: isLunas,
                total: total,
                pickupEstimate: pickupEstimate,
                notes: notes,
                layananSummary: layananSummary,
                createdAt: createdAt,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kode,
                required int outletId,
                Value<String> outletName = const Value.absent(),
                Value<int?> pelangganId = const Value.absent(),
                Value<String?> pelangganName = const Value.absent(),
                required String status,
                Value<bool> isLunas = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String?> pickupEstimate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> layananSummary = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => PesananEntriesCompanion.insert(
                id: id,
                kode: kode,
                outletId: outletId,
                outletName: outletName,
                pelangganId: pelangganId,
                pelangganName: pelangganName,
                status: status,
                isLunas: isLunas,
                total: total,
                pickupEstimate: pickupEstimate,
                notes: notes,
                layananSummary: layananSummary,
                createdAt: createdAt,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PesananEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PesananEntriesTable,
      PesananEntry,
      $$PesananEntriesTableFilterComposer,
      $$PesananEntriesTableOrderingComposer,
      $$PesananEntriesTableAnnotationComposer,
      $$PesananEntriesTableCreateCompanionBuilder,
      $$PesananEntriesTableUpdateCompanionBuilder,
      (
        PesananEntry,
        BaseReferences<_$AppDatabase, $PesananEntriesTable, PesananEntry>,
      ),
      PesananEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PelangganEntriesTableTableManager get pelangganEntries =>
      $$PelangganEntriesTableTableManager(_db, _db.pelangganEntries);
  $$KaryawanEntriesTableTableManager get karyawanEntries =>
      $$KaryawanEntriesTableTableManager(_db, _db.karyawanEntries);
  $$PesananEntriesTableTableManager get pesananEntries =>
      $$PesananEntriesTableTableManager(_db, _db.pesananEntries);
}
