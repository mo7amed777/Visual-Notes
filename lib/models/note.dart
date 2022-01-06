class Note {
  int? id;
  String? title;
  String? picture;
  String? desc;
  String? date;
  String? status;

  Note({
    this.id,
    this.title,
    this.picture,
    this.date,
    this.desc,
    this.status,
  });

  Map<String, Object?> toMap() => {
        'title': title,
        'picture': picture,
        'date': date,
        'desc': desc,
        'status': status,
      };

  Note.fromMap(Map note) {
    id = note['id'];
    date = note['date'];
    desc = note['desc'];
    picture = note['picture'];
    status = note['status'];
    title = note['title'];
  }
}
