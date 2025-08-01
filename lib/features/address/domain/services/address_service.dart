import 'package:sannip/common/models/response_model.dart';
import 'package:sannip/features/address/domain/models/address_model.dart';
import 'package:sannip/features/address/domain/repositories/address_repository_interface.dart';
import 'package:sannip/features/address/domain/services/address_service_interface.dart';

class AddressService implements AddressServiceInterface {
  final AddressRepositoryInterface addressRepoInterface;
  AddressService({required this.addressRepoInterface});

  @override
  Future<List<AddressModel>?> getAllAddress() async {
    return await addressRepoInterface.getList();
  }

  @override
  Future<ResponseModel> removeAddressByID(int? id) async {
    return await addressRepoInterface.delete(id);
  }

  @override
  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    return await addressRepoInterface.add(addressModel);
  }

  @override
  Future<ResponseModel> updateAddress(
      AddressModel addressModel, int? addressId) async {
    return await addressRepoInterface.update(addressModel.toJson(), addressId);
  }
}
