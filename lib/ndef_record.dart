import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:vietqr_sms/extensions.dart';
import 'package:vietqr_sms/record.dart';

class NdefRecordPage extends StatelessWidget {
  const NdefRecordPage(this.index, this.record, {super.key});

  final int index;

  final NdefRecord record;

  @override
  Widget build(BuildContext context) {
    final info = NdefRecordInfo.fromNdef(record);
    return Scaffold(
      appBar: AppBar(
        title: Text('Record #$index'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _RecordColumn(
            title: Text(info.title),
            subtitle: Text(info.subtitle),
          ),
          const SizedBox(height: 12),
          _RecordColumn(
            title: const Text('Size'),
            subtitle: Text('${record.byteLength} bytes'),
          ),
          const SizedBox(height: 12),
          _RecordColumn(
            title: const Text('Type Name Format'),
            subtitle: Text(record.typeNameFormat.index.toHexString()),
          ),
          const SizedBox(height: 12),
          _RecordColumn(
            title: const Text('Type'),
            subtitle: Text(record.type.toHexString()),
          ),
          const SizedBox(height: 12),
          _RecordColumn(
            title: const Text('Identifier'),
            subtitle: Text(record.identifier.toHexString()),
          ),
          const SizedBox(height: 12),
          _RecordColumn(
            title: const Text('Payload'),
            subtitle: Text(record.payload.toHexString()),
          ),
        ],
      ),
    );
  }
}

class _RecordColumn extends StatelessWidget {
  const _RecordColumn({required this.title, required this.subtitle});

  final Widget title;

  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
          child: title,
        ),
        const SizedBox(height: 2),
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15),
          child: subtitle,
        ),
      ],
    );
  }
}

class NdefRecordInfo {
  const NdefRecordInfo(
      {required this.record, required this.title, required this.subtitle});

  final Record record;

  final String title;

  final String subtitle;

  static NdefRecordInfo fromNdef(NdefRecord record) {
    final _record = Record.fromNdef(record);
    if (_record is WellKnownTextRecord) {
      return NdefRecordInfo(
        record: _record,
        title: 'Wellknown Text',
        subtitle: '(${_record.languageCode}) ${_record.text}',
      );
    }
    if (_record is WellknownUriRecord) {
      return NdefRecordInfo(
        record: _record,
        title: 'Wellknown Uri',
        subtitle: '${_record.uri}',
      );
    }
    if (_record is MimeRecord) {
      return NdefRecordInfo(
        record: _record,
        title: 'Mime',
        subtitle: '(${_record.type}) ${_record.dataString}',
      );
    }
    if (_record is AbsoluteUriRecord) {
      return NdefRecordInfo(
        record: _record,
        title: 'Absolute Uri',
        subtitle: '(${_record.uriType}) ${_record.payloadString}',
      );
    }
    if (_record is ExternalRecord) {
      return NdefRecordInfo(
        record: _record,
        title: 'External',
        subtitle: '(${_record.domainType}) ${_record.dataString}',
      );
    }
    if (_record is UnsupportedRecord) {
      // more custom info from NdefRecord.
      if (record.typeNameFormat == NdefTypeNameFormat.empty) {
        return NdefRecordInfo(
          record: _record,
          title: _typeNameFormatToString(_record.record.typeNameFormat),
          subtitle: '-',
        );
      }
      return NdefRecordInfo(
        record: _record,
        title: _typeNameFormatToString(_record.record.typeNameFormat),
        subtitle:
            '(${_record.record.type.toHexString()}) ${_record.record.payload.toHexString()}',
      );
    }
    throw UnimplementedError();
  }
}

String _typeNameFormatToString(NdefTypeNameFormat format) {
  switch (format) {
    case NdefTypeNameFormat.empty:
      return 'Empty';
    case NdefTypeNameFormat.nfcWellknown:
      return 'NFC Wellknown';
    case NdefTypeNameFormat.media:
      return 'Media';
    case NdefTypeNameFormat.absoluteUri:
      return 'Absolute Uri';
    case NdefTypeNameFormat.nfcExternal:
      return 'NFC External';
    case NdefTypeNameFormat.unknown:
      return 'Unknown';
    case NdefTypeNameFormat.unchanged:
      return 'Unchanged';
  }
}
