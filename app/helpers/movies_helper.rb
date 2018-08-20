module MoviesHelper
  def youtube_embed youtube_url
    return unless youtube_url
    if youtube_url[%r{youtu\.be\/([^\?]*)}]
      youtube_id = Regexp.last_match(1)
    else
      youtube_url[%r{^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*}]
      youtube_id = Regexp.last_match(5)
    end
    content_tag(:iframe, "", src: "https://www.youtube.com/embed/#{youtube_id}",
      width: Settings.movie.iframe_width,
      height: Settings.movie.iframe_height, frameborder: 0,
      allow: "autoplay; encrypted-media", allowfullscreen: true)
  end
end
