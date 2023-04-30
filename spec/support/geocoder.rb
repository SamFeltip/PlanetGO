# frozen_string_literal: true

Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'coordinates' => [53, -1]
    }
  ]
)
