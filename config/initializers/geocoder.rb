Geocoder.configure(

    # street address geocoding service (default :nominatim)
    lookup: :google,
  
    # IP address geocoding service (default :ipinfo_io)
    ip_lookup: :maxmind,
  
    # to use an API key:
    api_key: "AIzaSyBThFhfR14ttIDX_aTUR8DICEHWkE9MR-M",
  
    # geocoding service request timeout, in seconds (default 3):
    timeout: 5,
  
    # set default units to kilometers:
    units: :km,
  
    # caching (see Caching section below for details):
    # cache: Redis.new,
    # cache_prefix: "..."
  
  )