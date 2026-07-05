import * as admin from 'firebase-admin';
/**
 * Xiishopy ERP - Firebase Admin SDK Initialization
 * Detects emulator environment and configures locally accordingly.
 */
export declare function initializeFirebaseAdmin(): void;
export declare const getFirestore: () => admin.firestore.Firestore;
export declare const getAuth: () => admin.auth.Auth;
export declare const getStorage: () => admin.storage.Storage;
export default admin;
