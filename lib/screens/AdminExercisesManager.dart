import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/theme/app_theme.dart';

class AdminExercisesManager extends StatefulWidget {
  const AdminExercisesManager({super.key});

  @override
  State<AdminExercisesManager> createState() => _AdminExercisesManagerState();
}

class _AdminExercisesManagerState extends State<AdminExercisesManager> {
  List<Map<String, dynamic>> _exercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('exercises').get();

      if (!mounted) return; // ✅ نتأكد إنه الشاشة لسه موجودة

      setState(() {
        _exercises = snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                })
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading exercises: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteExercise(String id) async {
    try {
      await FirebaseFirestore.instance.collection('exercises').doc(id).delete();
      _loadExercises();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ تم حذف التمرين'),
            backgroundColor: Color(0xff934800),
          ),
        );
      }
    } catch (e) {
      print('Error deleting: $e');
    }
  }

  void _confirmDelete(String id, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('تأكيد الحذف'),
        content: Text('هل تريدين حذف تمرين "$title"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteExercise(id);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openExerciseForm({Map<String, dynamic>? exercise}) {
    final bool isEditing = exercise != null;

    final titleController =
        TextEditingController(text: exercise?['title'] ?? '');
    final subtitleController = TextEditingController(
        text: exercise?['subtitle'] ?? exercise?['description'] ?? '');
    final durationController = TextEditingController(
        text: (exercise?['durationMinutes'] ?? 10).toString());
    final videoFileController =
        TextEditingController(text: exercise?['videoFile'] ?? '');
    final imageController =
        TextEditingController(text: exercise?['image'] ?? 'hand2.png');

    String selectedCategory = exercise?['category'] ?? 'physical_therapy';
    String selectedSubcategory = exercise?['subcategory'] ?? 'Mobility';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? 'تعديل التمرين' : 'إضافة تمرين جديد',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  _formLabel('اسم التمرين'),
                  _formField(controller: titleController),
                  const SizedBox(height: 14),
                  _formLabel('الوصف'),
                  _formField(controller: subtitleController, maxLines: 2),
                  const SizedBox(height: 14),
                  _formLabel('المدة (دقائق)'),
                  _formField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      isLtr: true),
                  const SizedBox(height: 14),
                  _formLabel('نوع التمرين'),
                  Row(
                    children: [
                      Expanded(
                        child: _categoryChip(
                          label: 'علاج طبيعي',
                          selected: selectedCategory == 'physical_therapy',
                          onTap: () => setModalState(
                              () => selectedCategory = 'physical_therapy'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _categoryChip(
                          label: 'إدراكي',
                          selected: selectedCategory == 'cognitive',
                          onTap: () => setModalState(
                              () => selectedCategory = 'cognitive'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _formLabel('التصنيف الفرعي'),
                  Row(
                    children: [
                      Expanded(
                        child: _categoryChip(
                          label: 'الحركة',
                          selected: selectedSubcategory == 'Mobility',
                          onTap: () => setModalState(
                              () => selectedSubcategory = 'Mobility'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _categoryChip(
                          label: 'القوة',
                          selected: selectedSubcategory == 'Strength',
                          onTap: () => setModalState(
                              () => selectedSubcategory = 'Strength'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _formLabel('اسم ملف الفيديو (مثال: exercise1.mp4)'),
                  _formField(controller: videoFileController, isLtr: true),
                  const SizedBox(height: 14),
                  _formLabel('اسم ملف الصورة (مثال: hand2.png)'),
                  _formField(controller: imageController, isLtr: true),
                  const SizedBox(height: 26),
                  GestureDetector(
                    onTap: () async {
                      if (titleController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('الرجاء إدخال اسم التمرين')),
                        );
                        return;
                      }

                      final data = {
                        'title': titleController.text.trim(),
                        'subtitle': subtitleController.text.trim(),
                        'durationMinutes':
                            int.tryParse(durationController.text.trim()) ?? 10,
                        'category': selectedCategory,
                        'subcategory': selectedSubcategory,
                        'videoFile': videoFileController.text.trim(),
                        'image': imageController.text.trim(),
                      };

                      try {
                        if (isEditing) {
                          await FirebaseFirestore.instance
                              .collection('exercises')
                              .doc(exercise['id'])
                              .update(data);
                        } else {
                          await FirebaseFirestore.instance
                              .collection('exercises')
                              .add(data);
                        }

                        if (mounted) {
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _loadExercises();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isEditing
                                      ? '✅ تم تحديث التمرين'
                                      : '✅ تمت إضافة التمرين'),
                                  backgroundColor: const Color(0xff934800),
                                ),
                              );
                            }
                          });
                        }
                      } catch (e) {
                        print('Error saving exercise: $e');
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xff934800),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          isEditing ? 'حفظ التعديلات' : 'إضافة التمرين',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _formLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xff414752),
        ),
      ),
    );
  }

  Widget _formField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isLtr = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Directionality(
        textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _categoryChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xff934800) : const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xff414752),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // ⬅️ الهيدر
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xff934800),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      "إدارة التمارين",
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: const Color(0xff1A1C1C),
                      ),
                    ),
                  ),
                  // ➕ زر إضافة تمرين جديد
                  GestureDetector(
                    onTap: () => _openExerciseForm(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xff934800),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff934800),
                      ),
                    )
                  : _exercises.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fitness_center_outlined,
                                  size: 64,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "ما في تمارين مضافة بعد",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          itemCount: _exercises.length,
                          itemBuilder: (context, index) {
                            final exercise = _exercises[index];
                            final isPhysical =
                                exercise['category'] == 'physical_therapy';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isPhysical
                                          ? const Color(0xffDCFCE7)
                                          : const Color(0xffDBEAFE),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      isPhysical
                                          ? Icons.back_hand_outlined
                                          : Icons.psychology_outlined,
                                      color: isPhysical
                                          ? const Color(0xff16A34A)
                                          : const Color(0xff2563EB),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          exercise['title'] ?? 'تمرين',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff1A1C1C),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${exercise['durationMinutes'] ?? 10} دقيقة  •  ${exercise['subcategory'] == 'Strength' ? 'القوة' : 'الحركة'}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        _openExerciseForm(exercise: exercise),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.edit_outlined,
                                        color: Color(0xff934800),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _confirmDelete(
                                        exercise['id'], exercise['title']),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
