import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/app_colors.dart';

class PaymentDialog extends StatefulWidget {
  final double amount;
  final String payerName;
  final String description;
  final VoidCallback onPaymentSuccess;

  const PaymentDialog({
    super.key,
    required this.amount,
    required this.payerName,
    required this.description,
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final TextEditingController _upiController = TextEditingController();
  bool _showQr = false;
  bool _isProcessing = false;
  String _currentUpiId = "";

  @override
  void dispose() {
    _upiController.dispose();
    super.dispose();
  }

  void _generateQr() {
    if (_upiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a UPI ID")),
      );
      return;
    }
    setState(() {
      _currentUpiId = _upiController.text;
      _showQr = true;
    });
  }

  Future<void> _confirmPayment() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Create Transaction Record
      await FirebaseFirestore.instance.collection('transactions').add({
        'amount': widget.amount,
        'payerName': widget.payerName,
        'description': widget.description,
        'mode': 'UPI',
        'upiId': _currentUpiId,
        'timestamp': FieldValue.serverTimestamp(),
        'transactionId': 'TXN${DateTime.now().millisecondsSinceEpoch}',
        'status': 'SUCCESS',
      });

      if (mounted) {
        widget.onPaymentSuccess();
        Navigator.pop(context); // Close Dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Successful! Transaction Saved.")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving transaction: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.inputBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "PAYMENT",
              style: GoogleFonts.langar(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.appGreen,
              ),
            ),
            const SizedBox(height: 16),
            
            // Amount
            Text(
              "Amount: ₹${widget.amount.toStringAsFixed(2)}",
              style: GoogleFonts.langar(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // UPI Input
            TextField(
              controller: _upiController,
              decoration: InputDecoration(
                labelText: "Enter UPI ID",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: const Color(0xFFE0E0E0),
              ),
            ),
             const SizedBox(height: 12),

            if (!_showQr)
              ElevatedButton(
                onPressed: _generateQr,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appGreen,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Generate QR"),
              ),

            // QR Code Area
            if (_showQr) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black12),
                ),
                child: QrImageView(
                  data: "upi://pay?pa=$_currentUpiId&pn=${widget.payerName}&am=${widget.amount}&cu=INR", // Standard UPI Intent
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _confirmPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CFC00),
                    foregroundColor: const Color(0xFF006400),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  child: _isProcessing 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(
                          "CONFIRM PAYMENT",
                          style: GoogleFonts.langar(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
