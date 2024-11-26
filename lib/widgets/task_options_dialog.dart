import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskOptionsDialog extends StatelessWidget {
  final Function() onDelete;

  const TaskOptionsDialog({
    Key? key,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.centerRight,
      insetPadding: EdgeInsets.only(
        right: 40,
        left: MediaQuery.of(context).size.width * 0.4,
        top: MediaQuery.of(context).size.height * 0.4,
        bottom: MediaQuery.of(context).size.height * 0.4,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                // Edit functionality can be added here
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: Color(0xFF515152),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Edit',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF515152),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEFECF8)),
            InkWell(
              onTap: () {
                onDelete();
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Color(0xFFEA4335),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Delete',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFEA4335),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}