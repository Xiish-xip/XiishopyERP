"use strict";
/**
 * Xiishopy ERP - Dynamic Localization Engine
 * Real-time text translation between English, Swahili, Luganda, and French.
 * Uses the LOCALIZATION_MAP from constants for instant translation lookups.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.translateText = translateText;
exports.batchTranslate = batchTranslate;
exports.getAllLocalizedTexts = getAllLocalizedTexts;
exports.buildTranslationsDocument = buildTranslationsDocument;
const constants_1 = require("../config/constants");
/**
 * Translate a single UI text key to the target language.
 * Falls back to English if translation not found.
 */
function translateText(key, targetLang, fallbackLang = constants_1.Language.ENGLISH) {
    const translation = constants_1.LOCALIZATION_MAP[key];
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
function batchTranslate(keys, targetLang) {
    return keys.map((key) => translateText(key, targetLang));
}
/**
 * Get all available localized texts for a given language.
 * Returns the full localization map in the target language with English fallback.
 */
function getAllLocalizedTexts(language) {
    const result = {};
    for (const [key, translations] of Object.entries(constants_1.LOCALIZATION_MAP)) {
        result[key] = translations[language] || translations[constants_1.Language.ENGLISH] || key;
    }
    return result;
}
/**
 * Build a Firestore-compatible translations document for caching.
 */
function buildTranslationsDocument() {
    const doc = {};
    for (const [key, translations] of Object.entries(constants_1.LOCALIZATION_MAP)) {
        doc[key] = {
            key,
            en: translations[constants_1.Language.ENGLISH] || key,
            sw: translations[constants_1.Language.SWAHILI] || translations[constants_1.Language.ENGLISH] || key,
            lg: translations[constants_1.Language.LUGANDA] || translations[constants_1.Language.ENGLISH] || key,
            fr: translations[constants_1.Language.FRENCH] || translations[constants_1.Language.ENGLISH] || key,
        };
    }
    return doc;
}
//# sourceMappingURL=localization-engine.js.map