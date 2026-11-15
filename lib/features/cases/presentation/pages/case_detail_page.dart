
import 'package:flutter/material.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/case.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/add_note.dart';
import '../../domain/usecases/get_notes.dart';
import '../widgets/case_list_item.dart' show StatusPill;
import '../widgets/note_tile.dart';

class CaseDetailPage extends StatefulWidget {
  final Case caseItem;
  final GetNotes getNotes;
  final AddNote addNote;

  const CaseDetailPage({
    super.key,
    required this.caseItem,
    required this.getNotes,
    required this.addNote,
  });

  @override
  State<CaseDetailPage> createState() => _CaseDetailPageState();
}

class _CaseDetailPageState extends State<CaseDetailPage> {
  final TextEditingController _controller = TextEditingController();
  late Future<List<Note>> _notesFuture;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _notesFuture = widget.getNotes(widget.caseItem.id);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.addNote(widget.caseItem.id, _controller.text);
      if (!mounted) return;
      _controller.clear();
      setState(() {
        _notesFuture = widget.getNotes(widget.caseItem.id);
      });
    } on AppException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage('Could not save the note. Please try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Case #${widget.caseItem.id}')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _CaseInfoCard(caseItem: widget.caseItem),
                const SizedBox(height: 24),
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<Note>>(
                  future: _notesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: AppColors.navy),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      final e = snapshot.error;
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          e is AppException ? e.message : 'Could not load notes.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.red),
                        ),
                      );
                    }
                    final notes = snapshot.data!;
                    if (notes.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            'No notes yet. Add the first one below.',
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: [for (final n in notes) NoteTile(note: n)],
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Add a note...',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _saving ? null : _save,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      foregroundColor: Colors.white,
                    ),
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CaseInfoCard extends StatelessWidget {
  final Case caseItem;

  const _CaseInfoCard({required this.caseItem});

  @override
  Widget build(BuildContext context) {
    final isActive = caseItem.status == 'active';
    final title = caseItem.title.isEmpty
        ? caseItem.title
        : caseItem.title[0].toUpperCase() + caseItem.title.substring(1);
    final status =
        caseItem.status[0].toUpperCase() + caseItem.status.substring(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CASE #${caseItem.id}',
            style: const TextStyle(
              fontSize: 11,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          StatusPill(
            label: status,
            color: isActive ? AppColors.green : AppColors.textGrey,
            background:
                isActive ? AppColors.greenBg : const Color(0xFFECEFF3),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _InfoRow(label: 'Case ID', value: '#${caseItem.id}'),
          const SizedBox(height: 10),
          _InfoRow(
            label: 'Client ID',
            value: caseItem.clientId == 0 ? 'Not available' : '#${caseItem.clientId}',
          ),
          const SizedBox(height: 10),
          _InfoRow(label: 'Status', value: status),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: const TextStyle(color: AppColors.textGrey)),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
