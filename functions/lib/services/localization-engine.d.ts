/**
 * Xiishopy ERP - Dynamic Localization Engine
 * Real-time text translation between English, Swahili, Luganda, and French.
 * Uses the LOCALIZATION_MAP from constants for instant translation lookups.
 */
import { Language } from '../config/constants';
interface TranslationResult {
    success: boolean;
    key: string;
    sourceLanguage: string;
    targetLanguage: string;
    translatedText: string;
}
interface LocalizedText {
    key: string;
    en: string;
    sw: string;
    lg: string;
    fr: string;
}
/**
 * Translate a single UI text key to the target language.
 * Falls back to English if translation not found.
 */
export declare function translateText(key: string, targetLang: Language, fallbackLang?: Language): TranslationResult;
/**
 * Batch translate multiple UI keys at once.
 * Used by the Flutter app to fetch all translations for a given language.
 */
export declare function batchTranslate(keys: string[], targetLang: Language): TranslationResult[];
/**
 * Get all available localized texts for a given language.
 * Returns the full localization map in the target language with English fallback.
 */
export declare function getAllLocalizedTexts(language: Language): Record<string, string>;
/**
 * Build a Firestore-compatible translations document for caching.
 */
export declare function buildTranslationsDocument(): Record<string, LocalizedText>;
export {};
