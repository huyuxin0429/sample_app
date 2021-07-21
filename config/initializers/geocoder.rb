Geocoder.configure(

    # street address geocoding service (default :nominatim)
    lookup: :google,
  
    # IP address geocoding service (default :ipinfo_io)
    ip_lookup: :maxmind,
  
    # to use an API key:
    api_key: "AIzaSyCEkczgoE41K_X4sk4maD-ju_64GB-zSj4",
  
    # geocoding service request timeout, in seconds (default 3):
    timeout: 5,
  
    # set default units to kilometers:
    units: :km,
  
    # caching (see Caching section below for details):
    cache: $redis,
    cache_prefix: "geocoder"
  
  )