// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LeadsTable extends Leads with TableInfo<$LeadsTable, Lead> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta(
    'dateAdded',
  );
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
    'date_added',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessMeta = const VerificationMeta(
    'business',
  );
  @override
  late final GeneratedColumn<String> business = GeneratedColumn<String>(
    'business',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactPersonMeta = const VerificationMeta(
    'contactPerson',
  );
  @override
  late final GeneratedColumn<String> contactPerson = GeneratedColumn<String>(
    'contact_person',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _instagramMeta = const VerificationMeta(
    'instagram',
  );
  @override
  late final GeneratedColumn<String> instagram = GeneratedColumn<String>(
    'instagram',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LeadSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LeadSource>($LeadsTable.$convertersource);
  @override
  late final GeneratedColumnWithTypeConverter<ServiceType, String> service =
      GeneratedColumn<String>(
        'service',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ServiceType>($LeadsTable.$converterservice);
  static const VerificationMeta _potentialValueMeta = const VerificationMeta(
    'potentialValue',
  );
  @override
  late final GeneratedColumn<double> potentialValue = GeneratedColumn<double>(
    'potential_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LeadStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LeadStatus>($LeadsTable.$converterstatus);
  static const VerificationMeta _lastContactMeta = const VerificationMeta(
    'lastContact',
  );
  @override
  late final GeneratedColumn<DateTime> lastContact = GeneratedColumn<DateTime>(
    'last_contact',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextFollowUpMeta = const VerificationMeta(
    'nextFollowUp',
  );
  @override
  late final GeneratedColumn<DateTime> nextFollowUp = GeneratedColumn<DateTime>(
    'next_follow_up',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _proposalLinkMeta = const VerificationMeta(
    'proposalLink',
  );
  @override
  late final GeneratedColumn<String> proposalLink = GeneratedColumn<String>(
    'proposal_link',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _driveFolderMeta = const VerificationMeta(
    'driveFolder',
  );
  @override
  late final GeneratedColumn<String> driveFolder = GeneratedColumn<String>(
    'drive_folder',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _lostReasonMeta = const VerificationMeta(
    'lostReason',
  );
  @override
  late final GeneratedColumn<String> lostReason = GeneratedColumn<String>(
    'lost_reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _externalKeyMeta = const VerificationMeta(
    'externalKey',
  );
  @override
  late final GeneratedColumn<String> externalKey = GeneratedColumn<String>(
    'external_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dateAdded,
    business,
    contactPerson,
    phone,
    email,
    instagram,
    source,
    service,
    potentialValue,
    status,
    lastContact,
    nextFollowUp,
    notes,
    proposalLink,
    driveFolder,
    lostReason,
    clientId,
    externalKey,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leads';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lead> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date_added')) {
      context.handle(
        _dateAddedMeta,
        dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta),
      );
    } else if (isInserting) {
      context.missing(_dateAddedMeta);
    }
    if (data.containsKey('business')) {
      context.handle(
        _businessMeta,
        business.isAcceptableOrUnknown(data['business']!, _businessMeta),
      );
    } else if (isInserting) {
      context.missing(_businessMeta);
    }
    if (data.containsKey('contact_person')) {
      context.handle(
        _contactPersonMeta,
        contactPerson.isAcceptableOrUnknown(
          data['contact_person']!,
          _contactPersonMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('instagram')) {
      context.handle(
        _instagramMeta,
        instagram.isAcceptableOrUnknown(data['instagram']!, _instagramMeta),
      );
    }
    if (data.containsKey('potential_value')) {
      context.handle(
        _potentialValueMeta,
        potentialValue.isAcceptableOrUnknown(
          data['potential_value']!,
          _potentialValueMeta,
        ),
      );
    }
    if (data.containsKey('last_contact')) {
      context.handle(
        _lastContactMeta,
        lastContact.isAcceptableOrUnknown(
          data['last_contact']!,
          _lastContactMeta,
        ),
      );
    }
    if (data.containsKey('next_follow_up')) {
      context.handle(
        _nextFollowUpMeta,
        nextFollowUp.isAcceptableOrUnknown(
          data['next_follow_up']!,
          _nextFollowUpMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('proposal_link')) {
      context.handle(
        _proposalLinkMeta,
        proposalLink.isAcceptableOrUnknown(
          data['proposal_link']!,
          _proposalLinkMeta,
        ),
      );
    }
    if (data.containsKey('drive_folder')) {
      context.handle(
        _driveFolderMeta,
        driveFolder.isAcceptableOrUnknown(
          data['drive_folder']!,
          _driveFolderMeta,
        ),
      );
    }
    if (data.containsKey('lost_reason')) {
      context.handle(
        _lostReasonMeta,
        lostReason.isAcceptableOrUnknown(data['lost_reason']!, _lostReasonMeta),
      );
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    if (data.containsKey('external_key')) {
      context.handle(
        _externalKeyMeta,
        externalKey.isAcceptableOrUnknown(
          data['external_key']!,
          _externalKeyMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lead map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lead(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dateAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_added'],
      )!,
      business: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business'],
      )!,
      contactPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      instagram: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instagram'],
      )!,
      source: $LeadsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      service: $LeadsTable.$converterservice.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}service'],
        )!,
      ),
      potentialValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}potential_value'],
      )!,
      status: $LeadsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      lastContact: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_contact'],
      ),
      nextFollowUp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_follow_up'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      proposalLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proposal_link'],
      )!,
      driveFolder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drive_folder'],
      )!,
      lostReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lost_reason'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      ),
      externalKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_key'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LeadsTable createAlias(String alias) {
    return $LeadsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LeadSource, String, String> $convertersource =
      const EnumNameConverter<LeadSource>(LeadSource.values);
  static JsonTypeConverter2<ServiceType, String, String> $converterservice =
      const EnumNameConverter<ServiceType>(ServiceType.values);
  static JsonTypeConverter2<LeadStatus, String, String> $converterstatus =
      const EnumNameConverter<LeadStatus>(LeadStatus.values);
}

class Lead extends DataClass implements Insertable<Lead> {
  final String id;
  final DateTime dateAdded;
  final String business;
  final String contactPerson;
  final String phone;
  final String email;
  final String instagram;
  final LeadSource source;
  final ServiceType service;
  final double potentialValue;
  final LeadStatus status;
  final DateTime? lastContact;
  final DateTime? nextFollowUp;
  final String notes;
  final String proposalLink;
  final String driveFolder;
  final String lostReason;
  final String? clientId;

  /// Stable key of the external source row (sheet row / form timestamp) used to
  /// de-duplicate imports.
  final String? externalKey;
  final DateTime updatedAt;
  const Lead({
    required this.id,
    required this.dateAdded,
    required this.business,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.instagram,
    required this.source,
    required this.service,
    required this.potentialValue,
    required this.status,
    this.lastContact,
    this.nextFollowUp,
    required this.notes,
    required this.proposalLink,
    required this.driveFolder,
    required this.lostReason,
    this.clientId,
    this.externalKey,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date_added'] = Variable<DateTime>(dateAdded);
    map['business'] = Variable<String>(business);
    map['contact_person'] = Variable<String>(contactPerson);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['instagram'] = Variable<String>(instagram);
    {
      map['source'] = Variable<String>(
        $LeadsTable.$convertersource.toSql(source),
      );
    }
    {
      map['service'] = Variable<String>(
        $LeadsTable.$converterservice.toSql(service),
      );
    }
    map['potential_value'] = Variable<double>(potentialValue);
    {
      map['status'] = Variable<String>(
        $LeadsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || lastContact != null) {
      map['last_contact'] = Variable<DateTime>(lastContact);
    }
    if (!nullToAbsent || nextFollowUp != null) {
      map['next_follow_up'] = Variable<DateTime>(nextFollowUp);
    }
    map['notes'] = Variable<String>(notes);
    map['proposal_link'] = Variable<String>(proposalLink);
    map['drive_folder'] = Variable<String>(driveFolder);
    map['lost_reason'] = Variable<String>(lostReason);
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<String>(clientId);
    }
    if (!nullToAbsent || externalKey != null) {
      map['external_key'] = Variable<String>(externalKey);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LeadsCompanion toCompanion(bool nullToAbsent) {
    return LeadsCompanion(
      id: Value(id),
      dateAdded: Value(dateAdded),
      business: Value(business),
      contactPerson: Value(contactPerson),
      phone: Value(phone),
      email: Value(email),
      instagram: Value(instagram),
      source: Value(source),
      service: Value(service),
      potentialValue: Value(potentialValue),
      status: Value(status),
      lastContact: lastContact == null && nullToAbsent
          ? const Value.absent()
          : Value(lastContact),
      nextFollowUp: nextFollowUp == null && nullToAbsent
          ? const Value.absent()
          : Value(nextFollowUp),
      notes: Value(notes),
      proposalLink: Value(proposalLink),
      driveFolder: Value(driveFolder),
      lostReason: Value(lostReason),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      externalKey: externalKey == null && nullToAbsent
          ? const Value.absent()
          : Value(externalKey),
      updatedAt: Value(updatedAt),
    );
  }

  factory Lead.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lead(
      id: serializer.fromJson<String>(json['id']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
      business: serializer.fromJson<String>(json['business']),
      contactPerson: serializer.fromJson<String>(json['contactPerson']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      instagram: serializer.fromJson<String>(json['instagram']),
      source: $LeadsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      service: $LeadsTable.$converterservice.fromJson(
        serializer.fromJson<String>(json['service']),
      ),
      potentialValue: serializer.fromJson<double>(json['potentialValue']),
      status: $LeadsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      lastContact: serializer.fromJson<DateTime?>(json['lastContact']),
      nextFollowUp: serializer.fromJson<DateTime?>(json['nextFollowUp']),
      notes: serializer.fromJson<String>(json['notes']),
      proposalLink: serializer.fromJson<String>(json['proposalLink']),
      driveFolder: serializer.fromJson<String>(json['driveFolder']),
      lostReason: serializer.fromJson<String>(json['lostReason']),
      clientId: serializer.fromJson<String?>(json['clientId']),
      externalKey: serializer.fromJson<String?>(json['externalKey']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
      'business': serializer.toJson<String>(business),
      'contactPerson': serializer.toJson<String>(contactPerson),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'instagram': serializer.toJson<String>(instagram),
      'source': serializer.toJson<String>(
        $LeadsTable.$convertersource.toJson(source),
      ),
      'service': serializer.toJson<String>(
        $LeadsTable.$converterservice.toJson(service),
      ),
      'potentialValue': serializer.toJson<double>(potentialValue),
      'status': serializer.toJson<String>(
        $LeadsTable.$converterstatus.toJson(status),
      ),
      'lastContact': serializer.toJson<DateTime?>(lastContact),
      'nextFollowUp': serializer.toJson<DateTime?>(nextFollowUp),
      'notes': serializer.toJson<String>(notes),
      'proposalLink': serializer.toJson<String>(proposalLink),
      'driveFolder': serializer.toJson<String>(driveFolder),
      'lostReason': serializer.toJson<String>(lostReason),
      'clientId': serializer.toJson<String?>(clientId),
      'externalKey': serializer.toJson<String?>(externalKey),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Lead copyWith({
    String? id,
    DateTime? dateAdded,
    String? business,
    String? contactPerson,
    String? phone,
    String? email,
    String? instagram,
    LeadSource? source,
    ServiceType? service,
    double? potentialValue,
    LeadStatus? status,
    Value<DateTime?> lastContact = const Value.absent(),
    Value<DateTime?> nextFollowUp = const Value.absent(),
    String? notes,
    String? proposalLink,
    String? driveFolder,
    String? lostReason,
    Value<String?> clientId = const Value.absent(),
    Value<String?> externalKey = const Value.absent(),
    DateTime? updatedAt,
  }) => Lead(
    id: id ?? this.id,
    dateAdded: dateAdded ?? this.dateAdded,
    business: business ?? this.business,
    contactPerson: contactPerson ?? this.contactPerson,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    instagram: instagram ?? this.instagram,
    source: source ?? this.source,
    service: service ?? this.service,
    potentialValue: potentialValue ?? this.potentialValue,
    status: status ?? this.status,
    lastContact: lastContact.present ? lastContact.value : this.lastContact,
    nextFollowUp: nextFollowUp.present ? nextFollowUp.value : this.nextFollowUp,
    notes: notes ?? this.notes,
    proposalLink: proposalLink ?? this.proposalLink,
    driveFolder: driveFolder ?? this.driveFolder,
    lostReason: lostReason ?? this.lostReason,
    clientId: clientId.present ? clientId.value : this.clientId,
    externalKey: externalKey.present ? externalKey.value : this.externalKey,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Lead copyWithCompanion(LeadsCompanion data) {
    return Lead(
      id: data.id.present ? data.id.value : this.id,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      business: data.business.present ? data.business.value : this.business,
      contactPerson: data.contactPerson.present
          ? data.contactPerson.value
          : this.contactPerson,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      instagram: data.instagram.present ? data.instagram.value : this.instagram,
      source: data.source.present ? data.source.value : this.source,
      service: data.service.present ? data.service.value : this.service,
      potentialValue: data.potentialValue.present
          ? data.potentialValue.value
          : this.potentialValue,
      status: data.status.present ? data.status.value : this.status,
      lastContact: data.lastContact.present
          ? data.lastContact.value
          : this.lastContact,
      nextFollowUp: data.nextFollowUp.present
          ? data.nextFollowUp.value
          : this.nextFollowUp,
      notes: data.notes.present ? data.notes.value : this.notes,
      proposalLink: data.proposalLink.present
          ? data.proposalLink.value
          : this.proposalLink,
      driveFolder: data.driveFolder.present
          ? data.driveFolder.value
          : this.driveFolder,
      lostReason: data.lostReason.present
          ? data.lostReason.value
          : this.lostReason,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      externalKey: data.externalKey.present
          ? data.externalKey.value
          : this.externalKey,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lead(')
          ..write('id: $id, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('business: $business, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('instagram: $instagram, ')
          ..write('source: $source, ')
          ..write('service: $service, ')
          ..write('potentialValue: $potentialValue, ')
          ..write('status: $status, ')
          ..write('lastContact: $lastContact, ')
          ..write('nextFollowUp: $nextFollowUp, ')
          ..write('notes: $notes, ')
          ..write('proposalLink: $proposalLink, ')
          ..write('driveFolder: $driveFolder, ')
          ..write('lostReason: $lostReason, ')
          ..write('clientId: $clientId, ')
          ..write('externalKey: $externalKey, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dateAdded,
    business,
    contactPerson,
    phone,
    email,
    instagram,
    source,
    service,
    potentialValue,
    status,
    lastContact,
    nextFollowUp,
    notes,
    proposalLink,
    driveFolder,
    lostReason,
    clientId,
    externalKey,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lead &&
          other.id == this.id &&
          other.dateAdded == this.dateAdded &&
          other.business == this.business &&
          other.contactPerson == this.contactPerson &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.instagram == this.instagram &&
          other.source == this.source &&
          other.service == this.service &&
          other.potentialValue == this.potentialValue &&
          other.status == this.status &&
          other.lastContact == this.lastContact &&
          other.nextFollowUp == this.nextFollowUp &&
          other.notes == this.notes &&
          other.proposalLink == this.proposalLink &&
          other.driveFolder == this.driveFolder &&
          other.lostReason == this.lostReason &&
          other.clientId == this.clientId &&
          other.externalKey == this.externalKey &&
          other.updatedAt == this.updatedAt);
}

class LeadsCompanion extends UpdateCompanion<Lead> {
  final Value<String> id;
  final Value<DateTime> dateAdded;
  final Value<String> business;
  final Value<String> contactPerson;
  final Value<String> phone;
  final Value<String> email;
  final Value<String> instagram;
  final Value<LeadSource> source;
  final Value<ServiceType> service;
  final Value<double> potentialValue;
  final Value<LeadStatus> status;
  final Value<DateTime?> lastContact;
  final Value<DateTime?> nextFollowUp;
  final Value<String> notes;
  final Value<String> proposalLink;
  final Value<String> driveFolder;
  final Value<String> lostReason;
  final Value<String?> clientId;
  final Value<String?> externalKey;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LeadsCompanion({
    this.id = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.business = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.instagram = const Value.absent(),
    this.source = const Value.absent(),
    this.service = const Value.absent(),
    this.potentialValue = const Value.absent(),
    this.status = const Value.absent(),
    this.lastContact = const Value.absent(),
    this.nextFollowUp = const Value.absent(),
    this.notes = const Value.absent(),
    this.proposalLink = const Value.absent(),
    this.driveFolder = const Value.absent(),
    this.lostReason = const Value.absent(),
    this.clientId = const Value.absent(),
    this.externalKey = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeadsCompanion.insert({
    required String id,
    required DateTime dateAdded,
    required String business,
    this.contactPerson = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.instagram = const Value.absent(),
    required LeadSource source,
    required ServiceType service,
    this.potentialValue = const Value.absent(),
    required LeadStatus status,
    this.lastContact = const Value.absent(),
    this.nextFollowUp = const Value.absent(),
    this.notes = const Value.absent(),
    this.proposalLink = const Value.absent(),
    this.driveFolder = const Value.absent(),
    this.lostReason = const Value.absent(),
    this.clientId = const Value.absent(),
    this.externalKey = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dateAdded = Value(dateAdded),
       business = Value(business),
       source = Value(source),
       service = Value(service),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<Lead> custom({
    Expression<String>? id,
    Expression<DateTime>? dateAdded,
    Expression<String>? business,
    Expression<String>? contactPerson,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? instagram,
    Expression<String>? source,
    Expression<String>? service,
    Expression<double>? potentialValue,
    Expression<String>? status,
    Expression<DateTime>? lastContact,
    Expression<DateTime>? nextFollowUp,
    Expression<String>? notes,
    Expression<String>? proposalLink,
    Expression<String>? driveFolder,
    Expression<String>? lostReason,
    Expression<String>? clientId,
    Expression<String>? externalKey,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateAdded != null) 'date_added': dateAdded,
      if (business != null) 'business': business,
      if (contactPerson != null) 'contact_person': contactPerson,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (instagram != null) 'instagram': instagram,
      if (source != null) 'source': source,
      if (service != null) 'service': service,
      if (potentialValue != null) 'potential_value': potentialValue,
      if (status != null) 'status': status,
      if (lastContact != null) 'last_contact': lastContact,
      if (nextFollowUp != null) 'next_follow_up': nextFollowUp,
      if (notes != null) 'notes': notes,
      if (proposalLink != null) 'proposal_link': proposalLink,
      if (driveFolder != null) 'drive_folder': driveFolder,
      if (lostReason != null) 'lost_reason': lostReason,
      if (clientId != null) 'client_id': clientId,
      if (externalKey != null) 'external_key': externalKey,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeadsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? dateAdded,
    Value<String>? business,
    Value<String>? contactPerson,
    Value<String>? phone,
    Value<String>? email,
    Value<String>? instagram,
    Value<LeadSource>? source,
    Value<ServiceType>? service,
    Value<double>? potentialValue,
    Value<LeadStatus>? status,
    Value<DateTime?>? lastContact,
    Value<DateTime?>? nextFollowUp,
    Value<String>? notes,
    Value<String>? proposalLink,
    Value<String>? driveFolder,
    Value<String>? lostReason,
    Value<String?>? clientId,
    Value<String?>? externalKey,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LeadsCompanion(
      id: id ?? this.id,
      dateAdded: dateAdded ?? this.dateAdded,
      business: business ?? this.business,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      instagram: instagram ?? this.instagram,
      source: source ?? this.source,
      service: service ?? this.service,
      potentialValue: potentialValue ?? this.potentialValue,
      status: status ?? this.status,
      lastContact: lastContact ?? this.lastContact,
      nextFollowUp: nextFollowUp ?? this.nextFollowUp,
      notes: notes ?? this.notes,
      proposalLink: proposalLink ?? this.proposalLink,
      driveFolder: driveFolder ?? this.driveFolder,
      lostReason: lostReason ?? this.lostReason,
      clientId: clientId ?? this.clientId,
      externalKey: externalKey ?? this.externalKey,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (business.present) {
      map['business'] = Variable<String>(business.value);
    }
    if (contactPerson.present) {
      map['contact_person'] = Variable<String>(contactPerson.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (instagram.present) {
      map['instagram'] = Variable<String>(instagram.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $LeadsTable.$convertersource.toSql(source.value),
      );
    }
    if (service.present) {
      map['service'] = Variable<String>(
        $LeadsTable.$converterservice.toSql(service.value),
      );
    }
    if (potentialValue.present) {
      map['potential_value'] = Variable<double>(potentialValue.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $LeadsTable.$converterstatus.toSql(status.value),
      );
    }
    if (lastContact.present) {
      map['last_contact'] = Variable<DateTime>(lastContact.value);
    }
    if (nextFollowUp.present) {
      map['next_follow_up'] = Variable<DateTime>(nextFollowUp.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (proposalLink.present) {
      map['proposal_link'] = Variable<String>(proposalLink.value);
    }
    if (driveFolder.present) {
      map['drive_folder'] = Variable<String>(driveFolder.value);
    }
    if (lostReason.present) {
      map['lost_reason'] = Variable<String>(lostReason.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (externalKey.present) {
      map['external_key'] = Variable<String>(externalKey.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeadsCompanion(')
          ..write('id: $id, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('business: $business, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('instagram: $instagram, ')
          ..write('source: $source, ')
          ..write('service: $service, ')
          ..write('potentialValue: $potentialValue, ')
          ..write('status: $status, ')
          ..write('lastContact: $lastContact, ')
          ..write('nextFollowUp: $nextFollowUp, ')
          ..write('notes: $notes, ')
          ..write('proposalLink: $proposalLink, ')
          ..write('driveFolder: $driveFolder, ')
          ..write('lostReason: $lostReason, ')
          ..write('clientId: $clientId, ')
          ..write('externalKey: $externalKey, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _contactPersonMeta = const VerificationMeta(
    'contactPerson',
  );
  @override
  late final GeneratedColumn<String> contactPerson = GeneratedColumn<String>(
    'contact_person',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _instagramMeta = const VerificationMeta(
    'instagram',
  );
  @override
  late final GeneratedColumn<String> instagram = GeneratedColumn<String>(
    'instagram',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ServiceType, String> service =
      GeneratedColumn<String>(
        'service',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ServiceType>($ClientsTable.$converterservice);
  static const VerificationMeta _monthlyValueMeta = const VerificationMeta(
    'monthlyValue',
  );
  @override
  late final GeneratedColumn<double> monthlyValue = GeneratedColumn<double>(
    'monthly_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _projectValueMeta = const VerificationMeta(
    'projectValue',
  );
  @override
  late final GeneratedColumn<double> projectValue = GeneratedColumn<double>(
    'project_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ClientStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ClientStatus>($ClientsTable.$converterstatus);
  static const VerificationMeta _driveFolderMeta = const VerificationMeta(
    'driveFolder',
  );
  @override
  late final GeneratedColumn<String> driveFolder = GeneratedColumn<String>(
    'drive_folder',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _leadIdMeta = const VerificationMeta('leadId');
  @override
  late final GeneratedColumn<String> leadId = GeneratedColumn<String>(
    'lead_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    contactPerson,
    phone,
    email,
    instagram,
    service,
    monthlyValue,
    projectValue,
    startDate,
    status,
    driveFolder,
    notes,
    leadId,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Client> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('contact_person')) {
      context.handle(
        _contactPersonMeta,
        contactPerson.isAcceptableOrUnknown(
          data['contact_person']!,
          _contactPersonMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('instagram')) {
      context.handle(
        _instagramMeta,
        instagram.isAcceptableOrUnknown(data['instagram']!, _instagramMeta),
      );
    }
    if (data.containsKey('monthly_value')) {
      context.handle(
        _monthlyValueMeta,
        monthlyValue.isAcceptableOrUnknown(
          data['monthly_value']!,
          _monthlyValueMeta,
        ),
      );
    }
    if (data.containsKey('project_value')) {
      context.handle(
        _projectValueMeta,
        projectValue.isAcceptableOrUnknown(
          data['project_value']!,
          _projectValueMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('drive_folder')) {
      context.handle(
        _driveFolderMeta,
        driveFolder.isAcceptableOrUnknown(
          data['drive_folder']!,
          _driveFolderMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('lead_id')) {
      context.handle(
        _leadIdMeta,
        leadId.isAcceptableOrUnknown(data['lead_id']!, _leadIdMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      contactPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      instagram: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instagram'],
      )!,
      service: $ClientsTable.$converterservice.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}service'],
        )!,
      ),
      monthlyValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_value'],
      )!,
      projectValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}project_value'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      status: $ClientsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      driveFolder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drive_folder'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      leadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lead_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ServiceType, String, String> $converterservice =
      const EnumNameConverter<ServiceType>(ServiceType.values);
  static JsonTypeConverter2<ClientStatus, String, String> $converterstatus =
      const EnumNameConverter<ClientStatus>(ClientStatus.values);
}

class Client extends DataClass implements Insertable<Client> {
  final String id;
  final String name;
  final String contactPerson;
  final String phone;
  final String email;
  final String instagram;
  final ServiceType service;
  final double monthlyValue;
  final double projectValue;
  final DateTime startDate;
  final ClientStatus status;
  final String driveFolder;
  final String notes;
  final String? leadId;
  final DateTime updatedAt;
  const Client({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.instagram,
    required this.service,
    required this.monthlyValue,
    required this.projectValue,
    required this.startDate,
    required this.status,
    required this.driveFolder,
    required this.notes,
    this.leadId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['contact_person'] = Variable<String>(contactPerson);
    map['phone'] = Variable<String>(phone);
    map['email'] = Variable<String>(email);
    map['instagram'] = Variable<String>(instagram);
    {
      map['service'] = Variable<String>(
        $ClientsTable.$converterservice.toSql(service),
      );
    }
    map['monthly_value'] = Variable<double>(monthlyValue);
    map['project_value'] = Variable<double>(projectValue);
    map['start_date'] = Variable<DateTime>(startDate);
    {
      map['status'] = Variable<String>(
        $ClientsTable.$converterstatus.toSql(status),
      );
    }
    map['drive_folder'] = Variable<String>(driveFolder);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || leadId != null) {
      map['lead_id'] = Variable<String>(leadId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      name: Value(name),
      contactPerson: Value(contactPerson),
      phone: Value(phone),
      email: Value(email),
      instagram: Value(instagram),
      service: Value(service),
      monthlyValue: Value(monthlyValue),
      projectValue: Value(projectValue),
      startDate: Value(startDate),
      status: Value(status),
      driveFolder: Value(driveFolder),
      notes: Value(notes),
      leadId: leadId == null && nullToAbsent
          ? const Value.absent()
          : Value(leadId),
      updatedAt: Value(updatedAt),
    );
  }

  factory Client.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      contactPerson: serializer.fromJson<String>(json['contactPerson']),
      phone: serializer.fromJson<String>(json['phone']),
      email: serializer.fromJson<String>(json['email']),
      instagram: serializer.fromJson<String>(json['instagram']),
      service: $ClientsTable.$converterservice.fromJson(
        serializer.fromJson<String>(json['service']),
      ),
      monthlyValue: serializer.fromJson<double>(json['monthlyValue']),
      projectValue: serializer.fromJson<double>(json['projectValue']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      status: $ClientsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      driveFolder: serializer.fromJson<String>(json['driveFolder']),
      notes: serializer.fromJson<String>(json['notes']),
      leadId: serializer.fromJson<String?>(json['leadId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'contactPerson': serializer.toJson<String>(contactPerson),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String>(email),
      'instagram': serializer.toJson<String>(instagram),
      'service': serializer.toJson<String>(
        $ClientsTable.$converterservice.toJson(service),
      ),
      'monthlyValue': serializer.toJson<double>(monthlyValue),
      'projectValue': serializer.toJson<double>(projectValue),
      'startDate': serializer.toJson<DateTime>(startDate),
      'status': serializer.toJson<String>(
        $ClientsTable.$converterstatus.toJson(status),
      ),
      'driveFolder': serializer.toJson<String>(driveFolder),
      'notes': serializer.toJson<String>(notes),
      'leadId': serializer.toJson<String?>(leadId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Client copyWith({
    String? id,
    String? name,
    String? contactPerson,
    String? phone,
    String? email,
    String? instagram,
    ServiceType? service,
    double? monthlyValue,
    double? projectValue,
    DateTime? startDate,
    ClientStatus? status,
    String? driveFolder,
    String? notes,
    Value<String?> leadId = const Value.absent(),
    DateTime? updatedAt,
  }) => Client(
    id: id ?? this.id,
    name: name ?? this.name,
    contactPerson: contactPerson ?? this.contactPerson,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    instagram: instagram ?? this.instagram,
    service: service ?? this.service,
    monthlyValue: monthlyValue ?? this.monthlyValue,
    projectValue: projectValue ?? this.projectValue,
    startDate: startDate ?? this.startDate,
    status: status ?? this.status,
    driveFolder: driveFolder ?? this.driveFolder,
    notes: notes ?? this.notes,
    leadId: leadId.present ? leadId.value : this.leadId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      contactPerson: data.contactPerson.present
          ? data.contactPerson.value
          : this.contactPerson,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      instagram: data.instagram.present ? data.instagram.value : this.instagram,
      service: data.service.present ? data.service.value : this.service,
      monthlyValue: data.monthlyValue.present
          ? data.monthlyValue.value
          : this.monthlyValue,
      projectValue: data.projectValue.present
          ? data.projectValue.value
          : this.projectValue,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      status: data.status.present ? data.status.value : this.status,
      driveFolder: data.driveFolder.present
          ? data.driveFolder.value
          : this.driveFolder,
      notes: data.notes.present ? data.notes.value : this.notes,
      leadId: data.leadId.present ? data.leadId.value : this.leadId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('instagram: $instagram, ')
          ..write('service: $service, ')
          ..write('monthlyValue: $monthlyValue, ')
          ..write('projectValue: $projectValue, ')
          ..write('startDate: $startDate, ')
          ..write('status: $status, ')
          ..write('driveFolder: $driveFolder, ')
          ..write('notes: $notes, ')
          ..write('leadId: $leadId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    contactPerson,
    phone,
    email,
    instagram,
    service,
    monthlyValue,
    projectValue,
    startDate,
    status,
    driveFolder,
    notes,
    leadId,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.name == this.name &&
          other.contactPerson == this.contactPerson &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.instagram == this.instagram &&
          other.service == this.service &&
          other.monthlyValue == this.monthlyValue &&
          other.projectValue == this.projectValue &&
          other.startDate == this.startDate &&
          other.status == this.status &&
          other.driveFolder == this.driveFolder &&
          other.notes == this.notes &&
          other.leadId == this.leadId &&
          other.updatedAt == this.updatedAt);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> contactPerson;
  final Value<String> phone;
  final Value<String> email;
  final Value<String> instagram;
  final Value<ServiceType> service;
  final Value<double> monthlyValue;
  final Value<double> projectValue;
  final Value<DateTime> startDate;
  final Value<ClientStatus> status;
  final Value<String> driveFolder;
  final Value<String> notes;
  final Value<String?> leadId;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.instagram = const Value.absent(),
    this.service = const Value.absent(),
    this.monthlyValue = const Value.absent(),
    this.projectValue = const Value.absent(),
    this.startDate = const Value.absent(),
    this.status = const Value.absent(),
    this.driveFolder = const Value.absent(),
    this.notes = const Value.absent(),
    this.leadId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientsCompanion.insert({
    required String id,
    required String name,
    this.contactPerson = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.instagram = const Value.absent(),
    required ServiceType service,
    this.monthlyValue = const Value.absent(),
    this.projectValue = const Value.absent(),
    required DateTime startDate,
    required ClientStatus status,
    this.driveFolder = const Value.absent(),
    this.notes = const Value.absent(),
    this.leadId = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       service = Value(service),
       startDate = Value(startDate),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<Client> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? contactPerson,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? instagram,
    Expression<String>? service,
    Expression<double>? monthlyValue,
    Expression<double>? projectValue,
    Expression<DateTime>? startDate,
    Expression<String>? status,
    Expression<String>? driveFolder,
    Expression<String>? notes,
    Expression<String>? leadId,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (contactPerson != null) 'contact_person': contactPerson,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (instagram != null) 'instagram': instagram,
      if (service != null) 'service': service,
      if (monthlyValue != null) 'monthly_value': monthlyValue,
      if (projectValue != null) 'project_value': projectValue,
      if (startDate != null) 'start_date': startDate,
      if (status != null) 'status': status,
      if (driveFolder != null) 'drive_folder': driveFolder,
      if (notes != null) 'notes': notes,
      if (leadId != null) 'lead_id': leadId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? contactPerson,
    Value<String>? phone,
    Value<String>? email,
    Value<String>? instagram,
    Value<ServiceType>? service,
    Value<double>? monthlyValue,
    Value<double>? projectValue,
    Value<DateTime>? startDate,
    Value<ClientStatus>? status,
    Value<String>? driveFolder,
    Value<String>? notes,
    Value<String?>? leadId,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ClientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      instagram: instagram ?? this.instagram,
      service: service ?? this.service,
      monthlyValue: monthlyValue ?? this.monthlyValue,
      projectValue: projectValue ?? this.projectValue,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
      driveFolder: driveFolder ?? this.driveFolder,
      notes: notes ?? this.notes,
      leadId: leadId ?? this.leadId,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (contactPerson.present) {
      map['contact_person'] = Variable<String>(contactPerson.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (instagram.present) {
      map['instagram'] = Variable<String>(instagram.value);
    }
    if (service.present) {
      map['service'] = Variable<String>(
        $ClientsTable.$converterservice.toSql(service.value),
      );
    }
    if (monthlyValue.present) {
      map['monthly_value'] = Variable<double>(monthlyValue.value);
    }
    if (projectValue.present) {
      map['project_value'] = Variable<double>(projectValue.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ClientsTable.$converterstatus.toSql(status.value),
      );
    }
    if (driveFolder.present) {
      map['drive_folder'] = Variable<String>(driveFolder.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (leadId.present) {
      map['lead_id'] = Variable<String>(leadId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('instagram: $instagram, ')
          ..write('service: $service, ')
          ..write('monthlyValue: $monthlyValue, ')
          ..write('projectValue: $projectValue, ')
          ..write('startDate: $startDate, ')
          ..write('status: $status, ')
          ..write('driveFolder: $driveFolder, ')
          ..write('notes: $notes, ')
          ..write('leadId: $leadId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  late final GeneratedColumnWithTypeConverter<ServiceType, String> service =
      GeneratedColumn<String>(
        'service',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ServiceType>($ProjectsTable.$converterservice);
  static const VerificationMeta _shootDateMeta = const VerificationMeta(
    'shootDate',
  );
  @override
  late final GeneratedColumn<DateTime> shootDate = GeneratedColumn<DateTime>(
    'shoot_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deadlineMeta = const VerificationMeta(
    'deadline',
  );
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
    'deadline',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ProjectStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ProjectStatus>($ProjectsTable.$converterstatus);
  static const VerificationMeta _deliverablesMeta = const VerificationMeta(
    'deliverables',
  );
  @override
  late final GeneratedColumn<String> deliverables = GeneratedColumn<String>(
    'deliverables',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _clientReviewDateMeta = const VerificationMeta(
    'clientReviewDate',
  );
  @override
  late final GeneratedColumn<DateTime> clientReviewDate =
      GeneratedColumn<DateTime>(
        'client_review_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _finalDeliveryDateMeta = const VerificationMeta(
    'finalDeliveryDate',
  );
  @override
  late final GeneratedColumn<DateTime> finalDeliveryDate =
      GeneratedColumn<DateTime>(
        'final_delivery_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentStatus, String>
  paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PaymentStatus>($ProjectsTable.$converterpaymentStatus);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _driveFolderMeta = const VerificationMeta(
    'driveFolder',
  );
  @override
  late final GeneratedColumn<String> driveFolder = GeneratedColumn<String>(
    'drive_folder',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _calendarEventIdMeta = const VerificationMeta(
    'calendarEventId',
  );
  @override
  late final GeneratedColumn<String> calendarEventId = GeneratedColumn<String>(
    'calendar_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    name,
    service,
    shootDate,
    deadline,
    status,
    deliverables,
    clientReviewDate,
    finalDeliveryDate,
    paymentStatus,
    value,
    driveFolder,
    notes,
    calendarEventId,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('shoot_date')) {
      context.handle(
        _shootDateMeta,
        shootDate.isAcceptableOrUnknown(data['shoot_date']!, _shootDateMeta),
      );
    }
    if (data.containsKey('deadline')) {
      context.handle(
        _deadlineMeta,
        deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta),
      );
    }
    if (data.containsKey('deliverables')) {
      context.handle(
        _deliverablesMeta,
        deliverables.isAcceptableOrUnknown(
          data['deliverables']!,
          _deliverablesMeta,
        ),
      );
    }
    if (data.containsKey('client_review_date')) {
      context.handle(
        _clientReviewDateMeta,
        clientReviewDate.isAcceptableOrUnknown(
          data['client_review_date']!,
          _clientReviewDateMeta,
        ),
      );
    }
    if (data.containsKey('final_delivery_date')) {
      context.handle(
        _finalDeliveryDateMeta,
        finalDeliveryDate.isAcceptableOrUnknown(
          data['final_delivery_date']!,
          _finalDeliveryDateMeta,
        ),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('drive_folder')) {
      context.handle(
        _driveFolderMeta,
        driveFolder.isAcceptableOrUnknown(
          data['drive_folder']!,
          _driveFolderMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('calendar_event_id')) {
      context.handle(
        _calendarEventIdMeta,
        calendarEventId.isAcceptableOrUnknown(
          data['calendar_event_id']!,
          _calendarEventIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      service: $ProjectsTable.$converterservice.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}service'],
        )!,
      ),
      shootDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}shoot_date'],
      ),
      deadline: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline'],
      ),
      status: $ProjectsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      deliverables: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deliverables'],
      )!,
      clientReviewDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_review_date'],
      ),
      finalDeliveryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}final_delivery_date'],
      ),
      paymentStatus: $ProjectsTable.$converterpaymentStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_status'],
        )!,
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      driveFolder: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drive_folder'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      calendarEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_event_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ServiceType, String, String> $converterservice =
      const EnumNameConverter<ServiceType>(ServiceType.values);
  static JsonTypeConverter2<ProjectStatus, String, String> $converterstatus =
      const EnumNameConverter<ProjectStatus>(ProjectStatus.values);
  static JsonTypeConverter2<PaymentStatus, String, String>
  $converterpaymentStatus = const EnumNameConverter<PaymentStatus>(
    PaymentStatus.values,
  );
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String clientId;
  final String name;
  final ServiceType service;
  final DateTime? shootDate;
  final DateTime? deadline;
  final ProjectStatus status;
  final String deliverables;
  final DateTime? clientReviewDate;
  final DateTime? finalDeliveryDate;
  final PaymentStatus paymentStatus;
  final double value;
  final String driveFolder;
  final String notes;
  final String? calendarEventId;
  final DateTime updatedAt;
  const Project({
    required this.id,
    required this.clientId,
    required this.name,
    required this.service,
    this.shootDate,
    this.deadline,
    required this.status,
    required this.deliverables,
    this.clientReviewDate,
    this.finalDeliveryDate,
    required this.paymentStatus,
    required this.value,
    required this.driveFolder,
    required this.notes,
    this.calendarEventId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    map['name'] = Variable<String>(name);
    {
      map['service'] = Variable<String>(
        $ProjectsTable.$converterservice.toSql(service),
      );
    }
    if (!nullToAbsent || shootDate != null) {
      map['shoot_date'] = Variable<DateTime>(shootDate);
    }
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    {
      map['status'] = Variable<String>(
        $ProjectsTable.$converterstatus.toSql(status),
      );
    }
    map['deliverables'] = Variable<String>(deliverables);
    if (!nullToAbsent || clientReviewDate != null) {
      map['client_review_date'] = Variable<DateTime>(clientReviewDate);
    }
    if (!nullToAbsent || finalDeliveryDate != null) {
      map['final_delivery_date'] = Variable<DateTime>(finalDeliveryDate);
    }
    {
      map['payment_status'] = Variable<String>(
        $ProjectsTable.$converterpaymentStatus.toSql(paymentStatus),
      );
    }
    map['value'] = Variable<double>(value);
    map['drive_folder'] = Variable<String>(driveFolder);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || calendarEventId != null) {
      map['calendar_event_id'] = Variable<String>(calendarEventId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      clientId: Value(clientId),
      name: Value(name),
      service: Value(service),
      shootDate: shootDate == null && nullToAbsent
          ? const Value.absent()
          : Value(shootDate),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      status: Value(status),
      deliverables: Value(deliverables),
      clientReviewDate: clientReviewDate == null && nullToAbsent
          ? const Value.absent()
          : Value(clientReviewDate),
      finalDeliveryDate: finalDeliveryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(finalDeliveryDate),
      paymentStatus: Value(paymentStatus),
      value: Value(value),
      driveFolder: Value(driveFolder),
      notes: Value(notes),
      calendarEventId: calendarEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(calendarEventId),
      updatedAt: Value(updatedAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      name: serializer.fromJson<String>(json['name']),
      service: $ProjectsTable.$converterservice.fromJson(
        serializer.fromJson<String>(json['service']),
      ),
      shootDate: serializer.fromJson<DateTime?>(json['shootDate']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      status: $ProjectsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      deliverables: serializer.fromJson<String>(json['deliverables']),
      clientReviewDate: serializer.fromJson<DateTime?>(
        json['clientReviewDate'],
      ),
      finalDeliveryDate: serializer.fromJson<DateTime?>(
        json['finalDeliveryDate'],
      ),
      paymentStatus: $ProjectsTable.$converterpaymentStatus.fromJson(
        serializer.fromJson<String>(json['paymentStatus']),
      ),
      value: serializer.fromJson<double>(json['value']),
      driveFolder: serializer.fromJson<String>(json['driveFolder']),
      notes: serializer.fromJson<String>(json['notes']),
      calendarEventId: serializer.fromJson<String?>(json['calendarEventId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'name': serializer.toJson<String>(name),
      'service': serializer.toJson<String>(
        $ProjectsTable.$converterservice.toJson(service),
      ),
      'shootDate': serializer.toJson<DateTime?>(shootDate),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'status': serializer.toJson<String>(
        $ProjectsTable.$converterstatus.toJson(status),
      ),
      'deliverables': serializer.toJson<String>(deliverables),
      'clientReviewDate': serializer.toJson<DateTime?>(clientReviewDate),
      'finalDeliveryDate': serializer.toJson<DateTime?>(finalDeliveryDate),
      'paymentStatus': serializer.toJson<String>(
        $ProjectsTable.$converterpaymentStatus.toJson(paymentStatus),
      ),
      'value': serializer.toJson<double>(value),
      'driveFolder': serializer.toJson<String>(driveFolder),
      'notes': serializer.toJson<String>(notes),
      'calendarEventId': serializer.toJson<String?>(calendarEventId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Project copyWith({
    String? id,
    String? clientId,
    String? name,
    ServiceType? service,
    Value<DateTime?> shootDate = const Value.absent(),
    Value<DateTime?> deadline = const Value.absent(),
    ProjectStatus? status,
    String? deliverables,
    Value<DateTime?> clientReviewDate = const Value.absent(),
    Value<DateTime?> finalDeliveryDate = const Value.absent(),
    PaymentStatus? paymentStatus,
    double? value,
    String? driveFolder,
    String? notes,
    Value<String?> calendarEventId = const Value.absent(),
    DateTime? updatedAt,
  }) => Project(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    name: name ?? this.name,
    service: service ?? this.service,
    shootDate: shootDate.present ? shootDate.value : this.shootDate,
    deadline: deadline.present ? deadline.value : this.deadline,
    status: status ?? this.status,
    deliverables: deliverables ?? this.deliverables,
    clientReviewDate: clientReviewDate.present
        ? clientReviewDate.value
        : this.clientReviewDate,
    finalDeliveryDate: finalDeliveryDate.present
        ? finalDeliveryDate.value
        : this.finalDeliveryDate,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    value: value ?? this.value,
    driveFolder: driveFolder ?? this.driveFolder,
    notes: notes ?? this.notes,
    calendarEventId: calendarEventId.present
        ? calendarEventId.value
        : this.calendarEventId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      name: data.name.present ? data.name.value : this.name,
      service: data.service.present ? data.service.value : this.service,
      shootDate: data.shootDate.present ? data.shootDate.value : this.shootDate,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      status: data.status.present ? data.status.value : this.status,
      deliverables: data.deliverables.present
          ? data.deliverables.value
          : this.deliverables,
      clientReviewDate: data.clientReviewDate.present
          ? data.clientReviewDate.value
          : this.clientReviewDate,
      finalDeliveryDate: data.finalDeliveryDate.present
          ? data.finalDeliveryDate.value
          : this.finalDeliveryDate,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      value: data.value.present ? data.value.value : this.value,
      driveFolder: data.driveFolder.present
          ? data.driveFolder.value
          : this.driveFolder,
      notes: data.notes.present ? data.notes.value : this.notes,
      calendarEventId: data.calendarEventId.present
          ? data.calendarEventId.value
          : this.calendarEventId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('name: $name, ')
          ..write('service: $service, ')
          ..write('shootDate: $shootDate, ')
          ..write('deadline: $deadline, ')
          ..write('status: $status, ')
          ..write('deliverables: $deliverables, ')
          ..write('clientReviewDate: $clientReviewDate, ')
          ..write('finalDeliveryDate: $finalDeliveryDate, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('value: $value, ')
          ..write('driveFolder: $driveFolder, ')
          ..write('notes: $notes, ')
          ..write('calendarEventId: $calendarEventId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    name,
    service,
    shootDate,
    deadline,
    status,
    deliverables,
    clientReviewDate,
    finalDeliveryDate,
    paymentStatus,
    value,
    driveFolder,
    notes,
    calendarEventId,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.name == this.name &&
          other.service == this.service &&
          other.shootDate == this.shootDate &&
          other.deadline == this.deadline &&
          other.status == this.status &&
          other.deliverables == this.deliverables &&
          other.clientReviewDate == this.clientReviewDate &&
          other.finalDeliveryDate == this.finalDeliveryDate &&
          other.paymentStatus == this.paymentStatus &&
          other.value == this.value &&
          other.driveFolder == this.driveFolder &&
          other.notes == this.notes &&
          other.calendarEventId == this.calendarEventId &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String> name;
  final Value<ServiceType> service;
  final Value<DateTime?> shootDate;
  final Value<DateTime?> deadline;
  final Value<ProjectStatus> status;
  final Value<String> deliverables;
  final Value<DateTime?> clientReviewDate;
  final Value<DateTime?> finalDeliveryDate;
  final Value<PaymentStatus> paymentStatus;
  final Value<double> value;
  final Value<String> driveFolder;
  final Value<String> notes;
  final Value<String?> calendarEventId;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.name = const Value.absent(),
    this.service = const Value.absent(),
    this.shootDate = const Value.absent(),
    this.deadline = const Value.absent(),
    this.status = const Value.absent(),
    this.deliverables = const Value.absent(),
    this.clientReviewDate = const Value.absent(),
    this.finalDeliveryDate = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.value = const Value.absent(),
    this.driveFolder = const Value.absent(),
    this.notes = const Value.absent(),
    this.calendarEventId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String clientId,
    required String name,
    required ServiceType service,
    this.shootDate = const Value.absent(),
    this.deadline = const Value.absent(),
    required ProjectStatus status,
    this.deliverables = const Value.absent(),
    this.clientReviewDate = const Value.absent(),
    this.finalDeliveryDate = const Value.absent(),
    required PaymentStatus paymentStatus,
    this.value = const Value.absent(),
    this.driveFolder = const Value.absent(),
    this.notes = const Value.absent(),
    this.calendarEventId = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       name = Value(name),
       service = Value(service),
       status = Value(status),
       paymentStatus = Value(paymentStatus),
       updatedAt = Value(updatedAt);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? name,
    Expression<String>? service,
    Expression<DateTime>? shootDate,
    Expression<DateTime>? deadline,
    Expression<String>? status,
    Expression<String>? deliverables,
    Expression<DateTime>? clientReviewDate,
    Expression<DateTime>? finalDeliveryDate,
    Expression<String>? paymentStatus,
    Expression<double>? value,
    Expression<String>? driveFolder,
    Expression<String>? notes,
    Expression<String>? calendarEventId,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (name != null) 'name': name,
      if (service != null) 'service': service,
      if (shootDate != null) 'shoot_date': shootDate,
      if (deadline != null) 'deadline': deadline,
      if (status != null) 'status': status,
      if (deliverables != null) 'deliverables': deliverables,
      if (clientReviewDate != null) 'client_review_date': clientReviewDate,
      if (finalDeliveryDate != null) 'final_delivery_date': finalDeliveryDate,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (value != null) 'value': value,
      if (driveFolder != null) 'drive_folder': driveFolder,
      if (notes != null) 'notes': notes,
      if (calendarEventId != null) 'calendar_event_id': calendarEventId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String>? name,
    Value<ServiceType>? service,
    Value<DateTime?>? shootDate,
    Value<DateTime?>? deadline,
    Value<ProjectStatus>? status,
    Value<String>? deliverables,
    Value<DateTime?>? clientReviewDate,
    Value<DateTime?>? finalDeliveryDate,
    Value<PaymentStatus>? paymentStatus,
    Value<double>? value,
    Value<String>? driveFolder,
    Value<String>? notes,
    Value<String?>? calendarEventId,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      name: name ?? this.name,
      service: service ?? this.service,
      shootDate: shootDate ?? this.shootDate,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      deliverables: deliverables ?? this.deliverables,
      clientReviewDate: clientReviewDate ?? this.clientReviewDate,
      finalDeliveryDate: finalDeliveryDate ?? this.finalDeliveryDate,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      value: value ?? this.value,
      driveFolder: driveFolder ?? this.driveFolder,
      notes: notes ?? this.notes,
      calendarEventId: calendarEventId ?? this.calendarEventId,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (service.present) {
      map['service'] = Variable<String>(
        $ProjectsTable.$converterservice.toSql(service.value),
      );
    }
    if (shootDate.present) {
      map['shoot_date'] = Variable<DateTime>(shootDate.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ProjectsTable.$converterstatus.toSql(status.value),
      );
    }
    if (deliverables.present) {
      map['deliverables'] = Variable<String>(deliverables.value);
    }
    if (clientReviewDate.present) {
      map['client_review_date'] = Variable<DateTime>(clientReviewDate.value);
    }
    if (finalDeliveryDate.present) {
      map['final_delivery_date'] = Variable<DateTime>(finalDeliveryDate.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(
        $ProjectsTable.$converterpaymentStatus.toSql(paymentStatus.value),
      );
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (driveFolder.present) {
      map['drive_folder'] = Variable<String>(driveFolder.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (calendarEventId.present) {
      map['calendar_event_id'] = Variable<String>(calendarEventId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('name: $name, ')
          ..write('service: $service, ')
          ..write('shootDate: $shootDate, ')
          ..write('deadline: $deadline, ')
          ..write('status: $status, ')
          ..write('deliverables: $deliverables, ')
          ..write('clientReviewDate: $clientReviewDate, ')
          ..write('finalDeliveryDate: $finalDeliveryDate, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('value: $value, ')
          ..write('driveFolder: $driveFolder, ')
          ..write('notes: $notes, ')
          ..write('calendarEventId: $calendarEventId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FollowUpsTable extends FollowUps
    with TableInfo<$FollowUpsTable, FollowUp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FollowUpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leadIdMeta = const VerificationMeta('leadId');
  @override
  late final GeneratedColumn<String> leadId = GeneratedColumn<String>(
    'lead_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasTimeMeta = const VerificationMeta(
    'hasTime',
  );
  @override
  late final GeneratedColumn<bool> hasTime = GeneratedColumn<bool>(
    'has_time',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_time" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  @override
  late final GeneratedColumnWithTypeConverter<FollowUpType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FollowUpType>($FollowUpsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<FollowUpStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<FollowUpStatus>($FollowUpsTable.$converterstatus);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _calendarEventIdMeta = const VerificationMeta(
    'calendarEventId',
  );
  @override
  late final GeneratedColumn<String> calendarEventId = GeneratedColumn<String>(
    'calendar_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meetLinkMeta = const VerificationMeta(
    'meetLink',
  );
  @override
  late final GeneratedColumn<String> meetLink = GeneratedColumn<String>(
    'meet_link',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notifiedAtMeta = const VerificationMeta(
    'notifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> notifiedAt = GeneratedColumn<DateTime>(
    'notified_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    leadId,
    clientId,
    title,
    dueAt,
    hasTime,
    durationMinutes,
    type,
    status,
    notes,
    outcome,
    calendarEventId,
    meetLink,
    notifiedAt,
    completedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'follow_ups';
  @override
  VerificationContext validateIntegrity(
    Insertable<FollowUp> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lead_id')) {
      context.handle(
        _leadIdMeta,
        leadId.isAcceptableOrUnknown(data['lead_id']!, _leadIdMeta),
      );
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('has_time')) {
      context.handle(
        _hasTimeMeta,
        hasTime.isAcceptableOrUnknown(data['has_time']!, _hasTimeMeta),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    }
    if (data.containsKey('calendar_event_id')) {
      context.handle(
        _calendarEventIdMeta,
        calendarEventId.isAcceptableOrUnknown(
          data['calendar_event_id']!,
          _calendarEventIdMeta,
        ),
      );
    }
    if (data.containsKey('meet_link')) {
      context.handle(
        _meetLinkMeta,
        meetLink.isAcceptableOrUnknown(data['meet_link']!, _meetLinkMeta),
      );
    }
    if (data.containsKey('notified_at')) {
      context.handle(
        _notifiedAtMeta,
        notifiedAt.isAcceptableOrUnknown(data['notified_at']!, _notifiedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FollowUp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FollowUp(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      leadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lead_id'],
      ),
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      )!,
      hasTime: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_time'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      type: $FollowUpsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      status: $FollowUpsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      calendarEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_event_id'],
      ),
      meetLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meet_link'],
      )!,
      notifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}notified_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FollowUpsTable createAlias(String alias) {
    return $FollowUpsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FollowUpType, String, String> $convertertype =
      const EnumNameConverter<FollowUpType>(FollowUpType.values);
  static JsonTypeConverter2<FollowUpStatus, String, String> $converterstatus =
      const EnumNameConverter<FollowUpStatus>(FollowUpStatus.values);
}

class FollowUp extends DataClass implements Insertable<FollowUp> {
  final String id;
  final String? leadId;
  final String? clientId;
  final String title;
  final DateTime dueAt;
  final bool hasTime;
  final int durationMinutes;
  final FollowUpType type;
  final FollowUpStatus status;
  final String notes;
  final String outcome;
  final String? calendarEventId;
  final String meetLink;
  final DateTime? notifiedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  const FollowUp({
    required this.id,
    this.leadId,
    this.clientId,
    required this.title,
    required this.dueAt,
    required this.hasTime,
    required this.durationMinutes,
    required this.type,
    required this.status,
    required this.notes,
    required this.outcome,
    this.calendarEventId,
    required this.meetLink,
    this.notifiedAt,
    this.completedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || leadId != null) {
      map['lead_id'] = Variable<String>(leadId);
    }
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<String>(clientId);
    }
    map['title'] = Variable<String>(title);
    map['due_at'] = Variable<DateTime>(dueAt);
    map['has_time'] = Variable<bool>(hasTime);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    {
      map['type'] = Variable<String>(
        $FollowUpsTable.$convertertype.toSql(type),
      );
    }
    {
      map['status'] = Variable<String>(
        $FollowUpsTable.$converterstatus.toSql(status),
      );
    }
    map['notes'] = Variable<String>(notes);
    map['outcome'] = Variable<String>(outcome);
    if (!nullToAbsent || calendarEventId != null) {
      map['calendar_event_id'] = Variable<String>(calendarEventId);
    }
    map['meet_link'] = Variable<String>(meetLink);
    if (!nullToAbsent || notifiedAt != null) {
      map['notified_at'] = Variable<DateTime>(notifiedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FollowUpsCompanion toCompanion(bool nullToAbsent) {
    return FollowUpsCompanion(
      id: Value(id),
      leadId: leadId == null && nullToAbsent
          ? const Value.absent()
          : Value(leadId),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      title: Value(title),
      dueAt: Value(dueAt),
      hasTime: Value(hasTime),
      durationMinutes: Value(durationMinutes),
      type: Value(type),
      status: Value(status),
      notes: Value(notes),
      outcome: Value(outcome),
      calendarEventId: calendarEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(calendarEventId),
      meetLink: Value(meetLink),
      notifiedAt: notifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(notifiedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
    );
  }

  factory FollowUp.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FollowUp(
      id: serializer.fromJson<String>(json['id']),
      leadId: serializer.fromJson<String?>(json['leadId']),
      clientId: serializer.fromJson<String?>(json['clientId']),
      title: serializer.fromJson<String>(json['title']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      hasTime: serializer.fromJson<bool>(json['hasTime']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      type: $FollowUpsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      status: $FollowUpsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      notes: serializer.fromJson<String>(json['notes']),
      outcome: serializer.fromJson<String>(json['outcome']),
      calendarEventId: serializer.fromJson<String?>(json['calendarEventId']),
      meetLink: serializer.fromJson<String>(json['meetLink']),
      notifiedAt: serializer.fromJson<DateTime?>(json['notifiedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'leadId': serializer.toJson<String?>(leadId),
      'clientId': serializer.toJson<String?>(clientId),
      'title': serializer.toJson<String>(title),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'hasTime': serializer.toJson<bool>(hasTime),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'type': serializer.toJson<String>(
        $FollowUpsTable.$convertertype.toJson(type),
      ),
      'status': serializer.toJson<String>(
        $FollowUpsTable.$converterstatus.toJson(status),
      ),
      'notes': serializer.toJson<String>(notes),
      'outcome': serializer.toJson<String>(outcome),
      'calendarEventId': serializer.toJson<String?>(calendarEventId),
      'meetLink': serializer.toJson<String>(meetLink),
      'notifiedAt': serializer.toJson<DateTime?>(notifiedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FollowUp copyWith({
    String? id,
    Value<String?> leadId = const Value.absent(),
    Value<String?> clientId = const Value.absent(),
    String? title,
    DateTime? dueAt,
    bool? hasTime,
    int? durationMinutes,
    FollowUpType? type,
    FollowUpStatus? status,
    String? notes,
    String? outcome,
    Value<String?> calendarEventId = const Value.absent(),
    String? meetLink,
    Value<DateTime?> notifiedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
  }) => FollowUp(
    id: id ?? this.id,
    leadId: leadId.present ? leadId.value : this.leadId,
    clientId: clientId.present ? clientId.value : this.clientId,
    title: title ?? this.title,
    dueAt: dueAt ?? this.dueAt,
    hasTime: hasTime ?? this.hasTime,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    type: type ?? this.type,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    outcome: outcome ?? this.outcome,
    calendarEventId: calendarEventId.present
        ? calendarEventId.value
        : this.calendarEventId,
    meetLink: meetLink ?? this.meetLink,
    notifiedAt: notifiedAt.present ? notifiedAt.value : this.notifiedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  FollowUp copyWithCompanion(FollowUpsCompanion data) {
    return FollowUp(
      id: data.id.present ? data.id.value : this.id,
      leadId: data.leadId.present ? data.leadId.value : this.leadId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      title: data.title.present ? data.title.value : this.title,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      hasTime: data.hasTime.present ? data.hasTime.value : this.hasTime,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      calendarEventId: data.calendarEventId.present
          ? data.calendarEventId.value
          : this.calendarEventId,
      meetLink: data.meetLink.present ? data.meetLink.value : this.meetLink,
      notifiedAt: data.notifiedAt.present
          ? data.notifiedAt.value
          : this.notifiedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FollowUp(')
          ..write('id: $id, ')
          ..write('leadId: $leadId, ')
          ..write('clientId: $clientId, ')
          ..write('title: $title, ')
          ..write('dueAt: $dueAt, ')
          ..write('hasTime: $hasTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('outcome: $outcome, ')
          ..write('calendarEventId: $calendarEventId, ')
          ..write('meetLink: $meetLink, ')
          ..write('notifiedAt: $notifiedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    leadId,
    clientId,
    title,
    dueAt,
    hasTime,
    durationMinutes,
    type,
    status,
    notes,
    outcome,
    calendarEventId,
    meetLink,
    notifiedAt,
    completedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FollowUp &&
          other.id == this.id &&
          other.leadId == this.leadId &&
          other.clientId == this.clientId &&
          other.title == this.title &&
          other.dueAt == this.dueAt &&
          other.hasTime == this.hasTime &&
          other.durationMinutes == this.durationMinutes &&
          other.type == this.type &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.outcome == this.outcome &&
          other.calendarEventId == this.calendarEventId &&
          other.meetLink == this.meetLink &&
          other.notifiedAt == this.notifiedAt &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt);
}

class FollowUpsCompanion extends UpdateCompanion<FollowUp> {
  final Value<String> id;
  final Value<String?> leadId;
  final Value<String?> clientId;
  final Value<String> title;
  final Value<DateTime> dueAt;
  final Value<bool> hasTime;
  final Value<int> durationMinutes;
  final Value<FollowUpType> type;
  final Value<FollowUpStatus> status;
  final Value<String> notes;
  final Value<String> outcome;
  final Value<String?> calendarEventId;
  final Value<String> meetLink;
  final Value<DateTime?> notifiedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FollowUpsCompanion({
    this.id = const Value.absent(),
    this.leadId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.title = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.hasTime = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.outcome = const Value.absent(),
    this.calendarEventId = const Value.absent(),
    this.meetLink = const Value.absent(),
    this.notifiedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FollowUpsCompanion.insert({
    required String id,
    this.leadId = const Value.absent(),
    this.clientId = const Value.absent(),
    required String title,
    required DateTime dueAt,
    this.hasTime = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    required FollowUpType type,
    required FollowUpStatus status,
    this.notes = const Value.absent(),
    this.outcome = const Value.absent(),
    this.calendarEventId = const Value.absent(),
    this.meetLink = const Value.absent(),
    this.notifiedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       dueAt = Value(dueAt),
       type = Value(type),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<FollowUp> custom({
    Expression<String>? id,
    Expression<String>? leadId,
    Expression<String>? clientId,
    Expression<String>? title,
    Expression<DateTime>? dueAt,
    Expression<bool>? hasTime,
    Expression<int>? durationMinutes,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<String>? outcome,
    Expression<String>? calendarEventId,
    Expression<String>? meetLink,
    Expression<DateTime>? notifiedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (leadId != null) 'lead_id': leadId,
      if (clientId != null) 'client_id': clientId,
      if (title != null) 'title': title,
      if (dueAt != null) 'due_at': dueAt,
      if (hasTime != null) 'has_time': hasTime,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (outcome != null) 'outcome': outcome,
      if (calendarEventId != null) 'calendar_event_id': calendarEventId,
      if (meetLink != null) 'meet_link': meetLink,
      if (notifiedAt != null) 'notified_at': notifiedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FollowUpsCompanion copyWith({
    Value<String>? id,
    Value<String?>? leadId,
    Value<String?>? clientId,
    Value<String>? title,
    Value<DateTime>? dueAt,
    Value<bool>? hasTime,
    Value<int>? durationMinutes,
    Value<FollowUpType>? type,
    Value<FollowUpStatus>? status,
    Value<String>? notes,
    Value<String>? outcome,
    Value<String?>? calendarEventId,
    Value<String>? meetLink,
    Value<DateTime?>? notifiedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return FollowUpsCompanion(
      id: id ?? this.id,
      leadId: leadId ?? this.leadId,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      hasTime: hasTime ?? this.hasTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      outcome: outcome ?? this.outcome,
      calendarEventId: calendarEventId ?? this.calendarEventId,
      meetLink: meetLink ?? this.meetLink,
      notifiedAt: notifiedAt ?? this.notifiedAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (leadId.present) {
      map['lead_id'] = Variable<String>(leadId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (hasTime.present) {
      map['has_time'] = Variable<bool>(hasTime.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $FollowUpsTable.$convertertype.toSql(type.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $FollowUpsTable.$converterstatus.toSql(status.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (calendarEventId.present) {
      map['calendar_event_id'] = Variable<String>(calendarEventId.value);
    }
    if (meetLink.present) {
      map['meet_link'] = Variable<String>(meetLink.value);
    }
    if (notifiedAt.present) {
      map['notified_at'] = Variable<DateTime>(notifiedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FollowUpsCompanion(')
          ..write('id: $id, ')
          ..write('leadId: $leadId, ')
          ..write('clientId: $clientId, ')
          ..write('title: $title, ')
          ..write('dueAt: $dueAt, ')
          ..write('hasTime: $hasTime, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('outcome: $outcome, ')
          ..write('calendarEventId: $calendarEventId, ')
          ..write('meetLink: $meetLink, ')
          ..write('notifiedAt: $notifiedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<String> clientId = GeneratedColumn<String>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _invoiceDateMeta = const VerificationMeta(
    'invoiceDate',
  );
  @override
  late final GeneratedColumn<DateTime> invoiceDate = GeneratedColumn<DateTime>(
    'invoice_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountReceivedMeta = const VerificationMeta(
    'amountReceived',
  );
  @override
  late final GeneratedColumn<double> amountReceived = GeneratedColumn<double>(
    'amount_received',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InvoiceStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InvoiceStatus>($InvoicesTable.$converterstatus);
  static const VerificationMeta _paymentDateMeta = const VerificationMeta(
    'paymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> paymentDate = GeneratedColumn<DateTime>(
    'payment_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _notifiedAtMeta = const VerificationMeta(
    'notifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> notifiedAt = GeneratedColumn<DateTime>(
    'notified_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    projectId,
    invoiceDate,
    amount,
    amountReceived,
    dueDate,
    status,
    paymentDate,
    description,
    notes,
    notifiedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Invoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('invoice_date')) {
      context.handle(
        _invoiceDateMeta,
        invoiceDate.isAcceptableOrUnknown(
          data['invoice_date']!,
          _invoiceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceDateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('amount_received')) {
      context.handle(
        _amountReceivedMeta,
        amountReceived.isAcceptableOrUnknown(
          data['amount_received']!,
          _amountReceivedMeta,
        ),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('payment_date')) {
      context.handle(
        _paymentDateMeta,
        paymentDate.isAcceptableOrUnknown(
          data['payment_date']!,
          _paymentDateMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('notified_at')) {
      context.handle(
        _notifiedAtMeta,
        notifiedAt.isAcceptableOrUnknown(data['notified_at']!, _notifiedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      ),
      invoiceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}invoice_date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      amountReceived: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_received'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      status: $InvoicesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      paymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}payment_date'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      notifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}notified_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InvoiceStatus, String, String> $converterstatus =
      const EnumNameConverter<InvoiceStatus>(InvoiceStatus.values);
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final String id;
  final String clientId;
  final String? projectId;
  final DateTime invoiceDate;
  final double amount;
  final double amountReceived;
  final DateTime dueDate;
  final InvoiceStatus status;
  final DateTime? paymentDate;
  final String description;
  final String notes;
  final DateTime? notifiedAt;
  final DateTime updatedAt;
  const Invoice({
    required this.id,
    required this.clientId,
    this.projectId,
    required this.invoiceDate,
    required this.amount,
    required this.amountReceived,
    required this.dueDate,
    required this.status,
    this.paymentDate,
    required this.description,
    required this.notes,
    this.notifiedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_id'] = Variable<String>(clientId);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['invoice_date'] = Variable<DateTime>(invoiceDate);
    map['amount'] = Variable<double>(amount);
    map['amount_received'] = Variable<double>(amountReceived);
    map['due_date'] = Variable<DateTime>(dueDate);
    {
      map['status'] = Variable<String>(
        $InvoicesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || paymentDate != null) {
      map['payment_date'] = Variable<DateTime>(paymentDate);
    }
    map['description'] = Variable<String>(description);
    map['notes'] = Variable<String>(notes);
    if (!nullToAbsent || notifiedAt != null) {
      map['notified_at'] = Variable<DateTime>(notifiedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      clientId: Value(clientId),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      invoiceDate: Value(invoiceDate),
      amount: Value(amount),
      amountReceived: Value(amountReceived),
      dueDate: Value(dueDate),
      status: Value(status),
      paymentDate: paymentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDate),
      description: Value(description),
      notes: Value(notes),
      notifiedAt: notifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(notifiedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Invoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<String>(json['id']),
      clientId: serializer.fromJson<String>(json['clientId']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      invoiceDate: serializer.fromJson<DateTime>(json['invoiceDate']),
      amount: serializer.fromJson<double>(json['amount']),
      amountReceived: serializer.fromJson<double>(json['amountReceived']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      status: $InvoicesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      paymentDate: serializer.fromJson<DateTime?>(json['paymentDate']),
      description: serializer.fromJson<String>(json['description']),
      notes: serializer.fromJson<String>(json['notes']),
      notifiedAt: serializer.fromJson<DateTime?>(json['notifiedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientId': serializer.toJson<String>(clientId),
      'projectId': serializer.toJson<String?>(projectId),
      'invoiceDate': serializer.toJson<DateTime>(invoiceDate),
      'amount': serializer.toJson<double>(amount),
      'amountReceived': serializer.toJson<double>(amountReceived),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'status': serializer.toJson<String>(
        $InvoicesTable.$converterstatus.toJson(status),
      ),
      'paymentDate': serializer.toJson<DateTime?>(paymentDate),
      'description': serializer.toJson<String>(description),
      'notes': serializer.toJson<String>(notes),
      'notifiedAt': serializer.toJson<DateTime?>(notifiedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Invoice copyWith({
    String? id,
    String? clientId,
    Value<String?> projectId = const Value.absent(),
    DateTime? invoiceDate,
    double? amount,
    double? amountReceived,
    DateTime? dueDate,
    InvoiceStatus? status,
    Value<DateTime?> paymentDate = const Value.absent(),
    String? description,
    String? notes,
    Value<DateTime?> notifiedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => Invoice(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    projectId: projectId.present ? projectId.value : this.projectId,
    invoiceDate: invoiceDate ?? this.invoiceDate,
    amount: amount ?? this.amount,
    amountReceived: amountReceived ?? this.amountReceived,
    dueDate: dueDate ?? this.dueDate,
    status: status ?? this.status,
    paymentDate: paymentDate.present ? paymentDate.value : this.paymentDate,
    description: description ?? this.description,
    notes: notes ?? this.notes,
    notifiedAt: notifiedAt.present ? notifiedAt.value : this.notifiedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      invoiceDate: data.invoiceDate.present
          ? data.invoiceDate.value
          : this.invoiceDate,
      amount: data.amount.present ? data.amount.value : this.amount,
      amountReceived: data.amountReceived.present
          ? data.amountReceived.value
          : this.amountReceived,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      status: data.status.present ? data.status.value : this.status,
      paymentDate: data.paymentDate.present
          ? data.paymentDate.value
          : this.paymentDate,
      description: data.description.present
          ? data.description.value
          : this.description,
      notes: data.notes.present ? data.notes.value : this.notes,
      notifiedAt: data.notifiedAt.present
          ? data.notifiedAt.value
          : this.notifiedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('projectId: $projectId, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('amount: $amount, ')
          ..write('amountReceived: $amountReceived, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('notifiedAt: $notifiedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    projectId,
    invoiceDate,
    amount,
    amountReceived,
    dueDate,
    status,
    paymentDate,
    description,
    notes,
    notifiedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.projectId == this.projectId &&
          other.invoiceDate == this.invoiceDate &&
          other.amount == this.amount &&
          other.amountReceived == this.amountReceived &&
          other.dueDate == this.dueDate &&
          other.status == this.status &&
          other.paymentDate == this.paymentDate &&
          other.description == this.description &&
          other.notes == this.notes &&
          other.notifiedAt == this.notifiedAt &&
          other.updatedAt == this.updatedAt);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<String> id;
  final Value<String> clientId;
  final Value<String?> projectId;
  final Value<DateTime> invoiceDate;
  final Value<double> amount;
  final Value<double> amountReceived;
  final Value<DateTime> dueDate;
  final Value<InvoiceStatus> status;
  final Value<DateTime?> paymentDate;
  final Value<String> description;
  final Value<String> notes;
  final Value<DateTime?> notifiedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.invoiceDate = const Value.absent(),
    this.amount = const Value.absent(),
    this.amountReceived = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.status = const Value.absent(),
    this.paymentDate = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    this.notifiedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoicesCompanion.insert({
    required String id,
    required String clientId,
    this.projectId = const Value.absent(),
    required DateTime invoiceDate,
    required double amount,
    this.amountReceived = const Value.absent(),
    required DateTime dueDate,
    required InvoiceStatus status,
    this.paymentDate = const Value.absent(),
    this.description = const Value.absent(),
    this.notes = const Value.absent(),
    this.notifiedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       clientId = Value(clientId),
       invoiceDate = Value(invoiceDate),
       amount = Value(amount),
       dueDate = Value(dueDate),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<Invoice> custom({
    Expression<String>? id,
    Expression<String>? clientId,
    Expression<String>? projectId,
    Expression<DateTime>? invoiceDate,
    Expression<double>? amount,
    Expression<double>? amountReceived,
    Expression<DateTime>? dueDate,
    Expression<String>? status,
    Expression<DateTime>? paymentDate,
    Expression<String>? description,
    Expression<String>? notes,
    Expression<DateTime>? notifiedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (projectId != null) 'project_id': projectId,
      if (invoiceDate != null) 'invoice_date': invoiceDate,
      if (amount != null) 'amount': amount,
      if (amountReceived != null) 'amount_received': amountReceived,
      if (dueDate != null) 'due_date': dueDate,
      if (status != null) 'status': status,
      if (paymentDate != null) 'payment_date': paymentDate,
      if (description != null) 'description': description,
      if (notes != null) 'notes': notes,
      if (notifiedAt != null) 'notified_at': notifiedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoicesCompanion copyWith({
    Value<String>? id,
    Value<String>? clientId,
    Value<String?>? projectId,
    Value<DateTime>? invoiceDate,
    Value<double>? amount,
    Value<double>? amountReceived,
    Value<DateTime>? dueDate,
    Value<InvoiceStatus>? status,
    Value<DateTime?>? paymentDate,
    Value<String>? description,
    Value<String>? notes,
    Value<DateTime?>? notifiedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      projectId: projectId ?? this.projectId,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      amount: amount ?? this.amount,
      amountReceived: amountReceived ?? this.amountReceived,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      paymentDate: paymentDate ?? this.paymentDate,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      notifiedAt: notifiedAt ?? this.notifiedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<String>(clientId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (invoiceDate.present) {
      map['invoice_date'] = Variable<DateTime>(invoiceDate.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (amountReceived.present) {
      map['amount_received'] = Variable<double>(amountReceived.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $InvoicesTable.$converterstatus.toSql(status.value),
      );
    }
    if (paymentDate.present) {
      map['payment_date'] = Variable<DateTime>(paymentDate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (notifiedAt.present) {
      map['notified_at'] = Variable<DateTime>(notifiedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('projectId: $projectId, ')
          ..write('invoiceDate: $invoiceDate, ')
          ..write('amount: $amount, ')
          ..write('amountReceived: $amountReceived, ')
          ..write('dueDate: $dueDate, ')
          ..write('status: $status, ')
          ..write('paymentDate: $paymentDate, ')
          ..write('description: $description, ')
          ..write('notes: $notes, ')
          ..write('notifiedAt: $notifiedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<EntityType, String> entityType =
      GeneratedColumn<String>(
        'entity_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EntityType>($ActivitiesTable.$converterentityType);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ActivityKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ActivityKind>($ActivitiesTable.$converterkind);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailMeta = const VerificationMeta('detail');
  @override
  late final GeneratedColumn<String> detail = GeneratedColumn<String>(
    'detail',
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
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    kind,
    title,
    detail,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Activity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('detail')) {
      context.handle(
        _detailMeta,
        detail.isAcceptableOrUnknown(data['detail']!, _detailMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: $ActivitiesTable.$converterentityType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entity_type'],
        )!,
      ),
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      kind: $ActivitiesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      detail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EntityType, String, String> $converterentityType =
      const EnumNameConverter<EntityType>(EntityType.values);
  static JsonTypeConverter2<ActivityKind, String, String> $converterkind =
      const EnumNameConverter<ActivityKind>(ActivityKind.values);
}

class Activity extends DataClass implements Insertable<Activity> {
  final int id;
  final EntityType entityType;
  final String entityId;
  final ActivityKind kind;
  final String title;
  final String detail;
  final DateTime createdAt;
  const Activity({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.kind,
    required this.title,
    required this.detail,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['entity_type'] = Variable<String>(
        $ActivitiesTable.$converterentityType.toSql(entityType),
      );
    }
    map['entity_id'] = Variable<String>(entityId);
    {
      map['kind'] = Variable<String>(
        $ActivitiesTable.$converterkind.toSql(kind),
      );
    }
    map['title'] = Variable<String>(title);
    map['detail'] = Variable<String>(detail);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      kind: Value(kind),
      title: Value(title),
      detail: Value(detail),
      createdAt: Value(createdAt),
    );
  }

  factory Activity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      id: serializer.fromJson<int>(json['id']),
      entityType: $ActivitiesTable.$converterentityType.fromJson(
        serializer.fromJson<String>(json['entityType']),
      ),
      entityId: serializer.fromJson<String>(json['entityId']),
      kind: $ActivitiesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      title: serializer.fromJson<String>(json['title']),
      detail: serializer.fromJson<String>(json['detail']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(
        $ActivitiesTable.$converterentityType.toJson(entityType),
      ),
      'entityId': serializer.toJson<String>(entityId),
      'kind': serializer.toJson<String>(
        $ActivitiesTable.$converterkind.toJson(kind),
      ),
      'title': serializer.toJson<String>(title),
      'detail': serializer.toJson<String>(detail),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Activity copyWith({
    int? id,
    EntityType? entityType,
    String? entityId,
    ActivityKind? kind,
    String? title,
    String? detail,
    DateTime? createdAt,
  }) => Activity(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    detail: detail ?? this.detail,
    createdAt: createdAt ?? this.createdAt,
  );
  Activity copyWithCompanion(ActivitiesCompanion data) {
    return Activity(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      detail: data.detail.present ? data.detail.value : this.detail,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('detail: $detail, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityType, entityId, kind, title, detail, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.detail == this.detail &&
          other.createdAt == this.createdAt);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<int> id;
  final Value<EntityType> entityType;
  final Value<String> entityId;
  final Value<ActivityKind> kind;
  final Value<String> title;
  final Value<String> detail;
  final Value<DateTime> createdAt;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.detail = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    this.id = const Value.absent(),
    required EntityType entityType,
    required String entityId,
    required ActivityKind kind,
    required String title,
    this.detail = const Value.absent(),
    required DateTime createdAt,
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       kind = Value(kind),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<Activity> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? detail,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (detail != null) 'detail': detail,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ActivitiesCompanion copyWith({
    Value<int>? id,
    Value<EntityType>? entityType,
    Value<String>? entityId,
    Value<ActivityKind>? kind,
    Value<String>? title,
    Value<String>? detail,
    Value<DateTime>? createdAt,
  }) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(
        $ActivitiesTable.$converterentityType.toSql(entityType.value),
      );
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $ActivitiesTable.$converterkind.toSql(kind.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (detail.present) {
      map['detail'] = Variable<String>(detail.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('detail: $detail, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EmailTemplatesTable extends EmailTemplates
    with TableInfo<$EmailTemplatesTable, EmailTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  late final GeneratedColumnWithTypeConverter<LeadStatus?, String>
  triggerStatus = GeneratedColumn<String>(
    'trigger_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<LeadStatus?>($EmailTemplatesTable.$convertertriggerStatusn);
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('lead'),
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _autoSendMeta = const VerificationMeta(
    'autoSend',
  );
  @override
  late final GeneratedColumn<bool> autoSend = GeneratedColumn<bool>(
    'auto_send',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_send" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isBuiltInMeta = const VerificationMeta(
    'isBuiltIn',
  );
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
    'is_built_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_built_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    triggerStatus,
    category,
    subject,
    body,
    autoSend,
    isBuiltIn,
    sortOrder,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'email_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmailTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('auto_send')) {
      context.handle(
        _autoSendMeta,
        autoSend.isAcceptableOrUnknown(data['auto_send']!, _autoSendMeta),
      );
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
        _isBuiltInMeta,
        isBuiltIn.isAcceptableOrUnknown(data['is_built_in']!, _isBuiltInMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmailTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmailTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      triggerStatus: $EmailTemplatesTable.$convertertriggerStatusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}trigger_status'],
        ),
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      autoSend: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_send'],
      )!,
      isBuiltIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_built_in'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $EmailTemplatesTable createAlias(String alias) {
    return $EmailTemplatesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LeadStatus, String, String>
  $convertertriggerStatus = const EnumNameConverter<LeadStatus>(
    LeadStatus.values,
  );
  static JsonTypeConverter2<LeadStatus?, String?, String?>
  $convertertriggerStatusn = JsonTypeConverter2.asNullable(
    $convertertriggerStatus,
  );
}

class EmailTemplate extends DataClass implements Insertable<EmailTemplate> {
  final String id;
  final String name;

  /// Lead status that suggests this template (null = manual only).
  final LeadStatus? triggerStatus;

  /// Free-form category: lead, client, invoice, project.
  final String category;
  final String subject;
  final String body;
  final bool autoSend;
  final bool isBuiltIn;
  final int sortOrder;
  final DateTime updatedAt;
  const EmailTemplate({
    required this.id,
    required this.name,
    this.triggerStatus,
    required this.category,
    required this.subject,
    required this.body,
    required this.autoSend,
    required this.isBuiltIn,
    required this.sortOrder,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || triggerStatus != null) {
      map['trigger_status'] = Variable<String>(
        $EmailTemplatesTable.$convertertriggerStatusn.toSql(triggerStatus),
      );
    }
    map['category'] = Variable<String>(category);
    map['subject'] = Variable<String>(subject);
    map['body'] = Variable<String>(body);
    map['auto_send'] = Variable<bool>(autoSend);
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['sort_order'] = Variable<int>(sortOrder);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EmailTemplatesCompanion toCompanion(bool nullToAbsent) {
    return EmailTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      triggerStatus: triggerStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerStatus),
      category: Value(category),
      subject: Value(subject),
      body: Value(body),
      autoSend: Value(autoSend),
      isBuiltIn: Value(isBuiltIn),
      sortOrder: Value(sortOrder),
      updatedAt: Value(updatedAt),
    );
  }

  factory EmailTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmailTemplate(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      triggerStatus: $EmailTemplatesTable.$convertertriggerStatusn.fromJson(
        serializer.fromJson<String?>(json['triggerStatus']),
      ),
      category: serializer.fromJson<String>(json['category']),
      subject: serializer.fromJson<String>(json['subject']),
      body: serializer.fromJson<String>(json['body']),
      autoSend: serializer.fromJson<bool>(json['autoSend']),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'triggerStatus': serializer.toJson<String?>(
        $EmailTemplatesTable.$convertertriggerStatusn.toJson(triggerStatus),
      ),
      'category': serializer.toJson<String>(category),
      'subject': serializer.toJson<String>(subject),
      'body': serializer.toJson<String>(body),
      'autoSend': serializer.toJson<bool>(autoSend),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EmailTemplate copyWith({
    String? id,
    String? name,
    Value<LeadStatus?> triggerStatus = const Value.absent(),
    String? category,
    String? subject,
    String? body,
    bool? autoSend,
    bool? isBuiltIn,
    int? sortOrder,
    DateTime? updatedAt,
  }) => EmailTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    triggerStatus: triggerStatus.present
        ? triggerStatus.value
        : this.triggerStatus,
    category: category ?? this.category,
    subject: subject ?? this.subject,
    body: body ?? this.body,
    autoSend: autoSend ?? this.autoSend,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    sortOrder: sortOrder ?? this.sortOrder,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  EmailTemplate copyWithCompanion(EmailTemplatesCompanion data) {
    return EmailTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      triggerStatus: data.triggerStatus.present
          ? data.triggerStatus.value
          : this.triggerStatus,
      category: data.category.present ? data.category.value : this.category,
      subject: data.subject.present ? data.subject.value : this.subject,
      body: data.body.present ? data.body.value : this.body,
      autoSend: data.autoSend.present ? data.autoSend.value : this.autoSend,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmailTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('triggerStatus: $triggerStatus, ')
          ..write('category: $category, ')
          ..write('subject: $subject, ')
          ..write('body: $body, ')
          ..write('autoSend: $autoSend, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    triggerStatus,
    category,
    subject,
    body,
    autoSend,
    isBuiltIn,
    sortOrder,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmailTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.triggerStatus == this.triggerStatus &&
          other.category == this.category &&
          other.subject == this.subject &&
          other.body == this.body &&
          other.autoSend == this.autoSend &&
          other.isBuiltIn == this.isBuiltIn &&
          other.sortOrder == this.sortOrder &&
          other.updatedAt == this.updatedAt);
}

class EmailTemplatesCompanion extends UpdateCompanion<EmailTemplate> {
  final Value<String> id;
  final Value<String> name;
  final Value<LeadStatus?> triggerStatus;
  final Value<String> category;
  final Value<String> subject;
  final Value<String> body;
  final Value<bool> autoSend;
  final Value<bool> isBuiltIn;
  final Value<int> sortOrder;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EmailTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.triggerStatus = const Value.absent(),
    this.category = const Value.absent(),
    this.subject = const Value.absent(),
    this.body = const Value.absent(),
    this.autoSend = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmailTemplatesCompanion.insert({
    required String id,
    required String name,
    this.triggerStatus = const Value.absent(),
    this.category = const Value.absent(),
    required String subject,
    required String body,
    this.autoSend = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       subject = Value(subject),
       body = Value(body),
       updatedAt = Value(updatedAt);
  static Insertable<EmailTemplate> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? triggerStatus,
    Expression<String>? category,
    Expression<String>? subject,
    Expression<String>? body,
    Expression<bool>? autoSend,
    Expression<bool>? isBuiltIn,
    Expression<int>? sortOrder,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (triggerStatus != null) 'trigger_status': triggerStatus,
      if (category != null) 'category': category,
      if (subject != null) 'subject': subject,
      if (body != null) 'body': body,
      if (autoSend != null) 'auto_send': autoSend,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmailTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<LeadStatus?>? triggerStatus,
    Value<String>? category,
    Value<String>? subject,
    Value<String>? body,
    Value<bool>? autoSend,
    Value<bool>? isBuiltIn,
    Value<int>? sortOrder,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return EmailTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      triggerStatus: triggerStatus ?? this.triggerStatus,
      category: category ?? this.category,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      autoSend: autoSend ?? this.autoSend,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      sortOrder: sortOrder ?? this.sortOrder,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (triggerStatus.present) {
      map['trigger_status'] = Variable<String>(
        $EmailTemplatesTable.$convertertriggerStatusn.toSql(
          triggerStatus.value,
        ),
      );
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (autoSend.present) {
      map['auto_send'] = Variable<bool>(autoSend.value);
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('triggerStatus: $triggerStatus, ')
          ..write('category: $category, ')
          ..write('subject: $subject, ')
          ..write('body: $body, ')
          ..write('autoSend: $autoSend, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmailLogsTable extends EmailLogs
    with TableInfo<$EmailLogsTable, EmailLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<EntityType, String> entityType =
      GeneratedColumn<String>(
        'entity_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EntityType>($EmailLogsTable.$converterentityType);
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toAddressMeta = const VerificationMeta(
    'toAddress',
  );
  @override
  late final GeneratedColumn<String> toAddress = GeneratedColumn<String>(
    'to_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gmailMessageIdMeta = const VerificationMeta(
    'gmailMessageId',
  );
  @override
  late final GeneratedColumn<String> gmailMessageId = GeneratedColumn<String>(
    'gmail_message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    toAddress,
    subject,
    body,
    templateId,
    gmailMessageId,
    error,
    sentAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'email_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmailLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('to_address')) {
      context.handle(
        _toAddressMeta,
        toAddress.isAcceptableOrUnknown(data['to_address']!, _toAddressMeta),
      );
    } else if (isInserting) {
      context.missing(_toAddressMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('gmail_message_id')) {
      context.handle(
        _gmailMessageIdMeta,
        gmailMessageId.isAcceptableOrUnknown(
          data['gmail_message_id']!,
          _gmailMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sentAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmailLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmailLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: $EmailLogsTable.$converterentityType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entity_type'],
        )!,
      ),
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      toAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_address'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      ),
      gmailMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gmail_message_id'],
      ),
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      )!,
    );
  }

  @override
  $EmailLogsTable createAlias(String alias) {
    return $EmailLogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EntityType, String, String> $converterentityType =
      const EnumNameConverter<EntityType>(EntityType.values);
}

class EmailLog extends DataClass implements Insertable<EmailLog> {
  final int id;
  final EntityType entityType;
  final String entityId;
  final String toAddress;
  final String subject;
  final String body;
  final String? templateId;
  final String? gmailMessageId;
  final String? error;
  final DateTime sentAt;
  const EmailLog({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.toAddress,
    required this.subject,
    required this.body,
    this.templateId,
    this.gmailMessageId,
    this.error,
    required this.sentAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['entity_type'] = Variable<String>(
        $EmailLogsTable.$converterentityType.toSql(entityType),
      );
    }
    map['entity_id'] = Variable<String>(entityId);
    map['to_address'] = Variable<String>(toAddress);
    map['subject'] = Variable<String>(subject);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    if (!nullToAbsent || gmailMessageId != null) {
      map['gmail_message_id'] = Variable<String>(gmailMessageId);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    map['sent_at'] = Variable<DateTime>(sentAt);
    return map;
  }

  EmailLogsCompanion toCompanion(bool nullToAbsent) {
    return EmailLogsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      toAddress: Value(toAddress),
      subject: Value(subject),
      body: Value(body),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      gmailMessageId: gmailMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(gmailMessageId),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
      sentAt: Value(sentAt),
    );
  }

  factory EmailLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmailLog(
      id: serializer.fromJson<int>(json['id']),
      entityType: $EmailLogsTable.$converterentityType.fromJson(
        serializer.fromJson<String>(json['entityType']),
      ),
      entityId: serializer.fromJson<String>(json['entityId']),
      toAddress: serializer.fromJson<String>(json['toAddress']),
      subject: serializer.fromJson<String>(json['subject']),
      body: serializer.fromJson<String>(json['body']),
      templateId: serializer.fromJson<String?>(json['templateId']),
      gmailMessageId: serializer.fromJson<String?>(json['gmailMessageId']),
      error: serializer.fromJson<String?>(json['error']),
      sentAt: serializer.fromJson<DateTime>(json['sentAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(
        $EmailLogsTable.$converterentityType.toJson(entityType),
      ),
      'entityId': serializer.toJson<String>(entityId),
      'toAddress': serializer.toJson<String>(toAddress),
      'subject': serializer.toJson<String>(subject),
      'body': serializer.toJson<String>(body),
      'templateId': serializer.toJson<String?>(templateId),
      'gmailMessageId': serializer.toJson<String?>(gmailMessageId),
      'error': serializer.toJson<String?>(error),
      'sentAt': serializer.toJson<DateTime>(sentAt),
    };
  }

  EmailLog copyWith({
    int? id,
    EntityType? entityType,
    String? entityId,
    String? toAddress,
    String? subject,
    String? body,
    Value<String?> templateId = const Value.absent(),
    Value<String?> gmailMessageId = const Value.absent(),
    Value<String?> error = const Value.absent(),
    DateTime? sentAt,
  }) => EmailLog(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    toAddress: toAddress ?? this.toAddress,
    subject: subject ?? this.subject,
    body: body ?? this.body,
    templateId: templateId.present ? templateId.value : this.templateId,
    gmailMessageId: gmailMessageId.present
        ? gmailMessageId.value
        : this.gmailMessageId,
    error: error.present ? error.value : this.error,
    sentAt: sentAt ?? this.sentAt,
  );
  EmailLog copyWithCompanion(EmailLogsCompanion data) {
    return EmailLog(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      toAddress: data.toAddress.present ? data.toAddress.value : this.toAddress,
      subject: data.subject.present ? data.subject.value : this.subject,
      body: data.body.present ? data.body.value : this.body,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      gmailMessageId: data.gmailMessageId.present
          ? data.gmailMessageId.value
          : this.gmailMessageId,
      error: data.error.present ? data.error.value : this.error,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmailLog(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('toAddress: $toAddress, ')
          ..write('subject: $subject, ')
          ..write('body: $body, ')
          ..write('templateId: $templateId, ')
          ..write('gmailMessageId: $gmailMessageId, ')
          ..write('error: $error, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    toAddress,
    subject,
    body,
    templateId,
    gmailMessageId,
    error,
    sentAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmailLog &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.toAddress == this.toAddress &&
          other.subject == this.subject &&
          other.body == this.body &&
          other.templateId == this.templateId &&
          other.gmailMessageId == this.gmailMessageId &&
          other.error == this.error &&
          other.sentAt == this.sentAt);
}

class EmailLogsCompanion extends UpdateCompanion<EmailLog> {
  final Value<int> id;
  final Value<EntityType> entityType;
  final Value<String> entityId;
  final Value<String> toAddress;
  final Value<String> subject;
  final Value<String> body;
  final Value<String?> templateId;
  final Value<String?> gmailMessageId;
  final Value<String?> error;
  final Value<DateTime> sentAt;
  const EmailLogsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.toAddress = const Value.absent(),
    this.subject = const Value.absent(),
    this.body = const Value.absent(),
    this.templateId = const Value.absent(),
    this.gmailMessageId = const Value.absent(),
    this.error = const Value.absent(),
    this.sentAt = const Value.absent(),
  });
  EmailLogsCompanion.insert({
    this.id = const Value.absent(),
    required EntityType entityType,
    required String entityId,
    required String toAddress,
    required String subject,
    required String body,
    this.templateId = const Value.absent(),
    this.gmailMessageId = const Value.absent(),
    this.error = const Value.absent(),
    required DateTime sentAt,
  }) : entityType = Value(entityType),
       entityId = Value(entityId),
       toAddress = Value(toAddress),
       subject = Value(subject),
       body = Value(body),
       sentAt = Value(sentAt);
  static Insertable<EmailLog> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? toAddress,
    Expression<String>? subject,
    Expression<String>? body,
    Expression<String>? templateId,
    Expression<String>? gmailMessageId,
    Expression<String>? error,
    Expression<DateTime>? sentAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (toAddress != null) 'to_address': toAddress,
      if (subject != null) 'subject': subject,
      if (body != null) 'body': body,
      if (templateId != null) 'template_id': templateId,
      if (gmailMessageId != null) 'gmail_message_id': gmailMessageId,
      if (error != null) 'error': error,
      if (sentAt != null) 'sent_at': sentAt,
    });
  }

  EmailLogsCompanion copyWith({
    Value<int>? id,
    Value<EntityType>? entityType,
    Value<String>? entityId,
    Value<String>? toAddress,
    Value<String>? subject,
    Value<String>? body,
    Value<String?>? templateId,
    Value<String?>? gmailMessageId,
    Value<String?>? error,
    Value<DateTime>? sentAt,
  }) {
    return EmailLogsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      toAddress: toAddress ?? this.toAddress,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      templateId: templateId ?? this.templateId,
      gmailMessageId: gmailMessageId ?? this.gmailMessageId,
      error: error ?? this.error,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(
        $EmailLogsTable.$converterentityType.toSql(entityType.value),
      );
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (toAddress.present) {
      map['to_address'] = Variable<String>(toAddress.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (gmailMessageId.present) {
      map['gmail_message_id'] = Variable<String>(gmailMessageId.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailLogsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('toAddress: $toAddress, ')
          ..write('subject: $subject, ')
          ..write('body: $body, ')
          ..write('templateId: $templateId, ')
          ..write('gmailMessageId: $gmailMessageId, ')
          ..write('error: $error, ')
          ..write('sentAt: $sentAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppNotificationsTable extends AppNotifications
    with TableInfo<$AppNotificationsTable, AppNotification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppNotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<NotificationKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<NotificationKind>($AppNotificationsTable.$converterkind);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<EntityType?, String> entityType =
      GeneratedColumn<String>(
        'entity_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<EntityType?>(
        $AppNotificationsTable.$converterentityTypen,
      );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    title,
    body,
    entityType,
    entityId,
    createdAt,
    readAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_notifications';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppNotification> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppNotification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppNotification(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $AppNotificationsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      entityType: $AppNotificationsTable.$converterentityTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}entity_type'],
        ),
      ),
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
    );
  }

  @override
  $AppNotificationsTable createAlias(String alias) {
    return $AppNotificationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NotificationKind, String, String> $converterkind =
      const EnumNameConverter<NotificationKind>(NotificationKind.values);
  static JsonTypeConverter2<EntityType, String, String> $converterentityType =
      const EnumNameConverter<EntityType>(EntityType.values);
  static JsonTypeConverter2<EntityType?, String?, String?>
  $converterentityTypen = JsonTypeConverter2.asNullable($converterentityType);
}

class AppNotification extends DataClass implements Insertable<AppNotification> {
  final int id;
  final NotificationKind kind;
  final String title;
  final String body;
  final EntityType? entityType;
  final String? entityId;
  final DateTime createdAt;
  final DateTime? readAt;
  const AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    this.entityType,
    this.entityId,
    required this.createdAt,
    this.readAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<String>(
        $AppNotificationsTable.$converterkind.toSql(kind),
      );
    }
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || entityType != null) {
      map['entity_type'] = Variable<String>(
        $AppNotificationsTable.$converterentityTypen.toSql(entityType),
      );
    }
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    return map;
  }

  AppNotificationsCompanion toCompanion(bool nullToAbsent) {
    return AppNotificationsCompanion(
      id: Value(id),
      kind: Value(kind),
      title: Value(title),
      body: Value(body),
      entityType: entityType == null && nullToAbsent
          ? const Value.absent()
          : Value(entityType),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      createdAt: Value(createdAt),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
    );
  }

  factory AppNotification.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppNotification(
      id: serializer.fromJson<int>(json['id']),
      kind: $AppNotificationsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      entityType: $AppNotificationsTable.$converterentityTypen.fromJson(
        serializer.fromJson<String?>(json['entityType']),
      ),
      entityId: serializer.fromJson<String?>(json['entityId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(
        $AppNotificationsTable.$converterkind.toJson(kind),
      ),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'entityType': serializer.toJson<String?>(
        $AppNotificationsTable.$converterentityTypen.toJson(entityType),
      ),
      'entityId': serializer.toJson<String?>(entityId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
    };
  }

  AppNotification copyWith({
    int? id,
    NotificationKind? kind,
    String? title,
    String? body,
    Value<EntityType?> entityType = const Value.absent(),
    Value<String?> entityId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> readAt = const Value.absent(),
  }) => AppNotification(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    body: body ?? this.body,
    entityType: entityType.present ? entityType.value : this.entityType,
    entityId: entityId.present ? entityId.value : this.entityId,
    createdAt: createdAt ?? this.createdAt,
    readAt: readAt.present ? readAt.value : this.readAt,
  );
  AppNotification copyWithCompanion(AppNotificationsCompanion data) {
    return AppNotification(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppNotification(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    kind,
    title,
    body,
    entityType,
    entityId,
    createdAt,
    readAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppNotification &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.body == this.body &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.createdAt == this.createdAt &&
          other.readAt == this.readAt);
}

class AppNotificationsCompanion extends UpdateCompanion<AppNotification> {
  final Value<int> id;
  final Value<NotificationKind> kind;
  final Value<String> title;
  final Value<String> body;
  final Value<EntityType?> entityType;
  final Value<String?> entityId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> readAt;
  const AppNotificationsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
  });
  AppNotificationsCompanion.insert({
    this.id = const Value.absent(),
    required NotificationKind kind,
    required String title,
    this.body = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    required DateTime createdAt,
    this.readAt = const Value.absent(),
  }) : kind = Value(kind),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<AppNotification> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? readAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (createdAt != null) 'created_at': createdAt,
      if (readAt != null) 'read_at': readAt,
    });
  }

  AppNotificationsCompanion copyWith({
    Value<int>? id,
    Value<NotificationKind>? kind,
    Value<String>? title,
    Value<String>? body,
    Value<EntityType?>? entityType,
    Value<String?>? entityId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? readAt,
  }) {
    return AppNotificationsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      body: body ?? this.body,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $AppNotificationsTable.$converterkind.toSql(kind.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(
        $AppNotificationsTable.$converterentityTypen.toSql(entityType.value),
      );
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppNotificationsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }
}

class $CountersTable extends Counters with TableInfo<$CountersTable, Counter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [name, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'counters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Counter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  Counter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Counter(
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $CountersTable createAlias(String alias) {
    return $CountersTable(attachedDatabase, alias);
  }
}

class Counter extends DataClass implements Insertable<Counter> {
  final String name;
  final int value;
  const Counter({required this.name, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['value'] = Variable<int>(value);
    return map;
  }

  CountersCompanion toCompanion(bool nullToAbsent) {
    return CountersCompanion(name: Value(name), value: Value(value));
  }

  factory Counter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Counter(
      name: serializer.fromJson<String>(json['name']),
      value: serializer.fromJson<int>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'value': serializer.toJson<int>(value),
    };
  }

  Counter copyWith({String? name, int? value}) =>
      Counter(name: name ?? this.name, value: value ?? this.value);
  Counter copyWithCompanion(CountersCompanion data) {
    return Counter(
      name: data.name.present ? data.name.value : this.name,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Counter(')
          ..write('name: $name, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Counter &&
          other.name == this.name &&
          other.value == this.value);
}

class CountersCompanion extends UpdateCompanion<Counter> {
  final Value<String> name;
  final Value<int> value;
  final Value<int> rowid;
  const CountersCompanion({
    this.name = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CountersCompanion.insert({
    required String name,
    required int value,
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       value = Value(value);
  static Insertable<Counter> custom({
    Expression<String>? name,
    Expression<int>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CountersCompanion copyWith({
    Value<String>? name,
    Value<int>? value,
    Value<int>? rowid,
  }) {
    return CountersCompanion(
      name: name ?? this.name,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CountersCompanion(')
          ..write('name: $name, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LeadsTable leads = $LeadsTable(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $FollowUpsTable followUps = $FollowUpsTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $EmailTemplatesTable emailTemplates = $EmailTemplatesTable(this);
  late final $EmailLogsTable emailLogs = $EmailLogsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $AppNotificationsTable appNotifications = $AppNotificationsTable(
    this,
  );
  late final $CountersTable counters = $CountersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    leads,
    clients,
    projects,
    followUps,
    invoices,
    activities,
    emailTemplates,
    emailLogs,
    appSettings,
    appNotifications,
    counters,
  ];
}

typedef $$LeadsTableCreateCompanionBuilder = LeadsCompanion Function({
  required String id,
  required DateTime dateAdded,
  required String business,
  Value<String> contactPerson,
  Value<String> phone,
  Value<String> email,
  Value<String> instagram,
  required LeadSource source,
  required ServiceType service,
  Value<double> potentialValue,
  required LeadStatus status,
  Value<DateTime?> lastContact,
  Value<DateTime?> nextFollowUp,
  Value<String> notes,
  Value<String> proposalLink,
  Value<String> driveFolder,
  Value<String> lostReason,
  Value<String?> clientId,
  Value<String?> externalKey,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$LeadsTableUpdateCompanionBuilder = LeadsCompanion Function({
  Value<String> id,
  Value<DateTime> dateAdded,
  Value<String> business,
  Value<String> contactPerson,
  Value<String> phone,
  Value<String> email,
  Value<String> instagram,
  Value<LeadSource> source,
  Value<ServiceType> service,
  Value<double> potentialValue,
  Value<LeadStatus> status,
  Value<DateTime?> lastContact,
  Value<DateTime?> nextFollowUp,
  Value<String> notes,
  Value<String> proposalLink,
  Value<String> driveFolder,
  Value<String> lostReason,
  Value<String?> clientId,
  Value<String?> externalKey,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LeadsTableFilterComposer extends Composer<_$AppDatabase, $LeadsTable> {
  $$LeadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get business => $composableBuilder(
    column: $table.business,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instagram => $composableBuilder(
    column: $table.instagram,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LeadSource, LeadSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<ServiceType, ServiceType, String>
  get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get potentialValue => $composableBuilder(
    column: $table.potentialValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LeadStatus, LeadStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get lastContact => $composableBuilder(
    column: $table.lastContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextFollowUp => $composableBuilder(
    column: $table.nextFollowUp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proposalLink => $composableBuilder(
    column: $table.proposalLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driveFolder => $composableBuilder(
    column: $table.driveFolder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lostReason => $composableBuilder(
    column: $table.lostReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalKey => $composableBuilder(
    column: $table.externalKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LeadsTableOrderingComposer
    extends Composer<_$AppDatabase, $LeadsTable> {
  $$LeadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get business => $composableBuilder(
    column: $table.business,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instagram => $composableBuilder(
    column: $table.instagram,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get potentialValue => $composableBuilder(
    column: $table.potentialValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastContact => $composableBuilder(
    column: $table.lastContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextFollowUp => $composableBuilder(
    column: $table.nextFollowUp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proposalLink => $composableBuilder(
    column: $table.proposalLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driveFolder => $composableBuilder(
    column: $table.driveFolder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lostReason => $composableBuilder(
    column: $table.lostReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalKey => $composableBuilder(
    column: $table.externalKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LeadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeadsTable> {
  $$LeadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<String> get business =>
      $composableBuilder(column: $table.business, builder: (column) => column);

  GeneratedColumn<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get instagram =>
      $composableBuilder(column: $table.instagram, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LeadSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ServiceType, String> get service =>
      $composableBuilder(column: $table.service, builder: (column) => column);

  GeneratedColumn<double> get potentialValue => $composableBuilder(
    column: $table.potentialValue,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LeadStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get lastContact => $composableBuilder(
    column: $table.lastContact,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextFollowUp => $composableBuilder(
    column: $table.nextFollowUp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get proposalLink => $composableBuilder(
    column: $table.proposalLink,
    builder: (column) => column,
  );

  GeneratedColumn<String> get driveFolder => $composableBuilder(
    column: $table.driveFolder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lostReason => $composableBuilder(
    column: $table.lostReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get externalKey => $composableBuilder(
    column: $table.externalKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LeadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeadsTable,
          Lead,
          $$LeadsTableFilterComposer,
          $$LeadsTableOrderingComposer,
          $$LeadsTableAnnotationComposer,
          $$LeadsTableCreateCompanionBuilder,
          $$LeadsTableUpdateCompanionBuilder,
          (Lead, BaseReferences<_$AppDatabase, $LeadsTable, Lead>),
          Lead,
          PrefetchHooks Function()
        > {
  $$LeadsTableTableManager(_$AppDatabase db, $LeadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> dateAdded = const Value.absent(),
                Value<String> business = const Value.absent(),
                Value<String> contactPerson = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> instagram = const Value.absent(),
                Value<LeadSource> source = const Value.absent(),
                Value<ServiceType> service = const Value.absent(),
                Value<double> potentialValue = const Value.absent(),
                Value<LeadStatus> status = const Value.absent(),
                Value<DateTime?> lastContact = const Value.absent(),
                Value<DateTime?> nextFollowUp = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> proposalLink = const Value.absent(),
                Value<String> driveFolder = const Value.absent(),
                Value<String> lostReason = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
                Value<String?> externalKey = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeadsCompanion(
                id: id,
                dateAdded: dateAdded,
                business: business,
                contactPerson: contactPerson,
                phone: phone,
                email: email,
                instagram: instagram,
                source: source,
                service: service,
                potentialValue: potentialValue,
                status: status,
                lastContact: lastContact,
                nextFollowUp: nextFollowUp,
                notes: notes,
                proposalLink: proposalLink,
                driveFolder: driveFolder,
                lostReason: lostReason,
                clientId: clientId,
                externalKey: externalKey,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime dateAdded,
                required String business,
                Value<String> contactPerson = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> instagram = const Value.absent(),
                required LeadSource source,
                required ServiceType service,
                Value<double> potentialValue = const Value.absent(),
                required LeadStatus status,
                Value<DateTime?> lastContact = const Value.absent(),
                Value<DateTime?> nextFollowUp = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> proposalLink = const Value.absent(),
                Value<String> driveFolder = const Value.absent(),
                Value<String> lostReason = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
                Value<String?> externalKey = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => LeadsCompanion.insert(
                id: id,
                dateAdded: dateAdded,
                business: business,
                contactPerson: contactPerson,
                phone: phone,
                email: email,
                instagram: instagram,
                source: source,
                service: service,
                potentialValue: potentialValue,
                status: status,
                lastContact: lastContact,
                nextFollowUp: nextFollowUp,
                notes: notes,
                proposalLink: proposalLink,
                driveFolder: driveFolder,
                lostReason: lostReason,
                clientId: clientId,
                externalKey: externalKey,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LeadsTable, Lead>(table),
                  BaseReferences<_$AppDatabase, $LeadsTable, Lead>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LeadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeadsTable,
      Lead,
      $$LeadsTableFilterComposer,
      $$LeadsTableOrderingComposer,
      $$LeadsTableAnnotationComposer,
      $$LeadsTableCreateCompanionBuilder,
      $$LeadsTableUpdateCompanionBuilder,
      (Lead, BaseReferences<_$AppDatabase, $LeadsTable, Lead>),
      Lead,
      PrefetchHooks Function()
    >;
typedef $$ClientsTableCreateCompanionBuilder = ClientsCompanion Function({
  required String id,
  required String name,
  Value<String> contactPerson,
  Value<String> phone,
  Value<String> email,
  Value<String> instagram,
  required ServiceType service,
  Value<double> monthlyValue,
  Value<double> projectValue,
  required DateTime startDate,
  required ClientStatus status,
  Value<String> driveFolder,
  Value<String> notes,
  Value<String?> leadId,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ClientsTableUpdateCompanionBuilder = ClientsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> contactPerson,
  Value<String> phone,
  Value<String> email,
  Value<String> instagram,
  Value<ServiceType> service,
  Value<double> monthlyValue,
  Value<double> projectValue,
  Value<DateTime> startDate,
  Value<ClientStatus> status,
  Value<String> driveFolder,
  Value<String> notes,
  Value<String?> leadId,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instagram => $composableBuilder(
    column: $table.instagram,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ServiceType, ServiceType, String>
  get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get monthlyValue => $composableBuilder(
    column: $table.monthlyValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get projectValue => $composableBuilder(
    column: $table.projectValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ClientStatus, ClientStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get driveFolder => $composableBuilder(
    column: $table.driveFolder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leadId => $composableBuilder(
    column: $table.leadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instagram => $composableBuilder(
    column: $table.instagram,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyValue => $composableBuilder(
    column: $table.monthlyValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get projectValue => $composableBuilder(
    column: $table.projectValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driveFolder => $composableBuilder(
    column: $table.driveFolder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leadId => $composableBuilder(
    column: $table.leadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get instagram =>
      $composableBuilder(column: $table.instagram, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ServiceType, String> get service =>
      $composableBuilder(column: $table.service, builder: (column) => column);

  GeneratedColumn<double> get monthlyValue => $composableBuilder(
    column: $table.monthlyValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get projectValue => $composableBuilder(
    column: $table.projectValue,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ClientStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get driveFolder => $composableBuilder(
    column: $table.driveFolder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get leadId =>
      $composableBuilder(column: $table.leadId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          Client,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
          Client,
          PrefetchHooks Function()
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> contactPerson = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> instagram = const Value.absent(),
                Value<ServiceType> service = const Value.absent(),
                Value<double> monthlyValue = const Value.absent(),
                Value<double> projectValue = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<ClientStatus> status = const Value.absent(),
                Value<String> driveFolder = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String?> leadId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClientsCompanion(
                id: id,
                name: name,
                contactPerson: contactPerson,
                phone: phone,
                email: email,
                instagram: instagram,
                service: service,
                monthlyValue: monthlyValue,
                projectValue: projectValue,
                startDate: startDate,
                status: status,
                driveFolder: driveFolder,
                notes: notes,
                leadId: leadId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> contactPerson = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> instagram = const Value.absent(),
                required ServiceType service,
                Value<double> monthlyValue = const Value.absent(),
                Value<double> projectValue = const Value.absent(),
                required DateTime startDate,
                required ClientStatus status,
                Value<String> driveFolder = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String?> leadId = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ClientsCompanion.insert(
                id: id,
                name: name,
                contactPerson: contactPerson,
                phone: phone,
                email: email,
                instagram: instagram,
                service: service,
                monthlyValue: monthlyValue,
                projectValue: projectValue,
                startDate: startDate,
                status: status,
                driveFolder: driveFolder,
                notes: notes,
                leadId: leadId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ClientsTable, Client>(table),
                  BaseReferences<_$AppDatabase, $ClientsTable, Client>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      Client,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
      Client,
      PrefetchHooks Function()
    >;
typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String id,
  required String clientId,
  required String name,
  required ServiceType service,
  Value<DateTime?> shootDate,
  Value<DateTime?> deadline,
  required ProjectStatus status,
  Value<String> deliverables,
  Value<DateTime?> clientReviewDate,
  Value<DateTime?> finalDeliveryDate,
  required PaymentStatus paymentStatus,
  Value<double> value,
  Value<String> driveFolder,
  Value<String> notes,
  Value<String?> calendarEventId,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<String> clientId,
  Value<String> name,
  Value<ServiceType> service,
  Value<DateTime?> shootDate,
  Value<DateTime?> deadline,
  Value<ProjectStatus> status,
  Value<String> deliverables,
  Value<DateTime?> clientReviewDate,
  Value<DateTime?> finalDeliveryDate,
  Value<PaymentStatus> paymentStatus,
  Value<double> value,
  Value<String> driveFolder,
  Value<String> notes,
  Value<String?> calendarEventId,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ServiceType, ServiceType, String>
  get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get shootDate => $composableBuilder(
    column: $table.shootDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ProjectStatus, ProjectStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get deliverables => $composableBuilder(
    column: $table.deliverables,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientReviewDate => $composableBuilder(
    column: $table.clientReviewDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finalDeliveryDate => $composableBuilder(
    column: $table.finalDeliveryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentStatus, PaymentStatus, String>
  get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driveFolder => $composableBuilder(
    column: $table.driveFolder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get service => $composableBuilder(
    column: $table.service,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get shootDate => $composableBuilder(
    column: $table.shootDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
    column: $table.deadline,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deliverables => $composableBuilder(
    column: $table.deliverables,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientReviewDate => $composableBuilder(
    column: $table.clientReviewDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finalDeliveryDate => $composableBuilder(
    column: $table.finalDeliveryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driveFolder => $composableBuilder(
    column: $table.driveFolder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ServiceType, String> get service =>
      $composableBuilder(column: $table.service, builder: (column) => column);

  GeneratedColumn<DateTime> get shootDate =>
      $composableBuilder(column: $table.shootDate, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ProjectStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get deliverables => $composableBuilder(
    column: $table.deliverables,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get clientReviewDate => $composableBuilder(
    column: $table.clientReviewDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get finalDeliveryDate => $composableBuilder(
    column: $table.finalDeliveryDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PaymentStatus, String> get paymentStatus =>
      $composableBuilder(
        column: $table.paymentStatus,
        builder: (column) => column,
      );

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get driveFolder => $composableBuilder(
    column: $table.driveFolder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
          Project,
          PrefetchHooks Function()
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<ServiceType> service = const Value.absent(),
                Value<DateTime?> shootDate = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                Value<ProjectStatus> status = const Value.absent(),
                Value<String> deliverables = const Value.absent(),
                Value<DateTime?> clientReviewDate = const Value.absent(),
                Value<DateTime?> finalDeliveryDate = const Value.absent(),
                Value<PaymentStatus> paymentStatus = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> driveFolder = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String?> calendarEventId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                clientId: clientId,
                name: name,
                service: service,
                shootDate: shootDate,
                deadline: deadline,
                status: status,
                deliverables: deliverables,
                clientReviewDate: clientReviewDate,
                finalDeliveryDate: finalDeliveryDate,
                paymentStatus: paymentStatus,
                value: value,
                driveFolder: driveFolder,
                notes: notes,
                calendarEventId: calendarEventId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                required String name,
                required ServiceType service,
                Value<DateTime?> shootDate = const Value.absent(),
                Value<DateTime?> deadline = const Value.absent(),
                required ProjectStatus status,
                Value<String> deliverables = const Value.absent(),
                Value<DateTime?> clientReviewDate = const Value.absent(),
                Value<DateTime?> finalDeliveryDate = const Value.absent(),
                required PaymentStatus paymentStatus,
                Value<double> value = const Value.absent(),
                Value<String> driveFolder = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String?> calendarEventId = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                clientId: clientId,
                name: name,
                service: service,
                shootDate: shootDate,
                deadline: deadline,
                status: status,
                deliverables: deliverables,
                clientReviewDate: clientReviewDate,
                finalDeliveryDate: finalDeliveryDate,
                paymentStatus: paymentStatus,
                value: value,
                driveFolder: driveFolder,
                notes: notes,
                calendarEventId: calendarEventId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProjectsTable, Project>(table),
                  BaseReferences<_$AppDatabase, $ProjectsTable, Project>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
      Project,
      PrefetchHooks Function()
    >;
typedef $$FollowUpsTableCreateCompanionBuilder = FollowUpsCompanion Function({
  required String id,
  Value<String?> leadId,
  Value<String?> clientId,
  required String title,
  required DateTime dueAt,
  Value<bool> hasTime,
  Value<int> durationMinutes,
  required FollowUpType type,
  required FollowUpStatus status,
  Value<String> notes,
  Value<String> outcome,
  Value<String?> calendarEventId,
  Value<String> meetLink,
  Value<DateTime?> notifiedAt,
  Value<DateTime?> completedAt,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$FollowUpsTableUpdateCompanionBuilder = FollowUpsCompanion Function({
  Value<String> id,
  Value<String?> leadId,
  Value<String?> clientId,
  Value<String> title,
  Value<DateTime> dueAt,
  Value<bool> hasTime,
  Value<int> durationMinutes,
  Value<FollowUpType> type,
  Value<FollowUpStatus> status,
  Value<String> notes,
  Value<String> outcome,
  Value<String?> calendarEventId,
  Value<String> meetLink,
  Value<DateTime?> notifiedAt,
  Value<DateTime?> completedAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$FollowUpsTableFilterComposer
    extends Composer<_$AppDatabase, $FollowUpsTable> {
  $$FollowUpsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get leadId => $composableBuilder(
    column: $table.leadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasTime => $composableBuilder(
    column: $table.hasTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FollowUpType, FollowUpType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<FollowUpStatus, FollowUpStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meetLink => $composableBuilder(
    column: $table.meetLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get notifiedAt => $composableBuilder(
    column: $table.notifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FollowUpsTableOrderingComposer
    extends Composer<_$AppDatabase, $FollowUpsTable> {
  $$FollowUpsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get leadId => $composableBuilder(
    column: $table.leadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasTime => $composableBuilder(
    column: $table.hasTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meetLink => $composableBuilder(
    column: $table.meetLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get notifiedAt => $composableBuilder(
    column: $table.notifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FollowUpsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FollowUpsTable> {
  $$FollowUpsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get leadId =>
      $composableBuilder(column: $table.leadId, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<bool> get hasTime =>
      $composableBuilder(column: $table.hasTime, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FollowUpType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FollowUpStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<String> get calendarEventId => $composableBuilder(
    column: $table.calendarEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get meetLink =>
      $composableBuilder(column: $table.meetLink, builder: (column) => column);

  GeneratedColumn<DateTime> get notifiedAt => $composableBuilder(
    column: $table.notifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FollowUpsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FollowUpsTable,
          FollowUp,
          $$FollowUpsTableFilterComposer,
          $$FollowUpsTableOrderingComposer,
          $$FollowUpsTableAnnotationComposer,
          $$FollowUpsTableCreateCompanionBuilder,
          $$FollowUpsTableUpdateCompanionBuilder,
          (FollowUp, BaseReferences<_$AppDatabase, $FollowUpsTable, FollowUp>),
          FollowUp,
          PrefetchHooks Function()
        > {
  $$FollowUpsTableTableManager(_$AppDatabase db, $FollowUpsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FollowUpsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FollowUpsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FollowUpsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> leadId = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> dueAt = const Value.absent(),
                Value<bool> hasTime = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<FollowUpType> type = const Value.absent(),
                Value<FollowUpStatus> status = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<String?> calendarEventId = const Value.absent(),
                Value<String> meetLink = const Value.absent(),
                Value<DateTime?> notifiedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FollowUpsCompanion(
                id: id,
                leadId: leadId,
                clientId: clientId,
                title: title,
                dueAt: dueAt,
                hasTime: hasTime,
                durationMinutes: durationMinutes,
                type: type,
                status: status,
                notes: notes,
                outcome: outcome,
                calendarEventId: calendarEventId,
                meetLink: meetLink,
                notifiedAt: notifiedAt,
                completedAt: completedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> leadId = const Value.absent(),
                Value<String?> clientId = const Value.absent(),
                required String title,
                required DateTime dueAt,
                Value<bool> hasTime = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                required FollowUpType type,
                required FollowUpStatus status,
                Value<String> notes = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<String?> calendarEventId = const Value.absent(),
                Value<String> meetLink = const Value.absent(),
                Value<DateTime?> notifiedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => FollowUpsCompanion.insert(
                id: id,
                leadId: leadId,
                clientId: clientId,
                title: title,
                dueAt: dueAt,
                hasTime: hasTime,
                durationMinutes: durationMinutes,
                type: type,
                status: status,
                notes: notes,
                outcome: outcome,
                calendarEventId: calendarEventId,
                meetLink: meetLink,
                notifiedAt: notifiedAt,
                completedAt: completedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FollowUpsTable, FollowUp>(table),
                  BaseReferences<_$AppDatabase, $FollowUpsTable, FollowUp>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FollowUpsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FollowUpsTable,
      FollowUp,
      $$FollowUpsTableFilterComposer,
      $$FollowUpsTableOrderingComposer,
      $$FollowUpsTableAnnotationComposer,
      $$FollowUpsTableCreateCompanionBuilder,
      $$FollowUpsTableUpdateCompanionBuilder,
      (FollowUp, BaseReferences<_$AppDatabase, $FollowUpsTable, FollowUp>),
      FollowUp,
      PrefetchHooks Function()
    >;
typedef $$InvoicesTableCreateCompanionBuilder = InvoicesCompanion Function({
  required String id,
  required String clientId,
  Value<String?> projectId,
  required DateTime invoiceDate,
  required double amount,
  Value<double> amountReceived,
  required DateTime dueDate,
  required InvoiceStatus status,
  Value<DateTime?> paymentDate,
  Value<String> description,
  Value<String> notes,
  Value<DateTime?> notifiedAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$InvoicesTableUpdateCompanionBuilder = InvoicesCompanion Function({
  Value<String> id,
  Value<String> clientId,
  Value<String?> projectId,
  Value<DateTime> invoiceDate,
  Value<double> amount,
  Value<double> amountReceived,
  Value<DateTime> dueDate,
  Value<InvoiceStatus> status,
  Value<DateTime?> paymentDate,
  Value<String> description,
  Value<String> notes,
  Value<DateTime?> notifiedAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$InvoicesTableFilterComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountReceived => $composableBuilder(
    column: $table.amountReceived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InvoiceStatus, InvoiceStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get notifiedAt => $composableBuilder(
    column: $table.notifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientId => $composableBuilder(
    column: $table.clientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountReceived => $composableBuilder(
    column: $table.amountReceived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get notifiedAt => $composableBuilder(
    column: $table.notifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientId =>
      $composableBuilder(column: $table.clientId, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<DateTime> get invoiceDate => $composableBuilder(
    column: $table.invoiceDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get amountReceived => $composableBuilder(
    column: $table.amountReceived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InvoiceStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get paymentDate => $composableBuilder(
    column: $table.paymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get notifiedAt => $composableBuilder(
    column: $table.notifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoicesTable,
          Invoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (Invoice, BaseReferences<_$AppDatabase, $InvoicesTable, Invoice>),
          Invoice,
          PrefetchHooks Function()
        > {
  $$InvoicesTableTableManager(_$AppDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> clientId = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<DateTime> invoiceDate = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double> amountReceived = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<InvoiceStatus> status = const Value.absent(),
                Value<DateTime?> paymentDate = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime?> notifiedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                clientId: clientId,
                projectId: projectId,
                invoiceDate: invoiceDate,
                amount: amount,
                amountReceived: amountReceived,
                dueDate: dueDate,
                status: status,
                paymentDate: paymentDate,
                description: description,
                notes: notes,
                notifiedAt: notifiedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String clientId,
                Value<String?> projectId = const Value.absent(),
                required DateTime invoiceDate,
                required double amount,
                Value<double> amountReceived = const Value.absent(),
                required DateTime dueDate,
                required InvoiceStatus status,
                Value<DateTime?> paymentDate = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime?> notifiedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                clientId: clientId,
                projectId: projectId,
                invoiceDate: invoiceDate,
                amount: amount,
                amountReceived: amountReceived,
                dueDate: dueDate,
                status: status,
                paymentDate: paymentDate,
                description: description,
                notes: notes,
                notifiedAt: notifiedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InvoicesTable, Invoice>(table),
                  BaseReferences<_$AppDatabase, $InvoicesTable, Invoice>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoicesTable,
      Invoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (Invoice, BaseReferences<_$AppDatabase, $InvoicesTable, Invoice>),
      Invoice,
      PrefetchHooks Function()
    >;
typedef $$ActivitiesTableCreateCompanionBuilder = ActivitiesCompanion Function({
  Value<int> id,
  required EntityType entityType,
  required String entityId,
  required ActivityKind kind,
  required String title,
  Value<String> detail,
  required DateTime createdAt,
});
typedef $$ActivitiesTableUpdateCompanionBuilder = ActivitiesCompanion Function({
  Value<int> id,
  Value<EntityType> entityType,
  Value<String> entityId,
  Value<ActivityKind> kind,
  Value<String> title,
  Value<String> detail,
  Value<DateTime> createdAt,
});

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<EntityType, EntityType, String>
  get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ActivityKind, ActivityKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
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

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detail => $composableBuilder(
    column: $table.detail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EntityType, String> get entityType =>
      $composableBuilder(
        column: $table.entityType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActivityKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get detail =>
      $composableBuilder(column: $table.detail, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          Activity,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (Activity, BaseReferences<_$AppDatabase, $ActivitiesTable, Activity>),
          Activity,
          PrefetchHooks Function()
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<EntityType> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<ActivityKind> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> detail = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                kind: kind,
                title: title,
                detail: detail,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required EntityType entityType,
                required String entityId,
                required ActivityKind kind,
                required String title,
                Value<String> detail = const Value.absent(),
                required DateTime createdAt,
              }) => ActivitiesCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                kind: kind,
                title: title,
                detail: detail,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivitiesTable, Activity>(table),
                  BaseReferences<_$AppDatabase, $ActivitiesTable, Activity>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      Activity,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (Activity, BaseReferences<_$AppDatabase, $ActivitiesTable, Activity>),
      Activity,
      PrefetchHooks Function()
    >;
typedef $$EmailTemplatesTableCreateCompanionBuilder =
    EmailTemplatesCompanion Function({
      required String id,
      required String name,
      Value<LeadStatus?> triggerStatus,
      Value<String> category,
      required String subject,
      required String body,
      Value<bool> autoSend,
      Value<bool> isBuiltIn,
      Value<int> sortOrder,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$EmailTemplatesTableUpdateCompanionBuilder =
    EmailTemplatesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<LeadStatus?> triggerStatus,
      Value<String> category,
      Value<String> subject,
      Value<String> body,
      Value<bool> autoSend,
      Value<bool> isBuiltIn,
      Value<int> sortOrder,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$EmailTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $EmailTemplatesTable> {
  $$EmailTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LeadStatus?, LeadStatus, String>
  get triggerStatus => $composableBuilder(
    column: $table.triggerStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoSend => $composableBuilder(
    column: $table.autoSend,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmailTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmailTemplatesTable> {
  $$EmailTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get triggerStatus => $composableBuilder(
    column: $table.triggerStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoSend => $composableBuilder(
    column: $table.autoSend,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmailTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmailTemplatesTable> {
  $$EmailTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LeadStatus?, String> get triggerStatus =>
      $composableBuilder(
        column: $table.triggerStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get autoSend =>
      $composableBuilder(column: $table.autoSend, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$EmailTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmailTemplatesTable,
          EmailTemplate,
          $$EmailTemplatesTableFilterComposer,
          $$EmailTemplatesTableOrderingComposer,
          $$EmailTemplatesTableAnnotationComposer,
          $$EmailTemplatesTableCreateCompanionBuilder,
          $$EmailTemplatesTableUpdateCompanionBuilder,
          (
            EmailTemplate,
            BaseReferences<_$AppDatabase, $EmailTemplatesTable, EmailTemplate>,
          ),
          EmailTemplate,
          PrefetchHooks Function()
        > {
  $$EmailTemplatesTableTableManager(
    _$AppDatabase db,
    $EmailTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmailTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmailTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmailTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<LeadStatus?> triggerStatus = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> autoSend = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmailTemplatesCompanion(
                id: id,
                name: name,
                triggerStatus: triggerStatus,
                category: category,
                subject: subject,
                body: body,
                autoSend: autoSend,
                isBuiltIn: isBuiltIn,
                sortOrder: sortOrder,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<LeadStatus?> triggerStatus = const Value.absent(),
                Value<String> category = const Value.absent(),
                required String subject,
                required String body,
                Value<bool> autoSend = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => EmailTemplatesCompanion.insert(
                id: id,
                name: name,
                triggerStatus: triggerStatus,
                category: category,
                subject: subject,
                body: body,
                autoSend: autoSend,
                isBuiltIn: isBuiltIn,
                sortOrder: sortOrder,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmailTemplatesTable, EmailTemplate>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $EmailTemplatesTable,
                    EmailTemplate
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmailTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmailTemplatesTable,
      EmailTemplate,
      $$EmailTemplatesTableFilterComposer,
      $$EmailTemplatesTableOrderingComposer,
      $$EmailTemplatesTableAnnotationComposer,
      $$EmailTemplatesTableCreateCompanionBuilder,
      $$EmailTemplatesTableUpdateCompanionBuilder,
      (
        EmailTemplate,
        BaseReferences<_$AppDatabase, $EmailTemplatesTable, EmailTemplate>,
      ),
      EmailTemplate,
      PrefetchHooks Function()
    >;
typedef $$EmailLogsTableCreateCompanionBuilder = EmailLogsCompanion Function({
  Value<int> id,
  required EntityType entityType,
  required String entityId,
  required String toAddress,
  required String subject,
  required String body,
  Value<String?> templateId,
  Value<String?> gmailMessageId,
  Value<String?> error,
  required DateTime sentAt,
});
typedef $$EmailLogsTableUpdateCompanionBuilder = EmailLogsCompanion Function({
  Value<int> id,
  Value<EntityType> entityType,
  Value<String> entityId,
  Value<String> toAddress,
  Value<String> subject,
  Value<String> body,
  Value<String?> templateId,
  Value<String?> gmailMessageId,
  Value<String?> error,
  Value<DateTime> sentAt,
});

class $$EmailLogsTableFilterComposer
    extends Composer<_$AppDatabase, $EmailLogsTable> {
  $$EmailLogsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<EntityType, EntityType, String>
  get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toAddress => $composableBuilder(
    column: $table.toAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gmailMessageId => $composableBuilder(
    column: $table.gmailMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmailLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmailLogsTable> {
  $$EmailLogsTableOrderingComposer({
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

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toAddress => $composableBuilder(
    column: $table.toAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gmailMessageId => $composableBuilder(
    column: $table.gmailMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmailLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmailLogsTable> {
  $$EmailLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EntityType, String> get entityType =>
      $composableBuilder(
        column: $table.entityType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get toAddress =>
      $composableBuilder(column: $table.toAddress, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gmailMessageId => $composableBuilder(
    column: $table.gmailMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);
}

class $$EmailLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmailLogsTable,
          EmailLog,
          $$EmailLogsTableFilterComposer,
          $$EmailLogsTableOrderingComposer,
          $$EmailLogsTableAnnotationComposer,
          $$EmailLogsTableCreateCompanionBuilder,
          $$EmailLogsTableUpdateCompanionBuilder,
          (EmailLog, BaseReferences<_$AppDatabase, $EmailLogsTable, EmailLog>),
          EmailLog,
          PrefetchHooks Function()
        > {
  $$EmailLogsTableTableManager(_$AppDatabase db, $EmailLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmailLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmailLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmailLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<EntityType> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> toAddress = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> templateId = const Value.absent(),
                Value<String?> gmailMessageId = const Value.absent(),
                Value<String?> error = const Value.absent(),
                Value<DateTime> sentAt = const Value.absent(),
              }) => EmailLogsCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                toAddress: toAddress,
                subject: subject,
                body: body,
                templateId: templateId,
                gmailMessageId: gmailMessageId,
                error: error,
                sentAt: sentAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required EntityType entityType,
                required String entityId,
                required String toAddress,
                required String subject,
                required String body,
                Value<String?> templateId = const Value.absent(),
                Value<String?> gmailMessageId = const Value.absent(),
                Value<String?> error = const Value.absent(),
                required DateTime sentAt,
              }) => EmailLogsCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                toAddress: toAddress,
                subject: subject,
                body: body,
                templateId: templateId,
                gmailMessageId: gmailMessageId,
                error: error,
                sentAt: sentAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmailLogsTable, EmailLog>(table),
                  BaseReferences<_$AppDatabase, $EmailLogsTable, EmailLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmailLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmailLogsTable,
      EmailLog,
      $$EmailLogsTableFilterComposer,
      $$EmailLogsTableOrderingComposer,
      $$EmailLogsTableAnnotationComposer,
      $$EmailLogsTableCreateCompanionBuilder,
      $$EmailLogsTableUpdateCompanionBuilder,
      (EmailLog, BaseReferences<_$AppDatabase, $EmailLogsTable, EmailLog>),
      EmailLog,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$AppNotificationsTableCreateCompanionBuilder =
    AppNotificationsCompanion Function({
      Value<int> id,
      required NotificationKind kind,
      required String title,
      Value<String> body,
      Value<EntityType?> entityType,
      Value<String?> entityId,
      required DateTime createdAt,
      Value<DateTime?> readAt,
    });
typedef $$AppNotificationsTableUpdateCompanionBuilder =
    AppNotificationsCompanion Function({
      Value<int> id,
      Value<NotificationKind> kind,
      Value<String> title,
      Value<String> body,
      Value<EntityType?> entityType,
      Value<String?> entityId,
      Value<DateTime> createdAt,
      Value<DateTime?> readAt,
    });

class $$AppNotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<NotificationKind, NotificationKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EntityType?, EntityType, String>
  get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppNotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppNotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppNotificationsTable> {
  $$AppNotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NotificationKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EntityType?, String> get entityType =>
      $composableBuilder(
        column: $table.entityType,
        builder: (column) => column,
      );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);
}

class $$AppNotificationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppNotificationsTable,
          AppNotification,
          $$AppNotificationsTableFilterComposer,
          $$AppNotificationsTableOrderingComposer,
          $$AppNotificationsTableAnnotationComposer,
          $$AppNotificationsTableCreateCompanionBuilder,
          $$AppNotificationsTableUpdateCompanionBuilder,
          (
            AppNotification,
            BaseReferences<
              _$AppDatabase,
              $AppNotificationsTable,
              AppNotification
            >,
          ),
          AppNotification,
          PrefetchHooks Function()
        > {
  $$AppNotificationsTableTableManager(
    _$AppDatabase db,
    $AppNotificationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppNotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppNotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppNotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<NotificationKind> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<EntityType?> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
              }) => AppNotificationsCompanion(
                id: id,
                kind: kind,
                title: title,
                body: body,
                entityType: entityType,
                entityId: entityId,
                createdAt: createdAt,
                readAt: readAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required NotificationKind kind,
                required String title,
                Value<String> body = const Value.absent(),
                Value<EntityType?> entityType = const Value.absent(),
                Value<String?> entityId = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> readAt = const Value.absent(),
              }) => AppNotificationsCompanion.insert(
                id: id,
                kind: kind,
                title: title,
                body: body,
                entityType: entityType,
                entityId: entityId,
                createdAt: createdAt,
                readAt: readAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppNotificationsTable, AppNotification>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppNotificationsTable,
                    AppNotification
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppNotificationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppNotificationsTable,
      AppNotification,
      $$AppNotificationsTableFilterComposer,
      $$AppNotificationsTableOrderingComposer,
      $$AppNotificationsTableAnnotationComposer,
      $$AppNotificationsTableCreateCompanionBuilder,
      $$AppNotificationsTableUpdateCompanionBuilder,
      (
        AppNotification,
        BaseReferences<_$AppDatabase, $AppNotificationsTable, AppNotification>,
      ),
      AppNotification,
      PrefetchHooks Function()
    >;
typedef $$CountersTableCreateCompanionBuilder = CountersCompanion Function({
  required String name,
  required int value,
  Value<int> rowid,
});
typedef $$CountersTableUpdateCompanionBuilder = CountersCompanion Function({
  Value<String> name,
  Value<int> value,
  Value<int> rowid,
});

class $$CountersTableFilterComposer
    extends Composer<_$AppDatabase, $CountersTable> {
  $$CountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CountersTableOrderingComposer
    extends Composer<_$AppDatabase, $CountersTable> {
  $$CountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CountersTable> {
  $$CountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$CountersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CountersTable,
          Counter,
          $$CountersTableFilterComposer,
          $$CountersTableOrderingComposer,
          $$CountersTableAnnotationComposer,
          $$CountersTableCreateCompanionBuilder,
          $$CountersTableUpdateCompanionBuilder,
          (Counter, BaseReferences<_$AppDatabase, $CountersTable, Counter>),
          Counter,
          PrefetchHooks Function()
        > {
  $$CountersTableTableManager(_$AppDatabase db, $CountersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> name = const Value.absent(),
            Value<int> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => CountersCompanion(name: name, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String name,
                required int value,
                Value<int> rowid = const Value.absent(),
              }) => CountersCompanion.insert(
                name: name,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CountersTable, Counter>(table),
                  BaseReferences<_$AppDatabase, $CountersTable, Counter>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CountersTable,
      Counter,
      $$CountersTableFilterComposer,
      $$CountersTableOrderingComposer,
      $$CountersTableAnnotationComposer,
      $$CountersTableCreateCompanionBuilder,
      $$CountersTableUpdateCompanionBuilder,
      (Counter, BaseReferences<_$AppDatabase, $CountersTable, Counter>),
      Counter,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LeadsTableTableManager get leads =>
      $$LeadsTableTableManager(_db, _db.leads);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$FollowUpsTableTableManager get followUps =>
      $$FollowUpsTableTableManager(_db, _db.followUps);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$EmailTemplatesTableTableManager get emailTemplates =>
      $$EmailTemplatesTableTableManager(_db, _db.emailTemplates);
  $$EmailLogsTableTableManager get emailLogs =>
      $$EmailLogsTableTableManager(_db, _db.emailLogs);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$AppNotificationsTableTableManager get appNotifications =>
      $$AppNotificationsTableTableManager(_db, _db.appNotifications);
  $$CountersTableTableManager get counters =>
      $$CountersTableTableManager(_db, _db.counters);
}
