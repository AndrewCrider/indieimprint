class Series {
  final String seriesName;
  final String seriesDescription;
  final String gridValueAsset; // Asset path for gridValue image
  final String mainImageAsset; // Asset path for mainImage image
  final DateTime releaseDate;

  Series({
    required this.seriesName,
    required this.seriesDescription,
    required this.gridValueAsset,
    required this.mainImageAsset,
    required this.releaseDate,
  });


static fetchBrandSeriesData(){
  return [
        Series(seriesName: "The Absentee", seriesDescription: "This is about the absentees",
        gridValueAsset: "assets/flatline/series/flatline_absenteeBrand.jpg", mainImageAsset: "assets/flatline/series/flatline_absenteeBrand.jpg",
            releaseDate: DateTime(2023, 9, 17) ),
    Series(seriesName: "Last Ride of the 4 Horsemen", seriesDescription: "Horsemen and Stuff",
        gridValueAsset: "assets/flatline/series/flatline_LR4HBrand.jpg", mainImageAsset: "assets/flatline/series/flatline_LR4HBrand.jpg", releaseDate: DateTime(2023, 9, 16) ),
    Series(seriesName: "Vicious Circus", seriesDescription: "You know where it all started",
        gridValueAsset: "assets/flatline/series/flatline_viciousCircusBrand.jpg", mainImageAsset: "assets/flatline/series/flatline_viciousCircusBrand.jpg",
        releaseDate: DateTime(2010, 9, 17) ),
    Series(seriesName: "Single Issue", seriesDescription: "Everything under the sun",
        gridValueAsset: "assets/flatline/series/flatline_icon_large.jpg", mainImageAsset: "assets/flatline/series/flatline_icon_large.jpg",
        releaseDate: DateTime(2008, 9, 16) )];
}

}