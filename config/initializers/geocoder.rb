Geocoder.configure(

    # street address geocoding service (default :nominatim)
    lookup: :bing,
  
    # IP address geocoding service (default :ipinfo_io)
    ip_lookup: :maxmind,
  
    # to use an API key:
    api_key: "t1ICJhXTgMoo5DsxzNnq~mAKEXzUmovK9eVezECGzwg~AqnsLDBsQi86fnjf5k--ccR7vp8oTz8F-TYW8ZK_XNhg-a5u82OFb9mKrofRwaM6",
  
    # geocoding service request timeout, in seconds (default 3):
    timeout: 5,
  
    # set default units to kilometers:
    units: :km,
  
    # caching (see Caching section below for details):
    cache: $redis,
    cache_prefix: "geocoder"
  
  )