/**
 * Xiishopy ERP - Firestore Seed Data Script
 * Seeds initial data into the local Firestore emulator.
 * Uses Firestore admin SDK directly.
 *
 * Run: cd functions && npx ts-node scripts/seed-firestore.ts
 * (or as part of start-emulators.sh)
 */

import * as admin from 'firebase-admin';

// Initialize admin SDK for emulator
process.env.FIRESTORE_EMULATOR_HOST = '127.0.0.1:8080';
process.env.FIREBASE_AUTH_EMULATOR_HOST = '127.0.0.1:9099';

admin.initializeApp({ projectId: 'demo-xiishopy-erp' });
const db = admin.firestore();
const auth = admin.auth();

async function delay(ms: number) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function seed() {
  console.log('🌱 Xiishopy ERP - Seeding Firestore...\n');

  // Wait for emulators to be ready
  console.log('  Waiting for Firestore emulator...');
  await delay(2000);

  // 1. Create Auth users first
  const authUsers = [
    { uid: 'distributor-001', email: 'distributor1@xiishopy.com', password: 'Test123!', displayName: 'Nairobi Wholesale' },
    { uid: 'distributor-002', email: 'distributor2@xiishopy.com', password: 'Test123!', displayName: 'Dar Supply Chain' },
    { uid: 'retailer-001', email: 'retailer1@xiishopy.com', password: 'Test123!', displayName: 'Kampala Corner Shop' },
    { uid: 'retailer-002', email: 'retailer2@xiishopy.com', password: 'Test123!', displayName: 'Kigali General Store' },
    { uid: 'retailer-003', email: 'retailer3@xiishopy.com', password: 'Test123!', displayName: 'Mombasa Duka' },
  ];

  for (const u of authUsers) {
    try {
      await auth.createUser({
        uid: u.uid, email: u.email, password: u.password, displayName: u.displayName,
      });
      console.log(`  ✅ Auth user: ${u.email} (${u.uid})`);
    } catch (err: any) {
      if (err.code === 'auth/uid-already-exists') {
        console.log(`  ⏭️  Auth user exists: ${u.email}`);
      } else {
        console.error(`  ❌ Auth error for ${u.email}:`, err.message);
      }
    }
  }

  // 2. Seed Users collection with Firestore Timestamps
  const now = admin.firestore.Timestamp.now();
  const yesterday = admin.firestore.Timestamp.fromMillis(Date.now() - 86400000);

  const users = [
    { uid: 'distributor-001', companyName: 'Nairobi Wholesale Distributors Ltd', role: 'distributor', country: 'KE', balance: 1250000, language: 'en', phoneNumber: '+254712345678', email: 'distributor1@xiishopy.com' },
    { uid: 'distributor-002', companyName: 'Dar es Salaam Supply Chain Co.', role: 'distributor', country: 'TZ', balance: 985000, language: 'sw', phoneNumber: '+255712345678', email: 'distributor2@xiishopy.com' },
    { uid: 'retailer-001', companyName: 'Kampala Corner Shop', role: 'retailer', country: 'UG', balance: 250000, language: 'lg', phoneNumber: '+256712345678', email: 'retailer1@xiishopy.com' },
    { uid: 'retailer-002', companyName: 'Kigali General Store', role: 'retailer', country: 'RW', balance: 180000, language: 'fr', phoneNumber: '+250712345678', email: 'retailer2@xiishopy.com' },
    { uid: 'retailer-003', companyName: 'Mombasa Duka La Mboga', role: 'retailer', country: 'KE', balance: 320000, language: 'sw', phoneNumber: '+254723456789', email: 'retailer3@xiishopy.com' },
  ];

  for (const user of users) {
    const { uid, ...userData } = user;
    await db.collection('users').doc(uid).set({
      ...userData,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log(`  ✅ User: ${user.companyName}`);
  }

  // 3. Seed Products collection
  const products = [
    { id: 'prod-001', SKU: 'COOK-OIL-5L', name: 'Cooking Oil - 5L', category: 'Groceries', stockLevel: 250, wholesalePriceUSD: 8.50, unit: 'piece', reorderLevel: 20 },
    { id: 'prod-002', SKU: 'MAIZE-10KG', name: 'Maize Flour - 10kg', category: 'Staples', stockLevel: 500, wholesalePriceUSD: 5.20, unit: 'bag', reorderLevel: 30 },
    { id: 'prod-003', SKU: 'SUGAR-2KG', name: 'Sugar - 2kg', category: 'Staples', stockLevel: 800, wholesalePriceUSD: 3.80, unit: 'pack', reorderLevel: 50 },
    { id: 'prod-004', SKU: 'RICE-5KG', name: 'Rice - 5kg', category: 'Staples', stockLevel: 350, wholesalePriceUSD: 6.50, unit: 'bag', reorderLevel: 25 },
    { id: 'prod-005', SKU: 'CEMENT-50KG', name: 'Cement - 50kg', category: 'Construction', stockLevel: 120, wholesalePriceUSD: 7.80, unit: 'bag', reorderLevel: 15 },
    { id: 'prod-006', SKU: 'WHEAT-2KG', name: 'Wheat Flour - 2kg', category: 'Staples', stockLevel: 420, wholesalePriceUSD: 2.90, unit: 'pack', reorderLevel: 30 },
    { id: 'prod-007', SKU: 'BEANS-1KG', name: 'Dried Beans - 1kg', category: 'Groceries', stockLevel: 600, wholesalePriceUSD: 1.50, unit: 'kg', reorderLevel: 40 },
    { id: 'prod-008', SKU: 'SALT-500G', name: 'Salt - 500g', category: 'Groceries', stockLevel: 1000, wholesalePriceUSD: 0.80, unit: 'pack', reorderLevel: 60 },
    { id: 'prod-009', SKU: 'ROOF-SHEET', name: 'Roofing Sheets', category: 'Construction', stockLevel: 75, wholesalePriceUSD: 4.20, unit: 'piece', reorderLevel: 10 },
    { id: 'prod-010', SKU: 'PAINT-4L', name: 'Paint - 4L', category: 'Construction', stockLevel: 45, wholesalePriceUSD: 12.00, unit: 'can', reorderLevel: 10 },
  ];

  for (const product of products) {
    const { id, ...productData } = product;
    await db.collection('products').doc(id).set({
      ...productData,
      createdAt: now,
      updatedAt: now,
    });
    console.log(`  ✅ Product: ${product.name}`);
  }

  // 4. Seed Forex rates
  await db.collection('forex_rates').doc('live').set({
    base: 'USD',
    rates: { KES: 150.00, TZS: 2500.00, UGX: 3700.00, RWF: 1300.00 },
    lastUpdated: now,
    source: 'initial-seed',
  });
  console.log('  ✅ Forex rates seeded');

  // 5. Seed sample orders (fields matching OrderModel)
  const orders = [
    {
      id: 'order-001',
      orderNumber: 'XIISHOPY-00000001',
      retailerId: 'retailer-001',
      retailerName: 'Kampala Corner Shop',
      distributorId: 'distributor-001',
      items: [
        { productId: 'prod-001', productName: 'Cooking Oil - 5L', sku: 'COOK-OIL-5L', quantity: 20, unitPriceUSD: 8.50, totalPriceUSD: 170.00 },
      ],
      subtotalUSD: 170.00, shippingUSD: 0.0, taxUSD: 0.0,
      totalUSD: 170.00,
      status: 'paid',
      deliveryAddress: 'Kampala, Uganda',
      trackingNumber: 'XIISHOPY-TRACK-001',
    },
    {
      id: 'order-002',
      orderNumber: 'XIISHOPY-00000002',
      retailerId: 'retailer-002',
      retailerName: 'Kigali General Store',
      distributorId: 'distributor-001',
      items: [
        { productId: 'prod-005', productName: 'Cement - 50kg', sku: 'CEMENT-50KG', quantity: 50, unitPriceUSD: 7.80, totalPriceUSD: 390.00 },
      ],
      subtotalUSD: 390.00, shippingUSD: 0.0, taxUSD: 0.0,
      totalUSD: 390.00,
      status: 'shipped',
      deliveryAddress: 'Kigali, Rwanda',
      trackingNumber: 'XIISHOPY-TRACK-002',
    },
    {
      id: 'order-003',
      orderNumber: 'XIISHOPY-00000003',
      retailerId: 'retailer-003',
      retailerName: 'Mombasa Duka La Mboga',
      distributorId: 'distributor-002',
      items: [
        { productId: 'prod-002', productName: 'Maize Flour - 10kg', sku: 'MAIZE-10KG', quantity: 100, unitPriceUSD: 5.20, totalPriceUSD: 520.00 },
      ],
      subtotalUSD: 520.00, shippingUSD: 0.0, taxUSD: 0.0,
      totalUSD: 520.00,
      status: 'pending',
      deliveryAddress: 'Mombasa, Kenya',
      trackingNumber: null,
    },
  ];

  for (const order of orders) {
    const { id, ...orderData } = order;
    await db.collection('orders').doc(id).set({
      ...orderData,
      createdAt: yesterday,
      updatedAt: now,
    });
    console.log(`  ✅ Order: ${order.orderNumber} (${order.status})`);
  }

  // 6. Seed sample payments (fields matching PaymentModel)
  const payments = [
    { id: 'payment-001', orderId: 'order-001', retailerId: 'retailer-001', distributorId: 'distributor-001', amountUSD: 170.00, amountLocal: 25500.00, currency: 'UGX', provider: 'mpesa', status: 'completed', transactionId: 'TXN-001', phoneNumber: '+256712345678', mpesaCode: 'MPESA-001' },
    { id: 'payment-002', orderId: 'order-002', retailerId: 'retailer-002', distributorId: 'distributor-001', amountUSD: 390.00, amountLocal: 507000.00, currency: 'RWF', provider: 'airtel_money', status: 'completed', transactionId: 'TXN-002', phoneNumber: '+250712345678', mpesaCode: null },
    { id: 'payment-003', orderId: 'order-003', retailerId: 'retailer-003', distributorId: 'distributor-002', amountUSD: 520.00, amountLocal: 78000.00, currency: 'KES', provider: 'mpesa', status: 'pending', transactionId: 'TXN-003', phoneNumber: '+254723456789', mpesaCode: null },
  ];

  for (const payment of payments) {
    const { id, ...paymentData } = payment;
    await db.collection('payments').doc(id).set({
      ...paymentData,
      createdAt: yesterday,
      updatedAt: now,
    });
    console.log(`  ✅ Payment: ${payment.id} (${payment.status})`);
  }

  // 7. Seed sample shipments (fields matching ShipmentModel)
  const shipments = [
    {
      id: 'shipment-001', orderId: 'order-001', retailerId: 'retailer-001', distributorId: 'distributor-001',
      carrier: 'sendy', status: 'In Transit', trackingNumber: 'XIISHOPY-TRACK-001',
      origin: 'Nairobi, KE', destination: 'Kampala, UG',
      estimatedDelivery: admin.firestore.Timestamp.fromMillis(Date.now() + 2 * 86400000),
      pickedUpAt: yesterday, deliveredAt: null,
      trackingHistory: [
        { status: 'Picked up', location: 'Nairobi, KE', description: 'Package picked up from warehouse', timestamp: yesterday },
        { status: 'In Transit', location: 'Nakuru, KE', description: 'Package in transit to destination', timestamp: now },
      ],
      notes: null,
    },
    {
      id: 'shipment-002', orderId: 'order-002', retailerId: 'retailer-002', distributorId: 'distributor-001',
      carrier: 'amit_trucking', status: 'Picked up', trackingNumber: 'XIISHOPY-TRACK-002',
      origin: 'Nairobi, KE', destination: 'Kigali, RW',
      estimatedDelivery: admin.firestore.Timestamp.fromMillis(Date.now() + 3 * 86400000),
      pickedUpAt: yesterday, deliveredAt: null,
      trackingHistory: [
        { status: 'Picked up', location: 'Nairobi, KE', description: 'Package picked up from warehouse', timestamp: yesterday },
      ],
      notes: null,
    },
  ];

  for (const shipment of shipments) {
    const { id, ...shipmentData } = shipment;
    await db.collection('shipments').doc(id).set({
      ...shipmentData,
      createdAt: yesterday,
      updatedAt: now,
    });
    console.log(`  ✅ Shipment: ${shipment.trackingNumber} (${shipment.status})`);
  }

  console.log('\n🎉 Xiishopy ERP seeding complete!\n');
  console.log('Demo Login Credentials:');
  console.log('  Distributor: distributor1@xiishopy.com / Test123!');
  console.log('  Distributor: distributor2@xiishopy.com / Test123!');
  console.log('  Retailer:    retailer1@xiishopy.com / Test123!');
  console.log('  Retailer:    retailer2@xiishopy.com / Test123!');
  console.log('  Retailer:    retailer3@xiishopy.com / Test123!\n');

  process.exit(0);
}

seed().catch((err) => {
  console.error('❌ Seed failed:', err);
  process.exit(1);
});