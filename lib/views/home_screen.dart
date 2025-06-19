import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/note_view_model.dart';
import '../models/note.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/hand_painted_card.dart';
import '../widgets/celebrating_checkbox.dart';
import '../widgets/hover_bounce_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final List<Color> babyColors = [
    Color.fromARGB(255, 251, 222, 255), // LavenderBlush
    Color(0xFFFFE4E1), // MistyRose
    Color(0xFFFFF5E6), // Peach
    Color(0xFFE0FFFF), // LightCyan
    Color(0xFFFFFACD), // LemonChiffon
    Color(0xFFE6E6FA), // Lavender
    Color(0xFFDCF8C6), // LightGreen
    Color(0xFFFFDAB9), // PeachPuff
  ];
  bool _celebrationShown = false;
  bool _showCelebrationGif = false;

  void _triggerCelebration() {
    setState(() {
      _showCelebrationGif = true;
      _celebrationShown = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NoteViewModel>(context);
    bool _celebrationShown = false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "To-Do List",
          style: GoogleFonts.indieFlower(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<List<Note>>(
            stream: viewModel.notes,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final notes = snapshot.data!;
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, i) {
                  final note = notes[i];
                  return HoverBounceCard(
                    child: HandPaintedCard(
                      backgroundColor:
                          (note.checked)
                              ? const Color.fromARGB(255, 206, 255, 207)
                              : note.color,
                      child: ListTile(
                        leading: CelebratingCheckbox(
                          value: note.checked,
                          onChanged: (value) {
                            if (value != null) {
                              final Note update = Note(
                                id: note.id,
                                title: note.title,
                                description: note.description,
                                checked: value,
                                color: note.color,
                              );
                              viewModel.updateNote(update);
                            }
                          },
                        ),
                        title: Text(
                          note.title,
                          style: GoogleFonts.indieFlower(
                            color: const Color.fromARGB(194, 37, 34, 34),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle:
                            (note.description.trim().isEmpty)
                                ? null
                                : Text(
                                  note.description,
                                  style: GoogleFonts.indieFlower(
                                    color: const Color.fromARGB(
                                      194,
                                      37,
                                      34,
                                      34,
                                    ),
                                  ),
                                ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              hoverColor: Colors.orange,
                              onPressed: () {
                                titleController.text = note.title;
                                descController.text = note.description;
                                _showStickyNoteModal(
                                  context,
                                  viewModel,
                                  isUpdate: true,
                                  note: note,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              hoverColor: Colors.red,
                              onPressed: () => viewModel.deleteNote(note.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          StreamBuilder<bool>(
            stream: viewModel.allNotesChecked,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == true && !_celebrationShown) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) _triggerCelebration();
                  });
                } else if (snapshot.data == false) {
                  _celebrationShown = false;
                  _showCelebrationGif = false;
                }
              }

              return _showCelebrationGif
                  ? Positioned(
                    bottom: -150,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'assets/images/celebrate.gif',
                        width: MediaQuery.of(context).size.width * 0.9,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.clear();
          descController.clear();
          _showStickyNoteModal(context, viewModel);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showStickyNoteModal(
    BuildContext context,
    NoteViewModel viewModel, {
    bool isUpdate = false,
    Note? note,
  }) {
    Color selectedColor = note?.color ?? babyColors.first;
    titleController.text = note?.title ?? "";
    descController.text = note?.description ?? "";
    final _formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          behavior:
              HitTestBehavior
                  .opaque, // Ensures tap is detected outside the child
          onTap: () => Navigator.of(context).pop(),
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(4, 6),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Center(
                          child: Text(
                            isUpdate ? "Update Note" : "Add Note",
                            style: GoogleFonts.indieFlower(
                              color: const Color.fromARGB(194, 37, 34, 34),
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Things to do',
                            labelStyle: GoogleFonts.indieFlower(
                              color: Color.fromARGB(194, 37, 34, 34),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: descController,
                          decoration: InputDecoration(
                            labelText: 'Add description ...',
                            labelStyle: GoogleFonts.indieFlower(
                              color: Color.fromARGB(194, 37, 34, 34),
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            children:
                                babyColors.map((color) {
                                  final isSelected = selectedColor == color;

                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        selectedColor = color;
                                        (context as Element)
                                            .markNeedsBuild(); // Force rebuild
                                      },
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: color,
                                          border: Border.all(
                                            color: darken(
                                              color,
                                              0.2,
                                            ), // Slightly darker border
                                            width: 2,
                                          ),
                                        ),
                                        child:
                                            isSelected
                                                ? const Icon(
                                                  Icons.check,
                                                  size: 18,
                                                  color: Colors.black,
                                                )
                                                : null,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Inputs are valid
                                if (isUpdate && note != null) {
                                  viewModel.updateNote(
                                    Note(
                                      id: note.id,
                                      title: titleController.text,
                                      description: descController.text,
                                      checked: note.checked,
                                      color: selectedColor,
                                    ),
                                  );
                                } else {
                                  if (isUpdate && note != null) {
                                    final updated = Note(
                                      id: note.id,
                                      title: titleController.text,
                                      description: descController.text,
                                      checked: note.checked,
                                      color: selectedColor,
                                    );
                                    viewModel.updateNote(updated);
                                  } else {
                                    viewModel.addNote(
                                      titleController.text,
                                      descController.text,
                                      selectedColor,
                                    );
                                  }
                                }
                                Navigator.of(context).pop();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: const BorderSide(
                                  color: Colors.brown, // pencil-like border
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Text(
                              isUpdate ? "Update" : "Add",
                              style: GoogleFonts.indieFlower(
                                color: Color.fromARGB(194, 37, 34, 34),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Darkens a [color] by [amount] (0.0 to 1.0)
  Color darken(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final darker = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darker.toColor();
  }
}
