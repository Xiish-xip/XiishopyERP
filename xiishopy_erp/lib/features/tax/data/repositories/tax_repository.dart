/// Xiishopy ERP - Tax Repository
library;

import '../datasources/tax_remote_datasource.dart';
import '../models/tax_model.dart';

class TaxRepository {
  final TaxRemoteDataSource _remoteDataSource;
  TaxRepository({required TaxRemoteDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  Stream<List<TaxConfigModel>> watchTaxConfigs() => _remoteDataSource.watchTaxConfigs();
  Future<void> createTaxConfig(TaxConfigModel config) => _remoteDataSource.createTaxConfig(config);
  Future<void> updateTaxConfig(TaxConfigModel config) => _remoteDataSource.updateTaxConfig(config);

  Stream<List<TaxRateModel>> watchTaxRates() => _remoteDataSource.watchTaxRates();
  Future<void> createTaxRate(TaxRateModel rate) => _remoteDataSource.createTaxRate(rate);
  Future<void> updateTaxRate(TaxRateModel rate) => _remoteDataSource.updateTaxRate(rate);
}