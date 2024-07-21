// ignore_for_file: public_member_api_docs, sort_constructors_first
enum Category {
  freezing, //congelar
  protect, //proteger
  pay, //pagar
  receive, //receber
  stage, //prova
}

class Code {
  String token;
  Category category;
  String description;
  int value;
  Code({
    required this.token,
    required this.category,
    required this.description,
    required this.value,
  });
}
