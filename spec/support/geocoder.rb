# frozen_string_literal: true

Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'coordinates' => [53, -1]
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  '25-27 Mosley St, Newcastle, NE1 1YF', [
    {
      'coordinates' => [53.477, -2.241]
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  '104 West Street, Sheffield, S1 4EP', [
    {
      'coordinates' => [53.38131, -1.4746]
    }
  ]
)

Geocoder::Lookup::Test.add_stub(
  'S1 4EP', [
    {
      'coordinates' => [53.38131, -1.4746]
    }
  ]
)
Geocoder::Lookup::Test.add_stub(
  'S1 4EP, UK', [
    {
      'coordinates' => [53.38131, -1.4746]
    }
  ]
)
