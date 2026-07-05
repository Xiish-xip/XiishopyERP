/**
 * Xiishopy ERP - Dynamic Localization Engine
 * Real-time text translation between English, Swahili, Luganda, and French.
 * Uses the LOCALIZATION_MAP from constants for instant translation lookups.
 */

import { LOCALIZATION_MAP, Language } from '../config/constants';

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
export function translateText(
  key: string,
  targetLang: Language,
  fallbackLang: Language = Language.ENGLISH
): TranslationResult {
  const translation = LOCALIZATION_MAP[key];

  if (!translation) {
    return {
      success: false,
      key,
      sourceLanguage: fallbackLang,
      targetLanguage: targetLang,
      translatedText: key,
    };
  }

  const translatedText = translation[targetLang] || translation[fallbackLang] || key;

  return {
    success: true,
    key,
    sourceLanguage: fallbackLang,
    targetLanguage: targetLang,
    translatedText,
  };
}

/**
 * Batch translate multiple UI keys at once.
 * Used by the Flutter app to fetch all translations for a given language.
 */
export function batchTranslate(
  keys: string[],
  targetLang: Language
): TranslationResult[] {
  return keys.map((key) => translateText(key, targetLang));
}

/**
 * Get all available localized texts for a given language.
 * Returns the full localization map in the target language with English fallback.
 */
export function getAllLocalizedTexts(language: Language): Record<string, string> {
  const result: Record<string, string> = {};

  for (const [key, translations] of Object.entries(LOCALIZATION_MAP)) {
    result[key] = translations[language] || translations[Language.ENGLISH] || key;
  }

  return result;
}

/**
 * Build a Firestore-compatible translations document for caching.
 */
export function buildTranslationsDocument(): Record<string, LocalizedText> {
  const doc: Record<string, LocalizedText> = {};

  for (const [key, translations] of Object.entries(LOCALIZATION_MAP)) {
    doc[key] = {
      key,
      en: translations[Language.ENGLISH] || key,
      sw: translations[Language.SWAHILI] || translations[Language.ENGLISH] || key,
      lg: translations[Language.LUGANDA] || translations[Language.ENGLISH] || key,
      fr: translations[Language.FRENCH] || translations[Language.ENGLISH] || key,
    };
  }

  return doc;
}