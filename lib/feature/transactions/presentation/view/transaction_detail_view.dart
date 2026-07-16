import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:xpiria_app/feature/transactions/domain/entity/order_transaction.dart';

class TransactionDetailView extends StatelessWidget {
  final OrderTransaction? transaction;
  final bool isEmpty;
  final bool backToHome;

  const TransactionDetailView({
    super.key,
    required OrderTransaction transaction,
    this.backToHome = false,
  })
    : transaction = transaction,
      isEmpty = false;

  const TransactionDetailView.empty({super.key})
    : transaction = null,
      isEmpty = true,
      backToHome = true;

  @override
  Widget build(BuildContext context) {
    if (isEmpty || transaction == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F9FC),
        appBar: AppBar(
          title: const Text('Detalle de transaccion'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('No se encontro la transaccion.'),
          ),
        ),
      );
    }

    final tx = transaction!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Detalle de transaccion'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (backToHome) {
              context.go('/');
              return;
            }

            context.pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_outlined),
            tooltip: 'Imprimir PDF',
            onPressed: () => _printPdf(tx),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF22A55A),
                        size: 34,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.status,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            Text(
                              _formatDate(tx.createdAt),
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(label: 'ID', value: tx.id),
                  _InfoRow(label: 'Usuario', value: tx.userId),
                  _InfoRow(
                    label: 'Total',
                    value:
                        '\$${tx.amount.toStringAsFixed(2)} ${tx.currency}',
                  ),
                  if (tx.message.isNotEmpty)
                    _InfoRow(label: 'Mensaje', value: tx.message),
                  if (_hasShippingInfo(tx)) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    const Text(
                      'Datos del cliente',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_hasText(tx.shippingFullName))
                      _InfoRow(label: 'Nombre', value: tx.shippingFullName!),
                    if (_hasText(tx.shippingAddress))
                      _InfoRow(label: 'Direccion', value: tx.shippingAddress!),
                    if (_hasText(tx.shippingCity))
                      _InfoRow(label: 'Ciudad', value: tx.shippingCity!),
                    if (_hasText(tx.shippingZipCode))
                      _InfoRow(label: 'ZIP', value: tx.shippingZipCode!),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Panel(
              title: 'Productos',
              child: Column(
                children: tx.items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A1A2E),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item.colorName} - ${item.size}',
                                    style: const TextStyle(
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${item.quantity} x \$${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _printPdf(tx),
                icon: const Icon(Icons.print_outlined),
                label: const Text('Imprimir como PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _printPdf(OrderTransaction transaction) {
    return Printing.layoutPdf(
      name: 'comprobante-${transaction.id}.pdf',
      onLayout: (_) => _buildPdf(transaction),
    );
  }

  Future<Uint8List> _buildPdf(OrderTransaction transaction) async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Comprobante de compra',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text('Transaccion: ${transaction.id}'),
              pw.Text('Estado: ${transaction.status}'),
              pw.Text('Fecha: ${_formatDate(transaction.createdAt)}'),
              pw.Text('Usuario: ${transaction.userId}'),
              if (_hasShippingInfo(transaction)) ...[
                pw.SizedBox(height: 12),
                pw.Text(
                  'Datos del cliente',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                if (_hasText(transaction.shippingFullName))
                  pw.Text('Nombre: ${transaction.shippingFullName}'),
                if (_hasText(transaction.shippingAddress))
                  pw.Text('Direccion: ${transaction.shippingAddress}'),
                if (_hasText(transaction.shippingCity))
                  pw.Text('Ciudad: ${transaction.shippingCity}'),
                if (_hasText(transaction.shippingZipCode))
                  pw.Text('ZIP: ${transaction.shippingZipCode}'),
              ],
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                headers: ['Producto', 'Detalle', 'Cantidad', 'Precio'],
                data: transaction.items
                    .map(
                      (item) => [
                        item.name,
                        '${item.colorName} - ${item.size}',
                        item.quantity.toString(),
                        '\$${item.price.toStringAsFixed(2)}',
                      ],
                    )
                    .toList(),
              ),
              pw.SizedBox(height: 18),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total: \$${transaction.amount.toStringAsFixed(2)} ${transaction.currency}',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  String _formatDate(DateTime? value) {
    if (value == null) return 'Pendiente';

    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();

    return '$day/$month/$year';
  }

  bool _hasShippingInfo(OrderTransaction transaction) {
    return _hasText(transaction.shippingFullName) ||
        _hasText(transaction.shippingAddress) ||
        _hasText(transaction.shippingCity) ||
        _hasText(transaction.shippingZipCode);
  }

  bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _Panel extends StatelessWidget {
  final String? title;
  final Widget child;

  const _Panel({required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E6EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 12),
          ],
          child,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 86,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
