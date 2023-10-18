

class Purchase {
  String issueID;
  String title;
  String series;
  String localDownloadPath;
  int purchaseDate;
  String status;
  String coverImage;
  String issueLocation;
  int lastPageRead;

  Purchase({
    required this.issueID,
    required this.title,
    required this.series,
    required this.localDownloadPath,
    required this.purchaseDate,
    required this.status,
    required this.coverImage,
    required this.issueLocation,
    required this.lastPageRead,
  });

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      issueID: map['issueID'],
      title: map['title'],
      series: map['series'],
      localDownloadPath: map['localDownloadPath'],
      purchaseDate: map['purchaseDate'],
      status: map['status'],
      coverImage: map['coverImage'],
      issueLocation: map['issueLocation'],
      lastPageRead: map['lastPageRead'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'issueID': issueID,
      'title': title,
      'series': series,
      'localDownloadPath': localDownloadPath,
      'purchaseDate': purchaseDate,
      'status': status,
      'coverImage': coverImage,
      'issueLocation': issueLocation,
      'lastPageRead': lastPageRead,
    };
  }

 /* String toJSON() {
    return json.encode(toMap());
  }*/
}
