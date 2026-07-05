/**
 * Xiishopy ERP - AI Smart Receipt OCR Parser
 * Endpoint: /api/v1/ai/parse-invoice
 * Accepts base64 image strings and simulates parsing printed delivery notes
 * into structured JSON records.
 */
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
/**
 * Simulate OCR parsing of a printed invoice image.
 * In production, this would integrate with Google Vision API or Tesseract.
 * Here we generate realistic structured data to simulate the pipeline.
 */
export declare function parseInvoice(input: ParseInvoiceInput): Promise<ParsedInvoice>;
export {};
