/**
 * Xiishopy ERP - AI Smart Receipt OCR Parser
 * Endpoint: /api/v1/ai/parse-invoice
 * Accepts base64 image strings and simulates parsing printed delivery notes
 * into structured JSON records.
 */

import * as functions from 'firebase-functions';

interface ParseInvoiceInput {
  imageBase64: string;
  fileName?: string;
  mimeType?: string;
}

interface ParsedInvoiceItem {
  name: string;
  quantity: number;
  unitPrice: number;
  totalPrice: number;
}

interface ParsedInvoice {
  success: boolean;
  invoiceNumber: string;
  supplier: string;
  date: string;
  items: ParsedInvoiceItem[];
  subtotal: number;
  tax: number;
  total: number;
  currency: string;
  confidence: number;
  rawText: string;
  processingTimeMs: number;
  note: string;
}

// Simulated supplier inventory for realistic OCR generation
const SIMULATED_SUPPLIERS = [
  'East African Distributors Ltd',
  'Nairobi Wholesale Mart',
  'Dar es Salaam Supply Co.',
  'Kampala General Merchants',
  'Kigali Trading Enterprise',
  'Mombasa Port Imports',
  'Lagos Continental Goods',
];

const SIMULATED_PRODUCTS = [
  'Cooking Oil - 5L',
  'Maize Flour - 10kg',
  'Sugar - 2kg',
  'Rice - 5kg',
  'Wheat Flour - 2kg',
  'Dried Beans - 1kg',
  'Salt - 500g',
  'Soap - Bar',
  'Tea Leaves - 250g',
  'Coffee Beans - 500g',
  'Milk Powder - 500g',
  'Tomato Paste - Can',
  'Cooking Gas - 6kg',
  'Mineral Water - 1.5L',
  'Bread - Loaf',
  'Cement - 50kg',
  'Roofing Sheets',
  'Paint - 4L',
  'Plywood - 8x4',
  'Steel Bars - 12mm',
];

/**
 * Simulate OCR parsing of a printed invoice image.
 * In production, this would integrate with Google Vision API or Tesseract.
 * Here we generate realistic structured data to simulate the pipeline.
 */
export async function parseInvoice(input: ParseInvoiceInput): Promise<ParsedInvoice> {
  const startTime = Date.now();

  functions.logger.info(`📄 AI OCR Parsing invoice: ${input.fileName || 'unknown'}`);

  // Simulate processing delay (real OCR would take 500-1500ms)
  await simulateDelay(100, 400);

  // Generate simulated invoice data
  const itemCount = 2 + Math.floor(Math.random() * 6); // 2-7 items
  const items: ParsedInvoiceItem[] = [];
  let subtotal = 0;

  for (let i = 0; i < itemCount; i++) {
    const product = SIMULATED_PRODUCTS[Math.floor(Math.random() * SIMULATED_PRODUCTS.length)];
    const quantity = 1 + Math.floor(Math.random() * 50);
    const unitPrice = parseFloat((50 + Math.random() * 5000).toFixed(2));
    const totalPrice = parseFloat((quantity * unitPrice).toFixed(2));
    subtotal += totalPrice;

    items.push({
      name: product,
      quantity,
      unitPrice,
      totalPrice,
    });
  }

  subtotal = parseFloat(subtotal.toFixed(2));
  const taxRate = 0.16; // 16% VAT (standard EAC)
  const tax = parseFloat((subtotal * taxRate).toFixed(2));
  const total = parseFloat((subtotal + tax).toFixed(2));

  // Simulate confidence based on "image quality"
  const confidence = parseFloat((0.75 + Math.random() * 0.2).toFixed(2));

  // Generate simulated raw text as it would appear on a receipt
  const invoiceNumber = `INV-${String(Math.floor(10000 + Math.random() * 90000))}-EAC`;
  const supplier = SIMULATED_SUPPLIERS[Math.floor(Math.random() * SIMULATED_SUPPLIERS.length)];
  const date = new Date(Date.now() - Math.floor(Math.random() * 30 * 24 * 60 * 60 * 1000))
    .toISOString().split('T')[0];

  const processingTimeMs = Date.now() - startTime;

  const result: ParsedInvoice = {
    success: true,
    invoiceNumber,
    supplier,
    date,
    items,
    subtotal,
    tax,
    total,
    currency: 'KES',
    confidence,
    rawText: [
      `=== DELIVERY NOTE ===`,
      `Supplier: ${supplier}`,
      `Invoice: ${invoiceNumber}`,
      `Date: ${date}`,
      `---`,
      ...items.map((item) =>
        `${item.name} x${item.quantity} @ ${item.unitPrice} = ${item.totalPrice}`
      ),
      `---`,
      `Subtotal: ${subtotal}`,
      `Tax (16%): ${tax}`,
      `TOTAL: ${total}`,
      `=== END ===`,
    ].join('\n'),
    processingTimeMs,
    note: 'Simulated OCR via Xiishopy AI Engine (demo mode)',
  };

  functions.logger.info(`✅ Invoice parsed: ${invoiceNumber} with ${items.length} items, ${confidence*100}% confidence`);

  return result;
}

function simulateDelay(min: number, max: number): Promise<void> {
  const delay = min + Math.random() * (max - min);
  return new Promise((resolve) => setTimeout(resolve, delay));
}