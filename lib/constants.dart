class Constants {
  static String baseUrl = "https://stream.mux.com";

  static String getVideoLink(String videoId) {
    return "$baseUrl/$videoId.m3u8";
  }
}
