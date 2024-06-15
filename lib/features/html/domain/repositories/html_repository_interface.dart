import 'package:sannip/interfaces/repository_interface.dart';
import 'package:sannip/util/html_type.dart';

abstract class HtmlRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getHtmlText(HtmlType htmlType);
}
