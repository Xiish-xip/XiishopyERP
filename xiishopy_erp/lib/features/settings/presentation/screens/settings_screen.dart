import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/config/routes.dart';
import '../../../../core/constants/enums.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedCategory = 0;

  final _categories = [
    'Company Profile',
    'Business Rules',
    'Payment Config',
    'Shipping Config',
    'Notification Rules',
    'Tax & Compliance',
    'Localization',
    'Security',
    'UI Theme',
  ];

  final _categoryIcons = [
    Icons.business,
    Icons.rule,
    Icons.payment,
    Icons.local_shipping,
    Icons.notifications,
    Icons.receipt_long,
    Icons.language,
    Icons.security,
    Icons.palette,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Settings',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save All',
            onPressed: _showSaveConfirmation,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'export') _exportSettings();
              if (value == 'import') _importSettings();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'export', child: Text('Export Settings')),
              const PopupMenuItem(value: 'import', child: Text('Import Settings')),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          // Category sidebar
          Container(
            width: 220,
            color: const Color(0xFF16213E),
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Material(
                  color: _selectedCategory == index
                      ? const Color(0xFF0F3460)
                      : Colors.transparent,
                  child: ListTile(
                    leading: Icon(_categoryIcons[index],
                        color: _selectedCategory == index
                            ? Colors.white
                            : Colors.white54,
                        size: 20),
                    title: Text(_categories[index],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: _selectedCategory == index
                              ? Colors.white
                              : Colors.white54,
                        )),
                    onTap: () => setState(() => _selectedCategory = index),
                  ),
                );
              },
            ),
          ),
          // Settings content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildSettingsContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent() {
    switch (_selectedCategory) {
      case 0:
        return _buildCompanyProfile();
      case 1:
        return _buildBusinessRules();
      case 2:
        return _buildPaymentConfig();
      case 3:
        return _buildShippingConfig();
      case 4:
        return _buildNotificationRules();
      case 5:
        return _buildTaxCompliance();
      case 6:
        return _buildLocalization();
      case 7:
        return _buildSecurity();
      case 8:
        return _buildUITheme();
      default:
        return _buildCompanyProfile();
    }
  }

  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(subtitle,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: Colors.white54)),
          ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSettingCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField(String label, String value,
      {bool multiline = false, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: TextEditingController(text: value),
        maxLines: multiline ? 3 : 1,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.white54),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF0F3460)),
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.03),
        ),
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.white)),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF0F3460),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: items.contains(value) ? value : items.first,
        dropdownColor: const Color(0xFF16213E),
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.white54),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF0F3460)),
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.03),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildCompanyProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Company Profile',
            subtitle: 'Business identity and contact information'),
        _buildSettingCard([
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3460),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.business, color: Colors.white54),
                ),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logo upload dialog opened'), backgroundColor: Colors.blue),
                  );
                },
                icon: const Icon(Icons.upload),
                label: const Text('Upload Logo'),
                style: TextButton.styleFrom(foregroundColor: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField('Company Name', 'Xiishopy Enterprises'),
          _buildTextField('Address', '123 Commerce Street, Dar es Salaam',
              multiline: true),
          _buildTextField('Phone', '+255 712 345 678'),
          _buildTextField('Email', 'info@xiishopy.com'),
          _buildTextField('Tax ID', 'TIN-123456789'),
          _buildTextField('Website', 'https://xiishopy.com'),
        ]),
      ],
    );
  }

  Widget _buildBusinessRules() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Business Rules',
            subtitle: 'Configure core business logic and thresholds'),
        _buildSettingCard([
          _buildTextField('Low Stock Threshold', '10',
              keyboardType: TextInputType.number),
          _buildTextField('Default Currency', 'TZS'),
          _buildTextField('Order Approval Limit', '10000',
              keyboardType: TextInputType.number),
          _buildTextField('Credit Limit Default', '50000',
              keyboardType: TextInputType.number),
          _buildTextField('Max Discount Percentage', '25',
              keyboardType: TextInputType.number),
          _buildSwitch('Require Order Approval', false, (v) {}),
          _buildSwitch('Enable Credit Sales', true, (v) {}),
          _buildSwitch('Auto-generate Purchase Orders', false, (v) {}),
        ]),
      ],
    );
  }

  Widget _buildPaymentConfig() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Payment Configuration',
            subtitle: 'Manage payment methods and gateway settings'),
        _buildSettingCard([
          _buildSwitch('M-Pesa', true, (v) {}),
          _buildSwitch('Airtel Money', true, (v) {}),
          _buildSwitch('Selcom', true, (v) {}),
          _buildSwitch('Pesapal', false, (v) {}),
          _buildSwitch('Bank Transfer', true, (v) {}),
          _buildSwitch('Cash on Delivery', true, (v) {}),
          const Divider(color: Colors.white12),
          _buildTextField('Payment Processing Fee (%)', '2.5',
              keyboardType: TextInputType.number),
          _buildTextField('Minimum Payment Amount', '1000',
              keyboardType: TextInputType.number),
          _buildSwitch('Enable Payment Reminders', true, (v) {}),
          _buildSwitch('Enable Installment Plans', false, (v) {}),
        ]),
      ],
    );
  }

  Widget _buildShippingConfig() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Shipping Configuration',
            subtitle: 'Configure carriers, zones, and delivery rules'),
        _buildSettingCard([
          _buildSwitch('Enable Shipping Tracking', true, (v) {}),
          _buildSwitch('Auto-assign Carrier', false, (v) {}),
          _buildTextField('Default Shipping Carrier', 'Express Logistics'),
          _buildTextField('Free Shipping Threshold', '50000',
              keyboardType: TextInputType.number),
          _buildTextField('Standard Delivery Time (days)', '3',
              keyboardType: TextInputType.number),
          _buildTextField('Express Delivery Time (days)', '1',
              keyboardType: TextInputType.number),
          _buildDropdown('Default Shipping Zone', 'Domestic',
              ['Domestic', 'East Africa', 'International']),
        ]),
      ],
    );
  }

  Widget _buildNotificationRules() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Notification Rules',
            subtitle: 'Configure alert triggers and delivery channels'),
        _buildSettingCard([
          _buildSwitch('Push Notifications', true, (v) {}),
          _buildSwitch('Email Notifications', true, (v) {}),
          _buildSwitch('SMS Notifications', false, (v) {}),
          const Divider(color: Colors.white12),
          _buildSwitch('Low Stock Alerts', true, (v) {}),
          _buildTextField('Low Stock Alert Threshold', '10',
              keyboardType: TextInputType.number),
          _buildSwitch('Order Status Updates', true, (v) {}),
          _buildSwitch('Payment Confirmation', true, (v) {}),
          _buildSwitch('New Registration Alerts', true, (v) {}),
        ]),
      ],
    );
  }

  Widget _buildTaxCompliance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Tax & Compliance',
            subtitle: 'Tax rates, VAT settings, and regional compliance'),
        _buildSettingCard([
          _buildTextField('Default Tax Rate (%)', '18',
              keyboardType: TextInputType.number),
          _buildTextField('VAT Registration Number', 'VAT-TZ-123456789'),
          _buildDropdown('Tax Calculation Method', 'Inclusive',
              ['Inclusive', 'Exclusive']),
          _buildSwitch('Enable Automated Tax Filing', false, (v) {}),
          _buildSwitch('Include Tax in Reports', true, (v) {}),
          const Divider(color: Colors.white12),
          Text('Regional Tax Rates',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70)),
          const SizedBox(height: 12),
          _buildTextField('Tanzania (VAT %)', '18',
              keyboardType: TextInputType.number),
          _buildTextField('Kenya (VAT %)', '16',
              keyboardType: TextInputType.number),
          _buildTextField('Uganda (VAT %)', '18',
              keyboardType: TextInputType.number),
          _buildTextField('Rwanda (VAT %)', '18',
              keyboardType: TextInputType.number),
        ]),
      ],
    );
  }

  Widget _buildLocalization() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Localization',
            subtitle: 'Language, currency, and regional format settings'),
        _buildSettingCard([
          _buildDropdown('Default Language', 'English',
              ['English', 'Swahili', 'French', 'Arabic']),
          _buildDropdown('Default Currency', 'TZS (Tanzanian Shilling)',
              ['TZS (Tanzanian Shilling)', 'KES (Kenyan Shilling)', 'UGX (Ugandan Shilling)', 'RWF (Rwandan Franc)', 'USD (US Dollar)']),
          _buildDropdown('Date Format', 'DD/MM/YYYY',
              ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD']),
          _buildDropdown('Time Format', '24-hour',
              ['24-hour', '12-hour (AM/PM)']),
          _buildDropdown('Number Format', '1,234.56',
              ['1,234.56', '1 234,56', '1.234,56']),
          _buildDropdown('Week Starts On', 'Monday',
              ['Monday', 'Sunday', 'Saturday']),
        ]),
      ],
    );
  }

  Widget _buildSecurity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Security',
            subtitle: 'Authentication, session, and access control settings'),
        _buildSettingCard([
          _buildSwitch('Enable Two-Factor Authentication', false, (v) {}),
          _buildSwitch('Enable Biometric Authentication', false, (v) {}),
          _buildTextField('Session Timeout (minutes)', '60',
              keyboardType: TextInputType.number),
          _buildTextField('Password Minimum Length', '8',
              keyboardType: TextInputType.number),
          _buildSwitch('Require Special Characters', true, (v) {}),
          _buildSwitch('Require Numbers in Password', true, (v) {}),
          _buildSwitch('Enable Audit Trail', true, (v) {}),
          _buildSwitch('IP Whitelist for Admin', false, (v) {}),
          const Divider(color: Colors.white12),
          Text('Admin Security',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70)),
          const SizedBox(height: 12),
          _buildTextField('Max Login Attempts', '5',
              keyboardType: TextInputType.number),
          _buildTextField('Lockout Duration (minutes)', '30',
              keyboardType: TextInputType.number),
        ]),
      ],
    );
  }

  Widget _buildUITheme() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('UI Theme',
            subtitle: 'Customize the application appearance'),
        _buildSettingCard([
          _buildDropdown('Theme Mode', 'Dark',
              ['Dark', 'Light', 'System Default']),
          _buildDropdown('Primary Color', 'Navy Blue (#0F3460)',
              ['Navy Blue (#0F3460)', 'Deep Purple (#1A1A2E)', 'Teal (#008080)', 'Crimson (#DC143C)']),
          _buildDropdown('Accent Color', 'Red (#E94560)',
              ['Red (#E94560)', 'Gold (#FFD700)', 'Green (#22C55E)', 'Blue (#3B82F6)']),
          _buildDropdown('Font Family', 'Poppins',
              ['Poppins', 'Inter', 'Roboto', 'Open Sans']),
          _buildDropdown('Layout Density', 'Comfortable',
              ['Compact', 'Comfortable', 'Spacious']),
          _buildSwitch('Show Scrollbars', true, (v) {}),
          _buildSwitch('Enable Animations', true, (v) {}),
          _buildSwitch('Show Page Transitions', true, (v) {}),
        ]),
      ],
    );
  }

  void _showSaveConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        title: Text('Save Settings',
            style: GoogleFonts.poppins(color: Colors.white)),
        content: Text('All settings will be saved and applied immediately.',
            style: GoogleFonts.poppins(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Settings saved successfully',
                      style: GoogleFonts.poppins()),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3460),
            ),
            child: Text('Save',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _exportSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings exported as JSON',
            style: GoogleFonts.poppins()),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _importSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings import started',
            style: GoogleFonts.poppins()),
        backgroundColor: Colors.blue,
      ),
    );
  }
}