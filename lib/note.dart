class Note {
  int? id;
  String title;
  String content;

  Note(this.title, this.content, {this.id});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }
}