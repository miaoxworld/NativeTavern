import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service to detect the user's region for provider filtering
class RegionService {
  static const _channel = MethodChannel('com.nativetavern/region');
  
  static bool? _cachedIsChinaRegion;
  static List<String>? _cachedReasons;
  
  /// Check if the app is running in China region
  /// On iOS: Uses comprehensive detection (SKStorefront, locale, timezone, preferred languages)
  /// On Android: Uses system locale and SIM country
  /// On other platforms: Uses system locale
  static Future<bool> isChinaRegion() async {
    // Return cached result if available
    if (_cachedIsChinaRegion != null) {
      return _cachedIsChinaRegion!;
    }
    
    try {
      if (Platform.isIOS) {
        // Use comprehensive iOS detection
        final result = await _getIOSChinaRegion();
        _cachedIsChinaRegion = result;
        debugPrint('RegionService: iOS isChina: $_cachedIsChinaRegion, reasons: $_cachedReasons');
        return _cachedIsChinaRegion!;
      } else if (Platform.isAndroid) {
        // On Android, check SIM country and system locale
        final result = await _getAndroidRegion();
        _cachedIsChinaRegion = result;
        debugPrint('RegionService: Android isChina: $_cachedIsChinaRegion');
        return _cachedIsChinaRegion!;
      } else {
        // On other platforms, use system locale
        _cachedIsChinaRegion = _checkSystemLocale();
        debugPrint('RegionService: System locale isChina: $_cachedIsChinaRegion');
        return _cachedIsChinaRegion!;
      }
    } catch (e) {
      debugPrint('RegionService: Error detecting region: $e');
      // Fallback to system locale check
      _cachedIsChinaRegion = _checkSystemLocale();
      return _cachedIsChinaRegion!;
    }
  }
  
  /// Get comprehensive iOS China region detection
  /// Checks: SKStorefront, system locale, preferred languages, timezone
  static Future<bool> _getIOSChinaRegion() async {
    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>('isChinaRegion');
      if (result != null) {
        final isChina = result['isChina'] as bool? ?? false;
        final reasons = (result['reasons'] as List<dynamic>?)?.cast<String>() ?? [];
        _cachedReasons = reasons;
        debugPrint('RegionService: iOS comprehensive check - isChina: $isChina, reasons: $reasons');
        return isChina;
      }
      // Fallback to old method
      return await _getIOSStorefrontCountryFallback();
    } on PlatformException catch (e) {
      debugPrint('RegionService: Failed to get iOS region: ${e.message}');
      return _checkSystemLocale();
    } on MissingPluginException {
      debugPrint('RegionService: Platform channel not implemented');
      return _checkSystemLocale();
    }
  }
  
  /// Fallback: Get iOS App Store storefront country code (old method)
  static Future<bool> _getIOSStorefrontCountryFallback() async {
    try {
      final result = await _channel.invokeMethod<String>('getStorefrontCountry');
      final isChina = result == 'CHN' || result == 'CN';
      debugPrint('RegionService: iOS storefront fallback - country: $result, isChina: $isChina');
      return isChina;
    } on PlatformException catch (e) {
      debugPrint('RegionService: Failed to get iOS storefront: ${e.message}');
      return _checkSystemLocale();
    } on MissingPluginException {
      debugPrint('RegionService: Platform channel not implemented');
      return _checkSystemLocale();
    }
  }
  
  /// Get Android region from SIM country or system locale
  static Future<bool> _getAndroidRegion() async {
    try {
      final result = await _channel.invokeMethod<bool>('isChinaRegion');
      return result ?? _checkSystemLocale();
    } on PlatformException catch (e) {
      debugPrint('RegionService: Failed to get Android region: ${e.message}');
      return _checkSystemLocale();
    } on MissingPluginException {
      debugPrint('RegionService: Platform channel not implemented');
      return _checkSystemLocale();
    }
  }
  
  /// Check system locale as fallback
  static bool _checkSystemLocale() {
    try {
      final platformLocale = Platform.localeName;
      debugPrint('RegionService: Platform locale: $platformLocale');
      return platformLocale.contains('zh_CN') ||
             platformLocale.contains('zh-CN') ||
             platformLocale.contains('zh_Hans_CN');
    } catch (e) {
      debugPrint('RegionService: Error checking system locale: $e');
      return false;
    }
  }
  
  /// Get the reasons why China region was detected (for debugging)
  static List<String>? get detectionReasons => _cachedReasons;
  
  /// Clear cached region (useful for testing or when user changes region)
  static void clearCache() {
    _cachedIsChinaRegion = null;
    _cachedReasons = null;
  }
}