/// Xiishopy ERP - AI Assistant Service
/// Provides an AI-powered chat assistant that can:
/// - Process natural language queries about ERP data
/// - Classify user intents (query data, create records, navigate screens)
/// - Extract entities from text (product names, order IDs, dates, amounts)
/// - Generate contextual responses based on Firestore data
/// 
/// This service can be called by any AI/LLM tool to interact with the ERP system.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Represents a parsed user intent
class AssistantIntent {
  final String action; // query, create, navigate, analyze, help
  final String entity; // product, order, customer, payment, shipment, hr, report
  final Map<String, dynamic> parameters;
  final double confidence;

  const AssistantIntent({
    required this.action,
    required this.entity,
    this.parameters = const {},
    this.confidence = 1.0,
  });

  factory AssistantIntent.fromJson(Map<String, dynamic> json) => AssistantIntent(
    action: json['action'] as String? ?? 'help',
    entity: json['entity'] as String? ?? 'general',
    parameters: json['parameters'] as Map<String, dynamic>? ?? {},
    confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
  );

  Map<String, dynamic> toJson() => {
    'action': action,
    'entity': entity,
    'parameters': parameters,
    'confidence': confidence,
  };
}

/// Represents an AI assistant response
class AssistantResponse {
  final String message;
  final String? suggestedRoute;
  final Map<String, dynamic>? data;
  final List<String>? quickReplies;
  final String? chartType; // bar, pie, line, table
  final Map<String, dynamic>? chartData;

  const AssistantResponse({
    required this.message,
    this.suggestedRoute,
    this.data,
    this.quickReplies,
    this.chartType,
    this.chartData,
  });
}

/// AI Assistant Service for ERP natural language interactions
class AiAssistantService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AiAssistantService({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  /// Process a user's natural language query and return an intelligent response
  Future<AssistantResponse> processQuery(String query) async {
    try {
      final intent = await _classifyIntent(query);
      final params = await _extractEntities(query);

      switch (intent.action) {
        case 'query':
          return await _handleQuery(intent.entity, params);
        case 'navigate':
          return _handleNavigation(intent.entity, params);
        case 'analyze':
          return await _handleAnalysis(intent.entity, params);
        case 'create':
          return _handleCreate(intent.entity, params);
        default:
          return _helpResponse(query);
      }
    } catch (e) {
      return AssistantResponse(
        message: 'I encountered an error processing your request. Please try again or rephrase.',
        quickReplies: ['Show my dashboard', 'List recent orders', 'Help'],
      );
    }
  }

  /// Classify user intent from natural language
  Future<AssistantIntent> _classifyIntent(String query) async {
    final lower = query.toLowerCase();

    // Query intents
    if (lower.contains('how many') || lower.contains('list') || lower.contains('show') || 
        lower.contains('find') || lower.contains('search') || lower.contains('where')) {
      // Determine entity
      if (lower.contains('product') || lower.contains('item') || lower.contains('stock') || lower.contains('inventory')) {
        return const AssistantIntent(action: 'query', entity: 'product');
      }
      if (lower.contains('order') || lower.contains('purchase')) {
        return const AssistantIntent(action: 'query', entity: 'order');
      }
      if (lower.contains('customer') || lower.contains('client') || lower.contains('buyer')) {
        return const AssistantIntent(action: 'query', entity: 'customer');
      }
      if (lower.contains('payment') || lower.contains('transaction')) {
        return const AssistantIntent(action: 'query', entity: 'payment');
      }
      if (lower.contains('employee') || lower.contains('staff')) {
        return const AssistantIntent(action: 'query', entity: 'hr');
      }
      return const AssistantIntent(action: 'query', entity: 'general');
    }

    // Navigation intents
    if (lower.contains('go to') || lower.contains('open') || lower.contains('navigate') || 
        lower.contains('take me') || lower.contains('show me')) {
      return const AssistantIntent(action: 'navigate', entity: 'general');
    }

    // Analysis intents
    if (lower.contains('analyze') || lower.contains('report') || lower.contains('trend') || 
        lower.contains('summary') || lower.contains('revenue') || lower.contains('profit')) {
      return const AssistantIntent(action: 'analyze', entity: 'report');
    }

    // Create intents
    if (lower.contains('create') || lower.contains('new') || lower.contains('add') || 
        lower.contains('make') || lower.contains('register')) {
      return const AssistantIntent(action: 'create', entity: 'general');
    }

    return const AssistantIntent(action: 'help', entity: 'general', confidence: 0.5);
  }

  /// Extract entities from natural language using pattern matching
  Future<Map<String, dynamic>> _extractEntities(String query) async {
    final params = <String, dynamic>{};
    final lower = query.toLowerCase();

    // Extract product names
    final productMatch = RegExp(r'(?:product|item)\s+["""]?([A-Za-z0-9\s\-]+)["""]?', caseSensitive: false).firstMatch(lower);
    if (productMatch != null) params['product'] = productMatch.group(1)?.trim();

    // Extract numbers (quantities, prices)
    final numbers = RegExp(r'\d+\.?\d*').allMatches(lower).map((m) => double.tryParse(m.group(0) ?? '') ?? 0).toList();
    if (numbers.isNotEmpty) params['numbers'] = numbers;

    // Extract order IDs
    final orderMatch = RegExp(r'(?:order|PO|#)\s*[:]?\s*([A-Za-z0-9\-]+)', caseSensitive: false).firstMatch(lower);
    if (orderMatch != null) params['orderId'] = orderMatch.group(1);

    // Extract dates
    if (lower.contains('today')) params['date'] = 'today';
    if (lower.contains('yesterday')) params['date'] = 'yesterday';
    if (lower.contains('this week')) params['date'] = 'this_week';
    if (lower.contains('this month')) params['date'] = 'this_month';

    // Extract status
    if (lower.contains('pending')) params['status'] = 'pending';
    if (lower.contains('completed') || lower.contains('done')) params['status'] = 'completed';
    if (lower.contains('cancelled')) params['status'] = 'cancelled';

    return params;
  }

  /// Handle data query intent
  Future<AssistantResponse> _handleQuery(String entity, Map<String, dynamic> params) async {
    try {
      switch (entity) {
        case 'product':
          final snapshot = await _firestore.collection('products').limit(10).get();
          final products = snapshot.docs.map((d) => d.data()).toList();
          if (products.isEmpty) {
            return AssistantResponse(
              message: 'No products found in inventory.',
              quickReplies: ['Add a product', 'Import products', 'Back to dashboard'],
            );
          }
          final lowStock = products.where((p) => ((p['stockLevel'] as num?)?.toDouble() ?? 0) < 10).length;
          return AssistantResponse(
            message: 'I found ${products.length} products. $lowStock items are low on stock.',
            data: {'products': products},
            chartType: 'table',
            chartData: {'headers': ['Name', 'Price', 'Stock', 'Status'], 'rows': products.map((p) => [p['name'], '\$${p['unitPriceUSD']}', '${p['stockLevel']}', ((p['stockLevel'] ?? 0) as num) < 10 ? '⚠️ Low' : '✅ Ok']).toList()},
            quickReplies: ['Show low stock items', 'Add new product', 'View inventory report'],
          );

        case 'order':
          final snapshot = await _firestore.collection('orders').orderBy('createdAt', descending: true).limit(10).get();
          final orderList = snapshot.docs.map((d) => {'id': d.id, ...d.data()}).toList();
          return AssistantResponse(
            message: 'Here are your ${orderList.length} most recent orders.',
            data: {'orders': orderList},
            chartType: 'table',
            chartData: {'headers': ['Order #', 'Status', 'Total', 'Date'], 'rows': orderList.map((o) => [o['orderNumber'] ?? o['id'], o['status'], '\$${o['totalAmountUSD']}', (o['createdAt'] as String?)?.substring(0, 10)]).toList()},
            quickReplies: ['Create new order', 'View pending orders', 'Order analytics'],
          );

        case 'customer':
          final snapshot = await _firestore.collection('users').where('role', isEqualTo: 'retailer').limit(10).get();
          final customers = snapshot.docs.map((d) => d.data()).toList();
          return AssistantResponse(
            message: 'You have ${customers.length} customers.',
            data: {'customers': customers},
            quickReplies: ['Add customer', 'View all customers'],
          );

        default:
          return _helpResponse('query');
      }
    } catch (e) {
      return AssistantResponse(
        message: 'I had trouble fetching that data. Please ensure the emulator is running.',
        quickReplies: ['Retry', 'Help'],
      );
    }
  }

  /// Handle navigation intent
  AssistantResponse _handleNavigation(String entity, Map<String, dynamic> params) {
    final lower = (params['query'] as String?)?.toLowerCase() ?? '';
    
    final routeMap = {
      'dashboard': '/dashboard',
      'products': '/products',
      'orders': '/orders',
      'payments': '/payments',
      'logistics': '/logistics',
      'customers': '/customers',
      'analytics': '/analytics',
      'admin': '/admin',
      'hr': '/hr',
      'suppliers': '/suppliers',
      'purchases': '/purchases',
      'expenses': '/expenses',
      'assets': '/assets',
      'projects': '/projects',
      'settings': '/settings',
    };

    for (final entry in routeMap.entries) {
      if (lower.contains(entry.key)) {
        return AssistantResponse(
          message: 'Navigating to ${entry.key}...',
          suggestedRoute: entry.value,
          quickReplies: ['Go back to dashboard', 'Help'],
        );
      }
    }

    return AssistantResponse(
      message: 'I can navigate you to: Dashboard, Products, Orders, Payments, Logistics, Customers, Analytics, Admin, HR, Suppliers, Purchases, Expenses, Assets, Projects, or Settings.',
      quickReplies: ['Go to Dashboard', 'Go to Orders', 'Go to Analytics'],
    );
  }

  /// Handle analysis/report intent
  Future<AssistantResponse> _handleAnalysis(String entity, Map<String, dynamic> params) async {
    try {
      // Revenue summary
      final payments = await _firestore.collection('payments').get();
      final totalRevenue = payments.docs.fold<double>(0, (sum, d) => sum + ((d.data()['amount'] as num?)?.toDouble() ?? 0));
      
      // Order counts
      final orders = await _firestore.collection('orders').get();
      final pendingOrders = orders.docs.where((d) => (d.data()['status'] as String?) == 'pending').length;

      return AssistantResponse(
        message: '📊 **Business Summary**\n\n• Total Revenue: **\$${totalRevenue.toStringAsFixed(2)}**\n• Total Orders: **${orders.docs.length}**\n• Pending Orders: **$pendingOrders**\n• Active Payments: **${payments.docs.length}**',
        data: {
          'totalRevenue': totalRevenue,
          'totalOrders': orders.docs.length,
          'pendingOrders': pendingOrders,
          'totalPayments': payments.docs.length,
        },
        chartType: 'bar',
        chartData: {
          'labels': ['Revenue', 'Orders', 'Pending', 'Payments'],
          'values': [totalRevenue, orders.docs.length.toDouble(), pendingOrders.toDouble(), payments.docs.length.toDouble()],
        },
        quickReplies: ['Monthly revenue trend', 'Top selling products', 'Full analytics report'],
      );
    } catch (e) {
      return AssistantResponse(
        message: 'Unable to generate analysis. Data may not be available.',
        quickReplies: ['Retry', 'Help'],
      );
    }
  }

  /// Handle create intent (guide user to create forms)
  AssistantResponse _handleCreate(String entity, Map<String, dynamic> params) {
    final lower = (params['query'] as String?)?.toLowerCase() ?? '';
    
    if (lower.contains('product')) {
      return AssistantResponse(
        message: 'Let me take you to the product creation screen.',
        suggestedRoute: '/products',
        quickReplies: ['Add product with details', 'Cancel'],
      );
    }
    if (lower.contains('order')) {
      return AssistantResponse(
        message: 'Opening order creation form.',
        suggestedRoute: '/orders/create',
        quickReplies: ['Create order', 'Cancel'],
      );
    }

    return AssistantResponse(
      message: 'I can help you create new records. What would you like to create? (Product, Order, Customer, etc.)',
      quickReplies: ['Create product', 'Create order', 'Cancel'],
    );
  }

  /// Default help response
  AssistantResponse _helpResponse(String query) {
    return const AssistantResponse(
      message: '🤖 **Xiishopy AI Assistant**\n\nI can help you with:\n\n• **Query data**: "Show me recent orders", "List products low on stock"\n• **Navigate**: "Go to analytics", "Open HR module"\n• **Analyze**: "Give me a business summary", "Revenue trends"\n• **Create**: "Create a new order", "Add a product"\n\nHow can I assist you today?',
      quickReplies: [
        'Show dashboard summary',
        'List recent orders',
        'Find low stock products',
        'Business analytics',
      ],
    );
  }
}