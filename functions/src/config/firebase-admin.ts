import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

/**
 * Xiishopy ERP - Firebase Admin SDK Initialization
 * Detects emulator environment and configures locally accordingly.
 */
export function initializeFirebaseAdmin(): void {
  if (admin.apps.length > 0) {
    return; // Already initialized
  }

  const app = admin.initializeApp({
    projectId: 'demo-xiishopy-erp',
  });

  // Detect emulator environment from FIREBASE_EMULATOR_HUB or functions config
  const isEmulator = process.env.FIREBASE_EMULATOR_HUB !== undefined ||
                     process.env.FUNCTIONS_EMULATOR === 'true' ||
                     process.env.FIRESTORE_EMULATOR_HOST !== undefined;

  if (isEmulator) {
    functions.logger.info('🔥 Running in Firebase Emulator mode');
    // Firestore emulator
    if (process.env.FIRESTORE_EMULATOR_HOST) {
      // Already auto-configured by firebase-functions
    }
    // Auth emulator
    process.env.FIREBASE_AUTH_EMULATOR_HOST = '127.0.0.1:9099';
    // Storage emulator
    process.env.FIREBASE_STORAGE_EMULATOR_HOST = '127.0.0.1:9199';
  }

  // Enable logging
  functions.logger.info('✅ Firebase Admin SDK initialized', {
    projectId: app.options.projectId,
    isEmulator,
  });
}

// Singleton instances
export const getFirestore = (): admin.firestore.Firestore => {
  return admin.firestore();
};

export const getAuth = (): admin.auth.Auth => {
  return admin.auth();
};

export const getStorage = (): admin.storage.Storage => {
  return admin.storage();
};

export default admin;