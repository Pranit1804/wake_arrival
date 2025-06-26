import 'package:objectbox/objectbox.dart';

@Entity()
class SearchModel {
  int? id;
  final String searchKeyword;

  SearchModel(this.id, this.searchKeyword);
}
