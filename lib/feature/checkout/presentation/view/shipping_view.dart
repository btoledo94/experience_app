import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/checkout_stepper.dart';

class ShippingView extends StatefulWidget {
  const ShippingView({super.key});

  @override
  State<ShippingView> createState() => _ShippingViewState();
}

class _ShippingViewState extends State<ShippingView> {
  static const _nameKey = 'shipping_full_name';
  static const _addressKey = 'shipping_address';
  static const _cityKey = 'shipping_city';
  static const _zipKey = 'shipping_zip_code';
  static const _collection = 'shipping_profiles';

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSavedShippingAddress();
  }

  Future<void> _loadSavedShippingAddress() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    _nameController.text = prefs.getString(_nameKey) ?? '';
    _addressController.text = prefs.getString(_addressKey) ?? '';
    _cityController.text = prefs.getString(_cityKey) ?? '';
    _zipController.text = prefs.getString(_zipKey) ?? '';

    await _loadRemoteShippingAddress();
  }

  Future<void> _loadRemoteShippingAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection(_collection)
        .doc(user.uid)
        .get();

    if (!mounted || !snapshot.exists) return;

    final data = snapshot.data() ?? {};
    final fullName = data['fullName'] as String?;
    final address = data['address'] as String?;
    final city = data['city'] as String?;
    final zipCode = data['zipCode'] as String?;

    _nameController.text = fullName ?? _nameController.text;
    _addressController.text = address ?? _addressController.text;
    _cityController.text = city ?? _cityController.text;
    _zipController.text = zipCode ?? _zipController.text;

    await _saveShippingAddressLocally();
  }

  Future<void> _saveShippingAddress() async {
    await _saveShippingAddressLocally();
    await _saveShippingAddressRemotely();
  }

  Future<void> _saveShippingAddressLocally() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_nameKey, _nameController.text.trim());
    await prefs.setString(_addressKey, _addressController.text.trim());
    await prefs.setString(_cityKey, _cityController.text.trim());
    await prefs.setString(_zipKey, _zipController.text.trim());
  }

  Future<void> _saveShippingAddressRemotely() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection(_collection).doc(user.uid).set({
      'userId': user.uid,
      'email': user.email,
      'fullName': _nameController.text.trim(),
      'address': _addressController.text.trim(),
      'city': _cityController.text.trim(),
      'zipCode': _zipController.text.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _continueToPayment() async {
    setState(() => _isSaving = true);

    try {
      await _saveShippingAddress();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo guardar la direccion de envio.'),
        ),
      );
      setState(() => _isSaving = false);
      return;
    }

    if (!mounted) return;

    setState(() => _isSaving = false);
    context.push('/checkout/payment');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 90,
        leading: TextButton(
          onPressed: () => context.go('/cart'),
          child: const Text('Cancel'),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const CheckoutStepper(currentStep: 1),
              const SizedBox(height: 28),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Shipping address',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildField('Full name', _nameController),
                      const SizedBox(height: 12),
                      _buildField('Address', _addressController),
                      const SizedBox(height: 12),
                      _buildField('City', _cityController),
                      const SizedBox(height: 12),
                      _buildField('ZIP Code', _zipController),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _continueToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A73E8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Continue to Payment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD8DEE8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD8DEE8)),
        ),
      ),
    );
  }
}
