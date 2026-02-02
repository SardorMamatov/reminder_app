import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder_app/features/calendar/presentation/bloc/calendar_bloc.dart';

import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/event_entity.dart';
import '../bloc/calendar_event.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key, required this.initialDay, this.existing});

  final DateTime initialDay;
  final EventEntity? existing;

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  late DateTime _startAt;
  late DateTime _endAt;
  int _colorHex = 0xFF2196F3;
  int _remind = 15;
  String? _titleError;
  String? _timeError;

  bool get isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;

    if (e != null) {
      _titleCtrl.text = e.title;
      _descCtrl.text = e.description ?? '';
      _locationCtrl.text = e.location ?? '';
      _startAt = e.startAt;
      _endAt = e.endAt;
      _colorHex = e.colorHex;
      _remind = e.remindMinutesBefore;
    } else {
      final d = widget.initialDay;
      _startAt = DateTime(d.year, d.month, d.day, 17, 0);
      _endAt = DateTime(d.year, d.month, d.day, 18, 0);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool isStart}) async {
    final base = isStart ? _startAt : _endAt;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: base.hour, minute: base.minute),
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked == null) return;

    setState(() {
      final updated = DateTime(
        base.year,
        base.month,
        base.day,
        picked.hour,
        picked.minute,
      );
      if (isStart) {
        _startAt = updated;
        if (_endAt.isBefore(_startAt))
          _endAt = _startAt.add(const Duration(hours: 1));
      } else {
        _endAt = updated;
        if (_endAt.isBefore(_startAt))
          _startAt = _endAt.subtract(const Duration(hours: 1));
      }
    });
  }

  void _save() {
    setState(() {
      _titleError = null;
      _timeError = null;
    });

    final title = _titleCtrl.text.trim();

    if (title.isEmpty) {
      setState(() => _titleError = 'Event name is required');
      return;
    }

    if (_endAt.isBefore(_startAt)) {
      setState(() => _timeError = 'End time must be after start time');
      return;
    }

    final now = DateTime.now();
    final old = widget.existing;

    final event = EventEntity(
      id: old?.id,
      title: title,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      location: _locationCtrl.text.trim().isEmpty
          ? null
          : _locationCtrl.text.trim(),
      startAt: _startAt,
      endAt: _endAt,
      colorHex: _colorHex,
      remindMinutesBefore: _remind,
      createdAt: old?.createdAt ?? now,
      updatedAt: now,
    );

    final bloc = context.read<EventBloc>();
    if (isEdit) {
      bloc.add(UpdateEventRequested(event));
    } else {
      bloc.add(CreateEventRequested(event));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String hhmm(DateTime d) =>
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(isEdit ? 'Edit event' : 'Add event')),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        children: [
          AppTextField(
            label: 'Event name',
            hint: 'Enter event title',
            controller: _titleCtrl,
            errorText: _titleError,
          ),

          const SizedBox(height: 12),
          AppTextField(
            label: 'Event description',
            hint: 'Optional',
            controller: _descCtrl,
            maxLines: 4,
          ),

          const SizedBox(height: 12),
          AppTextField(
            label: 'Event location',
            hint: 'Optional',
            controller: _locationCtrl,
            suffix: const Icon(Icons.place_outlined),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<int>(
            value: _remind,
            decoration: const InputDecoration(labelText: 'Reminder'),
            items: const [
              DropdownMenuItem(value: 0, child: Text('No reminder')),
              DropdownMenuItem(value: 5, child: Text('5 minutes before')),
              DropdownMenuItem(value: 10, child: Text('10 minutes before')),
              DropdownMenuItem(value: 15, child: Text('15 minutes before')),
              DropdownMenuItem(value: 30, child: Text('30 minutes before')),
            ],
            onChanged: (v) => setState(() => _remind = v ?? 15),
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<int>(
            value: _colorHex,
            decoration: const InputDecoration(labelText: 'Priority color'),
            items: const [
              DropdownMenuItem(value: 0xFF2196F3, child: Text('Blue')),
              DropdownMenuItem(value: 0xFFFF5722, child: Text('Orange')),
              DropdownMenuItem(value: 0xFFFFC107, child: Text('Amber')),
              DropdownMenuItem(value: 0xFF4CAF50, child: Text('Green')),
            ],
            onChanged: (v) => setState(() => _colorHex = v ?? 0xFF2196F3),
          ),

          const SizedBox(height: 12),

          AppTextField(
            label: 'Start time',
            hint: hhmm(_startAt),
            readOnly: true,
            onTap: () => _pickTime(isStart: true),
            suffix: const Icon(Icons.access_time),
          ),

          const SizedBox(height: 12),

          AppTextField(
            label: 'End time',
            hint: hhmm(_endAt),
            readOnly: true,
            onTap: () => _pickTime(isStart: false),
            suffix: const Icon(Icons.access_time),
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              backgroundColor: const Color(0xFF1E88E5),
              foregroundColor: Colors.white,
            ),
            child: Text(isEdit ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }
}
