
class ModalAPI{
  final String quote;
  final String author;
  final String category;

  ModalAPI({required this.quote,required this.author,required this.category});


  factory ModalAPI.fromJson(Map<String,dynamic> json){
    return ModalAPI(
        quote: json['quote'],
      author: json['author'],
      category: json['category']
    );
  }
  static List<ModalAPI> parseList(List<dynamic> jsonList) {
    return jsonList.map((json) => ModalAPI.fromJson(json)).toList();
  }

  Map<String, Object?> toMap() {
    return {
      'quote':quote,
      'author':author,
      'category':category,
    };
  }
}
