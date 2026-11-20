# frozen_string_literal: true

module PostsHelper
  # (posts/show)
  def post_share_url(post)
    params = {
      text: "#{post.address}について",
      hashtags: 'パルクール,pkmap',
      url: request.original_url,
      via: 'power_of_shikin'
    }
    "https://twitter.com/share?#{params.to_query}"
  end

  # (posts/_post)
  def streetview_image_ulr(post, size: '640x480')
    params = {
      size: size,
      heading: 160,
      fov: 120,
      location: "#{post.latitude},#{post.longitude}",
      key: ENV.fetch('GOOGLE_MAP_API')
    }
    "https://maps.googleapis.com/maps/api/streetview?#{params.to_query}"
  end
end
