# frozen_string_literal: true

Geocoder.configure(
  # Cache configuration
  Geocoder.configure(cache: Geocoder::CacheStore::Generic.new(Rails.cache, {}))
)
